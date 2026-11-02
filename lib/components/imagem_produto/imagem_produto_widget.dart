import '/flutter_flow/flutter_flow_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Imagem do produto vinda do campo `url_imagem` do Xano, com fundo neutro
/// enquanto carrega ou quando não há imagem.
class ImagemProdutoWidget extends StatelessWidget {
  const ImagemProdutoWidget({
    super.key,
    required this.url,
    this.largura,
    this.altura,
    this.raio = 16.0,
  });

  final String? url;
  final double? largura;
  final double? altura;
  final double raio;

  Widget _fundo(BuildContext context) {
    return Container(
      width: largura,
      height: altura,
      color: FlutterFlowTheme.of(context).alternate,
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Icon(
        Icons.restaurant_rounded,
        color: FlutterFlowTheme.of(context).secondaryText,
        size: 28.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(raio),
      child: (url == null || url!.isEmpty)
          ? _fundo(context)
          : CachedNetworkImage(
              imageUrl: url!,
              width: largura,
              height: altura,
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 200),
              placeholder: (context, _) => _fundo(context),
              errorWidget: (context, _, __) => _fundo(context),
            ),
    );
  }
}
