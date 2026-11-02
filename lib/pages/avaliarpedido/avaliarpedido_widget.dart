import '/backend/api_requests/api_calls.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/components/sl_ui.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'avaliarpedido_model.dart';
export 'avaliarpedido_model.dart';

/// Avaliar pedido: estrelas, destaques, comentário e pedido de contato.
/// Ainda não há tabela de avaliações no Xano; quando o cliente pede contato,
/// a avaliação vai para `escalonamento` (painel de gestão).
class AvaliarpedidoWidget extends StatefulWidget {
  const AvaliarpedidoWidget({super.key, required this.pedidoId});

  final int? pedidoId;

  static String routeName = 'avaliarpedido';
  static String routePath = '/avaliarpedido';

  @override
  State<AvaliarpedidoWidget> createState() => _AvaliarpedidoWidgetState();
}

class _AvaliarpedidoWidgetState extends State<AvaliarpedidoWidget> {
  late AvaliarpedidoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AvaliarpedidoModel());

    _model.comentarioTextController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _enviar() async {
    if (_model.estrelas == 0) {
      safeSetState(
          () => _model.mensagemErro = 'Escolha de 1 a 5 estrelas.');
      return;
    }
    safeSetState(() => _model.mensagemErro = null);
    if (!_model.querContato) {
      // Sem tabela de avaliações no Xano: nada é gravado neste caso.
      showSnackbar(context,
          'Obrigado! O registro de avaliações no app estará disponível em breve.');
      context.safePop();
      return;
    }
    safeSetState(() => _model.enviando = true);
    final app = FFAppState();
    final comentario = _model.comentarioTextController!.text.trim();
    final resumo = [
      'Avaliação do pedido #${widget.pedidoId}: ${_model.estrelas}/5 '
          '(${AvaliarpedidoModel.rotulosEstrelas[_model.estrelas]}).',
      if (_model.destaques.isNotEmpty)
        'Destaques: ${_model.destaques.join(', ')}.',
      if (comentario.isNotEmpty) 'Comentário: $comentario',
      'O cliente pediu contato do restaurante.',
    ].join(' ');
    final resposta = await CriarEscalonamentoCall.call(
      nomeCliente: app.usuarioNome.isEmpty ? 'Cliente' : app.usuarioNome,
      resumo: resumo,
    );
    safeSetState(() => _model.enviando = false);
    if (!resposta.succeeded) {
      safeSetState(() => _model.mensagemErro =
          'Não foi possível enviar sua avaliação. Tente novamente.');
      return;
    }
    if (!mounted) {
      return;
    }
    showSnackbar(context,
        'Avaliação enviada! O restaurante vai entrar em contato com você.');
    context.safePop();
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: tema.primaryBackground,
        bottomNavigationBar: BarraInferiorSL(
          child: BotaoPrimarioSL(
            texto: 'Enviar avaliação',
            carregando: _model.enviando,
            aoTocar: _enviar,
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              wrapWithModel(
                model: _model.cabecalhoModel,
                updateCallback: () => safeSetState(() {}),
                child: CabecalhoWidget(
                  titulo: 'Avaliar pedido',
                  subtitulo: widget.pedidoId == null
                      ? null
                      : 'Pedido #${widget.pedidoId}',
                ),
              ),
              Expanded(
                child: ListView(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 20.0, 24.0),
                  children: [
                    Text(
                      'Como estava, uai?',
                      textAlign: TextAlign.center,
                      style: tema.headlineMedium
                          .override(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Sua opinião vai direto para a nossa cozinha.',
                      textAlign: TextAlign.center,
                      style: tema.bodyMedium.override(color: tema.secondaryText),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        final cheia = i < _model.estrelas;
                        return IconButton(
                          iconSize: 48.0,
                          onPressed: () =>
                              safeSetState(() => _model.estrelas = i + 1),
                          icon: Icon(
                            cheia
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: tema.tertiary,
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      height: 28.0,
                      child: Text(
                        AvaliarpedidoModel.rotulosEstrelas[_model.estrelas],
                        textAlign: TextAlign.center,
                        style: tema.titleSmall.override(
                          color: tema.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_model.mensagemErro != null) ...[
                      SizedBox(height: 12.0),
                      AvisoSL(texto: _model.mensagemErro!),
                    ],
                    SizedBox(height: 20.0),
                    Text(
                      'O que você mais gostou?',
                      style: tema.titleSmall,
                    ),
                    SizedBox(height: 12.0),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: AvaliarpedidoModel.opcoesDestaque.map((opcao) {
                        final selecionada = _model.destaques.contains(opcao);
                        return InkWell(
                          borderRadius: BorderRadius.circular(9999.0),
                          onTap: () => safeSetState(() => selecionada
                              ? _model.destaques.remove(opcao)
                              : _model.destaques.add(opcao)),
                          child: Container(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 12.0, 20.0, 12.0),
                            decoration: BoxDecoration(
                              color: selecionada
                                  ? tema.primary
                                  : tema.secondaryBackground,
                              borderRadius: BorderRadius.circular(9999.0),
                              border: Border.all(
                                color:
                                    selecionada ? tema.primary : tema.alternate,
                              ),
                            ),
                            child: Text(
                              opcao,
                              style: tema.bodyMedium.override(
                                color: selecionada
                                    ? tema.onPrimary
                                    : tema.primaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24.0),
                    CampoSL(
                      rotulo: 'Comentário',
                      controller: _model.comentarioTextController,
                      dica: 'Conte como foi sua experiência',
                      capitalizacao: TextCapitalization.sentences,
                      linhas: 4,
                    ),
                    SizedBox(height: 16.0),
                    InkWell(
                      onTap: () => safeSetState(
                          () => _model.querContato = !_model.querContato),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _model.querContato,
                            onChanged: (valor) => safeSetState(
                                () => _model.querContato = valor ?? false),
                            activeColor: tema.primary,
                          ),
                          Expanded(
                            child: Text(
                              'Quero que o restaurante entre em contato',
                              style: tema.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
