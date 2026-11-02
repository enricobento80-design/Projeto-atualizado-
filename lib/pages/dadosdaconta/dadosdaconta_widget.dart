import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/sessao_cliente.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dadosdaconta_model.dart';
export 'dadosdaconta_model.dart';

/// Dados da conta: nome, e-mail, celular verificado e CPF do cliente logado
/// (auth/me e tabela `cliente` do Xano), segurança e exclusão da conta.
class DadosdacontaWidget extends StatefulWidget {
  const DadosdacontaWidget({super.key});

  static String routeName = 'dadosdaconta';
  static String routePath = '/dadosdaconta';

  @override
  State<DadosdacontaWidget> createState() => _DadosdacontaWidgetState();
}

class _DadosdacontaWidgetState extends State<DadosdacontaWidget> {
  late DadosdacontaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _mascaraCpf = MaskTextInputFormatter(mask: '###.###.###-##');

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DadosdacontaModel());

    _model.nomeTextController ??= TextEditingController();
    _model.nomeFocusNode ??= FocusNode();

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.cpfTextController ??= TextEditingController();
    _model.cpfFocusNode ??= FocusNode();

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
    await carregarSessaoCliente();
    if (app.token.isNotEmpty && !app.sessaoCarregada) {
      _model.mensagemErro =
          'Não foi possível carregar seus dados. Tente novamente.';
    }
    _model.nomeTextController!.text = app.usuarioNome;
    _model.emailTextController!.text = app.usuarioEmail;
    _model.celular =
        getJsonField(app.cliente, r'''$.celular''')?.toString() ?? '';
    _model.cpfTextController!.text = _mascaraCpf.maskText(
        getJsonField(app.cliente, r'''$.cpf''')?.toString() ?? '');
    safeSetState(() => _model.carregando = false);
  }

  Future<void> _salvar() async {
    safeSetState(() {
      _model.mensagemErro = null;
      _model.mensagemSucesso = null;
    });
    if (_model.formKey.currentState == null ||
        !_model.formKey.currentState!.validate()) {
      return;
    }

    final app = FFAppState();
    final clienteId = castToType<int>(getJsonField(app.cliente, r'''$.id'''));
    if (clienteId == null || app.usuarioId == null) {
      safeSetState(() => _model.mensagemErro =
          'Não encontramos seu cadastro. Entre novamente na sua conta.');
      return;
    }
    final nome = _model.nomeTextController!.text.trim();
    final email = _model.emailTextController!.text.trim().toLowerCase();
    final cpf = _model.cpfTextController!.text.replaceAll(RegExp(r'\D'), '');

    safeSetState(() => _model.salvando = true);
    final respostas = await Future.wait([
      AtualizarClienteCall.call(
        clienteId: clienteId,
        nome: nome,
        email: email,
        cpf: cpf,
      ),
      AtualizarUsuarioCall.call(
        userId: app.usuarioId!,
        nome: nome,
        email: email,
      ),
    ]);
    final ok = respostas.every((r) => r.succeeded);
    if (ok) {
      await carregarSessaoCliente(forcar: true);
    }
    safeSetState(() {
      _model.salvando = false;
      if (ok) {
        _model.mensagemSucesso = 'Dados atualizados com sucesso.';
      } else {
        _model.mensagemErro =
            'Não foi possível salvar suas alterações. Tente novamente.';
      }
    });
  }

  Future<void> _confirmarExclusao() async {
    final primeiraConfirmacao = await showDialog<bool>(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Excluir minha conta'),
              content: Text(
                  'Ao excluir sua conta, seus dados, endereços e histórico de pedidos serão removidos. Deseja continuar?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext, false),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext, true),
                  child: Text('Continuar'),
                ),
              ],
            );
          },
        ) ??
        false;
    if (!primeiraConfirmacao || !mounted) {
      return;
    }

    final segundaConfirmacao = await showDialog<bool>(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Tem certeza?'),
              content: Text('Esta ação é permanente e não poderá ser desfeita.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext, false),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext, true),
                  child: Text(
                    'Sim, excluir',
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
    if (!segundaConfirmacao || !mounted) {
      return;
    }

    // A exclusão não é feita automaticamente: quando houver um endpoint de
    // exclusão no Xano, chame-o aqui.
    showSnackbar(
      context,
      'Solicitação recebida. Para concluir a exclusão, entre em contato com o suporte.',
    );
  }

  InputDecoration _decoracao(BuildContext context, String hint) {
    OutlineInputBorder borda(Color cor) => OutlineInputBorder(
          borderSide: BorderSide(color: cor, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: FlutterFlowTheme.of(context).bodyLarge.override(
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
      filled: true,
      fillColor: FlutterFlowTheme.of(context).primaryBackground,
      contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 18.0, 20.0, 18.0),
      enabledBorder: borda(FlutterFlowTheme.of(context).alternate),
      focusedBorder: borda(FlutterFlowTheme.of(context).primary),
      errorBorder: borda(FlutterFlowTheme.of(context).error),
      focusedErrorBorder: borda(FlutterFlowTheme.of(context).error),
    );
  }

  Widget _campo(BuildContext context, Widget rotulo, Widget campo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [rotulo, campo].divide(SizedBox(height: 8.0)),
    );
  }

  Widget _rotulo(BuildContext context, String texto, [String? extra]) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: texto),
          if (extra != null)
            TextSpan(
              text: ' $extra',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).secondaryText,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
      style: FlutterFlowTheme.of(context).labelLarge.override(
            color: FlutterFlowTheme.of(context).primary,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  Widget _linhaSeguranca(
    BuildContext context, {
    required IconData icone,
    required String titulo,
    required bool perigo,
    required VoidCallback aoTocar,
    bool ultimo = false,
  }) {
    final cor = perigo
        ? FlutterFlowTheme.of(context).error
        : FlutterFlowTheme.of(context).primaryText;
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
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 16.0, 16.0),
        child: Row(
          children: [
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: perigo
                    ? FlutterFlowTheme.of(context)
                        .error
                        .withValues(alpha: 0.08)
                    : FlutterFlowTheme.of(context).alternate,
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: Icon(
                icone,
                color: perigo
                    ? FlutterFlowTheme.of(context).error
                    : FlutterFlowTheme.of(context).primary,
                size: 22.0,
              ),
            ),
            Expanded(
              child: Text(
                titulo,
                style: FlutterFlowTheme.of(context).titleSmall.override(
                      color: cor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: perigo
                  ? FlutterFlowTheme.of(context).error
                  : FlutterFlowTheme.of(context).secondaryText,
              size: 22.0,
            ),
          ].divide(SizedBox(width: 16.0)),
        ),
      ),
    );
  }

  Widget _aviso(BuildContext context, String texto, {required bool erro}) {
    final cor = erro
        ? FlutterFlowTheme.of(context).error
        : FlutterFlowTheme.of(context).success;
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Icon(
            erro
                ? Icons.error_outline_rounded
                : Icons.check_circle_outline_rounded,
            color: cor,
            size: 22.0,
          ),
          Expanded(
            child: Text(
              texto,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    color: cor,
                  ),
            ),
          ),
        ].divide(SizedBox(width: 12.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            border: Border(
              top: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 1.0,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
              child: FFButtonWidget(
                onPressed:
                    (_model.salvando || _model.carregando) ? null : _salvar,
                text: _model.salvando ? 'Salvando...' : 'Salvar alterações',
                icon: _model.salvando
                    ? SizedBox(
                        width: 18.0,
                        height: 18.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: FlutterFlowTheme.of(context).onPrimary,
                        ),
                      )
                    : null,
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 56.0,
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        color: FlutterFlowTheme.of(context).onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(18.0),
                  disabledColor: FlutterFlowTheme.of(context)
                      .primary
                      .withValues(alpha: 0.6),
                  disabledTextColor: FlutterFlowTheme.of(context).onPrimary,
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              wrapWithModel(
                model: _model.cabecalhoModel,
                updateCallback: () => safeSetState(() {}),
                child: CabecalhoWidget(
                  titulo: 'Dados da conta',
                  subtitulo: 'Gerencie suas informações e segurança',
                ),
              ),
              Expanded(
                child: _model.carregando
                    ? Center(
                        child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 24.0),
                        child: Form(
                          key: _model.formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_model.mensagemErro != null)
                                _aviso(context, _model.mensagemErro!,
                                    erro: true),
                              if (_model.mensagemSucesso != null)
                                _aviso(context, _model.mensagemSucesso!,
                                    erro: false),
                              Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _campo(
                                      context,
                                      _rotulo(context, 'Nome completo'),
                                      TextFormField(
                                        controller: _model.nomeTextController,
                                        focusNode: _model.nomeFocusNode,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        decoration: _decoracao(
                                            context, 'Ex.: Maria da Silva'),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        validator: _model
                                            .nomeTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                    _campo(
                                      context,
                                      _rotulo(context, 'E-mail'),
                                      TextFormField(
                                        controller:
                                            _model.emailTextController,
                                        focusNode: _model.emailFocusNode,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        decoration: _decoracao(
                                            context, 'seuemail@exemplo.com'),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        validator: _model
                                            .emailTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                    _campo(
                                      context,
                                      _rotulo(context, 'Celular',
                                          '(verificado)'),
                                      Container(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20.0, 18.0, 20.0, 18.0),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              _model.celular.isEmpty
                                                  ? 'Não informado'
                                                  : _model.celularMascarado,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge,
                                            ),
                                            if (_model.celular.isNotEmpty)
                                              Icon(
                                                Icons.check_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .success,
                                                size: 20.0,
                                              ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                      ),
                                    ),
                                    _campo(
                                      context,
                                      _rotulo(context, 'CPF', '(opcional)'),
                                      TextFormField(
                                        controller: _model.cpfTextController,
                                        focusNode: _model.cpfFocusNode,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [_mascaraCpf],
                                        decoration: _decoracao(
                                            context, '000.000.000-00'),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge,
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        validator: _model
                                            .cpfTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 16.0)),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Segurança e Privacidade',
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _linhaSeguranca(
                                      context,
                                      icone: Icons.lock_outline_rounded,
                                      titulo: 'Alterar senha',
                                      perigo: false,
                                      // A troca de senha usa o link de
                                      // redefinição enviado por e-mail.
                                      aoTocar: () => context.pushNamed(
                                        RecuperarsenhaWidget.routeName,
                                        queryParameters: {
                                          'email': serializeParam(
                                            FFAppState().usuarioEmail,
                                            ParamType.String,
                                          ),
                                        }.withoutNulls,
                                      ),
                                    ),
                                    _linhaSeguranca(
                                      context,
                                      icone: Icons.delete_outline_rounded,
                                      titulo: 'Excluir minha conta',
                                      perigo: true,
                                      ultimo: true,
                                      aoTocar: _confirmarExclusao,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Seus dados são tratados conforme a LGPD.',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
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
