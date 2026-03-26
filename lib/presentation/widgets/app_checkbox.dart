import 'package:flutter/material.dart';

import '../../core/config/app_assets_mapper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import 'index.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    this.onChanged,
    this.value = true,
    this.small = false,
    this.radius = AppRadii.r4,
  });

  final VoidCallback? onChanged;

  final bool value;

  final bool small;

  final double radius;

  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      onTap: onChanged,
      borderRadius: radius,
      child: Container(
        height: small ? 16 : 24,
        width: small ? 16 : 24,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : null,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            strokeAlign: BorderSide.strokeAlignInside,
            color: AppColors.borderFocused,
            width: 1,
          ),
        ),
        child: value
            ? Center(
                child: AppSvgAsset(
                  AppAssetsMapper.icCheck,
                  height: small ? 12 : 18,
                  width: small ? 12 : 18,
                  color: AppColors.iconSecondary,
                ),
              )
            : null,
      ),
    );
  }
}
