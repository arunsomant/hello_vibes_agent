import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppInkWell extends StatelessWidget {
  const AppInkWell({
    super.key,
    this.child,
    this.borderRadius = 0,
    this.onTap,
    this.onLongPress,
  });

  final Widget? child;

  final double borderRadius;

  final VoidCallback? onTap, onLongPress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child ?? const SizedBox(),
        Positioned.fill(
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                overlayColor: WidgetStatePropertyAll(
                  AppColors.overlay.withValues(alpha: 0.1),
                ),
                onTap: onTap,
                onLongPress: onLongPress,
                child: const SizedBox(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
