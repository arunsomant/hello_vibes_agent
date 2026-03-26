import 'package:flutter/material.dart';

import 'index.dart';

class AppButtonIcon extends StatelessWidget {
  const AppButtonIcon({
    super.key,
    this.onTap,
    required this.svgAsset,
    this.color,
    this.backgroundColor,
    this.size = 52,
    this.sizeIcon,
  });

  final VoidCallback? onTap;
  final String svgAsset;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final double? sizeIcon;

  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      borderRadius: size,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(size),
        child: Container(
          width: size,
          height: size,
          color: backgroundColor,
          child: Center(
            child: AppSvgAsset(
              svgAsset,
              color: color,
              height: sizeIcon,
              width: sizeIcon,
            ),
          ),
        ),
      ),
    );
  }
}
