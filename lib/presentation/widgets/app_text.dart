import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/config/app_config.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.type = AppTextType.t14r,
    this.textAlign,
    this.color,
    this.maxLine,
    this.dummy = false,
    this.maxDummy,
    this.decoration,
    this.shadow = false,
  }) : isCollapsible = false,
       onMorePressed = null;

  const AppText.readMoreText(
    this.text, {
    super.key,
    this.type = AppTextType.t14r,
    this.textAlign,
    this.color,
    this.maxLine,
    this.dummy = false,
    this.maxDummy,
    this.isCollapsible = true,
    this.onMorePressed,
    this.decoration,
    this.shadow = false,
  });

  final String text;

  final AppTextType type;

  final TextAlign? textAlign;

  final Color? color;

  final int? maxLine;

  final bool dummy;

  final int? maxDummy;

  final bool isCollapsible;

  final bool shadow;

  final TextDecoration? decoration;

  final VoidCallback? onMorePressed;

  static String fontFamily = 'Poppins';

  static TextStyle get t10l => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w300,
  );

  static TextStyle get t10sb => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get t12r =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp, height: 1.25);

  static TextStyle get t12m => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 1.25,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get t12sb => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 1.25,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get t14r =>
      TextStyle(fontFamily: fontFamily, fontSize: 14.sp, height: 1.25);

  static TextStyle get t14m => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get t14sb => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get t16r =>
      TextStyle(fontFamily: fontFamily, fontSize: 16.sp);

  static TextStyle get t16m => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get t16sb => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get t16b => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get t18m => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static TextStyle get t18sb => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle get t18b => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get t20sb => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle get t20b => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle get t24m => TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get t24sb => TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get t24b => TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get t40b => TextStyle(
    fontFamily: fontFamily,
    fontSize: 40.sp,
    fontWeight: FontWeight.bold,
    height: 1,
  );

  static TextStyle get t64b => TextStyle(
    fontFamily: fontFamily,
    fontSize: 64.sp,
    fontWeight: FontWeight.bold,
    height: 1,
  );

  @override
  Widget build(BuildContext context) {
    if (isCollapsible) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final style = _getStyle().copyWith(
            color: color,
            letterSpacing: dummy ? 0 : null,
            decoration: decoration,
            decorationColor: color,
          );
          final caption = dummy ? _generateRandomString() : text;
          final maxLines = maxLine;
          final span = TextSpan(text: caption, style: style);
          final TextPainter textPainter = TextPainter(
            text: span,
            maxLines: maxLines,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);
          final didExceedMaxLines = textPainter.didExceedMaxLines;
          return Text.rich(
            TextSpan(
              text: !didExceedMaxLines
                  ? caption
                  : _getTruncatedText(textPainter),
              style: style,
              children: <TextSpan>[
                if (didExceedMaxLines)
                  TextSpan(
                    text: 'more',
                    recognizer: TapGestureRecognizer()..onTap = onMorePressed,
                  ),
              ],
            ),
          );
        },
      );
    }
    return Text(
      dummy ? _generateRandomString() : text,
      style: _getStyle().copyWith(
        color: color,
        letterSpacing: dummy ? 0 : null,
        decoration: decoration,
        decorationColor: color,
        shadows: shadow ? [AppConfig.shadow] : null,
      ),
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: maxLine != null ? TextOverflow.ellipsis : null,
    );
  }

  TextStyle _getStyle() {
    switch (type) {
      case AppTextType.t10l:
        return t10l;
      case AppTextType.t10sb:
        return t10sb;
      case AppTextType.t12r:
        return t12r;
      case AppTextType.t12m:
        return t12m;
      case AppTextType.t12sb:
        return t12sb;
      case AppTextType.t14r:
        return t14r;
      case AppTextType.t14m:
        return t14m;
      case AppTextType.t14sb:
        return t14sb;
      case AppTextType.t16r:
        return t16r;
      case AppTextType.t16m:
        return t16m;
      case AppTextType.t16sb:
        return t16sb;
      case AppTextType.t16b:
        return t16b;
      case AppTextType.t18m:
        return t18m;
      case AppTextType.t18sb:
        return t18sb;
      case AppTextType.t18b:
        return t18b;
      case AppTextType.t20sb:
        return t20sb;
      case AppTextType.t20b:
        return t20b;
      case AppTextType.t24m:
        return t24m;
      case AppTextType.t24sb:
        return t24sb;
      case AppTextType.t24b:
        return t24b;
      case AppTextType.t40b:
        return t40b;
      case AppTextType.t64b:
        return t64b;
    }
  }

  String _generateRandomString() {
    int count = maxDummy ?? (Random().nextInt(50) + 5);
    return '▇' * count;
  }

  String _getTruncatedText(TextPainter painter) {
    final text = painter.plainText;
    final textSize = painter.size;
    final pos = painter.getPositionForOffset(
      Offset(textSize.width, textSize.height),
    );
    final endIndex = painter.getOffsetBefore(pos.offset) ?? 0;
    final sample = '${text.substring(0, endIndex - 14)}... ';
    return sample;
  }
}

enum AppTextType {
  t10l,
  t10sb,
  t12r,
  t12m,
  t12sb,
  t14r,
  t14m,
  t14sb,
  t16r,
  t16m,
  t16sb,
  t16b,
  t18m,
  t18sb,
  t18b,
  t20sb,
  t20b,
  t24m,
  t24sb,
  t24b,
  t40b,
  t64b,
}
