import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'recuperarsenha_widget.dart' show RecuperarsenhaWidget;
import 'package:flutter/material.dart';

class RecuperarsenhaModel extends FlutterFlowModel<RecuperarsenhaWidget> {
  ///  Local state fields for this page.

  // true = e-mail, false = celular.
  bool porEmail = true;

  bool enviando = false;

  String? mensagemErro;

  String? mensagemSucesso;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Contato widget.
  FocusNode? contatoFocusNode;
  TextEditingController? contatoTextController;

  // Model for Cabecalho.
  late CabecalhoModel cabecalhoModel;

  @override
  void initState(BuildContext context) {
    cabecalhoModel = createModel(context, () => CabecalhoModel());
  }

  @override
  void dispose() {
    contatoFocusNode?.dispose();
    contatoTextController?.dispose();

    cabecalhoModel.dispose();
  }
}
