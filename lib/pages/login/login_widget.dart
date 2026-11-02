import '/backend/api_requests/api_calls.dart';
import '/components/sl_ui.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'login_model.dart';
export 'login_model.dart';

/// Login do Sabor Local (e-mail e senha). Após 3 senhas erradas para o
/// mesmo e-mail, leva à tela "Acesso bloqueado".
class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'Login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const _maxTentativas = 3;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.senhaTextController ??= TextEditingController();
    _model.senhaFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void _irParaBloqueado(String email) {
    context.goNamed(
      AcessobloqueadoWidget.routeName,
      queryParameters: {
        'email': serializeParam(email, ParamType.String),
      }.withoutNulls,
    );
  }

  Future<void> _entrar() async {
    final email = _model.emailTextController!.text.trim().toLowerCase();
    final senha = _model.senhaTextController!.text;
    if (email.isEmpty || senha.isEmpty) {
      safeSetState(() {
        _model.mensagemErro = 'Informe seu e-mail e sua senha.';
        _model.tentativasRestantes = null;
      });
      return;
    }
    final app = FFAppState();
    if ((app.tentativasLogin[email] ?? 0) >= _maxTentativas) {
      _irParaBloqueado(email);
      return;
    }

    safeSetState(() {
      _model.entrando = true;
      _model.mensagemErro = null;
    });
    _model.respostaLogin = await AuthTokenCall.call(email: email, senha: senha);
    final resposta = _model.respostaLogin!;

    if (resposta.succeeded) {
      app.tentativasLogin.remove(email);
      app.sessaoCarregada = false;
      app.enderecoEntregaId = null;
      app.token =
          getJsonField(resposta.jsonBody, r'''$.authToken''')?.toString() ?? '';
      if (!mounted) {
        return;
      }
      context.goNamed(MenucardapioCopyCopy2Widget.routeName);
      return;
    }

    final mensagem =
        getJsonField(resposta.jsonBody, r'''$.message''')?.toString() ?? '';
    if (mensagem.toLowerCase().contains('bloque')) {
      app.tentativasLogin[email] = _maxTentativas;
      safeSetState(() => _model.entrando = false);
      _irParaBloqueado(email);
      return;
    }
    if (resposta.statusCode == 401 || resposta.statusCode == 403) {
      final tentativas = (app.tentativasLogin[email] ?? 0) + 1;
      app.tentativasLogin[email] = tentativas;
      if (tentativas >= _maxTentativas) {
        safeSetState(() => _model.entrando = false);
        _irParaBloqueado(email);
        return;
      }
      safeSetState(() {
        _model.entrando = false;
        _model.mensagemErro = 'E-mail ou senha incorretos.';
        _model.tentativasRestantes = _maxTentativas - tentativas;
      });
      return;
    }
    safeSetState(() {
      _model.entrando = false;
      _model.mensagemErro =
          'Não foi possível entrar agora. Verifique sua conexão e tente de novo.';
      _model.tentativasRestantes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final senhaComErro = _model.tentativasRestantes != null;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: tema.primaryBackground,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 40.0, 24.0, 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 96.0,
                          height: 96.0,
                          decoration: BoxDecoration(
                            color: tema.primary,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Icon(
                            Icons.ramen_dining_outlined,
                            color: tema.tertiary,
                            size: 48.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Sabor Local',
                        textAlign: TextAlign.center,
                        style: tema.headlineLarge,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Comida mineira de verdade, direto pra você',
                        textAlign: TextAlign.center,
                        style:
                            tema.bodyLarge.override(color: tema.secondaryText),
                      ),
                      SizedBox(height: 36.0),
                      if (_model.mensagemErro != null) ...[
                        AvisoSL(
                          texto: _model.mensagemErro!,
                          conteudo: _model.tentativasRestantes == null
                              ? null
                              : Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              '${_model.mensagemErro} Você ainda tem '),
                                      TextSpan(
                                        text:
                                            '${_model.tentativasRestantes} ${_model.tentativasRestantes == 1 ? 'tentativa' : 'tentativas'}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: '.'),
                                    ],
                                  ),
                                  style: tema.bodyMedium
                                      .override(color: tema.error),
                                ),
                        ),
                        SizedBox(height: 28.0),
                      ],
                      CampoSL(
                        rotulo: 'E-mail',
                        controller: _model.emailTextController,
                        focusNode: _model.emailFocusNode,
                        dica: 'seuemail@exemplo.com',
                        teclado: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 20.0),
                      CampoSL(
                        rotulo: 'Senha',
                        controller: _model.senhaTextController,
                        focusNode: _model.senhaFocusNode,
                        dica: 'Sua senha',
                        senha: !_model.senhaVisivel,
                        erro: senhaComErro,
                        acao: TextInputAction.done,
                        sufixo: IconButton(
                          onPressed: () => safeSetState(() =>
                              _model.senhaVisivel = !_model.senhaVisivel),
                          icon: Icon(
                            _model.senhaVisivel
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: tema.secondaryText,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Align(
                        alignment: AlignmentDirectional(1.0, 0.0),
                        child: TextButton(
                          onPressed: () async {
                            context.pushNamed(
                              RecuperarsenhaWidget.routeName,
                              queryParameters: {
                                'email': serializeParam(
                                  _model.emailTextController!.text.trim(),
                                  ParamType.String,
                                ),
                              }.withoutNulls,
                            );
                          },
                          child: Text(
                            'Esqueci minha senha',
                            style: tema.titleSmall.override(
                              color: tema.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      SizedBox(height: 24.0),
                      BotaoPrimarioSL(
                        texto: 'Entrar',
                        carregando: _model.entrando,
                        aoTocar: _entrar,
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ainda não tem conta?',
                            style: tema.bodyMedium
                                .override(color: tema.secondaryText),
                          ),
                          InkWell(
                            onTap: () async {
                              context.pushNamed(CadastroWidget.routeName);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                'Criar conta',
                                style: tema.bodyMedium.override(
                                  color: tema.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 4.0)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
