import '/backend/api_requests/api_calls.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/components/sl_ui.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'cadastro_model.dart';
export 'cadastro_model.dart';

/// Criar conta: Etapa 1 (nome e celular) e Etapa 2 (e-mail, CPF e senha).
/// Ao final da Etapa 2 a conta é criada no Xano (auth/signup + cliente) e o
/// código de verificação é enviado ao e-mail; a Etapa 3 é a tela Verificação.
class CadastroWidget extends StatefulWidget {
  const CadastroWidget({super.key});

  static String routeName = 'cadastro';
  static String routePath = '/cadastro';

  @override
  State<CadastroWidget> createState() => _CadastroWidgetState();
}

class _CadastroWidgetState extends State<CadastroWidget> {
  late CadastroModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _mascaraCelular = MaskTextInputFormatter(mask: '(##) #####-####');
  final _mascaraCpf = MaskTextInputFormatter(mask: '###.###.###-##');

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CadastroModel());

    _model.nomeTextController ??= TextEditingController();
    _model.nomeFocusNode ??= FocusNode();
    _model.celularTextController ??= TextEditingController();
    _model.celularFocusNode ??= FocusNode();
    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();
    _model.cpfTextController ??= TextEditingController();
    _model.cpfFocusNode ??= FocusNode();
    _model.senhaTextController ??= TextEditingController();
    _model.senhaFocusNode ??= FocusNode();
    _model.confirmarSenhaTextController ??= TextEditingController();
    _model.confirmarSenhaFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _voltar() async {
    if (_model.etapa == 2) {
      safeSetState(() {
        _model.etapa = 1;
        _model.mensagemErro = null;
      });
      return;
    }
    context.safePop();
  }

  Future<void> _continuarEtapa1() async {
    if (_model.formEtapa1.currentState?.validate() != true) {
      return;
    }
    safeSetState(() {
      _model.etapa = 2;
      _model.mensagemErro = null;
    });
  }

  Future<void> _criarContaEEnviarCodigo() async {
    if (_model.formEtapa2.currentState?.validate() != true) {
      return;
    }
    final email = _model.emailTextController!.text.trim().toLowerCase();
    safeSetState(() {
      _model.enviando = true;
      _model.mensagemErro = null;
    });
    final app = FFAppState();

    if (!_model.contaCriada) {
      final usuario = await CadastroUserCall.call(
        nome: _model.nomeTextController!.text.trim(),
        email: email,
        senha: _model.senha,
      );
      if (!usuario.succeeded) {
        final mensagem =
            getJsonField(usuario.jsonBody, r'''$.message''')?.toString() ?? '';
        safeSetState(() {
          _model.enviando = false;
          _model.mensagemErro = mensagem.toLowerCase().contains('exist') ||
                  mensagem.toLowerCase().contains('use')
              ? 'Já existe uma conta com este e-mail. Entre ou recupere sua senha.'
              : 'Não foi possível criar sua conta. Tente novamente.';
        });
        return;
      }
      app.token = CadastroUserCall.token(usuario.jsonBody) ?? '';
      app.sessaoCarregada = false;

      final cliente = await CadastroClienteCall.call(
        celular: _model.celularDigitos,
        cpf: _model.cpfDigitos,
        tokens: app.token,
      );
      if (!cliente.succeeded) {
        safeSetState(() {
          _model.enviando = false;
          _model.mensagemErro =
              'Sua conta foi criada, mas não conseguimos salvar seu celular e CPF. Tente novamente.';
        });
        return;
      }
      final clienteId =
          castToType<int>(getJsonField(cliente.jsonBody, r'''$.id'''));
      if (clienteId != null) {
        await AtualizarClienteCall.call(
          clienteId: clienteId,
          nome: _model.nomeTextController!.text.trim(),
          email: email,
        );
      }
      _model.contaCriada = true;
    }

    final codigo = await CodigoOTPCall.call(email: email);
    safeSetState(() => _model.enviando = false);
    if (!codigo.succeeded) {
      safeSetState(() => _model.mensagemErro =
          'Não foi possível enviar o código para $email. Tente novamente.');
      return;
    }
    if (!mounted) {
      return;
    }
    context.pushNamed(
      VerificaoWidget.routeName,
      queryParameters: {
        'email': serializeParam(email, ParamType.String),
      }.withoutNulls,
    );
  }

  Widget _requisito(BuildContext context, String texto, bool ok) {
    final tema = FlutterFlowTheme.of(context);
    final cor = ok ? tema.success : tema.secondaryText;
    return Row(
      children: [
        Icon(Icons.check_rounded, color: cor, size: 18.0),
        Text(texto, style: tema.bodySmall.override(color: cor)),
      ].divide(SizedBox(width: 8.0)),
    );
  }

  Widget _etapa1(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Form(
      key: _model.formEtapa1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Bem-vindo ao Sabor Local',
            style: tema.headlineMedium.override(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Insira seu nome completo e celular para começar.',
            style: tema.bodyLarge.override(color: tema.secondaryText),
          ),
          SizedBox(height: 24.0),
          CampoSL(
            rotulo: 'Nome completo',
            controller: _model.nomeTextController,
            focusNode: _model.nomeFocusNode,
            dica: 'Ex.: Maria da Silva',
            capitalizacao: TextCapitalization.words,
            validator: _model.validarNome,
          ),
          SizedBox(height: 20.0),
          Text(
            'Celular',
            style: tema.labelLarge.override(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: tema.alternate,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Text('+55', style: tema.bodyLarge),
              ),
              Expanded(
                child: TextFormField(
                  controller: _model.celularTextController,
                  focusNode: _model.celularFocusNode,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_mascaraCelular],
                  textInputAction: TextInputAction.done,
                  decoration:
                      decoracaoCampoSL(context, dica: '(31) 99999-9999'),
                  style: tema.bodyLarge,
                  cursorColor: tema.primary,
                  validator: _model.validarCelular,
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
          SizedBox(height: 24.0),
          AvisoSL(
            tipo: TipoAvisoSL.info,
            texto:
                'Na próxima etapa você cria sua senha e enviamos um código de verificação para o seu e-mail.',
          ),
        ],
      ),
    );
  }

  Widget _etapa2(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Form(
      key: _model.formEtapa2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quase lá!',
            style: tema.headlineMedium.override(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Complete seus dados e crie uma senha. Depois, confirme o código e cadastre o endereço de entrega.',
            style: tema.bodyLarge.override(color: tema.secondaryText),
          ),
          SizedBox(height: 24.0),
          if (_model.mensagemErro != null) ...[
            AvisoSL(texto: _model.mensagemErro!),
            SizedBox(height: 20.0),
          ],
          CampoSL(
            rotulo: 'E-mail',
            controller: _model.emailTextController,
            focusNode: _model.emailFocusNode,
            dica: 'seuemail@exemplo.com',
            teclado: TextInputType.emailAddress,
            validator: _model.validarEmail,
            somenteLeitura: _model.contaCriada,
          ),
          SizedBox(height: 20.0),
          CampoSL(
            rotulo: 'CPF',
            complementoRotulo: '(opcional)',
            controller: _model.cpfTextController,
            focusNode: _model.cpfFocusNode,
            dica: '000.000.000-00',
            teclado: TextInputType.number,
            formatadores: [_mascaraCpf],
            validator: _model.validarCpfOpcional,
            somenteLeitura: _model.contaCriada,
          ),
          SizedBox(height: 20.0),
          CampoSL(
            rotulo: 'Senha',
            controller: _model.senhaTextController,
            focusNode: _model.senhaFocusNode,
            dica: 'Mínimo de 8 caracteres',
            senha: true,
            validator: _model.validarSenha,
            aoMudar: (_) => safeSetState(() {}),
            somenteLeitura: _model.contaCriada,
          ),
          SizedBox(height: 12.0),
          _requisito(context, 'Pelo menos 8 caracteres', _model.senhaTemTamanho),
          SizedBox(height: 6.0),
          _requisito(context, 'Um número', _model.senhaTemNumero),
          SizedBox(height: 6.0),
          _requisito(context, 'Uma letra maiúscula', _model.senhaTemMaiuscula),
          SizedBox(height: 20.0),
          CampoSL(
            rotulo: 'Confirmar senha',
            controller: _model.confirmarSenhaTextController,
            focusNode: _model.confirmarSenhaFocusNode,
            dica: 'Repita a senha',
            senha: true,
            acao: TextInputAction.done,
            validator: _model.validarConfirmacao,
            somenteLeitura: _model.contaCriada,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final primeira = _model.etapa == 1;
    return PopScope(
      canPop: primeira,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _voltar();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: tema.primaryBackground,
          bottomNavigationBar: BarraInferiorSL(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BotaoPrimarioSL(
                  texto: primeira ? 'Continuar' : 'Enviar código',
                  carregando: _model.enviando,
                  aoTocar:
                      primeira ? _continuarEtapa1 : _criarContaEEnviarCodigo,
                ),
                if (primeira)
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Já tem conta?',
                          style: tema.bodyMedium
                              .override(color: tema.secondaryText),
                        ),
                        InkWell(
                          onTap: () async =>
                              context.goNamed(LoginWidget.routeName),
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              'Entrar',
                              style: tema.bodyMedium.override(
                                color: tema.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 4.0)),
                    ),
                  ),
              ],
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
                    titulo: primeira ? 'Criar conta' : 'Seus dados',
                    subtitulo: 'Etapa ${_model.etapa} de 3',
                    aoVoltar: _voltar,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: EtapasSL(etapa: _model.etapa),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                    child: primeira ? _etapa1(context) : _etapa2(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
