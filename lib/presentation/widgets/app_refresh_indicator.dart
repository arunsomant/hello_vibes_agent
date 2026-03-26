import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;

  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      strokeWidth: 2,
      backgroundColor: AppColors.backgroundRaised,
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
