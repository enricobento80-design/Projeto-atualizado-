import 'dart:async';

import '/backend/api_requests/api_calls.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/components/sl_ui.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'verificao_model.dart';
export 'verificao_model.dart';

/// Etapa 3 do cadastro: confirma o código de 6 dígitos enviado ao e-mail
/// (validarOtp do Xano) e segue para o endereço de entrega.
class VerificaoWidget extends StatefulWidget {
  const VerificaoWidget({super.key, this.email});

  final String? email;

  static String routeName = 'verificao';
  static String routePath = '/verificao';

  @override
  State<VerificaoWidget> createState() => _VerificaoWidgetState();
}

class _VerificaoWidgetState extends State<VerificaoWidget> {
  late VerificaoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Validade exibida para o código (o Xano controla a expiração real).
  static const _validade = Duration(minutes: 15);

  Timer? _relogio;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VerificaoModel());

    _model.codigoController ??= TextEditingController();
    _model.codigoFocusNode ??= FocusNode();

    _model.expiraEm = DateTime.now().add(_validade);
    _relogio = Timer.periodic(
        Duration(seconds: 1), (_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _relogio?.cancel();
    _model.dispose();

    super.dispose();
  }

  Duration get _restante {
    final restante = _model.expiraEm!.difference(DateTime.now());
    return restante.isNegative ? Duration.zero : restante;
  }

  Future<void> _reenviar() async {
    final email = widget.email ?? '';
    if (email.isEmpty) {
      return;
    }
    safeSetState(() {
      _model.reenviando = true;
      _model.mensagemErro = null;
    });
    final resposta = await CodigoOTPCall.call(email: email);
    safeSetState(() {
      _model.reenviando = false;
      if (resposta.succeeded) {
        _model.expiraEm = DateTime.now().add(_validade);
        _model.codigoController!.clear();
      } else {
        _model.mensagemErro =
            'Não foi possível reenviar o código. Tente novamente.';
      }
    });
  }

  Future<void> _confirmar() async {
    final codigo = _model.codigoController!.text;
    if (codigo.length != 6) {
      safeSetState(
          () => _model.mensagemErro = 'Digite os 6 dígitos do código.');
      return;
    }
    if (_restante == Duration.zero) {
      safeSetState(() => _model.mensagemErro =
          'O código expirou. Toque em "Reenviar código".');
      return;
    }
    safeSetState(() {
      _model.confirmando = true;
      _model.mensagemErro = null;
    });
    final resposta = await ValidarOTPCall.call(
      codigo: codigo,
      token: FFAppState().token,
    );
    safeSetState(() => _model.confirmando = false);
    if (!resposta.succeeded) {
      safeSetState(() => _model.mensagemErro = 'Código inválido. Confira e tente de novo.');
      return;
    }
    if (!mounted) {
      return;
    }
    context.goNamed(
      CadastroenderecoWidget.routeName,
      queryParameters: {
        'origemCadastro': serializeParam(true, ParamType.bool),
      }.withoutNulls,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final restante = _restante;
    final minutos = restante.inMinutes.toString().padLeft(2, '0');
    final segundos = (restante.inSeconds % 60).toString().padLeft(2, '0');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: tema.primaryBackground,
        bottomNavigationBar: BarraInferiorSL(
          child: BotaoPrimarioSL(
            texto: 'Confirmar código',
            carregando: _model.confirmando,
            aoTocar: _confirmar,
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
                  titulo: 'Verificação',
                  subtitulo: 'Etapa 3 de 3',
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: EtapasSL(etapa: 3),
              ),
              Expanded(
                child: ListView(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                  children: [
                    AvisoSL(
                      tipo: _model.mensagemErro == null
                          ? TipoAvisoSL.sucesso
                          : TipoAvisoSL.erro,
                      texto: _model.mensagemErro ??
                          'Código enviado! Verifique seu e-mail',
                    ),
                    SizedBox(height: 24.0),
                    Text(
                      'Digite o código',
                      style: tema.headlineMedium
                          .override(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Enviamos 6 dígitos para '),
                          TextSpan(
                            text: VerificaoModel.emailMascarado(
                                widget.email ?? 'seu e-mail'),
                            style: TextStyle(
                              color: tema.primaryText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                      style: tema.bodyLarge.override(color: tema.secondaryText),
                    ),
                    SizedBox(height: 24.0),
                    PinCodeTextField(
                      autoDisposeControllers: false,
                      appContext: context,
                      length: 6,
                      controller: _model.codigoController,
                      focusNode: _model.codigoFocusNode,
                      autoFocus: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      enableActiveFill: true,
                      showCursor: true,
                      cursorColor: tema.primary,
                      textStyle:
                          tema.headlineSmall.override(fontFamily: 'Poppins',
                              useGoogleFonts: true, fontWeight: FontWeight.bold),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(18.0),
                        fieldHeight: 60.0,
                        fieldWidth: 48.0,
                        borderWidth: 2.0,
                        activeColor: tema.alternate,
                        inactiveColor: tema.alternate,
                        selectedColor: tema.primary,
                        activeFillColor: tema.secondaryBackground,
                        inactiveFillColor: tema.secondaryBackground,
                        selectedFillColor: tema.secondaryBackground,
                      ),
                      onChanged: (_) {},
                      onCompleted: (_) => _confirmar(),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded,
                            color: tema.secondaryText, size: 20.0),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            restante == Duration.zero
                                ? 'Código expirado'
                                : 'Válido por $minutos:$segundos',
                            style: tema.bodyMedium
                                .override(color: tema.secondaryText),
                          ),
                        ),
                        TextButton(
                          onPressed: _model.reenviando ? null : _reenviar,
                          child: Text(
                            _model.reenviando
                                ? 'Reenviando...'
                                : 'Reenviar código',
                            style: tema.titleSmall.override(
                              color: tema.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
