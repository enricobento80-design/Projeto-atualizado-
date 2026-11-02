import 'dart:async';
import 'dart:convert';

import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/sessao_cliente.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/components/sl_ui.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pagarpix_model.dart';
export 'pagarpix_model.dart';

/// Pagar com PIX: mostra o QR code e o copia e cola gerados pelo backend
/// (campos `pix_qrcode` e `pix_copia_cola` do pedido) e acompanha a
/// confirmação do pagamento.
class PagarpixWidget extends StatefulWidget {
  const PagarpixWidget({super.key, required this.pedidoId});

  final int? pedidoId;

  static String routeName = 'pagarpix';
  static String routePath = '/pagarpix';

  @override
  State<PagarpixWidget> createState() => _PagarpixWidgetState();
}

class _PagarpixWidgetState extends State<PagarpixWidget> {
  late PagarpixModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Prazo exibido para pagar o PIX a partir da criação do pedido.
  static const _prazo = Duration(minutes: 20);

  Timer? _consulta;
  Timer? _relogio;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PagarpixModel());

    _atualizar();
    _consulta =
        Timer.periodic(Duration(seconds: 5), (_) => _atualizar(silencioso: true));
    _relogio = Timer.periodic(Duration(seconds: 1), (_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _consulta?.cancel();
    _relogio?.cancel();
    _model.dispose();

    super.dispose();
  }

  Future<bool> _atualizar({bool silencioso = false}) async {
    if (widget.pedidoId == null) {
      return false;
    }
    final resposta = await BuscarPedidoCall.call(pedidoId: widget.pedidoId!);
    if (!mounted) {
      return false;
    }
    safeSetState(() {
      _model.carregando = false;
      if (resposta.succeeded) {
        _model.pedido = resposta.jsonBody;
        _model.mensagemErro = null;
      } else if (!silencioso) {
        _model.mensagemErro = 'Não foi possível consultar seu pedido.';
      }
    });
    final pago = statusPedidoPago.contains(_model.statusId) ||
        getJsonField(_model.pedido, r'''$.pago_em''') != null;
    if (pago) {
      _consulta?.cancel();
      context.goNamed(
        PagamentorealizadoWidget.routeName,
        queryParameters: {
          'pedidoId': serializeParam(widget.pedidoId, ParamType.int),
        }.withoutNulls,
      );
    }
    return pago;
  }

  Future<void> _jaPaguei() async {
    safeSetState(() => _model.verificando = true);
    final pago = await _atualizar();
    safeSetState(() => _model.verificando = false);
    if (!pago && mounted) {
      showSnackbar(
        context,
        'Ainda não recebemos a confirmação do PIX. Ela pode levar alguns segundos.',
      );
    }
  }

  Widget _qrCode(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final base64 = _model.qrCodeBase64.contains(',')
        ? _model.qrCodeBase64.split(',').last
        : _model.qrCodeBase64;
    Widget conteudo;
    if (base64.isEmpty) {
      conteudo = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: tema.primary),
          Text(
            'Gerando QR code...',
            textAlign: TextAlign.center,
            style: tema.bodySmall.override(color: tema.secondaryText),
          ),
        ].divide(SizedBox(height: 12.0)),
      );
    } else {
      try {
        conteudo = Image.memory(base64Decode(base64), fit: BoxFit.contain);
      } catch (_) {
        conteudo = Center(
          child: Text(
            'Use o código copia e cola abaixo.',
            textAlign: TextAlign.center,
            style: tema.bodySmall.override(color: tema.secondaryText),
          ),
        );
      }
    }
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: CartaoSL(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(width: 180.0, height: 180.0, child: conteudo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final criado = dataDoXano(_model.pedido) ?? DateTime.now();
    var restante = criado.add(_prazo).difference(DateTime.now());
    if (restante.isNegative) {
      restante = Duration.zero;
    }
    final prazo =
        '${restante.inMinutes.toString().padLeft(2, '0')}:${(restante.inSeconds % 60).toString().padLeft(2, '0')}';
    final total = castToType<double>(getJsonField(_model.pedido, r'''$.total'''));
    final cancelado = statusPedidoCancelado.contains(_model.statusId);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: tema.primaryBackground,
      bottomNavigationBar: BarraInferiorSL(
        child: BotaoPrimarioSL(
          texto: 'Já paguei',
          carregando: _model.verificando,
          aoTocar: cancelado ? null : _jaPaguei,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            wrapWithModel(
              model: _model.cabecalhoModel,
              updateCallback: () => safeSetState(() {}),
              child: CabecalhoWidget(
                titulo: 'Pagar com PIX',
                aoVoltar: () async =>
                    context.goNamed(MeuspedidosWidget.routeName),
              ),
            ),
            Expanded(
              child: _model.carregando
                  ? Center(child: CircularProgressIndicator(color: tema.primary))
                  : ListView(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 20.0, 24.0),
                      children: [
                        if (_model.mensagemErro != null)
                          AvisoSL(texto: _model.mensagemErro!),
                        if (cancelado)
                          AvisoSL(
                            texto:
                                'Este pedido foi cancelado. Faça um novo pedido pelo cardápio.',
                          ),
                        Text(
                          'Total a pagar',
                          textAlign: TextAlign.center,
                          style: tema.bodyLarge
                              .override(color: tema.secondaryText),
                        ),
                        Text(
                          formatarReais(total),
                          textAlign: TextAlign.center,
                          style: tema.displaySmall.override(
                            color: tema.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Container(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 8.0, 16.0, 8.0),
                            decoration: BoxDecoration(
                              color: tema.alternate,
                              borderRadius: BorderRadius.circular(9999.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.schedule_rounded,
                                    color: tema.primaryText, size: 18.0),
                                Text(
                                  restante == Duration.zero
                                      ? 'Prazo encerrado'
                                      : 'Pague em até  $prazo',
                                  style: tema.labelLarge
                                      .override(fontWeight: FontWeight.w600),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                        ),
                        _qrCode(context),
                        Text(
                          'PIX copia e cola',
                          style: tema.titleSmall,
                        ),
                        CartaoSL(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 8.0, 8.0, 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _model.copiaECola.isEmpty
                                      ? 'Aguardando o código...'
                                      : _model.copiaECola,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tema.bodyMedium.override(
                                    fontFamily: 'Roboto Mono',
                                    useGoogleFonts: true,
                                    color: tema.secondaryText,
                                  ),
                                ),
                              ),
                              BotaoPrimarioSL(
                                texto: 'Copiar',
                                larguraTotal: false,
                                altura: 48.0,
                                aoTocar: _model.copiaECola.isEmpty
                                    ? null
                                    : () async {
                                        await Clipboard.setData(ClipboardData(
                                            text: _model.copiaECola));
                                        if (context.mounted) {
                                          showSnackbar(context,
                                              'Código PIX copiado!');
                                        }
                                      },
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                        CartaoSL(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              '1. Abra o app do seu banco e escolha PIX.',
                              '2. Cole o código ou leia o QR code.',
                              '3. Confirme o pagamento. A confirmação aparece aqui automaticamente.',
                            ]
                                .map((passo) =>
                                    Text(passo, style: tema.bodyLarge))
                                .toList()
                                .divide(SizedBox(height: 10.0)),
                          ),
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
