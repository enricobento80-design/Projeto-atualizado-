import '/components/menu_inferior/menu_inferior_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'menudaconta_widget.dart' show MenudacontaWidget;
import 'package:flutter/material.dart';

class MenudacontaModel extends FlutterFlowModel<MenudacontaWidget> {
  ///  Local state fields for this page.

  bool carregando = false;

  ///  State fields for stateful widgets in this page.

  // Model for MenuInferior.
  late MenuInferiorModel menuInferiorModel;

  @override
  void initState(BuildContext context) {
    menuInferiorModel = createModel(context, () => MenuInferiorModel());
  }

  @override
  void dispose() {
    menuInferiorModel.dispose();
  }
}
