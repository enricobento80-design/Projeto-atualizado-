import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'verificao_widget.dart' show VerificaoWidget;
import 'package:flutter/material.dart';

class VerificaoModel extends FlutterFlowModel<VerificaoWidget> {
  ///  Local state fields for this page.

  bool confirmando = false;

  bool reenviando = false;

  String? mensagemErro;

  // Validade do código enviado (contagem regressiva).
  DateTime? expiraEm;

  ///  State fields for stateful widgets in this page.

  TextEditingController? codigoController;
  FocusNode? codigoFocusNode;

  // Model for Cabecalho.
  late CabecalhoModel cabecalhoModel;

  @override
  void initState(BuildContext context) {
    cabecalhoModel = createModel(context, () => CabecalhoModel());
  }

  @override
  void dispose() {
    codigoController?.dispose();
    codigoFocusNode?.dispose();
    cabecalhoModel.dispose();
  }

  /// "m•••@gmail.com"
  static String emailMascarado(String email) {
    final partes = email.split('@');
    if (partes.length != 2 || partes.first.isEmpty) {
      return email;
    }
    return '${partes.first[0]}•••@${partes.last}';
  }
}
