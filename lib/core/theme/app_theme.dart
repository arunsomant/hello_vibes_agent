import 'package:flutter/material.dart';

import '../../presentation/widgets/index.dart';
import '../config/app_assets_mapper.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData theme() => ThemeData(
    primarySwatch: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundPage,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.transparent,
      elevation: 0,
    ),
    appBarTheme: AppBarThemeData(
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.backgroundPage,
      centerTitle: false,
      titleTextStyle: AppText.t16m.copyWith(color: AppColors.textPrimary),
      iconTheme: IconThemeData(color: AppColors.iconPrimary),
    ),
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) {
        return AppButtonIcon(
          svgAsset: AppAssetsMapper.icLeftArrow,
          color: AppColors.iconPrimary,
        );
      },
    ),

    fontFamily: AppText.fontFamily,
    textTheme: textThemeApply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
      decorationColor: AppColors.textPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
  );

  static TextTheme? textThemeApply({
    Color? bodyColor,
    Color? displayColor,
    Color? decorationColor,
  }) {
    return TextTheme(
      displayLarge: TextStyle(
        color: displayColor,
        decorationColor: decorationColor,
      ),
      displayMedium: TextStyle(
        color: displayColor,
        decorationColor: decorationColor,
      ),
      displaySmall: TextStyle(decorationColor: decorationColor),
      headlineLarge: TextStyle(
        color: displayColor,
        decorationColor: decorationColor,
      ),
      headlineMedium: TextStyle(
        color: displayColor,
        decorationColor: decorationColor,
      ),
      headlineSmall: TextStyle(
        color: bodyColor,
        decorationColor: decorationColor,
      ),
      titleLarge: TextStyle(color: bodyColor, decorationColor: decorationColor),
      titleMedium: TextStyle(
        color: bodyColor,
        decorationColor: decorationColor,
      ),
      titleSmall: TextStyle(color: bodyColor, decorationColor: decorationColor),
      bodyLarge: TextStyle(color: bodyColor, decorationColor: decorationColor),
      bodyMedium: TextStyle(color: bodyColor, decorationColor: decorationColor),
      bodySmall: TextStyle(
        color: displayColor,
        decorationColor: decorationColor,
      ),
      labelLarge: TextStyle(color: bodyColor, decorationColor: decorationColor),
      labelMedium: TextStyle(
        color: bodyColor,
        decorationColor: decorationColor,
      ),
      labelSmall: TextStyle(color: bodyColor, decorationColor: decorationColor),
    );
  }
}
