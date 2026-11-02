import '/backend/api_requests/sessao_cliente.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'pagamento_widget.dart' show PagamentoWidget;
import 'package:flutter/material.dart';

class PagamentoModel extends FlutterFlowModel<PagamentoWidget> {
  ///  Local state fields for this page.

  bool carregando = true;

  bool processando = false;

  String? mensagemErro;

  bool usarPontos = false;

  // null = PIX; senão, o id do cartão salvo (tabela `cartaotoknzd`).
  int? cartaoSelecionadoId;

  // Cartões salvos do cliente (apenas bandeira e últimos 4 dígitos).
  List<dynamic> cartoes = [];

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

  bool get pagarComPix => cartaoSelecionadoId == null;

  double desconto(int pontosDisponiveis) =>
      usarPontos && pontosDisponiveis >= kPontosPorResgate ? kValorResgate : 0.0;

  double total(double itens, int pontosDisponiveis) =>
      (itens + kTaxaEntrega - desconto(pontosDisponiveis))
          .clamp(0.0, double.infinity);
}
