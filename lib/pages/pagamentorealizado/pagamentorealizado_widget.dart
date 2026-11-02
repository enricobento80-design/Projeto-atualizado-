import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/sessao_cliente.dart';
import '/components/sl_ui.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'pagamentorealizado_model.dart';
export 'pagamentorealizado_model.dart';

/// Confirmação de pagamento: número do pedido, total pago, previsão de
/// entrega e pontos ganhos.
class PagamentorealizadoWidget extends StatefulWidget {
  const PagamentorealizadoWidget({super.key, required this.pedidoId});

  final int? pedidoId;

  static String routeName = 'pagamentorealizado';
  static String routePath = '/pagamentorealizado';

  @override
  State<PagamentorealizadoWidget> createState() =>
      _PagamentorealizadoWidgetState();
}

class _PagamentorealizadoWidgetState extends State<PagamentorealizadoWidget> {
  late PagamentorealizadoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PagamentorealizadoModel());

    SchedulerBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _carregar() async {
    if (widget.pedidoId != null) {
      final resposta = await BuscarPedidoCall.call(pedidoId: widget.pedidoId!);
      if (resposta.succeeded) {
        _model.pedido = resposta.jsonBody;
      }
    }
    // Atualiza o saldo de pontos exibido no Perfil.
    carregarSessaoCliente(forcar: true);
    safeSetState(() => _model.carregando = false);
  }

  Widget _linha(BuildContext context, String rotulo, String valor) {
    final tema = FlutterFlowTheme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(rotulo,
              style: tema.bodyMedium.override(color: tema.secondaryText)),
        ),
        Text(valor,
            style: tema.bodyMedium.override(fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final total =
        castToType<double>(getJsonField(_model.pedido, r'''$.total'''));
    final pontos =
        castToType<int>(getJsonField(_model.pedido, r'''$.pontos_ganhos''')) ??
            0;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: tema.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: IconeFundoSL(
                  icone: Icons.check_rounded,
                  cor: tema.success,
                  fundo: tema.success.withValues(alpha: 0.12),
                  tamanho: 140.0,
                  tamanhoIcone: 72.0,
                  circular: true,
                ),
              ),
              SizedBox(height: 28.0),
              Text(
                'Pagamento realizado com sucesso!',
                textAlign: TextAlign.center,
                style: tema.headlineMedium.override(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 28.0),
              if (_model.carregando)
                Center(child: CircularProgressIndicator(color: tema.primary))
              else
                CartaoSL(
                  child: Column(
                    children: [
                      _linha(context, 'Pedido', '#${widget.pedidoId ?? ''}'),
                      _linha(context, 'Total pago', formatarReais(total)),
                      _linha(context, 'Previsão de entrega', '45-60 min'),
                      if (pontos > 0)
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: tema.accentContainer,
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star_rounded,
                                  color: tema.tertiary, size: 24.0),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '+$pontos pontos',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                          text:
                                              ' para o seu programa de fidelidade'),
                                    ],
                                  ),
                                  style: tema.bodyMedium
                                      .override(color: tema.warning),
                                ),
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                    ].divide(SizedBox(height: 14.0)),
                  ),
                ),
              Spacer(flex: 2),
              BotaoPrimarioSL(
                texto: 'Acompanhar pedido',
                aoTocar: () async => context.goNamed(
                  AcompanharpedidoWidget.routeName,
                  queryParameters: {
                    'pedidoId': serializeParam(widget.pedidoId, ParamType.int),
                  }.withoutNulls,
                ),
              ),
              SizedBox(height: 16.0),
              BotaoSecundarioSL(
                texto: 'Voltar ao início',
                aoTocar: () async =>
                    context.goNamed(MenucardapioCopyCopy2Widget.routeName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
