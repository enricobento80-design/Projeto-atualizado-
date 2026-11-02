import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'novocartao_widget.dart' show NovocartaoWidget;
import 'package:flutter/material.dart';

class NovocartaoModel extends FlutterFlowModel<NovocartaoWidget> {
  ///  Local state fields for this page.

  String? mensagemErro;

  String? mensagemInfo;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();

  TextEditingController? numeroTextController;
  TextEditingController? nomeTextController;
  TextEditingController? validadeTextController;
  TextEditingController? cvvTextController;

  // Model for Cabecalho.
  late CabecalhoModel cabecalhoModel;

  @override
  void initState(BuildContext context) {
    cabecalhoModel = createModel(context, () => CabecalhoModel());
  }

  @override
  void dispose() {
    numeroTextController?.dispose();
    nomeTextController?.dispose();
    validadeTextController?.dispose();
    cvvTextController?.dispose();

    cabecalhoModel.dispose();
  }

  String get numeroDigitos =>
      (numeroTextController?.text ?? '').replaceAll(RegExp(r'\D'), '');

  /// Bandeira pelo prefixo do número (só para exibição).
  String get bandeira {
    final n = numeroDigitos;
    if (n.startsWith('4')) {
      return 'Visa';
    }
    if (RegExp(r'^(5[1-5]|2[2-7])').hasMatch(n)) {
      return 'Mastercard';
    }
    if (RegExp(r'^3[47]').hasMatch(n)) {
      return 'Amex';
    }
    if (RegExp(r'^(4011|4312|4389|4514|4576|5041|5066|5067|509|6277|6362|6363|650|6516|6550)')
        .hasMatch(n)) {
      return 'Elo';
    }
    if (RegExp(r'^(606282|3841)').hasMatch(n)) {
      return 'Hipercard';
    }
    return '';
  }

  /// Algoritmo de Luhn.
  bool get numeroValido {
    final n = numeroDigitos;
    if (n.length < 13 || n.length > 19) {
      return false;
    }
    var soma = 0;
    var dobrar = false;
    for (var i = n.length - 1; i >= 0; i--) {
      var digito = int.parse(n[i]);
      if (dobrar) {
        digito *= 2;
        if (digito > 9) {
          digito -= 9;
        }
      }
      soma += digito;
      dobrar = !dobrar;
    }
    return soma % 10 == 0;
  }

  bool get validadeValida {
    final partes = (validadeTextController?.text ?? '').split('/');
    if (partes.length != 2) {
      return false;
    }
    final mes = int.tryParse(partes[0]);
    final ano = int.tryParse(partes[1]);
    if (mes == null || ano == null || mes < 1 || mes > 12) {
      return false;
    }
    final agora = DateTime.now();
    final fimDoMes = DateTime(2000 + ano, mes + 1);
    return fimDoMes.isAfter(agora);
  }
}
