import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'cabecalho_model.dart';
export 'cabecalho_model.dart';

/// Cabeçalho padrão do Sabor Local: botão voltar quadrado + título em Lora
/// e subtítulo opcional.
class CabecalhoWidget extends StatefulWidget {
  const CabecalhoWidget({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.mostrarVoltar = true,
    this.aoVoltar,
  });

  final String titulo;
  final String? subtitulo;
  final bool mostrarVoltar;
  final Future Function()? aoVoltar;

  @override
  State<CabecalhoWidget> createState() => _CabecalhoWidgetState();
}

class _CabecalhoWidgetState extends State<CabecalhoWidget> {
  late CabecalhoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CabecalhoModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (widget.mostrarVoltar)
            InkWell(
              borderRadius: BorderRadius.circular(14.0),
              onTap: () async {
                if (widget.aoVoltar != null) {
                  await widget.aoVoltar!();
                } else {
                  context.safePop();
                }
              },
              child: Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1.0,
                  ),
                ),
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 26.0,
                ),
              ),
            ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (widget.subtitulo != null && widget.subtitulo!.isNotEmpty)
                  Text(
                    widget.subtitulo!,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
              ],
            ),
          ),
        ].divide(SizedBox(width: 16.0)),
      ),
    );
  }
}
