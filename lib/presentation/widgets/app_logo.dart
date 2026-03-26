import 'package:flutter/material.dart';

import '../../core/config/app_assets_mapper.dart';
import 'image_view.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.height = 150, this.width = 150});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: AppAssetImage(AppAssetsMapper.logoMT),
    );
  }
}
