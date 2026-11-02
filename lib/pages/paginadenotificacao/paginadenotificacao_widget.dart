import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/sessao_cliente.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'paginadenotificacao_model.dart';
export 'paginadenotificacao_model.dart';

/// Notificações: preferências (status do pedido e promoções) e lista de
/// notificações recentes.
class PaginadenotificacaoWidget extends StatefulWidget {
  const PaginadenotificacaoWidget({super.key});

  static String routeName = 'paginadenotificacao';
  static String routePath = '/paginadenotificacao';

  @override
  State<PaginadenotificacaoWidget> createState() =>
      _PaginadenotificacaoWidgetState();
}

class _PaginadenotificacaoWidgetState extends State<PaginadenotificacaoWidget> {
  late PaginadenotificacaoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaginadenotificacaoModel());

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
    await carregarSessaoCliente();
    try {
      // Ainda não existe endpoint `notificacao` no Xano (GET devolve 404).
      // Quando existir em api_calls.dart, atribua aqui a lista filtrada
      // pelo cliente logado a `_model.notificacoes`.
      _model.notificacoes = [];
    } catch (_) {
      _model.mensagemErro =
          'Não foi possível carregar suas notificações. Tente novamente.';
    }
    safeSetState(() => _model.carregando = false);
  }

  /// Grava a preferência no usuário (campos `notif_status` e `notif_promo`)
  /// e desfaz a mudança se o Xano recusar.
  Future<void> _salvarPreferencia({bool? status, bool? promocoes}) async {
    final anteriorStatus = _model.prefStatusPedido;
    final anteriorPromocoes = _model.prefPromocoes;
    safeSetState(() {
      _model.prefStatusPedido = status ?? _model.prefStatusPedido;
      _model.prefPromocoes = promocoes ?? _model.prefPromocoes;
    });
    final usuarioId = FFAppState().usuarioId;
    if (usuarioId == null) {
      return;
    }
    final resposta = await AtualizarUsuarioCall.call(
      userId: usuarioId,
      notifStatus: status,
      notifPromo: promocoes,
    );
    if (!resposta.succeeded && mounted) {
      safeSetState(() {
        _model.prefStatusPedido = anteriorStatus;
        _model.prefPromocoes = anteriorPromocoes;
      });
      showSnackbar(context, 'Não foi possível salvar sua preferência.');
    }
  }

  Widget _preferencia(
    BuildContext context, {
    required String titulo,
    required String subtitulo,
    required bool valor,
    required ValueChanged<bool> aoMudar,
    bool ultimo = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: ultimo
            ? null
            : Border(
                bottom: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1.0,
                ),
              ),
      ),
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 16.0, 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: FlutterFlowTheme.of(context).titleSmall,
                ),
                Text(
                  subtitulo,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ].divide(SizedBox(height: 2.0)),
            ),
          ),
          Switch(
            value: valor,
            onChanged: aoMudar,
            activeTrackColor: FlutterFlowTheme.of(context).primary,
            activeThumbColor: FlutterFlowTheme.of(context).onPrimary,
            inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
          ),
        ],
      ),
    );
  }

  Widget _cartaoNotificacao(BuildContext context, dynamic notificacao) {
    final titulo = getJsonField(notificacao, r'''$.titulo''')?.toString() ??
        'Notificação';
    final lida = getJsonField(notificacao, r'''$.lida''') == true;
    final icone = _model.iconeDe(titulo);
    final corIcone = icone == Icons.check_rounded
        ? FlutterFlowTheme.of(context).success
        : icone == Icons.two_wheeler_rounded
            ? FlutterFlowTheme.of(context).warning
            : FlutterFlowTheme.of(context).primary;
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52.0,
            height: 52.0,
            decoration: BoxDecoration(
              color: corIcone.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Icon(icone, color: corIcone, size: 24.0),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                        fontWeight: lida ? FontWeight.w500 : FontWeight.w600,
                      ),
                ),
                Text(
                  _model.tempoRelativo(dataDoXano(notificacao)),
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ].divide(SizedBox(height: 4.0)),
            ),
          ),
          if (!lida)
            Container(
              width: 10.0,
              height: 10.0,
              margin: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).error,
                shape: BoxShape.circle,
              ),
            ),
        ].divide(SizedBox(width: 16.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentes = _model.recentes;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            wrapWithModel(
              model: _model.cabecalhoModel,
              updateCallback: () => safeSetState(() {}),
              child: CabecalhoWidget(titulo: 'Notificações'),
            ),
            Expanded(
              child: RefreshIndicator(
                color: FlutterFlowTheme.of(context).primary,
                onRefresh: _carregar,
                child: ListView(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 24.0),
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _preferencia(
                            context,
                            titulo: 'Status do pedido',
                            subtitulo: 'Confirmação, preparo, entrega',
                            valor: _model.prefStatusPedido,
                            aoMudar: (valor) =>
                                _salvarPreferencia(status: valor),
                          ),
                          _preferencia(
                            context,
                            titulo: 'Promoções e ofertas',
                            subtitulo: 'Descontos exclusivos do Sabor Local',
                            valor: _model.prefPromocoes,
                            ultimo: true,
                            aoMudar: (valor) =>
                                _salvarPreferencia(promocoes: valor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.0),
                    Text(
                      'Recentes',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16.0),
                    if (_model.carregando)
                      Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      )
                    else if (_model.mensagemErro != null)
                      Column(
                        children: [
                          Text(
                            _model.mensagemErro!,
                            textAlign: TextAlign.center,
                            style:
                                FlutterFlowTheme.of(context).bodyMedium.override(
                                      color: FlutterFlowTheme.of(context).error,
                                    ),
                          ),
                          TextButton(
                            onPressed: _carregar,
                            child: Text(
                              'Tentar novamente',
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                            ),
                          ),
                        ],
                      )
                    else if (recentes.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.notifications_none_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 48.0,
                            ),
                            Text(
                              'Nenhuma notificação por aqui.',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).titleSmall,
                            ),
                            Text(
                              'Avisaremos você sobre seus pedidos e promoções.',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      )
                    else
                      ...recentes
                          .map((n) => _cartaoNotificacao(context, n))
                          .toList()
                          .divide(SizedBox(height: 12.0)),
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
