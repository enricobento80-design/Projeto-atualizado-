import '/backend/api_requests/api_calls.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/components/sl_ui.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'recuperarsenha_model.dart';
export 'recuperarsenha_model.dart';

/// Recuperar senha: envia o link de redefinição (reset/request-reset-link do
/// Xano) para o e-mail cadastrado.
class RecuperarsenhaWidget extends StatefulWidget {
  const RecuperarsenhaWidget({super.key, this.email});

  final String? email;

  static String routeName = 'recuperarsenha';
  static String routePath = '/recuperarsenha';

  @override
  State<RecuperarsenhaWidget> createState() => _RecuperarsenhaWidgetState();
}

class _RecuperarsenhaWidgetState extends State<RecuperarsenhaWidget> {
  late RecuperarsenhaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _mascaraCelular = MaskTextInputFormatter(mask: '(##) #####-####');

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecuperarsenhaModel());

    _model.contatoTextController ??=
        TextEditingController(text: widget.email ?? '');
    _model.contatoFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _enviarLink() async {
    safeSetState(() {
      _model.mensagemErro = null;
      _model.mensagemSucesso = null;
    });
    if (!_model.porEmail) {
      // Não há envio por SMS configurado no backend.
      safeSetState(() => _model.mensagemErro =
          'A recuperação por celular ainda não está disponível. Use seu e-mail cadastrado.');
      return;
    }
    final email = _model.contatoTextController!.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      safeSetState(() => _model.mensagemErro = 'Informe um e-mail válido.');
      return;
    }
    safeSetState(() => _model.enviando = true);
    final resposta = await SolicitarRedefinicaoSenhaCall.call(email: email);
    safeSetState(() {
      _model.enviando = false;
      if (resposta.succeeded) {
        _model.mensagemSucesso =
            'Se houver uma conta com $email, você receberá o link para criar uma nova senha em instantes.';
      } else {
        _model.mensagemErro =
            'Não foi possível enviar o link agora. Tente novamente.';
      }
    });
  }

  Widget _aba(BuildContext context, String rotulo, bool email) {
    final tema = FlutterFlowTheme.of(context);
    final selecionada = _model.porEmail == email;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14.0),
        onTap: () async => safeSetState(() {
          _model.porEmail = email;
          _model.contatoTextController!.clear();
          _model.mensagemErro = null;
          _model.mensagemSucesso = null;
        }),
        child: Container(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 14.0),
          decoration: BoxDecoration(
            color: selecionada ? tema.secondaryBackground : Colors.transparent,
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
            style: tema.titleSmall.override(
              color: selecionada ? tema.primary : tema.secondaryText,
              fontWeight: selecionada ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
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
            texto: 'Enviar link',
            carregando: _model.enviando,
            aoTocar: _enviarLink,
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              wrapWithModel(
                model: _model.cabecalhoModel,
                updateCallback: () => safeSetState(() {}),
                child: CabecalhoWidget(titulo: 'Recuperar senha'),
              ),
              Expanded(
                child: ListView(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 24.0),
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: IconeFundoSL(
                        icone: Icons.key_outlined,
                        tamanho: 88.0,
                        tamanhoIcone: 40.0,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Text(
                      'Esqueceu a senha?',
                      style: tema.headlineMedium
                          .override(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Escolha como quer receber o link para criar uma nova senha.',
                      style: tema.bodyLarge.override(color: tema.secondaryText),
                    ),
                    SizedBox(height: 24.0),
                    Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: tema.alternate,
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Row(
                        children: [
                          _aba(context, 'E-mail', true),
                          _aba(context, 'Celular', false),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.0),
                    CampoSL(
                      rotulo: _model.porEmail
                          ? 'E-mail cadastrado'
                          : 'Celular cadastrado',
                      controller: _model.contatoTextController,
                      focusNode: _model.contatoFocusNode,
                      dica: _model.porEmail
                          ? 'seuemail@exemplo.com'
                          : '(31) 99999-9999',
                      teclado: _model.porEmail
                          ? TextInputType.emailAddress
                          : TextInputType.phone,
                      formatadores: _model.porEmail ? null : [_mascaraCelular],
                      acao: TextInputAction.done,
                    ),
                    if (_model.mensagemErro != null) ...[
                      SizedBox(height: 20.0),
                      AvisoSL(texto: _model.mensagemErro!),
                    ],
                    if (_model.mensagemSucesso != null) ...[
                      SizedBox(height: 20.0),
                      AvisoSL(
                        texto: _model.mensagemSucesso!,
                        tipo: TipoAvisoSL.sucesso,
                      ),
                    ],
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
