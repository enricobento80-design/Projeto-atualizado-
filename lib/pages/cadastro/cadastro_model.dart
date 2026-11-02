import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/code/validar_c_p_f.dart';
import 'cadastro_widget.dart' show CadastroWidget;
import 'package:flutter/material.dart';

class CadastroModel extends FlutterFlowModel<CadastroWidget> {
  ///  Local state fields for this page.

  // 1 = nome e celular, 2 = e-mail, CPF e senha.
  int etapa = 1;

  bool enviando = false;

  String? mensagemErro;

  // A conta (user + cliente) já foi criada nesta tela; reenviar só o código.
  bool contaCriada = false;

  ///  State fields for stateful widgets in this page.

  final formEtapa1 = GlobalKey<FormState>();
  final formEtapa2 = GlobalKey<FormState>();

  TextEditingController? nomeTextController;
  FocusNode? nomeFocusNode;
  TextEditingController? celularTextController;
  FocusNode? celularFocusNode;
  TextEditingController? emailTextController;
  FocusNode? emailFocusNode;
  TextEditingController? cpfTextController;
  FocusNode? cpfFocusNode;
  TextEditingController? senhaTextController;
  FocusNode? senhaFocusNode;
  TextEditingController? confirmarSenhaTextController;
  FocusNode? confirmarSenhaFocusNode;

  // Model for Cabecalho.
  late CabecalhoModel cabecalhoModel;

  @override
  void initState(BuildContext context) {
    cabecalhoModel = createModel(context, () => CabecalhoModel());
  }

  @override
  void dispose() {
    nomeTextController?.dispose();
    nomeFocusNode?.dispose();
    celularTextController?.dispose();
    celularFocusNode?.dispose();
    emailTextController?.dispose();
    emailFocusNode?.dispose();
    cpfTextController?.dispose();
    cpfFocusNode?.dispose();
    senhaTextController?.dispose();
    senhaFocusNode?.dispose();
    confirmarSenhaTextController?.dispose();
    confirmarSenhaFocusNode?.dispose();

    cabecalhoModel.dispose();
  }

  String get celularDigitos =>
      (celularTextController?.text ?? '').replaceAll(RegExp(r'\D'), '');

  String get cpfDigitos =>
      (cpfTextController?.text ?? '').replaceAll(RegExp(r'\D'), '');

  String get senha => senhaTextController?.text ?? '';

  bool get senhaTemTamanho => senha.length >= 8;
  bool get senhaTemNumero => RegExp(r'\d').hasMatch(senha);
  bool get senhaTemMaiuscula => RegExp(r'[A-ZÀ-Ú]').hasMatch(senha);

  String? validarNome(String? valor) {
    final nome = (valor ?? '').trim();
    if (nome.isEmpty) {
      return 'Informe seu nome completo.';
    }
    if (nome.split(RegExp(r'\s+')).length < 2) {
      return 'Informe nome e sobrenome.';
    }
    return null;
  }

  String? validarCelular(String? _) {
    if (celularDigitos.length != 11) {
      return 'Informe o celular com DDD, ex.: (31) 99999-9999.';
    }
    return null;
  }

  String? validarEmail(String? valor) {
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch((valor ?? '').trim())) {
      return 'Informe um e-mail válido.';
    }
    return null;
  }

  String? validarCpfOpcional(String? _) {
    if (cpfDigitos.isEmpty) {
      return null;
    }
    return validarCPF(cpfDigitos) == true ? null : 'CPF inválido.';
  }

  String? validarSenha(String? _) {
    if (!senhaTemTamanho || !senhaTemNumero || !senhaTemMaiuscula) {
      return 'A senha não atende aos requisitos abaixo.';
    }
    return null;
  }

  String? validarConfirmacao(String? valor) {
    if ((valor ?? '') != senha) {
      return 'As senhas não conferem.';
    }
    return null;
  }
}
