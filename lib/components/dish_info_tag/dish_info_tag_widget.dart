import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dish_info_tag_model.dart';
export 'dish_info_tag_model.dart';

class DishInfoTagWidget extends StatefulWidget {
  const DishInfoTagWidget({
    super.key,
    this.icon,
    String? label,
  }) : this.label = label ?? '45-60 min';

  final Widget? icon;
  final String label;

  @override
  State<DishInfoTagWidget> createState() => _DishInfoTagWidgetState();
}

class _DishInfoTagWidgetState extends State<DishInfoTagWidget> {
  late DishInfoTagModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DishInfoTagModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget!.icon!,
        Text(
          valueOrDefault<String>(
            widget!.label,
            '45-60 min',
          ),
          style: FlutterFlowTheme.of(context).bodySmall.override(
                font: GoogleFonts.poppins(
                  fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).onSurfaceVariant,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                lineHeight: 1.4,
              ),
        ),
      ].divide(SizedBox(width: 4.0)),
    );
  }
}
