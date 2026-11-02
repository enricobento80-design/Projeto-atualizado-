import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/sessao_cliente.dart';
import '/components/imagem_produto/imagem_produto_widget.dart';
import '/components/menu_inferior/menu_inferior_widget.dart';
import '/components/seletor_quantidade/seletor_quantidade_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'menucardapio_copy_copy2_model.dart';
export 'menucardapio_copy_copy2_model.dart';

/// Tela Início do Sabor Local: endereço de entrega, saudação, busca,
/// promoção, categorias e cardápio vindo da tabela `produto` do Xano.
class MenucardapioCopyCopy2Widget extends StatefulWidget {
  const MenucardapioCopyCopy2Widget({super.key});

  static String routeName = 'MenucardapioCopyCopy2';
  static String routePath = '/menucardapioCopyCopy2';

  @override
  State<MenucardapioCopyCopy2Widget> createState() =>
      _MenucardapioCopyCopy2WidgetState();
}

class _MenucardapioCopyCopy2WidgetState
    extends State<MenucardapioCopyCopy2Widget> {
  late MenucardapioCopyCopy2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenucardapioCopyCopy2Model());

    _model.buscaTextController ??= TextEditingController();
    _model.buscaFocusNode ??= FocusNode();

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
    final resposta = await TodosOsProdutosCall.call();
    // Nome e endereço para o cabeçalho; não bloqueia o cardápio.
    carregarSessaoCliente();
    safeSetState(() {
      if (resposta.succeeded) {
        _model.produtos = (resposta.jsonBody as List?) ?? [];
      } else {
        _model.mensagemErro =
            'Não foi possível carregar o cardápio. Verifique sua conexão.';
      }
      _model.carregando = false;
    });
  }

  void _abrirProduto(dynamic produto) {
    context.pushNamed(
      DetalhesdoitemWidget.routeName,
      queryParameters: {
        'produtoId': serializeParam(
          castToType<int>(getJsonField(produto, r'''$.id''')),
          ParamType.int,
        ),
      }.withoutNulls,
    );
  }

  Widget _cabecalho(BuildContext context, FFAppState app) {
    final endereco = enderecoDeEntrega(app);
    final saudacao = app.usuarioNome.isEmpty
        ? 'Olá! O que vai ser hoje, uai?'
        : 'Olá, ${primeiroNome(app.usuarioNome)}! O que vai ser hoje, uai?';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () async {
                  context.pushNamed(EnderecosWidget.routeName);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entregar em',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: FlutterFlowTheme.of(context).tertiary,
                          size: 20.0,
                        ),
                        Flexible(
                          child: Text(
                            endereco == null
                                ? 'Escolha um endereço'
                                : ruaENumero(endereco),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 20.0,
                        ),
                      ].divide(SizedBox(width: 4.0)),
                    ),
                  ].divide(SizedBox(height: 2.0)),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: () async {
                context.pushNamed(PaginadenotificacaoWidget.routeName);
              },
              child: Container(
                width: 52.0,
                height: 52.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 26.0,
                ),
              ),
            ),
          ],
        ),
        Text(
          saudacao,
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontWeight: FontWeight.bold,
              ),
        ),
        TextFormField(
          controller: _model.buscaTextController,
          focusNode: _model.buscaFocusNode,
          onChanged: (_) => EasyDebounce.debounce(
            '_model.buscaTextController',
            Duration(milliseconds: 300),
            () => safeSetState(() {}),
          ),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Buscar pratos mineiros...',
            hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            suffixIcon: _model.buscaTextController!.text.isNotEmpty
                ? InkWell(
                    onTap: () async {
                      _model.buscaTextController?.clear();
                      safeSetState(() {});
                    },
                    child: Icon(
                      Icons.clear_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 20.0,
                    ),
                  )
                : null,
            filled: true,
            fillColor: FlutterFlowTheme.of(context).secondaryBackground,
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(16.0, 14.0, 16.0, 14.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).alternate,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(9999.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(9999.0),
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyMedium,
          cursorColor: FlutterFlowTheme.of(context).primary,
        ),
      ].divide(SizedBox(height: 16.0)),
    );
  }

  Widget _promocao(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary,
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40.0,
            top: -60.0,
            child: Container(
              width: 180.0,
              height: 180.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: FlutterFlowTheme.of(context)
                      .tertiary
                      .withValues(alpha: 0.35),
                  width: 22.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROMOÇÃO',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        color: FlutterFlowTheme.of(context).tertiary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                ),
                Text(
                  'Festival do Tropeiro',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        color: FlutterFlowTheme.of(context).onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Descontos de até 30% hoje',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context)
                            .onPrimary
                            .withValues(alpha: 0.85),
                      ),
                ),
                SizedBox(height: 8.0),
                FFButtonWidget(
                  onPressed: () async {
                    _model.buscaTextController?.text = 'Tropeiro';
                    safeSetState(() => _model.categoriaSelecionada = 'Tudo');
                  },
                  text: 'Peça agora',
                  options: FFButtonOptions(
                    height: 38.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                    color: FlutterFlowTheme.of(context).tertiary,
                    textStyle: FlutterFlowTheme.of(context).labelLarge.override(
                          color: FlutterFlowTheme.of(context).secondary,
                          fontWeight: FontWeight.bold,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ].divide(SizedBox(height: 4.0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categorias(BuildContext context) {
    final categorias = _model.categorias;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categorias
            .map((categoria) {
              final selecionada = categoria == _model.categoriaSelecionada;
              return InkWell(
                borderRadius: BorderRadius.circular(14.0),
                onTap: () async {
                  safeSetState(() => _model.categoriaSelecionada = categoria);
                },
                child: Container(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(18.0, 10.0, 18.0, 10.0),
                  decoration: BoxDecoration(
                    color: selecionada
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      color: selecionada
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    categoria,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          color: selecionada
                              ? FlutterFlowTheme.of(context).onPrimary
                              : FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              );
            })
            .toList()
            .divide(SizedBox(width: 8.0)),
      ),
    );
  }

  Widget _selo(BuildContext context, String texto, {required bool destaque}) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(10.0, 4.0, 10.0, 4.0),
      decoration: BoxDecoration(
        color: destaque
            ? FlutterFlowTheme.of(context).success.withValues(alpha: 0.12)
            : FlutterFlowTheme.of(context).accentContainer,
        borderRadius: BorderRadius.circular(9999.0),
      ),
      child: Text(
        texto,
        style: FlutterFlowTheme.of(context).labelSmall.override(
              color: destaque
                  ? FlutterFlowTheme.of(context).success
                  : FlutterFlowTheme.of(context).warning,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _cartaoProduto(BuildContext context, dynamic produto, FFAppState app) {
    final id = castToType<int>(getJsonField(produto, r'''$.id''')) ?? 0;
    final disponivel =
        castToType<int>(getJsonField(produto, r'''$.qtd_disp''')) ?? 0;
    final prontaEntrega =
        getJsonField(produto, r'''$.precisa_produzir''') != true;
    final noCarrinho = app.quantidadeNoCarrinho(id);
    return InkWell(
      borderRadius: BorderRadius.circular(24.0),
      onTap: () => _abrirProduto(produto),
      child: Container(
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
                  url: getJsonField(produto, r'''$.url_imagem''')?.toString(),
                  largura: 96.0,
                  altura: 96.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getJsonField(produto, r'''$.nome''')?.toString() ?? '',
                        style: FlutterFlowTheme.of(context).titleMedium,
                      ),
                      Text(
                        getJsonField(produto, r'''$.descricao''')
                                ?.toString() ??
                            '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                      ),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            disponivel > 0
                                ? 'Disponível: $disponivel'
                                : 'Esgotado',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  color: disponivel > 0
                                      ? FlutterFlowTheme.of(context)
                                          .secondaryText
                                      : FlutterFlowTheme.of(context).error,
                                ),
                          ),
                          _selo(
                            context,
                            prontaEntrega ? 'Pronta entrega' : 'Feito na hora',
                            destaque: prontaEntrega,
                          ),
                        ],
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ),
              ].divide(SizedBox(width: 16.0)),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    formatarReais(castToType<double>(
                        getJsonField(produto, r'''$.preco'''))),
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          color: FlutterFlowTheme.of(context).primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (noCarrinho > 0)
                  SeletorQuantidadeWidget(
                    quantidade: noCarrinho,
                    podeAumentar: noCarrinho < disponivel,
                    aoDiminuir: () =>
                        app.alterarQuantidadeProduto(produto, -1),
                    aoAumentar: () => app.alterarQuantidadeProduto(produto, 1),
                  )
                else
                  FFButtonWidget(
                    onPressed: disponivel > 0
                        ? () async => app.adicionarAoCarrinho(produto)
                        : null,
                    text: disponivel > 0 ? 'Adicionar' : 'Esgotado',
                    options: FFButtonOptions(
                      height: 44.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                color: FlutterFlowTheme.of(context).onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(14.0),
                      disabledColor: FlutterFlowTheme.of(context).alternate,
                      disabledTextColor:
                          FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
              ],
            ),
          ].divide(SizedBox(height: 12.0)),
        ),
      ),
    );
  }

  Widget _estadoCentral(
    BuildContext context, {
    required IconData icone,
    required String titulo,
    required String mensagem,
    bool erro = false,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 48.0, 16.0, 48.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 112.0,
            height: 112.0,
            decoration: BoxDecoration(
              color: erro
                  ? FlutterFlowTheme.of(context).error.withValues(alpha: 0.08)
                  : FlutterFlowTheme.of(context).alternate,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icone,
              color: erro
                  ? FlutterFlowTheme.of(context).error
                  : FlutterFlowTheme.of(context).secondaryText,
              size: 48.0,
            ),
          ),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            mensagem,
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
          ),
          FFButtonWidget(
            onPressed: _carregar,
            text: 'Atualizar',
            icon: Icon(Icons.refresh_rounded, size: 20.0),
            options: FFButtonOptions(
              height: 48.0,
              padding: EdgeInsetsDirectional.fromSTEB(28.0, 0.0, 28.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              iconColor: FlutterFlowTheme.of(context).onPrimary,
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
    );
  }

  Widget _barraVerPedido(BuildContext context, FFAppState app) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
      child: Material(
        color: FlutterFlowTheme.of(context).primary,
        elevation: 6.0,
        borderRadius: BorderRadius.circular(22.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(22.0),
          onTap: () async {
            context.goNamed(
              CartCheckoutWidget.routeName,
              extra: <String, dynamic>{
                kTransitionInfoKey: TransitionInfo(hasTransition: false),
              },
            );
          },
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 14.0, 20.0, 14.0),
            child: Row(
              children: [
                Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).tertiary,
                    shape: BoxShape.circle,
                  ),
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Text(
                    '${app.totalItensCarrinho}',
                    style: FlutterFlowTheme.of(context).labelLarge.override(
                          color: FlutterFlowTheme.of(context).secondary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Ver pedido',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          color: FlutterFlowTheme.of(context).onPrimary,
                        ),
                  ),
                ),
                Text(
                  formatarReais(app.totalCarrinho),
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        color: FlutterFlowTheme.of(context).onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ].divide(SizedBox(width: 12.0)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<FFAppState>();
    final produtos = _model.produtosFiltrados;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        bottomNavigationBar: wrapWithModel(
          model: _model.menuInferiorModel,
          updateCallback: () => safeSetState(() {}),
          child: MenuInferiorWidget(abaAtual: AbaMenu.inicio),
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: [
              RefreshIndicator(
                color: FlutterFlowTheme.of(context).primary,
                onRefresh: _carregar,
                child: ListView(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      20.0, 16.0, 20.0, app.carrinho.isEmpty ? 24.0 : 96.0),
                  children: [
                    _cabecalho(context, app),
                    SizedBox(height: 20.0),
                    if (_model.carregando)
                      Padding(
                        padding: EdgeInsets.all(48.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      )
                    else if (_model.mensagemErro != null)
                      _estadoCentral(
                        context,
                        icone: Icons.wifi_off_rounded,
                        titulo: 'Não foi possível carregar',
                        mensagem: _model.mensagemErro!,
                        erro: true,
                      )
                    else if (_model.produtos.isEmpty)
                      _estadoCentral(
                        context,
                        icone: Icons.ramen_dining_outlined,
                        titulo: 'Nenhum produto disponível no momento',
                        mensagem:
                            'A cozinha está preparando novidades. Tente de novo daqui a pouco.',
                      )
                    else ...[
                      _promocao(context),
                      SizedBox(height: 20.0),
                      _categorias(context),
                      SizedBox(height: 20.0),
                      if (produtos.isEmpty)
                        Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'Nenhum prato encontrado para essa busca.',
                            textAlign: TextAlign.center,
                            style:
                                FlutterFlowTheme.of(context).bodyMedium.override(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                          ),
                        ),
                      ...produtos
                          .map((produto) =>
                              _cartaoProduto(context, produto, app))
                          .toList()
                          .divide(SizedBox(height: 16.0)),
                    ],
                  ],
                ),
              ),
              if (app.carrinho.isNotEmpty)
                Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: _barraVerPedido(context, app),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
