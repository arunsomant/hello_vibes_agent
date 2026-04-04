import 'package:flutter/material.dart';
import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacings.dart';
import '../../widgets/index.dart';

class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key, this.onIAgreePressed});

  final VoidCallback? onIAgreePressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacings.s16),
      child: Material(
        color: AppColors.transparent,
        child: Stack(
          children: [
            Positioned.fill(child: AppBackground()),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacings.s16,
                vertical: AppSpacings.s40,
              ),
              child: Column(
                spacing: AppSpacings.s8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacings.s4,
                    children: [
                      AppLogo(height: 44, width: 44),
                      AppText(
                        'Welcome to Mingle Talk',
                        type: AppTextType.t18sb,
                      ),
                      AppText(
                        'We strive to build a space where everyone feels secure and valued',
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildBulletPoint(
                          'Let’s keep it positive',
                          'Treat others with the same care you’d want',
                        ),
                        _buildBulletPoint(
                          'Prioritise your peace of mind',
                          'Limit to what you feel is right for you',
                        ),
                        _buildBulletPoint(
                          'Help us uphold safety',
                          'Report any interactions that feel out of line',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacings.s8),
                  TermsAndPrivacy(),
                  const SizedBox(height: AppSpacings.s8),
                  AppButton(
                    text: 'I Agree',
                    onPressed: onIAgreePressed,
                    height: AppSizes.appButtonHeightLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacings.s16),
      child: Row(
        spacing: AppSpacings.s12,
        children: [
          AppSvgAsset(
            AppAssetsMapper.icHeartFill,
            color: AppColors.primary,
            height: 24,
            width: 24,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, type: AppTextType.t14sb),
                AppText(content, type: AppTextType.t12r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
