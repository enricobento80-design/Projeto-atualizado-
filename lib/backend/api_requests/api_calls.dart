import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class AuthTokenCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? senha = '',
  }) async {
    final ffApiRequestBody = '''
{
  "email": ${email == null ? 'null' : '"${escapeStringForJson(email)}"'},
  "password": ${senha == null ? 'null' : '"${escapeStringForJson(senha)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'authToken',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:1y-RviMn/auth/login',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BuscaCepCall {
  static Future<ApiCallResponse> call({
    String? cep = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'buscaCep',
      apiUrl: 'https://viacep.com.br/ws/${cep}/json/',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? logradouro(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.logradouro''',
      ));
  static String? bairro(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.bairro''',
      ));
  static String? cidade(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.localidade''',
      ));
  static String? uf(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.uf''',
      ));
  static String? estado(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.estado''',
      ));
}

class CodigoOTPCall {
  static Future<ApiCallResponse> call({
    String? email = '',
  }) async {
    final ffApiRequestBody = '''
{
  "to_email": ${email == null ? 'null' : '"${escapeStringForJson(email)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'codigoOTP',
      apiUrl:
          'https://x8ki-letl-twmt.n7.xano.io/api:Qvd-QuTm/sendgrid/validate',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CadastroUserCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? senha = '',
    String? nome = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": ${nome == null ? 'null' : '"${escapeStringForJson(nome)}"'},
  "email": ${email == null ? 'null' : '"${escapeStringForJson(email)}"'},
  "password": ${senha == null ? 'null' : '"${escapeStringForJson(senha)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'cadastroUser',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:1y-RviMn/auth/signup',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? token(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.authToken''',
      ));
}

class CadastroClienteCall {
  static Future<ApiCallResponse> call({
    String? celular = '',
    String? cpf = '',
    String? tokens = '',
  }) async {
    final ffApiRequestBody = '''
{
  "cpf": ${cpf == null ? 'null' : '"${escapeStringForJson(cpf)}"'},
  "celular": ${celular == null ? 'null' : '"${escapeStringForJson(celular)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'cadastroCliente',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:qmIH7GAV/cliente',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${tokens}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? id(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.user_id''',
      ));
}

