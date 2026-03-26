import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacings.dart';
import 'index.dart';

class TermsAndPrivacy extends StatelessWidget {
  const TermsAndPrivacy({
    super.key,
    this.onTermsChecked,
    this.onTermsPressed,
    this.onPolicyPressed,
    this.termsAccepted = false,
  });

  final VoidCallback? onTermsChecked, onTermsPressed, onPolicyPressed;

  final bool termsAccepted;

  @override
  Widget build(BuildContext context) {
    final child = RichText(
      textAlign: onTermsChecked != null ? TextAlign.start : TextAlign.center,
      text: TextSpan(
        style: AppText.t10l.copyWith(color: AppColors.textPrimary),
        children: [
          TextSpan(
            text: onTermsChecked != null
                ? 'I agree to all the '
                : 'By Continuing you accepting the ',
          ),
          TextSpan(
            text: 'Terms of Use',
            style: TextStyle(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTermsPressed,
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onPolicyPressed,
          ),
        ],
      ),
    );
    if (onTermsChecked != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCheckbox(
            small: true,
            value: termsAccepted,
            onChanged: onTermsChecked,
          ),
          const SizedBox(width: AppSpacings.s8),
          Expanded(child: child),
        ],
      );
    }
    return child;
  }
}
