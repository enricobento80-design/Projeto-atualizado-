import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'menu_inferior_model.dart';
export 'menu_inferior_model.dart';

/// Abas do menu inferior.
enum AbaMenu { inicio, pedido, pedidos, perfil }

/// Menu inferior do Sabor Local: Início, Pedido (carrinho), Pedidos e Perfil.
class MenuInferiorWidget extends StatefulWidget {
  const MenuInferiorWidget({
    super.key,
    required this.abaAtual,
  });

  final AbaMenu abaAtual;

  @override
  State<MenuInferiorWidget> createState() => _MenuInferiorWidgetState();
}

class _MenuInferiorWidgetState extends State<MenuInferiorWidget> {
  late MenuInferiorModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuInferiorModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  String _rotaDaAba(AbaMenu aba) {
    switch (aba) {
      case AbaMenu.inicio:
        return MenucardapioCopyCopy2Widget.routeName;
      case AbaMenu.pedido:
        return CartCheckoutWidget.routeName;
      case AbaMenu.pedidos:
        return MeuspedidosWidget.routeName;
      case AbaMenu.perfil:
        return MenudacontaWidget.routeName;
    }
  }

  Widget _item(
    BuildContext context, {
    required AbaMenu aba,
    required IconData icone,
    required String rotulo,
    int contador = 0,
  }) {
    final selecionado = widget.abaAtual == aba;
    final cor = selecionado
        ? FlutterFlowTheme.of(context).primary
        : FlutterFlowTheme.of(context).secondaryText;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18.0),
        onTap: () async {
          if (selecionado) {
            return;
          }
          context.goNamed(
            _rotaDaAba(aba),
            extra: <String, dynamic>{
              kTransitionInfoKey: TransitionInfo(hasTransition: false),
            },
          );
        },
        child: Container(
          margin: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
          decoration: BoxDecoration(
            color: selecionado
                ? FlutterFlowTheme.of(context).alternate
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Badge(
                isLabelVisible: contador > 0,
                label: Text('$contador'),
                backgroundColor: FlutterFlowTheme.of(context).tertiary,
                textColor: FlutterFlowTheme.of(context).secondary,
                child: Icon(icone, color: cor, size: 26.0),
              ),
              Text(
                rotulo,
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      color: cor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ].divide(SizedBox(height: 4.0)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itensNoCarrinho = context.watch<FFAppState>().totalItensCarrinho;
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
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _item(
                context,
                aba: AbaMenu.inicio,
                icone: Icons.home_outlined,
                rotulo: 'Início',
              ),
              _item(
                context,
                aba: AbaMenu.pedido,
                icone: Icons.shopping_bag_outlined,
                rotulo: 'Pedido',
                contador: itensNoCarrinho,
              ),
              _item(
                context,
                aba: AbaMenu.pedidos,
                icone: Icons.receipt_long_outlined,
                rotulo: 'Pedidos',
              ),
              _item(
                context,
                aba: AbaMenu.perfil,
                icone: Icons.person_outline_rounded,
                rotulo: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
