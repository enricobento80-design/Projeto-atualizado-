import '/backend/api_requests/sessao_cliente.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/components/imagem_produto/imagem_produto_widget.dart';
import '/components/menu_inferior/menu_inferior_widget.dart';
import '/components/seletor_quantidade/seletor_quantidade_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_checkout_model.dart';
export 'cart_checkout_model.dart';

/// "Seu pedido": itens do carrinho (FFAppState.carrinho), total e ações.
class CartCheckoutWidget extends StatefulWidget {
  const CartCheckoutWidget({super.key});

  static String routeName = 'CartCheckout';
  static String routePath = '/cartCheckout';

  @override
  State<CartCheckoutWidget> createState() => _CartCheckoutWidgetState();
}

class _CartCheckoutWidgetState extends State<CartCheckoutWidget> {
  late CartCheckoutModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CartCheckoutModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void _irParaInicio() {
    context.goNamed(
      MenucardapioCopyCopy2Widget.routeName,
      extra: <String, dynamic>{
        kTransitionInfoKey: TransitionInfo(hasTransition: false),
      },
    );
  }

  Widget _cartaoItem(
      BuildContext context, FFAppState app, int indice, Map item) {
    final quantidade = item['quantidade'] as int;
    final preco = item['preco'] as double;
    final obs = (item['obs'] as String?) ?? '';
    final precisaProduzir = item['precisa_produzir'] == true;
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagemProdutoWidget(
                url: item['url_imagem'] as String?,
                largura: 72.0,
                altura: 72.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item['nome'] as String,
                            style: FlutterFlowTheme.of(context).titleMedium,
                          ),
                        ),
                        Text(
                          formatarReais(preco * quantidade),
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ].divide(SizedBox(width: 8.0)),
                    ),
                    Text(
                      '$quantidade × ${formatarReais(preco)} (valor unitário)',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                    ),
                    if (obs.isNotEmpty)
                      Text(
                        'Obs.: $obs',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                  ].divide(SizedBox(height: 4.0)),
                ),
              ),
            ].divide(SizedBox(width: 14.0)),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 12.0, 6.0),
                decoration: BoxDecoration(
                  color: precisaProduzir
                      ? FlutterFlowTheme.of(context).accentContainer
                      : FlutterFlowTheme.of(context)
                          .success
                          .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9999.0),
                ),
                child: Text(
                  precisaProduzir ? 'Precisa produzir' : 'Não precisa produzir',
                  style: FlutterFlowTheme.of(context).labelSmall.override(
                        color: precisaProduzir
                            ? FlutterFlowTheme.of(context).warning
                            : FlutterFlowTheme.of(context).success,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Spacer(),
              SeletorQuantidadeWidget(
                quantidade: quantidade,
                aoDiminuir: () => app.alterarQuantidadeItem(indice, -1),
                aoAumentar: () => app.alterarQuantidadeItem(indice, 1),
              ),
            ],
          ),
        ].divide(SizedBox(height: 12.0)),
      ),
    );
  }

  Widget _pedidoVazio(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 112.0,
              height: 112.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).alternate,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 48.0,
              ),
            ),
            Text(
              'Seu pedido está vazio',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Escolha seus pratos mineiros favoritos no cardápio.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
            ),
            FFButtonWidget(
              onPressed: () async => _irParaInicio(),
              text: 'Ver cardápio',
              options: FFButtonOptions(
                height: 48.0,
                padding: EdgeInsetsDirectional.fromSTEB(28.0, 0.0, 28.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      color: FlutterFlowTheme.of(context).onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(14.0),
              ),
            ),
          ].divide(SizedBox(height: 16.0)),
        ),
      ),
    );
  }

  Widget _rodape(BuildContext context, FFAppState app) {
    final itens = app.totalItensCarrinho;
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        border: Border(
          top: BorderSide(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
        ),
      ),
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total ($itens ${itens == 1 ? 'item' : 'itens'})',
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ),
              Text(
                formatarReais(app.totalCarrinho),
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Poppins',
                      useGoogleFonts: true,
                      color: FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FFButtonWidget(
                  onPressed: () async => _irParaInicio(),
                  text: 'Continuar comprando',
                  options: FFButtonOptions(
                    height: 52.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          color: FlutterFlowTheme.of(context).primary,
                          fontWeight: FontWeight.bold,
                        ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              Expanded(
                child: FFButtonWidget(
                  onPressed: () async {
                    if (app.token.isEmpty) {
                      showSnackbar(
                          context, 'Entre na sua conta para finalizar o pedido.');
                      context.pushNamed(LoginWidget.routeName);
                      return;
                    }
                    context.pushNamed(PagamentoWidget.routeName);
                  },
                  text: 'Prosseguir',
                  options: FFButtonOptions(
                    height: 52.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          color: FlutterFlowTheme.of(context).onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ].divide(SizedBox(height: 14.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      bottomNavigationBar: wrapWithModel(
        model: _model.menuInferiorModel,
        updateCallback: () => safeSetState(() {}),
        child: MenuInferiorWidget(abaAtual: AbaMenu.pedido),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            wrapWithModel(
              model: _model.cabecalhoModel,
              updateCallback: () => safeSetState(() {}),
              child: CabecalhoWidget(
                titulo: 'Seu pedido',
                subtitulo: app.carrinho.isEmpty
                    ? null
                    : 'Status do pedido: Criado',
                aoVoltar: () async => _irParaInicio(),
              ),
            ),
            Expanded(
              child: app.carrinho.isEmpty
                  ? _pedidoVazio(context)
                  : ListView.separated(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 20.0),
                      itemCount: app.carrinho.length,
                      separatorBuilder: (_, __) => SizedBox(height: 14.0),
                      itemBuilder: (context, indice) => _cartaoItem(
                          context, app, indice, app.carrinho[indice]),
                    ),
            ),
            if (app.carrinho.isNotEmpty) _rodape(context, app),
          ],
        ),
      ),
    );
  }
}
