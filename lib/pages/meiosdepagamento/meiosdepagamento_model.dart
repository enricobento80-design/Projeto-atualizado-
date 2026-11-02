import '/components/cabecalho/cabecalho_widget.dart';
import '/components/payment_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'meiosdepagamento_widget.dart' show MeiosdepagamentoWidget;
import 'package:flutter/material.dart';

class MeiosdepagamentoModel extends FlutterFlowModel<MeiosdepagamentoWidget> {
  ///  Local state fields for this page.

  bool carregando = true;

  String? mensagemErro;

  // Cartões salvos do cliente (tabela `cartaotoknzd`): apenas bandeira e
  // últimos quatro dígitos (campos: bandeira, ultimos4). Nunca armazene
  // número completo ou CVV.
  List<dynamic> cartoes = [];

  ///  State fields for stateful widgets in this page.

  // Model for Cabecalho.
  late CabecalhoModel cabecalhoModel;
  // Models for PaymentCard (one per saved card).
  late FlutterFlowDynamicModels<PaymentCardModel> paymentCardModels;

  @override
  void initState(BuildContext context) {
    cabecalhoModel = createModel(context, () => CabecalhoModel());
    paymentCardModels = FlutterFlowDynamicModels(() => PaymentCardModel());
  }

  @override
  void dispose() {
    cabecalhoModel.dispose();
    paymentCardModels.dispose();
  }

  /// Garante que só os quatro últimos dígitos sejam exibidos.
  String ultimosDigitos(dynamic cartao) {
    final digitos = (getJsonField(cartao, r'''$.ultimos4''') ?? '')
        .toString()
        .replaceAll(RegExp(r'\D'), '');
    return digitos.length > 4 ? digitos.substring(digitos.length - 4) : digitos;
  }
}
