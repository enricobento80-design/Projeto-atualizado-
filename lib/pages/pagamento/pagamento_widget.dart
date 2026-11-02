import 'dart:math' as math;

import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/sessao_cliente.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/components/sl_ui.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'pagamento_model.dart';
export 'pagamento_model.dart';

/// Pagamento: endereço, pontos de fidelidade, forma de pagamento e resumo.
/// Cria o pedido e os itens no Xano e segue para o PIX (ou acompanhamento,
/// no cartão).
class PagamentoWidget extends StatefulWidget {
  const PagamentoWidget({super.key});

  static String routeName = 'pagamento';
  static String routePath = '/pagamento';

  @override
  State<PagamentoWidget> createState() => _PagamentoWidgetState();
}

class _PagamentoWidgetState extends State<PagamentoWidget> {
  late PagamentoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PagamentoModel());

    SchedulerBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _carregar() async {
    safeSetState(() => _model.carregando = true);
    final app = FFAppState();
    await carregarSessaoCliente();
    final clienteId = getJsonField(app.cliente, r'''$.id''');
    final resposta = await ListarCartoesCall.call();
    safeSetState(() {
      _model.cartoes = resposta.succeeded && clienteId != null
          ? ((resposta.jsonBody as List?) ?? [])
              .where((c) => getJsonField(c, r'''$.cliente_id''') == clienteId)
              .toList()
          : [];
      _model.carregando = false;
    });
  }

  int _pontos(FFAppState app) =>
      castToType<int>(getJsonField(app.cliente, r'''$.pontos''')) ?? 0;

  Future<void> _pagar() async {
    final app = FFAppState();
    safeSetState(() => _model.mensagemErro = null);
    if (app.token.isEmpty) {
      context.pushNamed(LoginWidget.routeName);
      return;
    }
    final clienteId = castToType<int>(getJsonField(app.cliente, r'''$.id'''));
    final endereco = enderecoDeEntrega(app);
    final enderecoId = castToType<int>(getJsonField(endereco, r'''$.id'''));
    if (clienteId == null) {
      safeSetState(() => _model.mensagemErro =
          'Não encontramos seu cadastro de cliente. Entre novamente na sua conta.');
      return;
    }
    if (enderecoId == null) {
      safeSetState(() => _model.mensagemErro =
          'Cadastre um endereço de entrega para continuar.');
      return;
    }
    if (app.carrinho.isEmpty) {
      context.safePop();
      return;
    }

    final pontos = _pontos(app);
    final itens = app.totalCarrinho;
    final desconto = _model.desconto(pontos);
    final total = _model.total(itens, pontos);
    final pix = _model.pagarComPix;

    safeSetState(() => _model.processando = true);
    final pedido = await CriarPedidoCall.call(
      clienteId: clienteId,
      enderecoId: enderecoId,
      total: total,
      taxaEntrega: kTaxaEntrega,
      desconto: desconto,
      pontosUsados: desconto > 0 ? kPontosPorResgate : 0,
      pontosGanhos: pontosGanhosPor(total),
      formaPagamento: pix ? 'PIX' : 'CREDIT_CARD',
      // 2 = "Pagamento em PIX iniciado", 7 = "Transação via Cartão Iniciada".
      statusPedidoId: pix ? 2 : 7,
      codEntrega: (1000 + math.Random().nextInt(9000)).toString(),
    );
    final pedidoId = CriarPedidoCall.id(pedido.jsonBody);
    if (!pedido.succeeded || pedidoId == null) {
      safeSetState(() {
        _model.processando = false;
        _model.mensagemErro =
            'Não foi possível criar seu pedido. Tente novamente.';
      });
      return;
    }

    final respostasItens = await Future.wait(app.carrinho.map((item) =>
        CriarItemCall.call(
          pedidoId: pedidoId,
          produtoId: item['id'] as int,
          qtd: item['quantidade'] as int,
          valorUnit: item['preco'] as double,
          observacao: item['obs'] as String?,
        )));
    if (respostasItens.any((r) => !r.succeeded)) {
      safeSetState(() {
        _model.processando = false;
        _model.mensagemErro =
            'O pedido #$pedidoId foi criado, mas alguns itens não foram salvos. Fale com o atendimento.';
      });
      return;
    }

    app.update(() => app.carrinho = []);
    safeSetState(() => _model.processando = false);
    if (!mounted) {
      return;
    }
    context.goNamed(
      pix ? PagarpixWidget.routeName : AcompanharpedidoWidget.routeName,
      queryParameters: {
        'pedidoId': serializeParam(pedidoId, ParamType.int),
      }.withoutNulls,
    );
  }

  Widget _linhaResumo(BuildContext context, String rotulo, String valor,
      {Color? cor, bool negrito = false}) {
    final tema = FlutterFlowTheme.of(context);
    final estilo = tema.bodyMedium.override(
      color: cor ?? tema.secondaryText,
      fontWeight: negrito ? FontWeight.w600 : FontWeight.normal,
    );
    return Row(
      children: [
        Expanded(child: Text(rotulo, style: estilo)),
        Text(valor, style: estilo),
      ],
    );
  }

  Widget _opcaoPagamento(
    BuildContext context, {
    required IconData icone,
    required String titulo,
    required String subtitulo,
    required bool selecionada,
    required VoidCallback aoTocar,
  }) {
    final tema = FlutterFlowTheme.of(context);
    return InkWell(
      onTap: aoTocar,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 14.0, 16.0, 14.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: tema.alternate, width: 1.0),
          ),
        ),
        child: Row(
          children: [
            IconeFundoSL(icone: icone),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: tema.titleSmall),
                  Text(
                    subtitulo,
                    style: tema.bodySmall.override(color: tema.secondaryText),
                  ),
                ],
              ),
            ),
            Icon(
              selecionada
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selecionada ? tema.primary : tema.secondaryText,
              size: 26.0,
            ),
          ].divide(SizedBox(width: 16.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final app = context.watch<FFAppState>();
    final pontos = _pontos(app);
    final itens = app.totalCarrinho;
    final desconto = _model.desconto(pontos);
    final total = _model.total(itens, pontos);
    final endereco = enderecoDeEntrega(app);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: tema.primaryBackground,
      bottomNavigationBar: BarraInferiorSL(
        child: BotaoPrimarioSL(
          texto: _model.pagarComPix
              ? 'Gerar código PIX · ${formatarReais(total)}'
              : 'Pagar com cartão · ${formatarReais(total)}',
          icone: Icons.lock_outline_rounded,
          carregando: _model.processando,
          aoTocar: _model.carregando || app.carrinho.isEmpty ? null : _pagar,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            wrapWithModel(
              model: _model.cabecalhoModel,
              updateCallback: () => safeSetState(() {}),
              child: CabecalhoWidget(titulo: 'Pagamento'),
            ),
            Expanded(
              child: _model.carregando
                  ? Center(
                      child: CircularProgressIndicator(color: tema.primary),
                    )
                  : ListView(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 24.0),
                      children: [
                        if (_model.mensagemErro != null) ...[
                          AvisoSL(texto: _model.mensagemErro!),
                          SizedBox(height: 20.0),
                        ],
                        TituloSecaoSL('Entregar em'),
                        SizedBox(height: 12.0),
                        CartaoSL(
                          child: Row(
                            children: [
                              IconeFundoSL(icone: Icons.location_on_outlined),
                              Expanded(
                                child: endereco == null
                                    ? Text(
                                        'Nenhum endereço cadastrado',
                                        style: tema.titleSmall,
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(ruaENumero(endereco),
                                              style: tema.titleSmall),
                                          Text(
                                            bairroCidadeUf(endereco, app.ceps),
                                            style: tema.bodySmall.override(
                                                color: tema.secondaryText),
                                          ),
                                        ],
                                      ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await context.pushNamed(
                                    endereco == null
                                        ? CadastroenderecoWidget.routeName
                                        : EnderecosWidget.routeName,
                                  );
                                  safeSetState(() {});
                                },
                                child: Text(
                                  endereco == null ? 'Cadastrar' : 'Trocar',
                                  style: tema.titleSmall.override(
                                    color: tema.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                        SizedBox(height: 24.0),
                        TituloSecaoSL('Pontos de fidelidade'),
                        SizedBox(height: 12.0),
                        InkWell(
                          borderRadius: BorderRadius.circular(24.0),
                          onTap: pontos < kPontosPorResgate
                              ? null
                              : () => safeSetState(
                                  () => _model.usarPontos = !_model.usarPontos),
                          child: CartaoSL(
                            cor: tema.accentContainer,
                            corBorda: tema.tertiary.withValues(alpha: 0.5),
                            child: Row(
                              children: [
                                Icon(Icons.star_rounded,
                                    color: tema.tertiary, size: 30.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Usar $kPontosPorResgate pontos',
                                        style: tema.titleSmall,
                                      ),
                                      Text(
                                        pontos >= kPontosPorResgate
                                            ? 'Você tem $pontos pontos · $kPontosPorResgate pts = ${formatarReais(kValorResgate)} de desconto'
                                            : 'Você tem $pontos pontos. Junte $kPontosPorResgate para ganhar ${formatarReais(kValorResgate)} de desconto.',
                                        style: tema.bodySmall
                                            .override(color: tema.warning),
                                      ),
                                    ],
                                  ),
                                ),
                                Checkbox(
                                  value: _model.usarPontos &&
                                      pontos >= kPontosPorResgate,
                                  onChanged: pontos < kPontosPorResgate
                                      ? null
                                      : (valor) => safeSetState(() =>
                                          _model.usarPontos = valor ?? false),
                                  activeColor: tema.primary,
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0),
                        TituloSecaoSL('Forma de pagamento'),
                        SizedBox(height: 12.0),
                        CartaoSL(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              _opcaoPagamento(
                                context,
                                icone: Icons.pix_rounded,
                                titulo: 'PIX',
                                subtitulo:
                                    'Código copia e cola, aprovação na hora',
                                selecionada: _model.pagarComPix,
                                aoTocar: () => safeSetState(
                                    () => _model.cartaoSelecionadoId = null),
                              ),
                              ..._model.cartoes.map((cartao) {
                                final id = castToType<int>(
                                    getJsonField(cartao, r'''$.id'''));
                                return _opcaoPagamento(
                                  context,
                                  icone: Icons.credit_card_rounded,
                                  titulo:
                                      '${getJsonField(cartao, r'''$.bandeira''') ?? 'Cartão'} •••• ${getJsonField(cartao, r'''$.ultimos4''') ?? ''}',
                                  subtitulo: 'Cartão de crédito cadastrado',
                                  selecionada: _model.cartaoSelecionadoId == id,
                                  aoTocar: () => safeSetState(
                                      () => _model.cartaoSelecionadoId = id),
                                );
                              }),
                              InkWell(
                                onTap: () async {
                                  await context
                                      .pushNamed(NovocartaoWidget.routeName);
                                  await _carregar();
                                },
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 14.0, 16.0, 14.0),
                                  child: Row(
                                    children: [
                                      IconeFundoSL(
                                        icone: Icons.add_rounded,
                                        fundo: tema.secondaryBackground,
                                      ),
                                      Text(
                                        'Adicionar cartão',
                                        style: tema.titleSmall.override(
                                          color: tema.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 16.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.0),
                        CartaoSL(
                          child: Column(
                            children: [
                              _linhaResumo(
                                  context, 'Itens', formatarReais(itens)),
                              _linhaResumo(context, 'Taxa de entrega',
                                  formatarReais(kTaxaEntrega)),
                              if (desconto > 0)
                                _linhaResumo(
                                  context,
                                  'Desconto ($kPontosPorResgate pontos)',
                                  '- ${formatarReais(desconto)}',
                                  cor: tema.success,
                                  negrito: true,
                                ),
                              Divider(color: tema.alternate, height: 8.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('Total',
                                        style: tema.titleMedium.override(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Text(
                                    formatarReais(total),
                                    style: tema.titleLarge.override(
                                      color: tema.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Você vai ganhar ${pontosGanhosPor(total)} pontos com este pedido',
                                style: tema.bodySmall
                                    .override(color: tema.secondaryText),
                              ),
                            ].divide(SizedBox(height: 12.0)),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
