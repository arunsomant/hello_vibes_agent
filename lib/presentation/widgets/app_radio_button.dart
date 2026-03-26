import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'index.dart';

class AppRadioButton extends StatelessWidget {
  const AppRadioButton({super.key, this.selected = false, this.onPressed});

  final bool selected;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      borderRadius: 16,
      onTap: onPressed,
      child: Container(
        height: 16,
        width: 16,
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(
              color: selected
                  ? AppColors.borderFocused
                  : AppColors.borderDivider,
              width: 1,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
        ),
        child: selected
            ? Center(
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: ShapeDecoration(
                    color: selected ? AppColors.borderFocused : null,
                    shape: const CircleBorder(),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
