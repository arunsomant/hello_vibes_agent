import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacings.dart';
import '../index.dart';

class AppPill extends StatelessWidget {
  const AppPill({
    super.key,
    this.text = '',
    this.onTap,
    this.closeButton = true,
    this.selected = false,
  });

  final String text;

  final VoidCallback? onTap;

  final bool closeButton;

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      borderRadius: 16,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.s18,
          vertical: AppSpacings.s8,
        ),
        decoration: ShapeDecoration(
          shape: StadiumBorder(
            side: BorderSide(
              color: selected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
        child: AppText(
          text,
          color: selected ? AppColors.primary : AppColors.textPrimary,
          maxLine: 1,
          type: AppTextType.t14r,
        ),
      ),
    );
  }
}
