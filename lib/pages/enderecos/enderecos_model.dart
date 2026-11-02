import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'enderecos_widget.dart' show EnderecosWidget;
import 'package:flutter/material.dart';

class EnderecosModel extends FlutterFlowModel<EnderecosWidget> {
  ///  Local state fields for this page.

  bool carregando = true;

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

  /// Ícone pelo apelido do endereço (Casa, Trabalho ou outro).
  IconData iconeDoApelido(String apelido) {
    switch (apelido.trim().toLowerCase()) {
      case 'casa':
        return Icons.home_outlined;
      case 'trabalho':
        return Icons.work_outline_rounded;
      default:
        return Icons.location_on_outlined;
    }
  }
}