class CadastroEnderecoCall {
  static Future<ApiCallResponse> call({
    String? tokens = '',
    String? bairro = '',
    String? numero = '',
    String? idCli = '',
    String? logradouro = '',
    String? referencia = '',
    String? cepId = '',
    String? complemento = '',
    bool padrao = false,
  }) async {
    final ffApiRequestBody = '''
{
  "logradouro": ${logradouro == null ? 'null' : '"${escapeStringForJson(logradouro)}"'},
  "numero": ${numero == null ? 'null' : '"${escapeStringForJson(numero)}"'},
  "bairro": ${bairro == null ? 'null' : '"${escapeStringForJson(bairro)}"'},
  "referencia": ${referencia == null ? 'null' : '"${escapeStringForJson(referencia)}"'},
  "complemento": ${complemento == null ? 'null' : '"${escapeStringForJson(complemento)}"'},
  "padrao": "${padrao}",
  "cep_id": ${cepId == null ? 'null' : '"${escapeStringForJson(cepId)}"'},
  "cliente_id": ${idCli == null ? 'null' : '"${escapeStringForJson(idCli)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'cadastroEndereco',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:qmIH7GAV/endereco',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${tokens}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class TodosOsProdutosCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'TodosOsProdutos',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:qmIH7GAV/produto',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? urlImagem(dynamic response) => (getJsonField(
        response,
        r'''$[:].url_imagem''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? nome(dynamic response) => (getJsonField(
        response,
        r'''$[:].nome''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<double>? preco(dynamic response) => (getJsonField(
        response,
        r'''$[:].preco''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<double>(x))
          .withoutNulls
          .toList();
  static List<int>? idProd(dynamic response) => (getJsonField(
        response,
        r'''$[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<int>(x))
          .withoutNulls
          .toList();
  static List<String>? categorias(dynamic response) => (getJsonField(
        response,
        r'''$[:]._catego.Categorias''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static dynamic produtos(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
  static List<String>? descricao(dynamic response) => (getJsonField(
        response,
        r'''$[:].descricao''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class CadastroCepCall {
  static Future<ApiCallResponse> call({
    String? cep = '',
    String? uf = '',
    String? cidade = '',
  }) async {
    final ffApiRequestBody = '''
{
  "cep": ${cep == null ? 'null' : '"${escapeStringForJson(cep)}"'},
  "uf": ${uf == null ? 'null' : '"${escapeStringForJson(uf)}"'},
  "cidade": ${cidade == null ? 'null' : '"${escapeStringForJson(cidade)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'cadastroCep',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:qmIH7GAV/cep',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? idCEP(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.id''',
      ));
}

class ValidarOTPCall {
  static Future<ApiCallResponse> call({
    String? codigo = '',
    String? token = '',
  }) async {
    final ffApiRequestBody = '''
{
  "cod_digitado": ${codigo == null ? 'null' : '"${escapeStringForJson(codigo)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'validarOTP',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:qmIH7GAV/validarOtp',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AssasCall {
  static Future<ApiCallResponse> call({
    String? name = '',
    String? cpfCnpj = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": ${name == null ? 'null' : '"${escapeStringForJson(name)}"'},
  "cpfCnpj": ${cpfCnpj == null ? 'null' : '"${escapeStringForJson(cpfCnpj)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ASSAS',
      apiUrl: 'https://api-sandbox.asaas.com/v3/customers',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class BuscaIdProdutoCall {
  static Future<ApiCallResponse> call({
    int? id,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'buscaIdProduto',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:qmIH7GAV/ProdutoPorId',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'id': id,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? imagem(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.url_imagem''',
      ));
  static double? preco(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.preco''',
      ));
  static String? descrip(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.descricao''',
      ));
  static String? nome(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.nome''',
      ));
}

class UsuarioLogadoCall {
  static Future<ApiCallResponse> call({
    String? token = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'usuarioLogado',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:1y-RviMn/auth/me',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? id(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.id''',
      ));
  static String? nome(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.name''',
      ));
  static String? email(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.email''',
      ));
}

class ListarClientesCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'listarClientes',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:qmIH7GAV/cliente',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListarEnderecosCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'listarEnderecos',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:qmIH7GAV/endereco',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListarCepsCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'listarCeps',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:qmIH7GAV/cep',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListarPedidosCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'listarPedidos',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:qmIH7GAV/pedido',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListarStatusPedidoCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'listarStatusPedido',
      apiUrl: 'https://x8ki-letl-twmt.n7.xano.io/api:qmIH7GAV/status_pedido',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: true,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

const _kSaborLocalApi = 'https://x8ki-letl-twmt.n7.xano.io/api:qmIH7GAV';

/// Chamada genérica ao grupo `sabor_local` do Xano com corpo JSON montado a
/// partir de um Map (valores nulos são omitidos).
Future<ApiCallResponse> _chamarSaborLocal(
  String callName,
  String caminho,
  ApiCallType tipo, {
  Map<String, dynamic>? corpo,
  Map<String, dynamic> params = const {},
  String? token,
}) {
  return ApiManager.instance.makeApiCall(
    callName: callName,
    apiUrl: '$_kSaborLocalApi$caminho',
    callType: tipo,
    headers: {
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    },
    params: params,
    body: corpo == null
        ? null
        : json.encode(Map.fromEntries(
            corpo.entries.where((entrada) => entrada.value != null))),
    bodyType: corpo == null ? BodyType.NONE : BodyType.JSON,
    returnBody: true,
    encodeBodyUtf8: false,
    decodeUtf8: false,
    cache: false,
    isStreamingApi: false,
    alwaysAllowBody: false,
  );
}

class BuscarCepXanoCall {
  static Future<ApiCallResponse> call({required String cep}) =>
      _chamarSaborLocal('buscarCepXano', '/cep', ApiCallType.GET,
          params: {'cep': cep});
}

class CriarCepCall {
  static Future<ApiCallResponse> call({
    required String cep,
    required String uf,
    required String cidade,
  }) =>
      _chamarSaborLocal('criarCep', '/cep', ApiCallType.POST,
          corpo: {'cep': cep, 'uf': uf, 'cidade': cidade});
}

class AtualizarClienteCall {
  static Future<ApiCallResponse> call({
    required int clienteId,
    String? nome,
    String? celular,
    String? cpf,
    String? email,
  }) =>
      _chamarSaborLocal(
          'atualizarCliente', '/cliente/$clienteId', ApiCallType.PATCH,
          corpo: {'nome': nome, 'celular': celular, 'cpf': cpf, 'email': email});
}

class AtualizarUsuarioCall {
  static Future<ApiCallResponse> call({
    required int userId,
    String? nome,
    String? email,
    bool? notifStatus,
    bool? notifPromo,
  }) =>
      _chamarSaborLocal('atualizarUsuario', '/user/$userId', ApiCallType.PATCH,
          corpo: {
            'name': nome,
            'email': email,
            'notif_status': notifStatus,
            'notif_promo': notifPromo,
          });
}

class AtualizarEnderecoCall {
  static Future<ApiCallResponse> call({
    required int enderecoId,
    Map<String, dynamic> campos = const {},
  }) =>
      _chamarSaborLocal(
          'atualizarEndereco', '/endereco/$enderecoId', ApiCallType.PATCH,
          corpo: campos);
}

class ExcluirEnderecoCall {
  static Future<ApiCallResponse> call({required int enderecoId}) =>
      _chamarSaborLocal(
          'excluirEndereco', '/endereco/$enderecoId', ApiCallType.DELETE);
}

class CriarPedidoCall {
  static Future<ApiCallResponse> call({
    required int clienteId,
    required int enderecoId,
    required double total,
    required double taxaEntrega,
    required double desconto,
    required int pontosUsados,
    required int pontosGanhos,
    required String formaPagamento,
    required int statusPedidoId,
    required String codEntrega,
  }) =>
      _chamarSaborLocal('criarPedido', '/pedido', ApiCallType.POST, corpo: {
        'cliente_id': clienteId,
        'endereco_id': enderecoId,
        'total': total,
        'taxa_entrega': taxaEntrega,
        'desconto': desconto,
        'pontos_usados': pontosUsados,
        'pontos_ganhos': pontosGanhos,
        'forma_pagamento': formaPagamento,
        'status_pedido_id': statusPedidoId,
        'cod_entrega': codEntrega,
      });

  static int? id(dynamic response) =>
      castToType<int>(getJsonField(response, r'''$.id'''));
}

class BuscarPedidoCall {
  static Future<ApiCallResponse> call({required int pedidoId}) =>
      _chamarSaborLocal('buscarPedido', '/pedido/$pedidoId', ApiCallType.GET);
}

class CriarItemCall {
  static Future<ApiCallResponse> call({
    required int pedidoId,
    required int produtoId,
    required int qtd,
    required double valorUnit,
    String? observacao,
  }) =>
      _chamarSaborLocal('criarItem', '/item', ApiCallType.POST, corpo: {
        'pedido_id': pedidoId,
        'produto_id': produtoId,
        'qtd': qtd,
        'valor_unit': valorUnit,
        'subtotal': valorUnit * qtd,
        'observacao': (observacao ?? '').isEmpty ? null : observacao,
      });
}

class ListarItensCall {
  static Future<ApiCallResponse> call() =>
      _chamarSaborLocal('listarItens', '/item', ApiCallType.GET);
}

class ListarCartoesCall {
  static Future<ApiCallResponse> call() =>
      _chamarSaborLocal('listarCartoes', '/cartaotoknzd', ApiCallType.GET);
}

/// Pedido de contato humano exibido no painel de gestão (tabela
/// `escalonamento`).
class CriarEscalonamentoCall {
  static Future<ApiCallResponse> call({
    required String nomeCliente,
    required String resumo,
  }) =>
      _chamarSaborLocal('criarEscalonamento', '/escalonamento',
          ApiCallType.POST, corpo: {
        'nome_cliente': nomeCliente,
        'resumo': resumo,
        'atendido': false,
      });
}

class SolicitarRedefinicaoSenhaCall {
  static Future<ApiCallResponse> call({required String email}) {
    return ApiManager.instance.makeApiCall(
      callName: 'solicitarRedefinicaoSenha',
      apiUrl:
          'https://x8ki-letl-twmt.n7.xano.io/api:1y-RviMn/reset/request-reset-link',
      callType: ApiCallType.GET,
      headers: {},
      params: {'email': email},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  final encoded = jsonEncode(input);
  return encoded.substring(1, encoded.length - 1);
}
