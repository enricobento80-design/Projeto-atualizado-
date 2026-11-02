import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Peças visuais repetidas nas telas do Sabor Local (layout do SLFood).

/// Botão principal marrom, largura total por padrão.
class BotaoPrimarioSL extends StatelessWidget {
  const BotaoPrimarioSL({
    super.key,
    required this.texto,
    required this.aoTocar,
    this.icone,
    this.carregando = false,
    this.larguraTotal = true,
    this.altura = 56.0,
  });

  final String texto;
  final Future Function()? aoTocar;
  final IconData? icone;
  final bool carregando;
  final bool larguraTotal;
  final double altura;

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: (carregando || aoTocar == null) ? null : () => aoTocar!(),
      text: texto,
      icon: carregando
          ? SizedBox(
              width: 18.0,
              height: 18.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: FlutterFlowTheme.of(context).onPrimary,
              ),
            )
          : (icone == null ? null : Icon(icone, size: 20.0)),
      options: FFButtonOptions(
        width: larguraTotal ? double.infinity : null,
        height: altura,
        padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
        iconColor: FlutterFlowTheme.of(context).onPrimary,
        color: FlutterFlowTheme.of(context).primary,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              color: FlutterFlowTheme.of(context).onPrimary,
              fontWeight: FontWeight.bold,
            ),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(18.0),
        disabledColor:
            FlutterFlowTheme.of(context).primary.withValues(alpha: 0.55),
        disabledTextColor: FlutterFlowTheme.of(context).onPrimary,
      ),
    );
  }
}

/// Botão de contorno marrom (ação secundária).
class BotaoSecundarioSL extends StatelessWidget {
  const BotaoSecundarioSL({
    super.key,
    required this.texto,
    required this.aoTocar,
    this.larguraTotal = true,
    this.altura = 56.0,
  });

  final String texto;
  final Future Function()? aoTocar;
  final bool larguraTotal;
  final double altura;

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: aoTocar == null ? null : () => aoTocar!(),
      text: texto,
      options: FFButtonOptions(
        width: larguraTotal ? double.infinity : null,
        height: altura,
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
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
        borderRadius: BorderRadius.circular(18.0),
      ),
    );
  }
}

/// Cartão branco com borda clara e cantos de 24.
class CartaoSL extends StatelessWidget {
  const CartaoSL({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
    this.corBorda,
    this.larguraBorda = 1.0,
    this.cor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? corBorda;
  final double larguraBorda;
  final Color? cor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: padding,
      decoration: BoxDecoration(
        color: cor ?? FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: corBorda ?? FlutterFlowTheme.of(context).alternate,
          width: larguraBorda,
        ),
      ),
      child: child,
    );
  }
}

/// Barra fixa no rodapé (fundo branco e borda superior) para o botão final.
class BarraInferiorSL extends StatelessWidget {
  const BarraInferiorSL({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
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
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
          child: child,
        ),
      ),
    );
  }
}

/// Três barras de progresso do cadastro ("Etapa N de 3").
class EtapasSL extends StatelessWidget {
  const EtapasSL({super.key, required this.etapa, this.total = 3});

  final int etapa;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        total,
        (indice) => Expanded(
          child: Container(
            height: 8.0,
            decoration: BoxDecoration(
              color: indice < etapa
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).alternate,
              borderRadius: BorderRadius.circular(9999.0),
            ),
          ),
        ),
      ).divide(SizedBox(width: 8.0)),
    );
  }
}

/// Aviso colorido (erro, sucesso, informação) com ícone.
class AvisoSL extends StatelessWidget {
  const AvisoSL({
    super.key,
    required this.texto,
    this.tipo = TipoAvisoSL.erro,
    this.conteudo,
  });

  final String texto;
  final TipoAvisoSL tipo;
  final Widget? conteudo;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    final cor = switch (tipo) {
      TipoAvisoSL.erro => tema.error,
      TipoAvisoSL.sucesso => tema.success,
      TipoAvisoSL.info => tema.primary,
    };
    final icone = switch (tipo) {
      TipoAvisoSL.erro => Icons.error_outline_rounded,
      TipoAvisoSL.sucesso => Icons.check_rounded,
      TipoAvisoSL.info => Icons.info_outline_rounded,
    };
    return Container(
      padding: EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: tipo == TipoAvisoSL.info
            ? tema.secondaryBackground
            : cor.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(20.0),
        border: tipo == TipoAvisoSL.info
            ? Border.all(color: tema.alternate, width: 1.0)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: cor, size: 24.0),
          Expanded(
            child: conteudo ??
                Text(
                  texto,
                  style: tema.bodyMedium.override(
                    color: tipo == TipoAvisoSL.info ? tema.primaryText : cor,
                    fontWeight: tipo == TipoAvisoSL.sucesso
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
          ),
        ].divide(SizedBox(width: 12.0)),
      ),
    );
  }
}

