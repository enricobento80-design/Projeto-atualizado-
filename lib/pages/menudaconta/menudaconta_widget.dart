import '/backend/api_requests/sessao_cliente.dart';
import '/components/menu_inferior/menu_inferior_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'menudaconta_model.dart';
export 'menudaconta_model.dart';

/// Link do atendimento no Telegram.
const kLinkAtendimentoTelegram =
    'https://web.telegram.org/k/#@SaborLocalSLFoodbot';

/// Perfil: dados do usuário, pontos de fidelidade e menu da conta.
class MenudacontaWidget extends StatefulWidget {
  const MenudacontaWidget({super.key});

  static String routeName = 'menudaconta';
  static String routePath = '/menudaconta';

  @override
  State<MenudacontaWidget> createState() => _MenudacontaWidgetState();
}

class _MenudacontaWidgetState extends State<MenudacontaWidget> {
  late MenudacontaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenudacontaModel());

    SchedulerBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _carregar({bool forcar = false}) async {
    safeSetState(() => _model.carregando = true);
    await carregarSessaoCliente(forcar: forcar);
    safeSetState(() => _model.carregando = false);
  }

  Future<void> _sair() async {
    final confirmou = await showDialog<bool>(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Sair da conta'),
              content: Text('Deseja mesmo sair da sua conta?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext, false),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext, true),
                  child: Text(
                    'Sair',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).error,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
    if (!confirmou || !mounted) {
      return;
    }
    FFAppState().limparSessao();
    context.goNamed(LoginWidget.routeName);
  }

  Widget _itemMenu(
    BuildContext context, {
    required IconData icone,
    required String titulo,
    required String subtitulo,
    required VoidCallback aoTocar,
    bool ultimo = false,
  }) {
    return InkWell(
      onTap: aoTocar,
      child: Container(
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
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 14.0, 16.0, 14.0),
        child: Row(
          children: [
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).alternate,
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: Icon(
                icone,
                color: FlutterFlowTheme.of(context).primary,
                size: 22.0,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    subtitulo,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 22.0,
            ),
          ].divide(SizedBox(width: 16.0)),
        ),
      ),
    );
  }

  Widget _cabecalhoUsuario(BuildContext context, FFAppState app) {
    final nome = app.usuarioNome.isEmpty ? 'Minha conta' : app.usuarioNome;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).alternate,
            shape: BoxShape.circle,
          ),
          child: Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
              shape: BoxShape.circle,
            ),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: app.usuarioNome.isEmpty
                ? Icon(
                    Icons.person_rounded,
                    color: FlutterFlowTheme.of(context).onPrimary,
                    size: 40.0,
                  )
                : Text(
                    iniciais(app.usuarioNome),
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          color: FlutterFlowTheme.of(context).onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nome,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (app.usuarioEmail.isNotEmpty)
                Text(
                  app.usuarioEmail,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
            ].divide(SizedBox(height: 4.0)),
          ),
        ),
      ].divide(SizedBox(width: 16.0)),
    );
  }

  Widget _cartaoPontos(BuildContext context, int pontos) {
    // Cada resgate de R$ 10 custa 50 pontos (programa de fidelidade).
    final resgates = pontos ~/ 50;
    return Material(
      color: FlutterFlowTheme.of(context).primary,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(24.0),
        onTap: () async {
          context.pushNamed(MeuspontosWidget.routeName);
        },
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context)
                      .tertiary
                      .withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Icon(
                  Icons.star_rounded,
                  color: FlutterFlowTheme.of(context).tertiary,
                  size: 30.0,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seus pontos',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            color: FlutterFlowTheme.of(context)
                                .onPrimary
                                .withValues(alpha: 0.85),
                          ),
                    ),
                    Text(
                      '$pontos ${pontos == 1 ? 'ponto' : 'pontos'}',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'Poppins',
                            useGoogleFonts: true,
                            color: FlutterFlowTheme.of(context).onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      resgates > 0
                          ? 'Dá para $resgates ${resgates == 1 ? 'resgate' : 'resgates'} de R\$ 10'
                          : 'Junte 50 pontos para resgatar R\$ 10',
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            color: FlutterFlowTheme.of(context).tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: FlutterFlowTheme.of(context).onPrimary,
                size: 26.0,
              ),
            ].divide(SizedBox(width: 16.0)),
          ),
        ),
      ),
    );
  }

  Widget _semLogin(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.0),
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
          Text(
            'Entre na sua conta',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'Acompanhe seus pedidos, endereços e pontos de fidelidade.',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
          ),
          FFButtonWidget(
            onPressed: () async {
              context.pushNamed(LoginWidget.routeName);
            },
            text: 'Entrar',
            options: FFButtonOptions(
              width: double.infinity,
              height: 52.0,
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    color: FlutterFlowTheme.of(context).onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ].divide(SizedBox(height: 12.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<FFAppState>();
    final logado = app.token.isNotEmpty;
    final pontos = castToType<int>(getJsonField(app.cliente, r'''$.pontos'''));

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      bottomNavigationBar: wrapWithModel(
        model: _model.menuInferiorModel,
        updateCallback: () => safeSetState(() {}),
        child: MenuInferiorWidget(abaAtual: AbaMenu.perfil),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: RefreshIndicator(
          color: FlutterFlowTheme.of(context).primary,
          onRefresh: () => _carregar(forcar: true),
          child: ListView(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
            children: [
              if (!logado)
                _semLogin(context)
              else ...[
                _cabecalhoUsuario(context, app),
                if (_model.carregando && !app.sessaoCarregada)
                  LinearProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                    backgroundColor: FlutterFlowTheme.of(context).alternate,
                  ),
                if (pontos != null) _cartaoPontos(context, pontos),
              ],
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
                    _itemMenu(
                      context,
                      icone: Icons.receipt_long_outlined,
                      titulo: 'Meus pedidos',
                      subtitulo: 'Histórico e pedidos em andamento',
                      aoTocar: () => context.goNamed(
                        MeuspedidosWidget.routeName,
                        extra: <String, dynamic>{
                          kTransitionInfoKey:
                              TransitionInfo(hasTransition: false),
                        },
                      ),
                    ),
                    _itemMenu(
                      context,
                      icone: Icons.location_on_outlined,
                      titulo: 'Endereços',
                      subtitulo: 'Cadastrar e alterar endereços',
                      aoTocar: () =>
                          context.pushNamed(EnderecosWidget.routeName),
                    ),
                    _itemMenu(
                      context,
                      icone: Icons.credit_card_outlined,
                      titulo: 'Formas de pagamento',
                      subtitulo: 'Cartões cadastrados e PIX',
                      aoTocar: () =>
                          context.pushNamed(MeiosdepagamentoWidget.routeName),
                    ),
                    _itemMenu(
                      context,
                      icone: Icons.notifications_none_rounded,
                      titulo: 'Notificações',
                      subtitulo: 'Status do pedido e promoções',
                      aoTocar: () => context
                          .pushNamed(PaginadenotificacaoWidget.routeName),
                    ),
                    _itemMenu(
                      context,
                      icone: Icons.person_outline_rounded,
                      titulo: 'Dados da conta',
                      subtitulo: 'Nome, e-mail, celular e senha',
                      aoTocar: () =>
                          context.pushNamed(DadosdacontaWidget.routeName),
                    ),
                    _itemMenu(
                      context,
                      icone: Icons.send_outlined,
                      titulo: 'Atendimento no Telegram',
                      subtitulo: 'Tire dúvidas com nosso assistente',
                      ultimo: true,
                      aoTocar: () async {
                        if (kLinkAtendimentoTelegram.isEmpty) {
                          showSnackbar(
                            context,
                            'O atendimento no Telegram estará disponível em breve.',
                          );
                          return;
                        }
                        await launchURL(kLinkAtendimentoTelegram);
                      },
                    ),
                  ],
                ),
              ),
              if (logado)
                FFButtonWidget(
                  onPressed: _sair,
                  text: 'Sair da conta',
                  icon: Icon(Icons.logout_rounded, size: 22.0),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 56.0,
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconColor: FlutterFlowTheme.of(context).error,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          color: FlutterFlowTheme.of(context).error,
                          fontWeight: FontWeight.bold,
                        ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color:
                          FlutterFlowTheme.of(context).error.withValues(alpha: 0.2),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
            ].divide(SizedBox(height: 20.0)),
          ),
        ),
      ),
    );
  }
}
