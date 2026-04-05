import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/app_assets_mapper.dart';
import '../../core/theme/app_colors.dart';
import 'index.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    this.height = double.maxFinite,
    this.width = double.maxFinite,
    this.backgroundColor = AppColors.backgroundPage,
  });

  final double height;
  final double width;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxHeight: Get.size.height,
      child: ColoredBox(
        color: backgroundColor,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.macaroni.withValues(alpha: 0.8),
                AppColors.finn.withValues(alpha: 0.5),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.3, 1.0],
            ),
          ),
          child: Opacity(
            opacity: 0.5,
            child: AppSvgAsset(AppAssetsMapper.bgIcons),
          ),
        ),
      ),
    );
  }
}
