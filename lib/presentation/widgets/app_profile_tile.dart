import 'package:flutter/material.dart';
import '../../core/config/app_assets_mapper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacings.dart';
import 'index.dart';

class AppProfileTile extends StatelessWidget {
  const AppProfileTile({
    super.key,
    this.onPressed,
    required this.title,
    required this.assetIcon,
    this.isDestructive = false,
  });

  final VoidCallback? onPressed;
  final String title;
  final String assetIcon;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      borderRadius: AppRadii.r10,
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.s8,
          vertical: AppSpacings.s16,
        ),
        child: Row(
          spacing: AppSpacings.s8,
          children: [
            AppSvgAsset(
              assetIcon,
              color: isDestructive
                  ? AppColors.textError
                  : AppColors.iconPrimary,
            ),
            Expanded(
              child: AppText(
                title,
                type: AppTextType.t16b,
                color: isDestructive ? AppColors.textError : null,
              ),
            ),
            if (!isDestructive)
              AppSvgAsset(
                AppAssetsMapper.icRightArrow,
                color: AppColors.iconPrimary,
              ),
          ],
        ),
      ),
    );
  }
}
