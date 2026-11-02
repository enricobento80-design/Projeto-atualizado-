import '/components/sl_ui.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'acessobloqueado_model.dart';
export 'acessobloqueado_model.dart';

/// Acesso bloqueado após 3 senhas erradas; leva à redefinição de senha.
class AcessobloqueadoWidget extends StatefulWidget {
  const AcessobloqueadoWidget({super.key, this.email});

  final String? email;

  static String routeName = 'acessobloqueado';
  static String routePath = '/acessobloqueado';

  @override
  State<AcessobloqueadoWidget> createState() => _AcessobloqueadoWidgetState();
}

class _AcessobloqueadoWidgetState extends State<AcessobloqueadoWidget> {
  late AcessobloqueadoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AcessobloqueadoModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: tema.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: IconeFundoSL(
                  icone: Icons.lock_outline_rounded,
                  cor: tema.error,
                  fundo: tema.error.withValues(alpha: 0.09),
                  tamanho: 140.0,
                  tamanhoIcone: 64.0,
                  circular: true,
                ),
              ),
              SizedBox(height: 28.0),
              Text(
                'Acesso bloqueado',
                textAlign: TextAlign.center,
                style: tema.headlineMedium.override(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                'Você errou a senha 3 vezes. Por segurança, o acesso a esta conta foi bloqueado.',
                textAlign: TextAlign.center,
                style: tema.bodyLarge.override(color: tema.secondaryText),
              ),
              SizedBox(height: 28.0),
              AvisoSL(
                tipo: TipoAvisoSL.info,
                texto:
                    'Para desbloquear, redefina sua senha pelo e-mail cadastrado.',
              ),
              Spacer(flex: 2),
              BotaoPrimarioSL(
                texto: 'Redefinir senha',
                aoTocar: () async {
                  context.pushNamed(
                    RecuperarsenhaWidget.routeName,
                    queryParameters: {
                      'email': serializeParam(widget.email, ParamType.String),
                    }.withoutNulls,
                  );
                },
              ),
              SizedBox(height: 16.0),
              BotaoSecundarioSL(
                texto: 'Voltar ao login',
                aoTocar: () async => context.goNamed(LoginWidget.routeName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
