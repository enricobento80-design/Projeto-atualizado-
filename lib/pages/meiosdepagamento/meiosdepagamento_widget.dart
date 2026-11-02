import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/sessao_cliente.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/index.dart';
import '/components/payment_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'meiosdepagamento_model.dart';
export 'meiosdepagamento_model.dart';

/// Crie apenas uma página chamada “Pagamentos” para o app Sabor Local –
/// Culinária Mineira.
///
/// Use somente widgets e recursos nativos do FlutterFlow, sem Custom Code ou
/// Custom Widgets. Reutilize o tema e os componentes existentes; não defina
/// cores ou fontes diretamente nos widgets. Mantenha a interface em português
/// do Brasil e adequada a um layout mobile.
///
/// A página deve conter:
/// - Título “Pagamentos”.
/// - Uma seção informando que Pix está sempre disponível.
/// - Uma seção “Cartões salvos”.
/// - Cada cartão salvo deve mostrar apenas a bandeira e os últimos quatro
/// dígitos.
/// - Estado vazio quando não houver cartões salvos.
/// - Botão “Adicionar cartão” como elemento visual, sem solicitar ou
/// armazenar número completo ou CVV.
/// - Estados de carregamento, erro e sucesso.
/// - Não invente dados ou integração com backend.
///
/// Crie somente essa página. Não modifique outras páginas, componentes ou a
/// navegação.
class MeiosdepagamentoWidget extends StatefulWidget {
  const MeiosdepagamentoWidget({super.key});

  static String routeName = 'meiosdepagamento';
  static String routePath = '/meiosdepagamento';

  @override
  State<MeiosdepagamentoWidget> createState() => _MeiosdepagamentoWidgetState();
}

class _MeiosdepagamentoWidgetState extends State<MeiosdepagamentoWidget> {
  late MeiosdepagamentoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MeiosdepagamentoModel());

    SchedulerBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _carregar() async {
    safeSetState(() {
      _model.carregando = true;
      _model.mensagemErro = null;
    });
    final app = FFAppState();
    await carregarSessaoCliente();
    final clienteId = getJsonField(app.cliente, r'''$.id''');
    final resposta = await ListarCartoesCall.call();
    safeSetState(() {
      if (resposta.succeeded) {
        _model.cartoes = clienteId == null
            ? []
            : ((resposta.jsonBody as List?) ?? [])
                .where((c) => getJsonField(c, r'''$.cliente_id''') == clienteId)
                .toList();
      } else {
        _model.mensagemErro =
            'Não foi possível carregar seus cartões. Tente novamente.';
      }
      _model.carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              wrapWithModel(
                model: _model.cabecalhoModel,
                updateCallback: () => safeSetState(() {}),
                child: CabecalhoWidget(
                  titulo: 'Formas de pagamento',
                  subtitulo: 'Cartões cadastrados e PIX',
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  color: FlutterFlowTheme.of(context).primary,
                  onRefresh: _carregar,
                  child: ListView(
                    padding: EdgeInsets.all(24.0),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryContainer,
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        padding: EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 44.0,
                              height: 44.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Icon(
                                Icons.qr_code_2_rounded,
                                color: FlutterFlowTheme.of(context).onPrimary,
                                size: 24.0,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pix',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontWeight: FontWeight.bold,
                                          lineHeight: 1.4,
                                        ),
                                  ),
                                  Text(
                                    'O Pix está sempre disponível e tem confirmação instantânea.',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          lineHeight: 1.4,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                            ),
                          ].divide(SizedBox(width: 16.0)),
                        ),
                      ),
                      SizedBox(height: 32.0),
                      Text(
                        'Cartões salvos',
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontWeight: FontWeight.bold,
                              lineHeight: 1.4,
                            ),
                      ),
                      SizedBox(height: 16.0),
                      Builder(
                        builder: (context) {
                          if (_model.carregando) {
                            return Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 24.0,
                                    height: 24.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                  Text(
                                    'Carregando formas de pagamento...',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                  ),
                                ].divide(SizedBox(width: 16.0)),
                              ),
                            );
                          }

                          if (_model.mensagemErro != null) {
                            return Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 1.0,
                                ),
                              ),
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline_rounded,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        size: 24.0,
                                      ),
                                      Expanded(
                                        child: Text(
                                          _model.mensagemErro!,
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                              ),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 16.0)),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(1.0, 0.0),
                                    child: TextButton(
                                      onPressed: _carregar,
                                      child: Text(
                                        'Tentar novamente',
                                        style: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (_model.cartoes.isEmpty) {
                            return Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              padding: EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.credit_card_off_outlined,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 40.0,
                                  ),
                                  Text(
                                    'Nenhum cartão salvo',
                                    textAlign: TextAlign.center,
                                    style:
                                        FlutterFlowTheme.of(context).titleSmall,
                                  ),
                                  Text(
                                    'Você pode pagar com Pix a qualquer momento.',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            );
                          }

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(_model.cartoes.length,
                                (indice) {
                              final cartao = _model.cartoes[indice];
                              final ultimos = _model.ultimosDigitos(cartao);
                              final bandeira = valueOrDefault<String>(
                                getJsonField(cartao, r'''$.bandeira''')
                                    ?.toString(),
                                'Cartão',
                              );
                              final chave = '${bandeira}_$ultimos';
                              return wrapWithModel(
                                model: _model.paymentCardModels
                                    .getModel(chave, indice),
                                updateCallback: () => safeSetState(() {}),
                                child: PaymentCardWidget(
                                  key: Key('cartao_$chave'),
                                  brand: bandeira,
                                  lastDigits: ultimos,
                                  isDefault: getJsonField(
                                          cartao, r'''$.padrao''') ==
                                      true,
                                ),
                              );
                            }).divide(SizedBox(height: 8.0)),
                          );
                        },
                      ),
                      SizedBox(height: 24.0),
                      FFButtonWidget(
                        onPressed: () async {
                          await context.pushNamed(NovocartaoWidget.routeName);
                          await _carregar();
                        },
                        text: 'Adicionar cartão',
                        icon: Icon(
                          Icons.add_card_rounded,
                          size: 20.0,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 48.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconColor: FlutterFlowTheme.of(context).primary,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
