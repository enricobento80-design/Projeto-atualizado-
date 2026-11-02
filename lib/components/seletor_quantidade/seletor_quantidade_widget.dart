import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

/// Seletor "− 1 +" usado no cardápio, no detalhe do produto e no pedido.
class SeletorQuantidadeWidget extends StatelessWidget {
  const SeletorQuantidadeWidget({
    super.key,
    required this.quantidade,
    required this.aoDiminuir,
    required this.aoAumentar,
    this.podeAumentar = true,
    this.tamanho = 40.0,
  });

  final int quantidade;
  final VoidCallback aoDiminuir;
  final VoidCallback aoAumentar;
  final bool podeAumentar;
  final double tamanho;

  Widget _botao(
    BuildContext context, {
    required IconData icone,
    required Color fundo,
    required Color cor,
    VoidCallback? aoTocar,
  }) {
    return Material(
      color: fundo,
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: aoTocar,
        child: SizedBox(
          width: tamanho,
          height: tamanho,
          child: Icon(icone, color: cor, size: 20.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).alternate,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _botao(
            context,
            icone: Icons.remove_rounded,
            fundo: FlutterFlowTheme.of(context).secondaryBackground,
            cor: FlutterFlowTheme.of(context).primaryText,
            aoTocar: aoDiminuir,
          ),
          SizedBox(
            width: 32.0,
            child: Text(
              '$quantidade',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          _botao(
            context,
            icone: Icons.add_rounded,
            fundo: podeAumentar
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).secondaryText,
            cor: FlutterFlowTheme.of(context).onPrimary,
            aoTocar: podeAumentar ? aoAumentar : null,
          ),
        ],
      ),
    );
  }
}
