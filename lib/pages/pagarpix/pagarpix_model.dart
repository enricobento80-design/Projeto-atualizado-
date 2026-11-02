import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'pagarpix_widget.dart' show PagarpixWidget;
import 'package:flutter/material.dart';

class PagarpixModel extends FlutterFlowModel<PagarpixWidget> {
  ///  Local state fields for this page.

  // Registro atual do pedido (tabela `pedido`).
  dynamic pedido;

  bool carregando = true;

  bool verificando = false;

  String? mensagemErro;

  ///  State fields for stateful widgets in this page.

  // Model for Cabecalho.
  late CabecalhoModel cabecalhoModel;

  @override
  void initState(BuildContext context) {
    cabecalhoModel = createModel(context, () => CabecalhoModel());
  }

  @override
  void dispose() {
    cabecalhoModel.dispose();
  }

  String get copiaECola =>
      getJsonField(pedido, r'''$.pix_copia_cola''')?.toString() ?? '';

  String get qrCodeBase64 =>
      getJsonField(pedido, r'''$.pix_qrcode''')?.toString() ?? '';

  int get statusId =>
      castToType<int>(getJsonField(pedido, r'''$.status_pedido_id''')) ?? 2;
}
