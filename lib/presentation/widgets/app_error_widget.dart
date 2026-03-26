import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacings.dart';
import 'index.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    this.caption = '',
    this.message = '',
    this.onPressed,
    this.asset = '',
    this.captionTextType,
  });

  final String caption;
  final String message;
  final VoidCallback? onPressed;
  final String asset;
  final AppTextType? captionTextType;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (asset.isNotEmpty) ...[
                AppSvgAsset(
                  asset,
                  height: 80,
                  width: 80,
                  color: AppColors.iconHint,
                ),
                const SizedBox(height: AppSpacings.s8),
              ],
              if (caption.isNotEmpty) ...[
                AppText(caption, type: captionTextType ?? AppTextType.t18m),
                const SizedBox(height: AppSpacings.s4),
              ],
              if (message.isNotEmpty) ...[
                AppText(message),
                const SizedBox(height: AppSpacings.s8),
              ],
              if (onPressed != null)
                AppInkWell(
                  borderRadius: AppRadii.r8,
                  onTap: onPressed,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                    child: AppText('Retry', color: AppColors.textLink),
                  ),
                ),
              if (asset.isNotEmpty) const SizedBox(height: 2 * AppSpacings.s60),
            ],
          ),
        ),
      ],
    );
  }
}
