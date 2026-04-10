import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacings.dart';
import 'index.dart';

class AppDialog {
  static void showSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.backgroundRaised,
      margin: const EdgeInsets.all(0),
      colorText: AppColors.textPrimary,
      borderRadius: 0.0,
    );
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.backgroundRaised,
      textColor: AppColors.textPrimary,
      fontSize: 14.0,
    );
  }

  static Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    Object? arguments,
  }) {
    return Get.bottomSheet(
      SafeArea(bottom: true, top: false, child: child),
      enableDrag: false,
      clipBehavior: Clip.hardEdge,
      settings: RouteSettings(arguments: arguments),
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: AppColors.backgroundRaised,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.r20)),
      ),
    );
  }

  static void showAppDatePicker({
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required Function(DateTime) onDateSelected,
  }) async {
    final context = Get.context;
    if (context != null) {
      showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                onPrimary: AppColors.white,
                onSurface: AppColors.textPrimary,
                surface: AppColors.backgroundRaised,
              ),
            ),
            child: child!,
          );
        },
      ).then((picked) {
        if (picked != null) {
          onDateSelected(picked);
        }
      });
    }
  }

  static Future<T?> showDialog<T>({
    required Widget child,
    bool isDismissible = true,
  }) {
    return Get.dialog(child, barrierDismissible: isDismissible);
  }

  static Future<T?> showAlertDialog<T>({
    String? caption,
    String? title,
    String? positiveText,
    String? negativeText,
    VoidCallback? positiveOnPressed,
    VoidCallback? negativeOnPressed,
    double textHeight = 70,
    bool isDismissible = true,
    double childSizeRatio = 0.3,
  }) {
    return AppDialog.showBottomSheet(
      isDismissible: isDismissible,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: AppSpacings.s24),
              if (caption != null) ...[
                AppText(
                  caption,
                  type: AppTextType.t14sb,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacings.s16),
              ],
              SizedBox(
                height: textHeight,
                child: AppText(
                  title ?? '',
                  type: AppTextType.t14r,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacings.s16),
              Row(
                children: [
                  if (negativeOnPressed != null || negativeText != null)
                    Expanded(
                      child: AppButton(
                        text: negativeText ?? 'Cancel',
                        fillColor: false,
                        onPressed: negativeOnPressed,
                        border: true,
                        textType: AppTextType.t14m,
                        textColor: AppColors.primary,
                      ),
                    ),
                  if ((negativeOnPressed != null || negativeText != null) &&
                      (positiveOnPressed != null || positiveText != null))
                    const SizedBox(width: AppSpacings.s16),
                  if (positiveOnPressed != null || positiveText != null)
                    Expanded(
                      child: AppButton(
                        text: positiveText ?? 'Okay',
                        onPressed: positiveOnPressed,
                        textType: AppTextType.t14m,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacings.s16),
            ],
          ),
        ),
      ),
    );
  }
}
