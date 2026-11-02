import '/backend/api_requests/sessao_cliente.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'paginadenotificacao_widget.dart' show PaginadenotificacaoWidget;
import 'package:flutter/material.dart';

class PaginadenotificacaoModel
    extends FlutterFlowModel<PaginadenotificacaoWidget> {
  ///  Local state fields for this page.

  bool carregando = true;

  String? mensagemErro;

  // Registros da tabela `notificacao` do Xano
  // (campos: titulo, created_at, lida).
  List<dynamic> notificacoes = [];

  bool prefStatusPedido = true;

  bool prefPromocoes = true;

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

  List<dynamic> get recentes => [...notificacoes]..sort((a, b) =>
      (dataDoXano(b) ?? DateTime(0)).compareTo(dataDoXano(a) ?? DateTime(0)));

  /// "Agora", "Há 25 min", "Há 3 h", "Ontem" ou "12/10".
  String tempoRelativo(DateTime? data) {
    if (data == null) {
      return '';
    }
    final agora = DateTime.now();
    final diferenca = agora.difference(data);
    if (diferenca.inMinutes < 1) {
      return 'Agora';
    }
    if (diferenca.inMinutes < 60) {
      return 'Há ${diferenca.inMinutes} min';
    }
    final hoje = DateTime(agora.year, agora.month, agora.day);
    final dia = DateTime(data.year, data.month, data.day);
    final dias = hoje.difference(dia).inDays;
    if (dias == 0) {
      return 'Há ${diferenca.inHours} h';
    }
    if (dias == 1) {
      return 'Ontem';
    }
    return dateTimeFormat('dd/MM', data);
  }

  /// Ícone pelo assunto da notificação.
  IconData iconeDe(String titulo) {
    final t = titulo.toLowerCase();
    if (t.contains('entrega') || t.contains('caminho')) {
      return Icons.two_wheeler_rounded;
    }
    if (t.contains('pagamento') || t.contains('pix')) {
      return Icons.check_rounded;
    }
    if (t.contains('%') || t.contains('off') || t.contains('cupom')) {
      return Icons.local_offer_outlined;
    }
    return Icons.shopping_bag_outlined;
  }
}
