import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'avaliarpedido_widget.dart' show AvaliarpedidoWidget;
import 'package:flutter/material.dart';

class AvaliarpedidoModel extends FlutterFlowModel<AvaliarpedidoWidget> {
  ///  Local state fields for this page.

  int estrelas = 0;

  Set<String> destaques = {};

  bool querContato = false;

  bool enviando = false;

  String? mensagemErro;

  ///  State fields for stateful widgets in this page.

  TextEditingController? comentarioTextController;

  // Model for Cabecalho.
  late CabecalhoModel cabecalhoModel;

  @override
  void initState(BuildContext context) {
    cabecalhoModel = createModel(context, () => CabecalhoModel());
  }

  @override
  void dispose() {
    comentarioTextController?.dispose();
    cabecalhoModel.dispose();
  }

  static const opcoesDestaque = [
    'Saboroso',
    'Comida quentinha',
    'Entrega rápida',
    'Bem embalado',
    'Porção caprichada',
  ];

  static const rotulosEstrelas = [
    '',
    'Muito ruim',
    'Ruim',
    'Regular',
    'Muito bom',
    'Excelente',
  ];
}
