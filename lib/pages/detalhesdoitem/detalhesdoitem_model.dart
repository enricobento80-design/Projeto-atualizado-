import '/flutter_flow/flutter_flow_util.dart';
import 'detalhesdoitem_widget.dart' show DetalhesdoitemWidget;
import 'package:flutter/material.dart';

class DetalhesdoitemModel extends FlutterFlowModel<DetalhesdoitemWidget> {
  ///  Local state fields for this page.

  int quantidade = 1;

  bool favorito = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Observacao widget.
  FocusNode? observacaoFocusNode;
  TextEditingController? observacaoTextController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    observacaoFocusNode?.dispose();
    observacaoTextController?.dispose();
  }
}
