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
import 'meuspontos_model.dart';
export 'meuspontos_model.dart';

/// Meus pontos: saldo do programa de fidelidade (`cliente.pontos`),
/// recompensas e histórico de ganhos e resgates.
class MeuspontosWidget extends StatefulWidget {
  const MeuspontosWidget({super.key});

  static String routeName = 'meuspontos';
  static String routePath = '/meuspontos';

  @override
  State<MeuspontosWidget> createState() => _MeuspontosWidgetState();
}

class _MeuspontosWidgetState extends State<MeuspontosWidget> {
  late MeuspontosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MeuspontosModel());

    SchedulerBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _carregar() async {
    safeSetState(() {
      _model.carregando = true;
      _model.mensagemErro = null;
    });
    final app = FFAppState();
    await carregarSessaoCliente(forcar: true);
    final clienteId = getJsonField(app.cliente, r'''$.id''');
    final resposta = await ListarPedidosCall.call();
    safeSetState(() {
      if (resposta.succeeded && clienteId != null) {
        _model.historico = MeuspontosModel.montarHistorico(
            ((resposta.jsonBody as List?) ?? [])
                .where((p) => getJsonField(p, r'''$.cliente_id''') == clienteId)
                .toList());
      } else if (!resposta.succeeded) {
        _model.mensagemErro = 'Não foi possível carregar seu histórico.';
      }
      _model.carregando = false;
    });
  }

  Future<void> _resgatarDesconto(int pontos) async {
    if (pontos < kPontosPorResgate) {
      showSnackbar(context,
          'Você precisa de $kPontosPorResgate pontos para este resgate.');
      return;
    }
    if (FFAppState().carrinho.isEmpty) {
      showSnackbar(context,
          'Escolha seus pratos e use os pontos na tela de pagamento.');
      context.goNamed(MenucardapioCopyCopy2Widget.routeName);
      return;
    }
    context.pushNamed(PagamentoWidget.routeName);
  }

  Widget _recompensa(
    BuildContext context, {
    required int custo,
    required String titulo,
    required bool disponivel,
    required VoidCallback aoResgatar,
  }) {
    final tema = FlutterFlowTheme.of(context);
    return CartaoSL(
      child: Row(
        children: [
          Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
              color: tema.accentContainer,
              borderRadius: BorderRadius.circular(18.0),
            ),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Text(
              '$custo',
              style: tema.titleMedium.override(
                color: tema.warning,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style:
                        tema.titleMedium.override(fontWeight: FontWeight.w600)),
                Text(
                  '$custo pontos · use no pagamento',
                  style: tema.bodySmall.override(color: tema.secondaryText),
                ),
              ],
            ),
          ),
          BotaoPrimarioSL(
            texto: 'Resgatar',
            larguraTotal: false,
            altura: 48.0,
            aoTocar: disponivel ? () async => aoResgatar() : null,
          ),
        ].divide(SizedBox(width: 16.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final app = context.watch<FFAppState>();
    final pontos =
        castToType<int>(getJsonField(app.cliente, r'''$.pontos''')) ?? 0;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: tema.primaryBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            wrapWithModel(
              model: _model.cabecalhoModel,
              updateCallback: () => safeSetState(() {}),
              child: CabecalhoWidget(
                titulo: 'Meus pontos',
                subtitulo: 'Programa de fidelidade',
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: tema.primary,
                onRefresh: _carregar,
                child: ListView(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 24.0),
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: tema.primary,
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -50.0,
                            top: -10.0,
                            child: Container(
                              width: 220.0,
                              height: 220.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70.0),
                                border: Border.all(
                                  color: tema.tertiary.withValues(alpha: 0.25),
                                  width: 26.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Saldo disponível',
                                  style: tema.bodyLarge.override(
                                    color:
                                        tema.onPrimary.withValues(alpha: 0.85),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '$pontos',
                                      style: tema.displayMedium.override(
                                        color: tema.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      pontos == 1 ? 'ponto' : 'pontos',
                                      style: tema.titleLarge.override(
                                        color: tema.onPrimary,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                                Text(
                                  '1 ponto a cada R\$ 10 gastos · válidos por 180 dias',
                                  style: tema.labelLarge.override(
                                    color: tema.tertiary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.0),
                    TituloSecaoSL('Recompensas'),
                    SizedBox(height: 12.0),
                    _recompensa(
                      context,
                      custo: kPontosPorResgate,
                      titulo: '${formatarReais(kValorResgate)} de desconto',
                      disponivel: pontos >= kPontosPorResgate,
                      aoResgatar: () => _resgatarDesconto(pontos),
                    ),
                    SizedBox(height: 12.0),
                    _recompensa(
                      context,
                      custo: 100,
                      titulo: 'Prato grátis',
                      disponivel: pontos >= 100,
                      // Ainda não há regra de "prato grátis" no pagamento.
                      aoResgatar: () => showSnackbar(context,
                          'O resgate de prato grátis estará disponível em breve.'),
                    ),
                    SizedBox(height: 28.0),
                    TituloSecaoSL('Histórico'),
                    SizedBox(height: 12.0),
                    if (_model.carregando)
                      Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                            child:
                                CircularProgressIndicator(color: tema.primary)),
                      )
                    else if (_model.mensagemErro != null)
                      AvisoSL(texto: _model.mensagemErro!)
                    else if (_model.historico.isEmpty)
                      Text(
                        'Seus pontos aparecem aqui depois do primeiro pedido pago.',
                        style:
                            tema.bodyMedium.override(color: tema.secondaryText),
                      )
                    else
                      CartaoSL(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: _model.historico.map((lancamento) {
                            final positivo = lancamento.pontos > 0;
                            return Container(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 16.0, 20.0, 16.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: tema.alternate, width: 1.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(lancamento.descricao,
                                            style: tema.bodyLarge),
                                        Text(
                                          dataAmigavel(lancamento.data)
                                              .split(',')
                                              .first,
                                          style: tema.bodySmall.override(
                                              color: tema.secondaryText),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${positivo ? '+' : ''}${lancamento.pontos}',
                                    style: tema.titleMedium.override(
                                      color: positivo ? tema.success : tema.error,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
