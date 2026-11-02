import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/sessao_cliente.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'enderecos_model.dart';
export 'enderecos_model.dart';

/// Endereços do cliente logado (tabela `endereco` do Xano). Tocar num
/// endereço escolhe onde receber.
class EnderecosWidget extends StatefulWidget {
  const EnderecosWidget({super.key});

  static String routeName = 'enderecos';
  static String routePath = '/enderecos';

  @override
  State<EnderecosWidget> createState() => _EnderecosWidgetState();
}

class _EnderecosWidgetState extends State<EnderecosWidget> {
  late EnderecosModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EnderecosModel());

    SchedulerBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _carregar({bool forcar = false}) async {
    safeSetState(() {
      _model.carregando = true;
      _model.mensagemErro = null;
    });
    try {
      await carregarSessaoCliente(forcar: forcar);
    } catch (_) {
      _model.mensagemErro =
          'Não foi possível carregar seus endereços. Tente novamente.';
    }
    safeSetState(() => _model.carregando = false);
  }

  Future<void> _cadastrarNovoEndereco() async {
    await context.pushNamed(CadastroenderecoWidget.routeName);
    await _carregar(forcar: true);
  }

  Future<void> _excluir(dynamic endereco, String apelido) async {
    final id = castToType<int>(getJsonField(endereco, r'''$.id'''));
    if (id == null) {
      return;
    }
    final confirmou = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text('Excluir endereço'),
            content: Text('Deseja excluir o endereço "$apelido"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(
                  'Excluir',
                  style: TextStyle(color: FlutterFlowTheme.of(context).error),
                ),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmou) {
      return;
    }
    final resposta = await ExcluirEnderecoCall.call(enderecoId: id);
    if (!mounted) {
      return;
    }
    if (!resposta.succeeded) {
      showSnackbar(context, 'Não foi possível excluir o endereço.');
      return;
    }
    final app = FFAppState();
    if (app.enderecoEntregaId == id) {
      app.enderecoEntregaId = null;
    }
    showSnackbar(context, 'Endereço excluído.');
    await _carregar(forcar: true);
  }

  Widget _botaoAcao(
    BuildContext context, {
    required String texto,
    required bool perigo,
    required VoidCallback aoTocar,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.0),
      onTap: aoTocar,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(18.0, 10.0, 18.0, 10.0),
        decoration: BoxDecoration(
          color: perigo
              ? Colors.transparent
              : FlutterFlowTheme.of(context).alternate,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Text(
          texto,
          style: FlutterFlowTheme.of(context).titleSmall.override(
                color: perigo
                    ? FlutterFlowTheme.of(context).error
                    : FlutterFlowTheme.of(context).primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  Widget _cartaoEndereco(
      BuildContext context, FFAppState app, dynamic endereco) {
    final id = getJsonField(endereco, r'''$.id''');
    final selecionado =
        getJsonField(enderecoDeEntrega(app), r'''$.id''') == id;
    final principal = getJsonField(endereco, r'''$.padrao''') == true;
    final apelido = valueOrDefault<String>(
      getJsonField(endereco, r'''$.apelido''')?.toString(),
      valueOrDefault<String>(
        getJsonField(endereco, r'''$.referencia''')?.toString(),
        'Endereço',
      ),
    );
    final complemento =
        getJsonField(endereco, r'''$.complemento''')?.toString().trim() ?? '';
    final linha1 = complemento.isEmpty
        ? ruaENumero(endereco)
        : '${ruaENumero(endereco)} · $complemento';

    return InkWell(
      borderRadius: BorderRadius.circular(24.0),
      onTap: () async {
        app.update(() => app.enderecoEntregaId = id as int?);
        showSnackbar(context, 'Entregar em: $apelido');
      },
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: selecionado
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: selecionado ? 2.0 : 1.0,
          ),
        ),
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52.0,
                  height: 52.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Icon(
                    _model.iconeDoApelido(apelido),
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24.0,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            apelido,
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(fontWeight: FontWeight.w600),
                          ),
                          if (principal)
                            Container(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 4.0, 10.0, 4.0),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .success
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(9999.0),
                              ),
                              child: Text(
                                'Principal',
                                style: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .override(
                                      color:
                                          FlutterFlowTheme.of(context).success,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        linha1,
                        style: FlutterFlowTheme.of(context).bodyLarge,
                      ),
                      Text(
                        bairroCidadeUf(endereco, app.ceps),
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ),
              ].divide(SizedBox(width: 16.0)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _botaoAcao(
                  context,
                  texto: 'Excluir',
                  perigo: true,
                  aoTocar: () => _excluir(endereco, apelido),
                ),
                _botaoAcao(
                  context,
                  texto: 'Alterar',
                  perigo: false,
                  aoTocar: () async {
                    await context.pushNamed(
                      CadastroenderecoWidget.routeName,
                      queryParameters: {
                        'enderecoId': serializeParam(id, ParamType.int),
                      }.withoutNulls,
                    );
                    await _carregar(forcar: true);
                  },
                ),
              ].divide(SizedBox(width: 8.0)),
            ),
          ].divide(SizedBox(height: 12.0)),
        ),
      ),
    );
  }

  Widget _mensagemCentral(
    BuildContext context, {
    required IconData icone,
    required String titulo,
    required String texto,
    bool erro = false,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 48.0, 16.0, 48.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88.0,
            height: 88.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icone,
              color: erro
                  ? FlutterFlowTheme.of(context).error
                  : FlutterFlowTheme.of(context).primary,
              size: 40.0,
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
            texto,
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: erro
                      ? FlutterFlowTheme.of(context).error
                      : FlutterFlowTheme.of(context).secondaryText,
                ),
          ),
          if (erro)
            TextButton(
              onPressed: () => _carregar(forcar: true),
              child: Text(
                'Tentar novamente',
                style: FlutterFlowTheme.of(context).titleSmall.override(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
              ),
            ),
        ].divide(SizedBox(height: 12.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<FFAppState>();
    final logado = app.token.isNotEmpty;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      bottomNavigationBar: !logado
          ? null
          : Container(
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
                  child: FFButtonWidget(
                    onPressed: _cadastrarNovoEndereco,
                    text: 'Cadastrar novo endereço',
                    icon: Icon(Icons.add_rounded, size: 24.0),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 56.0,
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconColor: FlutterFlowTheme.of(context).onPrimary,
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                color: FlutterFlowTheme.of(context).onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
              ),
            ),
      body: SafeArea(
        top: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            wrapWithModel(
              model: _model.cabecalhoModel,
              updateCallback: () => safeSetState(() {}),
              child: CabecalhoWidget(
                titulo: 'Endereços',
                subtitulo: 'Toque para escolher onde receber',
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: FlutterFlowTheme.of(context).primary,
                onRefresh: () => _carregar(forcar: true),
                child: ListView(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 24.0),
                  children: [
                    if (!logado)
                      _mensagemCentral(
                        context,
                        icone: Icons.lock_outline_rounded,
                        titulo: 'Entre na sua conta',
                        texto: 'Faça login para ver e cadastrar endereços.',
                      )
                    else if (_model.carregando && !app.sessaoCarregada)
                      Padding(
                        padding: EdgeInsets.all(48.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      )
                    else if (_model.mensagemErro != null)
                      _mensagemCentral(
                        context,
                        icone: Icons.error_outline_rounded,
                        titulo: 'Algo deu errado',
                        texto: _model.mensagemErro!,
                        erro: true,
                      )
                    else if (app.enderecos.isEmpty)
                      _mensagemCentral(
                        context,
                        icone: Icons.location_on_outlined,
                        titulo: 'Nenhum endereço ainda',
                        texto:
                            'Cadastre seu primeiro endereço para receber seus pratos mineiros onde estiver.',
                      )
                    else
                      ...app.enderecos
                          .map((e) => _cartaoEndereco(context, app, e))
                          .toList()
                          .divide(SizedBox(height: 16.0)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
