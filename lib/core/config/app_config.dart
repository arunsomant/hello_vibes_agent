import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class AppConfig {
  static String appName = 'HelloVibess';

  static ThemeData theme = AppTheme.theme();

  static String baseUrl = 'http://65.1.70.29';

  static String apiBaseUrl = '$baseUrl/api';

  static AppColors colors = AppColors();

  static BoxShadow shadow = BoxShadow(
    color: AppColors.black.withValues(alpha: 0.2),
    blurRadius: 8,
    spreadRadius: 0,
    offset: const Offset(4, 4),
  );

  static LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.finn, AppColors.macaroni],
  );

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
