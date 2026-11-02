import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/sessao_cliente.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/components/menu_inferior/menu_inferior_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'meuspedidos_model.dart';
export 'meuspedidos_model.dart';

/// Meus pedidos: abas "Em andamento" e "Anteriores" com os pedidos do
/// cliente logado (tabelas `pedido` e `status_pedido` do Xano).
class MeuspedidosWidget extends StatefulWidget {
  const MeuspedidosWidget({super.key});

  static String routeName = 'meuspedidos';
  static String routePath = '/meuspedidos';

  @override
  State<MeuspedidosWidget> createState() => _MeuspedidosWidgetState();
}

class _MeuspedidosWidgetState extends State<MeuspedidosWidget> {
  late MeuspedidosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MeuspedidosModel());

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
    if (app.token.isEmpty) {
      safeSetState(() => _model.carregando = false);
      return;
    }
    await carregarSessaoCliente();
    final clienteId = getJsonField(app.cliente, r'''$.id''');

    final respostas = await Future.wait([
      ListarPedidosCall.call(),
      ListarStatusPedidoCall.call(),
      ListarItensCall.call(),
      TodosOsProdutosCall.call(),
    ]);
    if (respostas[2].succeeded && respostas[3].succeeded) {
      final nomes = {
        for (final produto in (respostas[3].jsonBody as List?) ?? [])
          getJsonField(produto, r'''$.id'''):
              getJsonField(produto, r'''$.nome''')?.toString() ?? 'Item',
      };
      final porPedido = <int, List<String>>{};
      for (final item in (respostas[2].jsonBody as List?) ?? []) {
        final pedidoId =
            castToType<int>(getJsonField(item, r'''$.pedido_id'''));
        if (pedidoId == null) {
          continue;
        }
        porPedido.putIfAbsent(pedidoId, () => []).add(
            '${getJsonField(item, r'''$.qtd''') ?? 1}× ${nomes[getJsonField(item, r'''$.produto_id''')] ?? 'Item'}');
      }
      _model.resumos = porPedido.map((id, itens) => MapEntry(id, itens.join(', ')));
    }
    safeSetState(() {
      if (!respostas[0].succeeded) {
        _model.mensagemErro =
            'Não foi possível carregar seus pedidos. Tente novamente.';
      } else {
        // O endpoint devolve todos os pedidos; filtramos pelo cliente.
        _model.pedidos = clienteId == null
            ? []
            : ((respostas[0].jsonBody as List?) ?? [])
                .where((p) => getJsonField(p, r'''$.cliente_id''') == clienteId)
                .toList();
      }
      if (respostas[1].succeeded) {
        _model.nomesStatus = {
          for (final status in (respostas[1].jsonBody as List?) ?? [])
            castToType<int>(getJsonField(status, r'''$.id''')) ?? 0:
                getJsonField(status, r'''$.status''')?.toString() ?? '',
        };
      }
      _model.carregando = false;
    });
  }

  void _irPara(String rota) {
    context.goNamed(
      rota,
      extra: <String, dynamic>{
        kTransitionInfoKey: TransitionInfo(hasTransition: false),
      },
    );
  }

  Widget _abas(BuildContext context) {
    Widget aba(int indice, String rotulo) {
      final selecionada = _model.abaSelecionada == indice;
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(14.0),
          onTap: () async =>
              safeSetState(() => _model.abaSelecionada = indice),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
            decoration: BoxDecoration(
              color: selecionada
                  ? FlutterFlowTheme.of(context).secondaryBackground
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14.0),
              boxShadow: selecionada
                  ? [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x14000000),
                        offset: Offset(0.0, 2.0),
                      )
                    ]
                  : null,
            ),
            child: Text(
              rotulo,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    color: selecionada
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).secondaryText,
                    fontWeight: selecionada ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).alternate,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        children: [
          aba(0, 'Em andamento'),
          aba(1, 'Anteriores'),
        ],
      ),
    );
  }

  Widget _cartaoPedido(BuildContext context, dynamic pedido) {
    final andamento = _model.emAndamento(pedido);
    final numero = getJsonField(pedido, r'''$.id''');
    final resumo = _model.resumos[numero] ?? '';
    void acompanhar() => context.pushNamed(
          AcompanharpedidoWidget.routeName,
          queryParameters: {
            'pedidoId': serializeParam(numero, ParamType.int),
          }.withoutNulls,
        );
    return InkWell(
      borderRadius: BorderRadius.circular(24.0),
      onTap: acompanhar,
      child: Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${dataAmigavel(dataDoXano(pedido))} · Pedido #$numero',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
                decoration: BoxDecoration(
                  color: andamento
                      ? FlutterFlowTheme.of(context).accentContainer
                      : FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(9999.0),
                ),
                child: Text(
                  _model.nomeStatus(pedido),
                  style: FlutterFlowTheme.of(context).labelSmall.override(
                        color: andamento
                            ? FlutterFlowTheme.of(context).warning
                            : FlutterFlowTheme.of(context).secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ].divide(SizedBox(width: 8.0)),
          ),
          if (resumo.isNotEmpty)
            Text(
              resumo,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: FlutterFlowTheme.of(context).bodyLarge,
            ),
          Row(
            children: [
              Expanded(
                child: Text(
                  formatarReais(_model.totalDoPedido(pedido)),
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              FFButtonWidget(
                onPressed: () async {
                  if (andamento) {
                    acompanhar();
                  } else {
                    _irPara(MenucardapioCopyCopy2Widget.routeName);
                  }
                },
                text: andamento ? 'Acompanhar' : 'Pedir de novo',
                options: FFButtonOptions(
                  height: 44.0,
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  color: andamento
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).secondaryBackground,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        color: andamento
                            ? FlutterFlowTheme.of(context).onPrimary
                            : FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.bold,
                      ),
                  elevation: 0.0,
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
            ],
          ),
        ].divide(SizedBox(height: 16.0)),
      ),
      ),
    );
  }

  Widget _mensagemCentral(
    BuildContext context, {
    required IconData icone,
    required String texto,
    required String rotuloBotao,
    required VoidCallback aoTocar,
    bool erro = false,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 48.0, 16.0, 48.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icone,
            color: erro
                ? FlutterFlowTheme.of(context).error
                : FlutterFlowTheme.of(context).secondaryText,
            size: 48.0,
          ),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  color: erro
                      ? FlutterFlowTheme.of(context).error
                      : FlutterFlowTheme.of(context).primaryText,
                ),
          ),
          FFButtonWidget(
            onPressed: aoTocar,
            text: rotuloBotao,
            options: FFButtonOptions(
              height: 48.0,
              padding: EdgeInsetsDirectional.fromSTEB(28.0, 0.0, 28.0, 0.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    color: FlutterFlowTheme.of(context).onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
        ].divide(SizedBox(height: 16.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logado = FFAppState().token.isNotEmpty;
    final pedidos = _model.pedidosDaAba;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      bottomNavigationBar: wrapWithModel(
        model: _model.menuInferiorModel,
        updateCallback: () => safeSetState(() {}),
        child: MenuInferiorWidget(abaAtual: AbaMenu.pedidos),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            wrapWithModel(
              model: _model.cabecalhoModel,
              updateCallback: () => safeSetState(() {}),
              child: CabecalhoWidget(
                titulo: 'Meus pedidos',
                aoVoltar: () async =>
                    _irPara(MenucardapioCopyCopy2Widget.routeName),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 8.0),
              child: _abas(context),
            ),
            Expanded(
              child: RefreshIndicator(
                color: FlutterFlowTheme.of(context).primary,
                onRefresh: _carregar,
                child: ListView(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 24.0),
                  children: [
                    if (!logado)
                      _mensagemCentral(
                        context,
                        icone: Icons.lock_outline_rounded,
                        texto: 'Entre na sua conta para ver seus pedidos.',
                        rotuloBotao: 'Entrar',
                        aoTocar: () =>
                            context.pushNamed(LoginWidget.routeName),
                      )
                    else if (_model.carregando)
                      Padding(
                        padding: EdgeInsets.all(48.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      )
                    else if (_model.mensagemErro != null)
                      _mensagemCentral(
                        context,
                        icone: Icons.error_outline_rounded,
                        texto: _model.mensagemErro!,
                        rotuloBotao: 'Tentar novamente',
                        aoTocar: _carregar,
                        erro: true,
                      )
                    else if (pedidos.isEmpty)
                      _mensagemCentral(
                        context,
                        icone: Icons.receipt_long_outlined,
                        texto: 'Você ainda não pediu nada por aqui.',
                        rotuloBotao: 'Ver cardápio',
                        aoTocar: () =>
                            _irPara(MenucardapioCopyCopy2Widget.routeName),
                      )
                    else
                      ...pedidos
                          .map((pedido) => _cartaoPedido(context, pedido))
                          .toList()
                          .divide(SizedBox(height: 16.0)),
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
