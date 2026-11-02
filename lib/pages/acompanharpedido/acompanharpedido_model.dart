import '/flutter_flow/flutter_flow_util.dart';
import 'acompanharpedido_widget.dart' show AcompanharpedidoWidget;
import 'package:flutter/material.dart';

class AcompanharpedidoModel extends FlutterFlowModel<AcompanharpedidoWidget> {
  ///  Local state fields for this page.

  dynamic pedido;

  Map<int, String> nomesStatus = {};

  bool carregando = true;

  String? mensagemErro;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  int get statusId =>
      castToType<int>(getJsonField(pedido, r'''$.status_pedido_id''')) ?? 1;

  static const etapas = [
    'Pedido confirmado',
    'Em preparo',
    'A caminho',
    'Próximo a você',
    'Entregue',
  ];

  /// Índice da etapa atual em [etapas]; -1 enquanto aguarda pagamento.
  int get etapaAtual {
    switch (statusId) {
      case 4: // PIX realizado
      case 8: // Pago (cartão)
        return 0;
      case 9: // Produção e entrega ordenada
      case 10: // Apenas entrega ordenada
      case 11: // Possível atraso
        return 1;
      case 12: // Pacote despachado
      case 13: // Pacote devolvido pelo motoboy
        return 2;
      case 14: // Pacote entregue
      case 15: // Finalizado
        return 4;
      default:
        return -1;
    }
  }

  bool get entregue => etapaAtual == 4;
}
