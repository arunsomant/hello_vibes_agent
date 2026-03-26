import 'package:flutter/material.dart';
import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../index.dart';

class MTLanguageTile extends StatelessWidget {
  const MTLanguageTile({
    super.key,
    required this.language,
    required this.languageCode,
    this.isSelected = false,
    this.onPressed,
  });

  final String language;
  final String languageCode;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.r32),
        color: AppColors.backgroundRaised,
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadii.r32 - 4),
        ),
        child: AppInkWell(
          onTap: onPressed,
          child: Center(
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      languageCode,
                      color: AppColors.textSecondary,
                      type: AppTextType.t24m,
                    ),
                    AppText(
                      language,
                      color: AppColors.textSecondary,
                      type: AppTextType.t12m,
                    ),
                  ],
                ),
                if (isSelected)
                  Positioned.fill(
                    child: Container(
                      color: AppColors.backgroundOverlay,
                      child: Center(
                        child: AppSvgAsset(
                          AppAssetsMapper.tick,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
