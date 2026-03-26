import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacings.dart';
import '../../../data/models/avatar.dart';
import '../index.dart';

class AppProfileSelectionCarousel extends StatelessWidget {
  const AppProfileSelectionCarousel({
    super.key,
    required this.avatarList,
    this.onAvatarChanged,
    this.selectedAvatar = const Avatar(),
  });

  final List<Avatar> avatarList;

  final Function(Avatar avatar)? onAvatarChanged;

  final Avatar selectedAvatar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.avatarCarouselHeight + 4,
      width: double.maxFinite,
      child: AppCarousel(
        itemCount: avatarList.length,
        enlargeCenterPage: true,
        autoPlay: false,
        initialPage: _getSelectedAvatarIndex(),
        viewportFraction: 0.43,
        onPageChanged: (index) {
          onAvatarChanged?.call(avatarList[index]);
        },
        itemBuilder: (context, index, realIndex) {
          return Center(
            child: Container(
              width: AppSizes.avatarCarouselHeight,
              height: AppSizes.avatarCarouselHeight,
              padding: EdgeInsets.all(AppSpacings.s8),
              decoration: BoxDecoration(
                color: AppColors.backgroundRaised,
                borderRadius: BorderRadius.circular(AppRadii.r32),
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(
                  AppRadii.r32 - AppSpacings.s8,
                ),
                child: AppNetworkImage(avatarList[index].url),
              ),
            ),
          );
        },
      ),
    );
  }

  int _getSelectedAvatarIndex() {
    final index = avatarList.indexWhere((a) => a.id == selectedAvatar.id);
    return index != -1 ? index : 0;
  }
}
