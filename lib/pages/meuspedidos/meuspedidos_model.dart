import '/backend/api_requests/sessao_cliente.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/components/menu_inferior/menu_inferior_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'meuspedidos_widget.dart' show MeuspedidosWidget;
import 'package:flutter/material.dart';

class MeuspedidosModel extends FlutterFlowModel<MeuspedidosWidget> {
  ///  Local state fields for this page.

  bool carregando = true;

  String? mensagemErro;

  // Pedidos do cliente logado (tabela `pedido` do Xano).
  List<dynamic> pedidos = [];

  // id -> nome do status (tabela `status_pedido`).
  Map<int, String> nomesStatus = {};

  // id do pedido -> "1× Feijoada Mineira, 2× Feijão Tropeiro".
  Map<int, String> resumos = {};

  // 0 = Em andamento, 1 = Anteriores.
  int abaSelecionada = 0;

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

  int statusId(dynamic pedido) =>
      castToType<int>(getJsonField(pedido, r'''$.status_pedido_id''')) ?? 1;

  bool emAndamento(dynamic pedido) =>
      !statusPedidoEncerrado.contains(statusId(pedido));

  String nomeStatus(dynamic pedido) =>
      nomesStatus[statusId(pedido)] ?? 'Criado';

  List<dynamic> get pedidosDaAba {
    final lista = pedidos
        .where((p) => abaSelecionada == 0 ? emAndamento(p) : !emAndamento(p))
        .toList();
    lista.sort((a, b) => (dataDoXano(b) ?? DateTime(0))
        .compareTo(dataDoXano(a) ?? DateTime(0)));
    return lista;
  }

  double totalDoPedido(dynamic pedido) =>
      castToType<double>(getJsonField(pedido, r'''$.total''')) ?? 0.0;
}
