import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/sessao_cliente.dart';
import '/components/imagem_produto/imagem_produto_widget.dart';
import '/components/seletor_quantidade/seletor_quantidade_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'detalhesdoitem_model.dart';
export 'detalhesdoitem_model.dart';

/// Detalhe do produto (tabela `produto` do Xano) com quantidade, observação
/// para a cozinha e botão "Adicionar".
class DetalhesdoitemWidget extends StatefulWidget {
  const DetalhesdoitemWidget({
    super.key,
    required this.produtoId,
  });

  final int? produtoId;

  static String routeName = 'detalhesdoitem';
  static String routePath = '/detalhesdoitem';

  @override
  State<DetalhesdoitemWidget> createState() => _DetalhesdoitemWidgetState();
}

class _DetalhesdoitemWidgetState extends State<DetalhesdoitemWidget> {
  late DetalhesdoitemModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<ApiCallResponse> _produtoFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalhesdoitemModel());

    _model.observacaoTextController ??= TextEditingController();
    _model.observacaoFocusNode ??= FocusNode();

    _produtoFuture = BuscaIdProdutoCall.call(id: widget.produtoId);
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Widget _botaoFlutuante(
    BuildContext context, {
    required IconData icone,
    required Color cor,
    required VoidCallback aoTocar,
  }) {
    return Material(
      color: FlutterFlowTheme.of(context).secondaryBackground,
      elevation: 2.0,
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: aoTocar,
        child: SizedBox(
          width: 52.0,
          height: 52.0,
          child: Icon(icone, color: cor, size: 26.0),
        ),
      ),
    );
  }

  Widget _selo(BuildContext context, String texto, {required bool destaque}) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(14.0, 8.0, 14.0, 8.0),
      decoration: BoxDecoration(
        color: destaque
            ? FlutterFlowTheme.of(context).success.withValues(alpha: 0.12)
            : FlutterFlowTheme.of(context).alternate,
        borderRadius: BorderRadius.circular(9999.0),
      ),
      child: Text(
        texto,
        style: FlutterFlowTheme.of(context).labelMedium.override(
              color: destaque
                  ? FlutterFlowTheme.of(context).success
                  : FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _estado(BuildContext context, Widget conteudo) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: conteudo),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: _botaoFlutuante(
                context,
                icone: Icons.chevron_left_rounded,
                cor: FlutterFlowTheme.of(context).primaryText,
                aoTocar: () => context.safePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiCallResponse>(
      future: _produtoFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _estado(
            context,
            CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary,
            ),
          );
        }
        final resposta = snapshot.data!;
        if (!resposta.succeeded || resposta.jsonBody == null) {
          return _estado(
            context,
            Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: FlutterFlowTheme.of(context).error,
                    size: 40.0,
                  ),
                  Text(
                    'Não foi possível carregar este prato.',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      safeSetState(() {
                        _produtoFuture =
                            BuscaIdProdutoCall.call(id: widget.produtoId);
                      });
                    },
                    text: 'Tentar novamente',
                    options: FFButtonOptions(
                      height: 44.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                color: FlutterFlowTheme.of(context).onPrimary,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                ].divide(SizedBox(height: 12.0)),
              ),
            ),
          );
        }

        final produto = resposta.jsonBody;
        final preco = BuscaIdProdutoCall.preco(produto) ?? 0.0;
        final disponivel =
            castToType<int>(getJsonField(produto, r'''$.qtd_disp''')) ?? 0;
        final prontaEntrega =
            getJsonField(produto, r'''$.precisa_produzir''') != true;
        final app = FFAppState();
        final jaNoCarrinho = app.quantidadeNoCarrinho(
            castToType<int>(getJsonField(produto, r'''$.id''')) ?? 0);
        final maximo = disponivel - jaNoCarrinho;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                border: Border(
                  top: BorderSide(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1.0,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
                  child: Row(
                    children: [
                      SeletorQuantidadeWidget(
                        quantidade: _model.quantidade,
                        tamanho: 48.0,
                        podeAumentar: _model.quantidade < maximo,
                        aoDiminuir: () {
                          if (_model.quantidade > 1) {
                            safeSetState(() => _model.quantidade--);
                          }
                        },
                        aoAumentar: () =>
                            safeSetState(() => _model.quantidade++),
                      ),
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: maximo <= 0
                              ? null
                              : () async {
                                  app.adicionarAoCarrinho(
                                    produto,
                                    quantidade: _model.quantidade,
                                    obs: _model.observacaoTextController!.text
                                        .trim(),
                                  );
                                  showSnackbar(
                                    context,
                                    '${BuscaIdProdutoCall.nome(produto) ?? 'Item'} adicionado ao pedido.',
                                  );
                                  context.safePop();
                                },
                          text: maximo <= 0
                              ? 'Indisponível'
                              : 'Adicionar · ${formatarReais(preco * _model.quantidade)}',
                          options: FFButtonOptions(
                            height: 56.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  color: FlutterFlowTheme.of(context).onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(18.0),
                            disabledColor:
                                FlutterFlowTheme.of(context).alternate,
                            disabledTextColor:
                                FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 16.0)),
                  ),
                ),
              ),
            ),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: false,
                  expandedHeight: 300.0,
                  automaticallyImplyLeading: false,
                  backgroundColor: FlutterFlowTheme.of(context).alternate,
                  flexibleSpace: FlexibleSpaceBar(
                    background: ImagemProdutoWidget(
                      url: BuscaIdProdutoCall.imagem(produto),
                      raio: 0.0,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _botaoFlutuante(
                        context,
                        icone: Icons.chevron_left_rounded,
                        cor: FlutterFlowTheme.of(context).primaryText,
                        aoTocar: () => context.safePop(),
                      ),
                      _botaoFlutuante(
                        context,
                        icone: _model.favorito
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        cor: FlutterFlowTheme.of(context).error,
                        aoTocar: () => safeSetState(
                            () => _model.favorito = !_model.favorito),
                      ),
                    ],
                  ),
                  titleSpacing: 20.0,
                  toolbarHeight: 84.0,
                ),
                SliverToBoxAdapter(
                  child: Container(
                    transform: Matrix4.translationValues(0.0, -28.0, 0.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28.0),
                      ),
                    ),
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 28.0, 20.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                BuscaIdProdutoCall.nome(produto) ?? '',
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 0.0),
                              child: Text(
                                formatarReais(preco),
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),
                        Text(
                          BuscaIdProdutoCall.descrip(produto) ?? '',
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            _selo(
                              context,
                              disponivel > 0
                                  ? 'Disponível: $disponivel'
                                  : 'Esgotado',
                              destaque: false,
                            ),
                            _selo(
                              context,
                              prontaEntrega ? 'Pronta entrega' : 'Feito na hora',
                              destaque: prontaEntrega,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Observação para a cozinha',
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                fontFamily: 'Lora',
                                useGoogleFonts: true,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        TextFormField(
                          controller: _model.observacaoTextController,
                          focusNode: _model.observacaoFocusNode,
                          maxLines: 3,
                          minLines: 2,
                          maxLength: 140,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Ex.: sem laranja, arroz integral...',
                            hintStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          cursorColor: FlutterFlowTheme.of(context).primary,
                        ),
                        if (jaNoCarrinho > 0)
                          Text(
                            'Você já tem $jaNoCarrinho no pedido.',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                          ),
                      ].divide(SizedBox(height: 12.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
