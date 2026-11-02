import 'package:flutter/material.dart'
    show ChangeNotifier, Color, Colors, VoidCallback;
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _token = prefs.getString('ff_token') ?? _token;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _token = '';
  String get token => _token;
  set token(String value) {
    _token = value;
    prefs.setString('ff_token', value);
  }

  ///  Sessão do cliente logado (preenchida por carregarSessaoCliente()).

  bool sessaoCarregada = false;

  int? usuarioId;

  String usuarioNome = '';

  String usuarioEmail = '';

  // Registro da tabela `cliente` do usuário logado.
  dynamic cliente;

  // Endereços do cliente logado (tabela `endereco`).
  List<dynamic> enderecos = [];

  // Tabela `cep` (cidade e UF dos endereços).
  List<dynamic> ceps = [];

  // Endereço escolhido para entrega nesta sessão (null = o principal).
  int? enderecoEntregaId;

  // Tentativas de login com senha errada por e-mail (bloqueia na 3ª).
  Map<String, int> tentativasLogin = {};

  void limparSessao() {
    token = '';
    sessaoCarregada = false;
    usuarioId = null;
    usuarioNome = '';
    usuarioEmail = '';
    cliente = null;
    enderecos = [];
    ceps = [];
    enderecoEntregaId = null;
    carrinho = [];
    notifyListeners();
  }

  ///  Carrinho (itens: id, nome, preco, url_imagem, precisa_produzir,
  ///  quantidade, obs).

  List<Map<String, dynamic>> carrinho = [];

  int quantidadeNoCarrinho(int produtoId) => carrinho
      .where((item) => item['id'] == produtoId)
      .fold(0, (soma, item) => soma + (item['quantidade'] as int));

  int get totalItensCarrinho =>
      carrinho.fold(0, (soma, item) => soma + (item['quantidade'] as int));

  double get totalCarrinho => carrinho.fold(
      0.0,
      (soma, item) =>
          soma + (item['preco'] as double) * (item['quantidade'] as int));

  void adicionarAoCarrinho(
    dynamic produto, {
    int quantidade = 1,
    String obs = '',
  }) {
    final id = castToType<int>(getJsonField(produto, r'''$.id''')) ?? 0;
    final existente = carrinho
        .where((item) => item['id'] == id && item['obs'] == obs)
        .firstOrNull;
    if (existente != null) {
      existente['quantidade'] = (existente['quantidade'] as int) + quantidade;
    } else {
      carrinho.add({
        'id': id,
        'nome': getJsonField(produto, r'''$.nome''')?.toString() ?? '',
        'preco':
            castToType<double>(getJsonField(produto, r'''$.preco''')) ?? 0.0,
        'url_imagem':
            getJsonField(produto, r'''$.url_imagem''')?.toString() ?? '',
        'precisa_produzir':
            getJsonField(produto, r'''$.precisa_produzir''') == true,
        'quantidade': quantidade,
        'obs': obs,
      });
    }
    notifyListeners();
  }

  /// Soma [delta] à quantidade do item no índice [indice]; remove se zerar.
  void alterarQuantidadeItem(int indice, int delta) {
    if (indice < 0 || indice >= carrinho.length) {
      return;
    }
    final novaQuantidade = (carrinho[indice]['quantidade'] as int) + delta;
    if (novaQuantidade <= 0) {
      carrinho.removeAt(indice);
    } else {
      carrinho[indice]['quantidade'] = novaQuantidade;
    }
    notifyListeners();
  }

  /// Soma [delta] ao produto (último item com esse id); usado nos cartões
  /// do cardápio.
  void alterarQuantidadeProduto(dynamic produto, int delta) {
    final id = castToType<int>(getJsonField(produto, r'''$.id''')) ?? 0;
    final indice = carrinho.lastIndexWhere((item) => item['id'] == id);
    if (indice == -1) {
      if (delta > 0) {
        adicionarAoCarrinho(produto, quantidade: delta);
      }
      return;
    }
    alterarQuantidadeItem(indice, delta);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
