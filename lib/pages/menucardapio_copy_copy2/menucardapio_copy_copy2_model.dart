import '/components/menu_inferior/menu_inferior_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'menucardapio_copy_copy2_widget.dart' show MenucardapioCopyCopy2Widget;
import 'package:flutter/material.dart';

class MenucardapioCopyCopy2Model
    extends FlutterFlowModel<MenucardapioCopyCopy2Widget> {
  ///  Local state fields for this page.

  bool carregando = true;

  String? mensagemErro;

  // Produtos da tabela `produto` do Xano.
  List<dynamic> produtos = [];

  String categoriaSelecionada = 'Tudo';

  ///  State fields for stateful widgets in this page.

  // State field(s) for Busca widget.
  FocusNode? buscaFocusNode;
  TextEditingController? buscaTextController;

  // Model for MenuInferior.
  late MenuInferiorModel menuInferiorModel;

  @override
  void initState(BuildContext context) {
    menuInferiorModel = createModel(context, () => MenuInferiorModel());
  }

  @override
  void dispose() {
    buscaFocusNode?.dispose();
    buscaTextController?.dispose();

    menuInferiorModel.dispose();
  }

  String categoriaDe(dynamic produto) =>
      getJsonField(produto, r'''$._catego.Categorias''')?.toString() ?? '';

  /// "Tudo" + categorias na ordem em que aparecem (Comidas, Bebidas...).
  List<String> get categorias {
    final unicas = <String>[];
    for (final produto in [...produtos]..sort((a, b) =>
        (getJsonField(a, r'''$.categoria''') as int? ?? 0)
            .compareTo(getJsonField(b, r'''$.categoria''') as int? ?? 0))) {
      final categoria = categoriaDe(produto);
      if (categoria.isNotEmpty && !unicas.contains(categoria)) {
        unicas.add(categoria);
      }
    }
    return ['Tudo', ...unicas];
  }

  List<dynamic> get produtosFiltrados {
    final busca = (buscaTextController?.text ?? '').trim().toLowerCase();
    return produtos.where((produto) {
      if (categoriaSelecionada != 'Tudo' &&
          categoriaDe(produto) != categoriaSelecionada) {
        return false;
      }
      if (busca.isEmpty) {
        return true;
      }
      final nome =
          getJsonField(produto, r'''$.nome''')?.toString().toLowerCase() ?? '';
      final descricao = getJsonField(produto, r'''$.descricao''')
              ?.toString()
              .toLowerCase() ??
          '';
      return nome.contains(busca) || descricao.contains(busca);
    }).toList()
      ..sort((a, b) => (getJsonField(a, r'''$.categoria''') as int? ?? 0)
          .compareTo(getJsonField(b, r'''$.categoria''') as int? ?? 0));
  }
}
