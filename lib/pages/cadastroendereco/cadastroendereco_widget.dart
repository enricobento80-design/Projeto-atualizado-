import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/sessao_cliente.dart';
import '/components/cabecalho/cabecalho_widget.dart';
import '/components/sl_ui.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'cadastroendereco_model.dart';
export 'cadastroendereco_model.dart';

/// Endereço de entrega: cadastro (fim do "Criar conta" ou a partir de
/// Endereços) e edição de um endereço existente ([enderecoId]).
class CadastroenderecoWidget extends StatefulWidget {
  const CadastroenderecoWidget({
    super.key,
    this.origemCadastro = false,
    this.enderecoId,
  });

  final bool origemCadastro;
  final int? enderecoId;

  static String routeName = 'cadastroendereco';
  static String routePath = '/cadastroendereco';

  @override
  State<CadastroenderecoWidget> createState() => _CadastroenderecoWidgetState();
}

class _CadastroenderecoWidgetState extends State<CadastroenderecoWidget> {
  late CadastroenderecoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _mascaraCep = MaskTextInputFormatter(mask: '#####-###');

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CadastroenderecoModel());

    _model.cepTextController ??= TextEditingController();
    _model.ruaTextController ??= TextEditingController();
    _model.numeroTextController ??= TextEditingController();
    _model.complementoTextController ??= TextEditingController();
    _model.bairroTextController ??= TextEditingController();
    _model.cidadeTextController ??= TextEditingController();
    _model.ufTextController ??= TextEditingController();

    if (widget.enderecoId != null) {
      _preencherParaEdicao();
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void _preencherParaEdicao() {
    final app = FFAppState();
    final endereco = app.enderecos
        .where((e) => getJsonField(e, r'''$.id''') == widget.enderecoId)
        .firstOrNull;
    if (endereco == null) {
      return;
    }
    String campo(dynamic origem, String caminho) =>
        getJsonField(origem, caminho)?.toString() ?? '';
    final cep = app.ceps
        .where((c) =>
            getJsonField(c, r'''$.id''') ==
            getJsonField(endereco, r'''$.cep_id'''))
        .firstOrNull;
    _model.cepTextController!.text =
        _mascaraCep.maskText(campo(cep, r'''$.cep''').replaceAll(RegExp(r'\D'), ''));
    _model.ruaTextController!.text = campo(endereco, r'''$.logradouro''');
    _model.numeroTextController!.text = campo(endereco, r'''$.numero''');
    _model.complementoTextController!.text =
        campo(endereco, r'''$.complemento''');
    _model.bairroTextController!.text = campo(endereco, r'''$.bairro''');
    _model.cidadeTextController!.text = campo(cep, r'''$.cidade''');
    _model.ufTextController!.text = campo(cep, r'''$.uf''');
    final apelido = campo(endereco, r'''$.apelido''');
    _model.apelido =
        ['Casa', 'Trabalho'].contains(apelido) ? apelido : 'Outro';
    _model.principal = getJsonField(endereco, r'''$.padrao''') == true;
  }

  Future<void> _buscarCep() async {
    FocusScope.of(context).unfocus();
    if (_model.cepDigitos.length != 8) {
      safeSetState(() => _model.mensagemErro = 'Informe um CEP com 8 dígitos.');
      return;
    }
    safeSetState(() {
      _model.buscandoCep = true;
      _model.mensagemErro = null;
    });
    final resposta = await BuscaCepCall.call(cep: _model.cepDigitos);
    safeSetState(() {
      _model.buscandoCep = false;
      if (!resposta.succeeded ||
          getJsonField(resposta.jsonBody, r'''$.erro''') != null) {
        _model.mensagemErro = 'CEP não encontrado. Confira o número.';
        return;
      }
      _model.ruaTextController!.text =
          BuscaCepCall.logradouro(resposta.jsonBody) ?? '';
      _model.bairroTextController!.text =
          BuscaCepCall.bairro(resposta.jsonBody) ?? '';
      _model.cidadeTextController!.text =
          BuscaCepCall.cidade(resposta.jsonBody) ?? '';
      _model.ufTextController!.text = BuscaCepCall.uf(resposta.jsonBody) ?? '';
    });
  }

  /// Reaproveita o CEP já cadastrado no Xano ou cria um novo.
  Future<int?> _idDoCep() async {
    final cepFormatado = _mascaraCep.maskText(_model.cepDigitos);
    final existentes = await BuscarCepXanoCall.call(cep: cepFormatado);
    if (existentes.succeeded) {
      final encontrado = ((existentes.jsonBody as List?) ?? [])
          .where((c) =>
              (getJsonField(c, r'''$.cep''')?.toString() ?? '')
                  .replaceAll(RegExp(r'\D'), '') ==
              _model.cepDigitos)
          .firstOrNull;
      final id = castToType<int>(getJsonField(encontrado, r'''$.id'''));
      if (id != null) {
        return id;
      }
    }
    final criado = await CriarCepCall.call(
      cep: cepFormatado,
      uf: _model.ufTextController!.text.trim(),
      cidade: _model.cidadeTextController!.text.trim(),
    );
    return criado.succeeded
        ? castToType<int>(getJsonField(criado.jsonBody, r'''$.id'''))
        : null;
  }

  Future<void> _salvar() async {
    safeSetState(() => _model.mensagemErro = null);
    if (_model.formKey.currentState?.validate() != true) {
      return;
    }
    if (_model.cidadeTextController!.text.trim().isEmpty) {
      safeSetState(() => _model.mensagemErro =
          'Toque em "Buscar" para preencher cidade e UF pelo CEP.');
      return;
    }
    final app = FFAppState();
    if (app.token.isEmpty) {
      safeSetState(() => _model.mensagemErro =
          'Entre na sua conta para cadastrar endereços.');
      return;
    }
    safeSetState(() => _model.salvando = true);

    final cepId = await _idDoCep();
    if (cepId == null) {
      safeSetState(() {
        _model.salvando = false;
        _model.mensagemErro = 'Não foi possível salvar o CEP. Tente novamente.';
      });
      return;
    }

    final campos = <String, dynamic>{
      'logradouro': _model.ruaTextController!.text.trim(),
      'numero': _model.numeroTextController!.text.trim(),
      'complemento': _model.complementoTextController!.text.trim(),
      'bairro': _model.bairroTextController!.text.trim(),
      'cep_id': cepId,
      'apelido': _model.apelido,
      'referencia': _model.apelido,
      'padrao': _model.principal,
    };

    int? enderecoId = widget.enderecoId;
    if (enderecoId == null) {
      final criado = await CadastroEnderecoCall.call(
        tokens: app.token,
        logradouro: campos['logradouro'],
        numero: campos['numero'],
        complemento: campos['complemento'],
        bairro: campos['bairro'],
        referencia: campos['referencia'],
        cepId: '$cepId',
        padrao: _model.principal,
      );
      enderecoId = criado.succeeded
          ? castToType<int>(getJsonField(criado.jsonBody, r'''$.id'''))
          : null;
      if (enderecoId != null) {
        // O POST não recebe o apelido; ele é gravado em seguida.
        await AtualizarEnderecoCall.call(
          enderecoId: enderecoId,
          campos: {'apelido': _model.apelido},
        );
      }
    } else {
      final atualizado = await AtualizarEnderecoCall.call(
        enderecoId: enderecoId,
        campos: campos,
      );
      if (!atualizado.succeeded) {
        enderecoId = null;
      }
    }

    if (enderecoId == null) {
      safeSetState(() {
        _model.salvando = false;
        _model.mensagemErro =
            'Não foi possível salvar o endereço. Tente novamente.';
      });
      return;
    }

    // Só um endereço pode ser o principal.
    if (_model.principal) {
      await carregarSessaoCliente(forcar: true);
      for (final outro in app.enderecos) {
        final outroId = castToType<int>(getJsonField(outro, r'''$.id'''));
        if (outroId != null &&
            outroId != enderecoId &&
            getJsonField(outro, r'''$.padrao''') == true) {
          await AtualizarEnderecoCall.call(
            enderecoId: outroId,
            campos: {'padrao': false},
          );
        }
      }
    }
    await carregarSessaoCliente(forcar: true);
    safeSetState(() => _model.salvando = false);
    if (!mounted) {
      return;
    }
    if (widget.origemCadastro) {
      showSnackbar(context, 'Cadastro concluído! Bom apetite, uai!');
      context.goNamed(MenucardapioCopyCopy2Widget.routeName);
    } else {
      showSnackbar(context, 'Endereço salvo.');
      context.safePop();
    }
  }

  Widget _chipApelido(BuildContext context, String apelido) {
    final tema = FlutterFlowTheme.of(context);
    final selecionado = _model.apelido == apelido;
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: () async => safeSetState(() => _model.apelido = apelido),
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 12.0),
        decoration: BoxDecoration(
          color: selecionado ? tema.primary : tema.secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: selecionado ? tema.primary : tema.alternate,
            width: 1.0,
          ),
        ),
        child: Text(
          apelido,
          style: tema.bodyLarge.override(
            color: selecionado ? tema.onPrimary : tema.primaryText,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: tema.primaryBackground,
        bottomNavigationBar: BarraInferiorSL(
          child: BotaoPrimarioSL(
            texto: widget.origemCadastro ? 'Concluir cadastro' : 'Salvar endereço',
            carregando: _model.salvando,
            aoTocar: _salvar,
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
                  titulo: 'Endereço de entrega',
                  subtitulo: 'Onde você quer receber?',
                  mostrarVoltar: !widget.origemCadastro,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 24.0),
                  child: Form(
                    key: _model.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_model.mensagemErro != null)
                          AvisoSL(texto: _model.mensagemErro!),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: CampoSL(
                                rotulo: 'CEP',
                                controller: _model.cepTextController,
                                dica: '00000-000',
                                teclado: TextInputType.number,
                                formatadores: [_mascaraCep],
                                validator: (_) => _model.cepDigitos.length == 8
                                    ? null
                                    : 'CEP inválido',
                              ),
                            ),
                            SizedBox(
                              height: 60.0,
                              child: TextButton(
                                onPressed:
                                    _model.buscandoCep ? null : _buscarCep,
                                style: TextButton.styleFrom(
                                  backgroundColor: tema.alternate,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                child: _model.buscandoCep
                                    ? SizedBox(
                                        width: 18.0,
                                        height: 18.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          color: tema.primary,
                                        ),
                                      )
                                    : Text(
                                        'Buscar',
                                        style: tema.titleSmall.override(
                                          color: tema.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),
                        CampoSL(
                          rotulo: 'Rua',
                          controller: _model.ruaTextController,
                          dica: 'Preenchido pelo CEP',
                          capitalizacao: TextCapitalization.words,
                          validator: _model.obrigatorio,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CampoSL(
                                rotulo: 'Número',
                                controller: _model.numeroTextController,
                                dica: '123',
                                teclado: TextInputType.text,
                                validator: _model.obrigatorio,
                              ),
                            ),
                            Expanded(
                              child: CampoSL(
                                rotulo: 'Complemento',
                                controller: _model.complementoTextController,
                                dica: 'Apto, bloco',
                              ),
                            ),
                          ].divide(SizedBox(width: 16.0)),
                        ),
                        CampoSL(
                          rotulo: 'Bairro',
                          controller: _model.bairroTextController,
                          dica: 'Preenchido pelo CEP',
                          capitalizacao: TextCapitalization.words,
                          validator: _model.obrigatorio,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: CampoSL(
                                rotulo: 'Cidade',
                                controller: _model.cidadeTextController,
                                somenteLeitura: true,
                              ),
                            ),
                            Expanded(
                              child: CampoSL(
                                rotulo: 'UF',
                                controller: _model.ufTextController,
                                somenteLeitura: true,
                              ),
                            ),
                          ].divide(SizedBox(width: 16.0)),
                        ),
                        Text(
                          'Salvar como',
                          style: tema.labelLarge
                              .override(fontWeight: FontWeight.w500),
                        ),
                        Wrap(
                          spacing: 12.0,
                          runSpacing: 12.0,
                          children: [
                            _chipApelido(context, 'Casa'),
                            _chipApelido(context, 'Trabalho'),
                            _chipApelido(context, 'Outro'),
                          ],
                        ),
                        InkWell(
                          onTap: () async => safeSetState(
                              () => _model.principal = !_model.principal),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _model.principal,
                                onChanged: (valor) => safeSetState(
                                    () => _model.principal = valor ?? false),
                                activeColor: tema.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              Text(
                                'Usar como endereço principal',
                                style: tema.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ].divide(SizedBox(height: 20.0)),
                    ),
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
