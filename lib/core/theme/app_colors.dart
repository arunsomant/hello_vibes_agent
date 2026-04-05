import 'package:flutter/material.dart';

class AppColors {
  static const int _finnPrimaryValue = 0xFF913D7D;
  static const MaterialColor finn =
      MaterialColor(_finnPrimaryValue, <int, Color>{
        50: Color(0xFFF1E7EF),
        100: Color(0xFFDEC4D8),
        200: Color(0xFFC89EBE),
        300: Color(0xFFB277A4),
        400: Color(0xFFA15A90),
        500: Color(_finnPrimaryValue),
        600: Color(0xFF833771),
        700: Color(0xFF753165),
        800: Color(0xFF622955),
        900: Color(0xFF451D3C),
      });
  static const Color teal = Color(0xFF4ECDC4);
  static const Color richBlack = Color(0xFF0E1417);
  static const Color macaroni = Color(0xFFF8BE98);
  static const Color macaroniDark = Color(0xFFE88849);
  static const Color macaroni20 = Color(0x33F8BE98);
  static const Color tradeWind = Color(0xFF5AABA7);
  static const Color grey = Color(0xFFBEBEBE);
  static const Color green = Color(0xFF1BAF2F);
  static const Color black = Color(0xFF1A1A1A);
  static const Color black60 = Color(0x991A1A1A);
  static const Color raisinBlack = Color(0xFF252525);
  static const Color white = Colors.white;
  static const Color red = Color(0xFFFF6B6B);
  static const Color violet = Color(0xFF6C5CE7);
  static const Color transparent = Colors.transparent;

  static const MaterialColor primary = finn;

  static const Color textPrimary = black;

  static const Color textSecondary = white;

  static const Color backgroundInputField = macaroni20;

  static const Color backgroundOverlay = black60;

  static const Color backgroundPage = white;

  static const Color backgroundRaised = white;

  static const Color borderDivider = grey;

  static const Color borderFocused = finn;

  static const Color buttonDisabled = grey;

  static const Color buttonPrimary = finn;

  static const Color buttonSecondary = white;

  static const Color textHint = grey;

  static const Color textLink = finn;

  static const Color textError = red;

  static const Color textPositive = green;

  static const Color iconPrimary = richBlack;

  static const Color iconSecondary = white;

  static const Color iconHint = grey;

  static const Color iconHighlight = finn;

  static const Color iconFavourite = red;

  static const Color iconCredit = green;

  static const Color iconDebit = red;

  static const Color shimmerBase = Color(0xFFEEEEEE);

  static final Color shimmerHighlight = grey;

  static const Color statusBar = transparent;

  static const Color overlay = macaroni20;

  static const Color online = green;

  static const Color offline = red;
}
