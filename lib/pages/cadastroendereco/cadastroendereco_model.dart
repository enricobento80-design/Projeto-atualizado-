import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'cadastroendereco_widget.dart' show CadastroenderecoWidget;
import 'package:flutter/material.dart';

class CadastroenderecoModel extends FlutterFlowModel<CadastroenderecoWidget> {
  ///  Local state fields for this page.

  bool buscandoCep = false;

  bool salvando = false;

  String? mensagemErro;

  // Casa, Trabalho ou Outro.
  String apelido = 'Casa';

  bool principal = true;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();

  TextEditingController? cepTextController;
  TextEditingController? ruaTextController;
  TextEditingController? numeroTextController;
  TextEditingController? complementoTextController;
  TextEditingController? bairroTextController;
  TextEditingController? cidadeTextController;
  TextEditingController? ufTextController;

  // Model for Cabecalho.
  late CabecalhoModel cabecalhoModel;

  @override
  void initState(BuildContext context) {
    cabecalhoModel = createModel(context, () => CabecalhoModel());
  }

  @override
  void dispose() {
    cepTextController?.dispose();
    ruaTextController?.dispose();
    numeroTextController?.dispose();
    complementoTextController?.dispose();
    bairroTextController?.dispose();
    cidadeTextController?.dispose();
    ufTextController?.dispose();

    cabecalhoModel.dispose();
  }

  String get cepDigitos =>
      (cepTextController?.text ?? '').replaceAll(RegExp(r'\D'), '');

  String? obrigatorio(String? valor) =>
      (valor ?? '').trim().isEmpty ? 'Obrigatório' : null;
}
