import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacings.dart';

class AppCarouselIndicator extends StatelessWidget {
  const AppCarouselIndicator({
    super.key,
    required this.length,
    this.activeIndex = 0,
  });

  final int length;
  final int activeIndex;
  final double widthLarge = 20.0;
  final double width = 4;
  final double widthZero = 0.0;
  final int maxToDisplay = 5;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: SizedBox(
        height: width,
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return AnimatedContainer(
              width: index == activeIndex ? widthLarge : width,
              height: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.r8),
                color: activeIndex == index
                    ? AppColors.indicatorActive
                    : AppColors.indicatorInactive,
              ),
              duration: const Duration(milliseconds: 200),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(width: AppSpacings.s2);
          },
          itemCount: length,
        ),
      ),
    );
  }
}
