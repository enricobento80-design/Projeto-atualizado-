import '/components/cabecalho/cabecalho_widget.dart';
import '/components/sl_ui.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'novocartao_model.dart';
export 'novocartao_model.dart';

/// Novo cartão: formulário com prévia do cartão. Os dados digitados nunca
/// saem do aparelho; o cartão só pode ser salvo depois de tokenizado pelo
/// gateway (Asaas), que devolve o token guardado em `cartaotoknzd`.
class NovocartaoWidget extends StatefulWidget {
  const NovocartaoWidget({super.key});

  static String routeName = 'novocartao';
  static String routePath = '/novocartao';

  @override
  State<NovocartaoWidget> createState() => _NovocartaoWidgetState();
}

class _NovocartaoWidgetState extends State<NovocartaoWidget> {
  late NovocartaoModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _mascaraNumero = MaskTextInputFormatter(mask: '#### #### #### #######');
  final _mascaraValidade = MaskTextInputFormatter(mask: '##/##');
  final _mascaraCvv = MaskTextInputFormatter(mask: '####');

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NovocartaoModel());

    _model.numeroTextController ??= TextEditingController();
    _model.nomeTextController ??= TextEditingController();
    _model.validadeTextController ??= TextEditingController();
    _model.cvvTextController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _salvar() async {
    safeSetState(() {
      _model.mensagemErro = null;
      _model.mensagemInfo = null;
    });
    if (_model.formKey.currentState?.validate() != true) {
      return;
    }
    // A tokenização precisa ser feita pelo servidor com a chave do Asaas;
    // ainda não existe endpoint para isso no Xano. Por segurança, o número
    // e o CVV não são enviados a nenhum serviço.
    safeSetState(() => _model.mensagemInfo =
        'Cartão ${_model.bandeira.isEmpty ? '' : '${_model.bandeira} '}validado, mas o cadastro de cartões ainda não está disponível. Nenhum dado do cartão foi enviado. Por enquanto, pague com PIX.');
  }

  Widget _previaCartao(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final digitos = _model.numeroDigitos;
    final grupos = List.generate(4, (g) {
      final inicio = g * 4;
      return List.generate(4, (i) {
        final indice = inicio + i;
        // Só os 4 últimos dígitos digitados ficam visíveis.
        if (indice < digitos.length && indice >= 12) {
          return digitos[indice];
        }
        return '•';
      }).join();
    }).join('  ');
    final nome = _model.nomeTextController!.text.trim().toUpperCase();
    final validade = _model.validadeTextController!.text;
    final estiloClaro = tema.bodyMedium.override(color: tema.onPrimary);

    return AspectRatio(
      aspectRatio: 1.75,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: tema.primary,
          borderRadius: BorderRadius.circular(28.0),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -60.0,
              top: -20.0,
              child: Container(
                width: 260.0,
                height: 260.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70.0),
                  border: Border.all(
                    color: tema.tertiary.withValues(alpha: 0.25),
                    width: 30.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _model.bandeira.isEmpty
                              ? 'Sabor Local'
                              : _model.bandeira,
                          style: tema.headlineSmall.override(
                            color: tema.onPrimary,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 56.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: tema.tertiary,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Text(
                      grupos,
                      style: tema.titleLarge.override(
                        color: tema.onPrimary,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          nome.isEmpty ? 'NOME IMPRESSO' : nome,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: estiloClaro,
                        ),
                      ),
                      Text(validade.isEmpty ? 'MM/AA' : validade,
                          style: estiloClaro),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
          child: BotaoPrimarioSL(texto: 'Salvar cartão', aoTocar: _salvar),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              wrapWithModel(
                model: _model.cabecalhoModel,
                updateCallback: () => safeSetState(() {}),
                child: CabecalhoWidget(titulo: 'Novo cartão'),
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
                        _previaCartao(context),
                        if (_model.mensagemInfo != null)
                          AvisoSL(
                            tipo: TipoAvisoSL.info,
                            texto: _model.mensagemInfo!,
                          ),
                        CampoSL(
                          rotulo: 'Número do cartão',
                          controller: _model.numeroTextController,
                          dica: '0000 0000 0000 0000',
                          teclado: TextInputType.number,
                          formatadores: [_mascaraNumero],
                          aoMudar: (_) => safeSetState(() {}),
                          validator: (_) => _model.numeroValido
                              ? null
                              : 'Número de cartão inválido.',
                        ),
                        CampoSL(
                          rotulo: 'Nome impresso no cartão',
                          controller: _model.nomeTextController,
                          dica: 'Como está no cartão',
                          capitalizacao: TextCapitalization.characters,
                          aoMudar: (_) => safeSetState(() {}),
                          validator: (valor) => (valor ?? '').trim().length < 3
                              ? 'Informe o nome impresso.'
                              : null,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CampoSL(
                                rotulo: 'Validade',
                                controller: _model.validadeTextController,
                                dica: 'MM/AA',
                                teclado: TextInputType.number,
                                formatadores: [_mascaraValidade],
                                aoMudar: (_) => safeSetState(() {}),
                                validator: (_) => _model.validadeValida
                                    ? null
                                    : 'Validade inválida.',
                              ),
                            ),
                            Expanded(
                              child: CampoSL(
                                rotulo: 'CVV',
                                controller: _model.cvvTextController,
                                dica: '•••',
                                teclado: TextInputType.number,
                                formatadores: [_mascaraCvv],
                                senha: true,
                                acao: TextInputAction.done,
                                validator: (valor) =>
                                    (valor ?? '').length >= 3
                                        ? null
                                        : 'CVV inválido.',
                              ),
                            ),
                          ].divide(SizedBox(width: 16.0)),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.shield_outlined,
                                color: tema.success, size: 22.0),
                            Expanded(
                              child: Text(
                                'Conexão segura (SSL). O cartão é tokenizado pelo gateway de pagamento: o Sabor Local não guarda o número nem o CVV.',
                                style: tema.bodySmall
                                    .override(color: tema.secondaryText),
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
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
