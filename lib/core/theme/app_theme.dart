import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    textTheme: GoogleFonts.poppinsTextTheme().apply(
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
}
