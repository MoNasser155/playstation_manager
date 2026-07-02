import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';

class VectorIcon extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;

  const VectorIcon({
    super.key,
    required this.assetPath,
    this.width = 24,
    this.height = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return VectorGraphic(
      loader: AssetBytesLoader(assetPath),
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
