import '/flutter_flow/flutter_flow_util.dart';
import 'api_calls.dart';

/// Carrega usuário (auth/me), registro de `cliente`, endereços e CEPs do
/// usuário logado e guarda em FFAppState.
///
/// Os endpoints `cliente` e `endereco` do Xano devolvem todos os registros,
/// por isso o filtro pelo usuário é feito aqui. O ideal é que o Xano filtre
/// pelo token no servidor.
Future<void> carregarSessaoCliente({bool forcar = false}) async {
  final app = FFAppState();
  if (app.sessaoCarregada && !forcar) {
    return;
  }
  if (app.token.isEmpty) {
    return;
  }

  final usuario = await UsuarioLogadoCall.call(token: app.token);
  if (!usuario.succeeded) {
    return;
  }
  final usuarioId = UsuarioLogadoCall.id(usuario.jsonBody);

  final respostas = await Future.wait([
    ListarClientesCall.call(),
    ListarEnderecosCall.call(),
    ListarCepsCall.call(),
  ]);

  final clientes = respostas[0].succeeded
      ? (respostas[0].jsonBody as List? ?? [])
      : <dynamic>[];
  final cliente = clientes
      .where((c) => getJsonField(c, r'''$.user_id''') == usuarioId)
      .firstOrNull;
  final clienteId = getJsonField(cliente, r'''$.id''');

  final enderecos = respostas[1].succeeded && clienteId != null
      ? (respostas[1].jsonBody as List? ?? [])
          .where((e) => getJsonField(e, r'''$.cliente_id''') == clienteId)
          .toList()
      : <dynamic>[];

  app.update(() {
    app.usuarioId = usuarioId;
    app.usuarioNome = UsuarioLogadoCall.nome(usuario.jsonBody) ??
        getJsonField(cliente, r'''$.nome''')?.toString() ??
        '';
    app.usuarioEmail = UsuarioLogadoCall.email(usuario.jsonBody) ?? '';
    app.cliente = cliente;
    app.enderecos = enderecos;
    app.ceps = respostas[2].succeeded
        ? (respostas[2].jsonBody as List? ?? [])
        : <dynamic>[];
    app.sessaoCarregada = true;
  });
}

/// "R$ 54,90"
String formatarReais(num? valor) => formatNumber(
      valor ?? 0,
      formatType: FormatType.custom,
      format: '#,##0.00',
      locale: 'pt_BR',
      currency: 'R\$ ',
    );

/// Primeiro nome do usuário logado ("Enrico").
String primeiroNome(String nomeCompleto) =>
    nomeCompleto.trim().split(RegExp(r'\s+')).first;

/// Iniciais para o avatar ("ER" para "Enrico Rocha").
String iniciais(String nomeCompleto) {
  final partes = nomeCompleto
      .trim()
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (partes.isEmpty) {
    return '';
  }
  if (partes.length == 1) {
    return partes.first.substring(0, partes.first.length.clamp(0, 2))
        .toUpperCase();
  }
  return (partes.first[0] + partes.last[0]).toUpperCase();
}

dynamic enderecoPrincipal(List<dynamic> enderecos) =>
    enderecos
        .where((e) => getJsonField(e, r'''$.padrao''') == true)
        .firstOrNull ??
    enderecos.firstOrNull;

/// Endereço escolhido para entrega; se nenhum foi escolhido, o principal.
dynamic enderecoDeEntrega(FFAppState app) =>
    app.enderecos
        .where((e) => getJsonField(e, r'''$.id''') == app.enderecoEntregaId)
        .firstOrNull ??
    enderecoPrincipal(app.enderecos);

/// "Rua das Flores, 123"
String ruaENumero(dynamic endereco) => [
      getJsonField(endereco, r'''$.logradouro'''),
      getJsonField(endereco, r'''$.numero'''),
    ]
        .map((parte) => parte?.toString().trim() ?? '')
        .where((parte) => parte.isNotEmpty)
        .join(', ');

/// "Lourdes, Belo Horizonte - MG · 30170-010"
String bairroCidadeUf(dynamic endereco, List<dynamic> ceps) {
  final cep = ceps
      .where((c) =>
          getJsonField(c, r'''$.id''') ==
          getJsonField(endereco, r'''$.cep_id'''))
      .firstOrNull;
  final bairro = getJsonField(endereco, r'''$.bairro''')?.toString() ?? '';
  final cidade = getJsonField(cep, r'''$.cidade''')?.toString() ?? '';
  final uf = getJsonField(cep, r'''$.uf''')?.toString() ?? '';
  final numeroCep = getJsonField(cep, r'''$.cep''')?.toString() ?? '';

  var linha = [bairro, cidade].where((p) => p.isNotEmpty).join(', ');
  if (uf.isNotEmpty) {
    linha = linha.isEmpty ? uf : '$linha - $uf';
  }
  if (numeroCep.isNotEmpty) {
    linha = linha.isEmpty ? numeroCep : '$linha · $numeroCep';
  }
  return linha;
}

/// Data de um campo `created_at` do Xano (epoch em ms).
DateTime? dataDoXano(dynamic registro) {
  final valor = getJsonField(registro, r'''$.created_at''');
  if (valor is int) {
    return DateTime.fromMillisecondsSinceEpoch(valor);
  }
  if (valor is String) {
    return DateTime.tryParse(valor)?.toLocal();
  }
  return null;
}

/// "Hoje, 20:15", "Ontem, 13:02" ou "12/10/2026, 19:40".
String dataAmigavel(DateTime? data) {
  if (data == null) {
    return '';
  }
  final hoje = DateTime.now();
  final dia = DateTime(data.year, data.month, data.day);
  final diferenca =
      DateTime(hoje.year, hoje.month, hoje.day).difference(dia).inDays;
  final hora = dateTimeFormat('HH:mm', data);
  if (diferenca == 0) {
    return 'Hoje, $hora';
  }
  if (diferenca == 1) {
    return 'Ontem, $hora';
  }
  return '${dateTimeFormat('dd/MM/yyyy', data)}, $hora';
}

/// Taxa de entrega cobrada no pagamento (valor do layout do app).
const kTaxaEntrega = 8.0;

/// Programa de fidelidade: 1 ponto a cada R$ 10 gastos; 50 pontos valem
/// R$ 10 de desconto no pagamento.
const kPontosPorResgate = 50;
const kValorResgate = 10.0;

int pontosGanhosPor(double totalPago) => totalPago ~/ 10;

/// IDs da tabela `status_pedido` em que o pagamento já foi confirmado
/// (PIX realizado, cartão pago e etapas de produção/entrega seguintes).
const statusPedidoPago = [4, 8, 9, 10, 11, 12, 13, 14, 15];

/// IDs da tabela `status_pedido` de pedidos cancelados ou estornados.
const statusPedidoCancelado = [6, 16, 17, 18, 19];

/// IDs da tabela `status_pedido` que encerram o pedido (vão para
/// "Anteriores"): cancelado por falta de pagamento, pacote entregue,
/// finalizado, cancelado e estornado e finalizado.
const statusPedidoEncerrado = [6, 14, 15, 16, 19];
