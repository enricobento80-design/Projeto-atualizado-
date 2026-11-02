import '/backend/api_requests/sessao_cliente.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'meuspontos_widget.dart' show MeuspontosWidget;
import 'package:flutter/material.dart';

/// Lançamento do histórico de pontos.
class LancamentoPontos {
  const LancamentoPontos(this.descricao, this.data, this.pontos);

  final String descricao;
  final DateTime? data;
  final int pontos;
}

class MeuspontosModel extends FlutterFlowModel<MeuspontosWidget> {
  ///  Local state fields for this page.

  bool carregando = true;

  String? mensagemErro;

  List<LancamentoPontos> historico = [];

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

  /// Ganhos (pedidos pagos) e resgates de cada pedido, do mais recente.
  static List<LancamentoPontos> montarHistorico(List<dynamic> pedidos) {
    final lancamentos = <LancamentoPontos>[];
    for (final pedido in pedidos) {
      final id = getJsonField(pedido, r'''$.id''');
      final data = dataDoXano(pedido);
      final status =
          castToType<int>(getJsonField(pedido, r'''$.status_pedido_id''')) ?? 1;
      final total = castToType<double>(getJsonField(pedido, r'''$.total'''));
      final usados =
          castToType<int>(getJsonField(pedido, r'''$.pontos_usados''')) ?? 0;
      final ganhos =
          castToType<int>(getJsonField(pedido, r'''$.pontos_ganhos''')) ?? 0;
      if (usados > 0) {
        lancamentos.add(LancamentoPontos(
            'Resgate · ${formatarReais(kValorResgate)} de desconto',
            data,
            -usados));
      }
      if (ganhos > 0 && statusPedidoPago.contains(status)) {
        lancamentos.add(LancamentoPontos(
            'Pedido #$id · ${formatarReais(total)}', data, ganhos));
      }
    }
    lancamentos.sort(
        (a, b) => (b.data ?? DateTime(0)).compareTo(a.data ?? DateTime(0)));
    return lancamentos;
  }
}
