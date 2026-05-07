import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class AppConfig {
  static String appName = 'MingleTalk';

  static ThemeData theme = AppTheme.theme();

  static String baseUrl = 'https://app.demarrer.in';

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

  static String supportMail = 'support-agent@mingletalk.com';

  static String supportNumber = '+919876543211';

  // WebSocket (Reverb) Config - placeholder values, update later
  static String websocketHost = 'app.demarrer.in';
  static int websocketPort = 443;
  static String websocketKey = 'lqt2kphzfzhgmwhktqi3';
  static String websocketAuthEndpoint = '/broadcasting/auth';
}
