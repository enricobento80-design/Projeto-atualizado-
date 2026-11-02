import '/components/cabecalho/cabecalho_widget.dart';
import '/components/menu_inferior/menu_inferior_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'cart_checkout_widget.dart' show CartCheckoutWidget;
import 'package:flutter/material.dart';

class CartCheckoutModel extends FlutterFlowModel<CartCheckoutWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Cabecalho.
  late CabecalhoModel cabecalhoModel;
  // Model for MenuInferior.
  late MenuInferiorModel menuInferiorModel;

  @override
  void initState(BuildContext context) {
    cabecalhoModel = createModel(context, () => CabecalhoModel());
    menuInferiorModel = createModel(context, () => MenuInferiorModel());
  }

  @override
  void dispose() {
    cabecalhoModel.dispose();
    menuInferiorModel.dispose();
  }
}
