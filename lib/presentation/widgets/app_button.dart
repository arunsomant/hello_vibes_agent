import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacings.dart';
import 'app_text.dart';
import 'image_view.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.onPressed,
    required this.text,
    this.child,
    this.style,
    this.disabledStyle,
    this.width,
    this.height = AppSizes.appButtonHeight,
    this.busy = false,
    this.shadow = false,
    this.padding = AppSpacings.s24,
    this.minWidth,
    this.round = true,
    this.textButton = false,
    this.prefixIconAsset,
    this.suffixIconAsset,
    this.border = false,
    this.fillColor = true,
    this.color,
    this.textColor,
    this.prefixIconColor,
    this.applyPrefixIconColor = true,
    this.applySuffixIconColor = true,
    this.iconHeight,
    this.iconWidth,
    this.iconPadding = AppSpacings.s8,
    this.textType,
    this.progress,
  });

  final VoidCallback? onPressed;
  final String text;
  final Widget? child;
  final ButtonStyle? style;
  final ButtonStyle? disabledStyle;
  final double? width;
  final double? minWidth;
  final double? iconWidth;
  final double? iconHeight;
  final double? iconPadding;
  final double padding;
  final double height;
  final bool busy;
  final bool shadow;
  final bool round;
  final bool textButton;
  final String? prefixIconAsset;
  final String? suffixIconAsset;
  final bool border;
  final bool fillColor;
  final Color? color;
  final Color? textColor;
  final Color? prefixIconColor;
  final bool applyPrefixIconColor;
  final bool applySuffixIconColor;
  final AppTextType? textType;
  final double? progress;

  double get _borderRadius => AppRadii.r32;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: minWidth ?? 0, maxHeight: height),
      decoration: !textButton
          ? BoxDecoration(
              border: border
                  ? Border.all(
                      color: onPressed != null
                          ? (textColor ?? AppColors.buttonPrimary)
                          : AppColors.textHint,
                      width: 1,
                    )
                  : null,
              boxShadow: shadow ? [AppConfig.shadow] : null,
              borderRadius: BorderRadius.circular(
                round ? height : _borderRadius,
              ),
            )
          : null,
      child: TextButton(
        onPressed: !busy ? onPressed : null,
        style: onPressed != null
            ? style ?? _appButtonStyle()
            : disabledStyle ?? _appButtonDisabledStyle(),
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: !busy
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (prefixIconAsset != null) ...[
                          AppSvgAsset(
                            prefixIconAsset!,
                            height: iconHeight,
                            width: iconWidth,
                            color: applyPrefixIconColor
                                ? prefixIconColor ?? textColor
                                : null,
                          ),
                          SizedBox(width: iconPadding),
                        ],
                        child ??
                            AppText(
                              text,
                              textAlign: TextAlign.center,
                              type: textType ?? AppTextType.t16m,
                              color: onPressed == null && !fillColor
                                  ? AppColors.textHint
                                  : textColor ?? AppColors.textSecondary,
                              //style: textStyle,
                            ),
                        if (suffixIconAsset != null) ...[
                          SizedBox(width: iconPadding),
                          AppSvgAsset(
                            suffixIconAsset!,
                            height: iconHeight,
                            width: iconWidth,
                            color: applySuffixIconColor
                                ? onPressed == null && !fillColor
                                      ? AppColors.textHint
                                      : textColor ?? AppColors.textPrimary
                                : null,
                          ),
                        ],
                      ],
                    ),
                  )
                : SizedBox(
                    height: height,
                    width: height,
                    child: Padding(
                      padding: EdgeInsets.all(height > 40 ? 16.0 : 8),
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: textColor ?? AppColors.buttonPrimary,
                        value: progress,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  ButtonStyle _appButtonStyle() {
    return TextButton.styleFrom(
      overlayColor: AppColors.overlay,
      backgroundColor: !textButton && fillColor
          ? (color ?? AppColors.primary)
          : null,
      padding: const EdgeInsets.all(AppSpacings.s0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(round ? height : 10),
      ),
    );
  }

  ButtonStyle _appButtonDisabledStyle() {
    return TextButton.styleFrom(
      overlayColor: AppColors.overlay,
      surfaceTintColor: Colors.green,
      backgroundColor: !textButton && fillColor ? AppColors.textHint : null,
      padding: const EdgeInsets.all(AppSpacings.s0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(round ? height : _borderRadius),
      ),
    );
  }
}