enum TipoAvisoSL { erro, sucesso, info }

/// Decoração dos campos de texto (fundo branco, cantos de 18).
InputDecoration decoracaoCampoSL(
  BuildContext context, {
  String? dica,
  Widget? sufixo,
  bool somenteLeitura = false,
  bool erro = false,
}) {
  final tema = FlutterFlowTheme.of(context);
  OutlineInputBorder borda(Color cor) => OutlineInputBorder(
        borderSide: BorderSide(color: cor, width: 1.0),
        borderRadius: BorderRadius.circular(18.0),
      );
  return InputDecoration(
    hintText: dica,
    hintStyle: tema.bodyLarge.override(color: tema.secondaryText),
    filled: true,
    fillColor: somenteLeitura ? tema.alternate : tema.secondaryBackground,
    contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 18.0, 20.0, 18.0),
    suffixIcon: sufixo,
    enabledBorder: borda(erro
        ? tema.error
        : (somenteLeitura ? tema.alternate : tema.alternate)),
    focusedBorder: borda(erro ? tema.error : tema.primary),
    disabledBorder: borda(tema.alternate),
    errorBorder: borda(tema.error),
    focusedErrorBorder: borda(tema.error),
  );
}

/// Rótulo + campo de texto, no padrão dos formulários do app.
class CampoSL extends StatelessWidget {
  const CampoSL({
    super.key,
    required this.rotulo,
    required this.controller,
    this.complementoRotulo,
    this.focusNode,
    this.dica,
    this.validator,
    this.teclado,
    this.formatadores,
    this.senha = false,
    this.somenteLeitura = false,
    this.sufixo,
    this.capitalizacao = TextCapitalization.none,
    this.aoMudar,
    this.acao = TextInputAction.next,
    this.linhas = 1,
    this.erro = false,
  });

  final String rotulo;
  final String? complementoRotulo;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? dica;
  final String? Function(String?)? validator;
  final TextInputType? teclado;
  final List<TextInputFormatter>? formatadores;
  final bool senha;
  final bool somenteLeitura;
  final Widget? sufixo;
  final TextCapitalization capitalizacao;
  final ValueChanged<String>? aoMudar;
  final TextInputAction acao;
  final int linhas;
  final bool erro;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: rotulo),
              if (complementoRotulo != null)
                TextSpan(
                  text: ' $complementoRotulo',
                  style: TextStyle(
                    color: tema.secondaryText,
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ],
          ),
          style: tema.labelLarge.override(
            color: tema.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: senha,
          readOnly: somenteLeitura,
          keyboardType: teclado,
          inputFormatters: formatadores,
          textCapitalization: capitalizacao,
          textInputAction: linhas > 1 ? TextInputAction.newline : acao,
          onChanged: aoMudar,
          maxLines: senha ? 1 : linhas,
          minLines: linhas > 1 ? linhas : null,
          decoration: decoracaoCampoSL(
            context,
            dica: dica,
            sufixo: sufixo,
            somenteLeitura: somenteLeitura,
            erro: erro,
          ),
          style: tema.bodyLarge,
          cursorColor: tema.primary,
          validator: validator,
        ),
      ].divide(SizedBox(height: 8.0)),
    );
  }
}

/// Ícone dentro de um quadrado/círculo de fundo suave.
class IconeFundoSL extends StatelessWidget {
  const IconeFundoSL({
    super.key,
    required this.icone,
    this.cor,
    this.fundo,
    this.tamanho = 52.0,
    this.tamanhoIcone = 24.0,
    this.circular = false,
  });

  final IconData icone;
  final Color? cor;
  final Color? fundo;
  final double tamanho;
  final double tamanhoIcone;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    final tema = FlutterFlowTheme.of(context);
    return Container(
      width: tamanho,
      height: tamanho,
      decoration: BoxDecoration(
        color: fundo ?? tema.alternate,
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circular ? null : BorderRadius.circular(tamanho * 0.28),
      ),
      child: Icon(icone, color: cor ?? tema.primary, size: tamanhoIcone),
    );
  }
}

/// Título de seção em Lora ("Recompensas", "Forma de pagamento"...).
class TituloSecaoSL extends StatelessWidget {
  const TituloSecaoSL(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: FlutterFlowTheme.of(context).headlineSmall.override(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
