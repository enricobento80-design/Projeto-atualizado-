import 'dart:async';

import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/sessao_cliente.dart';
import '/components/sl_ui.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'acompanharpedido_model.dart';
export 'acompanharpedido_model.dart';

/// Acompanhar pedido: etapas do pedido (tabela `status_pedido`), previsão,
/// código de entrega e avaliação ao final. Atualiza a cada minuto.
class AcompanharpedidoWidget extends StatefulWidget {
  const AcompanharpedidoWidget({super.key, required this.pedidoId});

  final int? pedidoId;

  static String routeName = 'acompanharpedido';
  static String routePath = '/acompanharpedido';

  @override
  State<AcompanharpedidoWidget> createState() => _AcompanharpedidoWidgetState();
}

class _AcompanharpedidoWidgetState extends State<AcompanharpedidoWidget> {
  late AcompanharpedidoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Timer? _consulta;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AcompanharpedidoModel());

    _carregar();
    _consulta = Timer.periodic(Duration(minutes: 1), (_) => _carregar());
  }

  @override
  void dispose() {
    _consulta?.cancel();
    _model.dispose();

    super.dispose();
  }

  Future<void> _carregar() async {
    if (widget.pedidoId == null) {
      safeSetState(() {
        _model.carregando = false;
        _model.mensagemErro = 'Pedido não informado.';
      });
      return;
    }
    final respostas = await Future.wait([
      BuscarPedidoCall.call(pedidoId: widget.pedidoId!),
      ListarStatusPedidoCall.call(),
    ]);
    safeSetState(() {
      _model.carregando = false;
      if (respostas[0].succeeded) {
        _model.pedido = respostas[0].jsonBody;
        _model.mensagemErro = null;
      } else {
        _model.mensagemErro = 'Não foi possível consultar seu pedido.';
      }
      if (respostas[1].succeeded) {
        _model.nomesStatus = {
          for (final status in (respostas[1].jsonBody as List?) ?? [])
            castToType<int>(getJsonField(status, r'''$.id''')) ?? 0:
                getJsonField(status, r'''$.status''')?.toString() ?? '',
        };
      }
    });
    if (_model.entregue) {
      _consulta?.cancel();
    }
  }

  /// Trajeto restaurante → moto → casa; a moto avança com a etapa.
  Widget _trajeto(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final etapa = _model.etapaAtual;
    final progresso = switch (etapa) {
      < 1 => 0.0,
      1 => 0.15,
      2 => 0.55,
      3 => 0.8,
      _ => 1.0,
    };

    Widget ponto(IconData icone, Color fundo, Color cor) => Container(
          width: 56.0,
          height: 56.0,
          decoration: BoxDecoration(
            color: fundo,
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(color: tema.secondaryBackground, width: 3.0),
          ),
          child: Icon(icone, color: cor, size: 26.0),
        );

    return Container(
      height: 220.0,
      color: tema.alternate,
      child: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Material(
                color: tema.secondaryBackground,
                elevation: 2.0,
                borderRadius: BorderRadius.circular(16.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: () => context.canPop()
                      ? context.pop()
                      : context.goNamed(MeuspedidosWidget.routeName),
                  child: SizedBox(
                    width: 52.0,
                    height: 52.0,
                    child: Icon(Icons.chevron_left_rounded,
                        color: tema.primaryText, size: 28.0),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 90.0,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 40.0),
              child: LayoutBuilder(
                builder: (context, restricoes) {
                  final largura = restricoes.maxWidth - 56.0;
                  return Stack(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    children: [
                      Positioned(
                        left: 28.0,
                        right: 28.0,
                        child: Container(height: 4.0, color: tema.secondaryBackground),
                      ),
                      Positioned(
                        left: 28.0,
                        width: largura * progresso,
                        child: Container(height: 4.0, color: tema.tertiary),
                      ),
                      Positioned(
                          left: 0.0,
                          child: ponto(Icons.restaurant_rounded, tema.primary,
                              tema.onPrimary)),
                      Positioned(
                          right: 0.0,
                          child: ponto(Icons.home_outlined, tema.success,
                              tema.onPrimary)),
                      if (etapa >= 1 && etapa < 4)
                        Positioned(
                          left: largura * progresso,
                          child: ponto(Icons.two_wheeler_rounded,
                              tema.tertiary, tema.secondary),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 16.0,
            bottom: 12.0,
            child: Container(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 4.0, 10.0, 4.0),
              decoration: BoxDecoration(
                color: tema.secondaryBackground.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Atualiza a cada minuto',
                style: tema.labelSmall.override(color: tema.secondaryText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _etapas(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final atual = _model.etapaAtual;
    return CartaoSL(
      child: Column(
        children: List.generate(AcompanharpedidoModel.etapas.length, (i) {
          final feita = i <= atual;
          final corrente = i == atual && !_model.entregue;
          final cor = corrente
              ? tema.tertiary
              : feita
                  ? tema.primary
                  : tema.alternate;
          return Row(
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
                child: Icon(Icons.check_rounded,
                    color: tema.onPrimary, size: 18.0),
              ),
              Text(
                AcompanharpedidoModel.etapas[i],
                style: tema.bodyLarge.override(
                  color: feita ? tema.primaryText : tema.secondaryText,
                  fontWeight: corrente ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ].divide(SizedBox(width: 16.0)),
          );
        }).divide(SizedBox(height: 16.0)),
      ),
    );
  }

  String _previsao() {
    if (_model.entregue) {
      return 'Entregue';
    }
    final criado = dataDoXano(_model.pedido);
    if (criado == null) {
      return '45-60 min';
    }
    final decorrido = DateTime.now().difference(criado).inMinutes;
    final minimo = 45 - decorrido;
    final maximo = 60 - decorrido;
    if (maximo <= 0) {
      return 'Em instantes';
    }
    return '${minimo < 1 ? 1 : minimo}-$maximo min';
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final status = _model.nomesStatus[_model.statusId] ?? '';
    final cancelado = statusPedidoCancelado.contains(_model.statusId);
    final aguardandoPix = _model.etapaAtual == -1 &&
        !cancelado &&
        getJsonField(_model.pedido, r'''$.forma_pagamento''') == 'PIX';
    final codigo =
        getJsonField(_model.pedido, r'''$.cod_entrega''')?.toString() ?? '';

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: tema.primaryBackground,
      body: _model.carregando
          ? Center(child: CircularProgressIndicator(color: tema.primary))
          : RefreshIndicator(
              color: tema.primary,
              onRefresh: _carregar,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _trajeto(context),
                  Container(
                    transform: Matrix4.translationValues(0.0, -24.0, 0.0),
                    decoration: BoxDecoration(
                      color: tema.primaryBackground,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28.0)),
                    ),
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_model.mensagemErro != null)
                          AvisoSL(texto: _model.mensagemErro!),
                        if (cancelado)
                          AvisoSL(texto: 'Pedido ${status.toLowerCase()}.'),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _model.entregue
                                        ? 'Pedido #${widget.pedidoId}'
                                        : 'Chega em',
                                    style: tema.bodyMedium
                                        .override(color: tema.secondaryText),
                                  ),
                                  Text(
                                    _model.etapaAtual == -1 && !cancelado
                                        ? 'Aguardando pagamento'
                                        : _previsao(),
                                    style: tema.headlineMedium
                                        .override(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            if (status.isNotEmpty)
                              Container(
                                constraints: BoxConstraints(maxWidth: 160.0),
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    14.0, 8.0, 14.0, 8.0),
                                decoration: BoxDecoration(
                                  color: tema.accentContainer,
                                  borderRadius: BorderRadius.circular(9999.0),
                                ),
                                child: Text(
                                  status,
                                  textAlign: TextAlign.center,
                                  style: tema.labelMedium.override(
                                    color: tema.warning,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (aguardandoPix)
                          BotaoPrimarioSL(
                            texto: 'Pagar com PIX',
                            aoTocar: () async => context.goNamed(
                              PagarpixWidget.routeName,
                              queryParameters: {
                                'pedidoId': serializeParam(
                                    widget.pedidoId, ParamType.int),
                              }.withoutNulls,
                            ),
                          ),
                        _etapas(context),
                        if (codigo.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: tema.alternate,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text('Código de entrega',
                                      style: tema.bodyLarge),
                                ),
                                Text(
                                  codigo.split('').join(' '),
                                  style: tema.headlineSmall.override(
                                    fontFamily: 'Poppins',
                                    useGoogleFonts: true,
                                    color: tema.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_model.entregue)
                          BotaoSecundarioSL(
                            texto: 'Avaliar pedido',
                            aoTocar: () async => context.pushNamed(
                              AvaliarpedidoWidget.routeName,
                              queryParameters: {
                                'pedidoId': serializeParam(
                                    widget.pedidoId, ParamType.int),
                              }.withoutNulls,
                            ),
                          ),
                      ].divide(SizedBox(height: 20.0)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
