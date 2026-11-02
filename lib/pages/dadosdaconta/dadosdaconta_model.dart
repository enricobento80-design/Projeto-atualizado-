import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/code/validar_c_p_f.dart';
import 'dadosdaconta_widget.dart' show DadosdacontaWidget;
import 'package:flutter/material.dart';

class DadosdacontaModel extends FlutterFlowModel<DadosdacontaWidget> {
  ///  Local state fields for this page.

  bool carregando = true;

  bool salvando = false;

  String? mensagemErro;

  String? mensagemSucesso;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Nome widget.
  FocusNode? nomeFocusNode;
  TextEditingController? nomeTextController;
  String? Function(BuildContext, String?)? nomeTextControllerValidator;
  String? _nomeTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Informe seu nome.';
    }
    if (val.trim().length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres.';
    }
    return null;
  }

  // State field(s) for Email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Informe seu e-mail.';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(val.trim())) {
      return 'Informe um e-mail válido.';
    }
    return null;
  }

  // Celular verificado (somente leitura).
  String celular = '';

  // State field(s) for Cpf widget.
  FocusNode? cpfFocusNode;
  TextEditingController? cpfTextController;
  String? Function(BuildContext, String?)? cpfTextControllerValidator;
  String? _cpfTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return null;
    }
    if (validarCPF(val) != true) {
      return 'CPF inválido.';
    }
    return null;
  }

  // Model for Cabecalho.
  late CabecalhoModel cabecalhoModel;

  @override
  void initState(BuildContext context) {
    nomeTextControllerValidator = _nomeTextControllerValidator;
    emailTextControllerValidator = _emailTextControllerValidator;
    cpfTextControllerValidator = _cpfTextControllerValidator;
    cabecalhoModel = createModel(context, () => CabecalhoModel());
  }

  @override
  void dispose() {
    nomeFocusNode?.dispose();
    nomeTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();

    cpfFocusNode?.dispose();
    cpfTextController?.dispose();

    cabecalhoModel.dispose();
  }

  /// "(31) 9••••-1234"
  String get celularMascarado {
    final digitos = celular.replaceAll(RegExp(r'\D'), '');
    if (digitos.length < 10) {
      return celular;
    }
    final ddd = digitos.substring(0, 2);
    final finais = digitos.substring(digitos.length - 4);
    return '($ddd) ${digitos[2]}••••-$finais';
  }
}
