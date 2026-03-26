import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../data/models/user.dart';
import '../index.dart';

class HVProfileImage extends StatelessWidget {
  const HVProfileImage({
    super.key,
    required this.user,
    this.size = 100,
    this.showOnlineStatus = true,
  });

  final User user;

  final double size;

  final bool showOnlineStatus;

  @override
  Widget build(BuildContext context) {
    final child = ProfileImage.network(user.avatar.url, size: size);
    if (!showOnlineStatus) {
      return child;
    }
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        children: [
          child,
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: size * 0.25,
              width: size * 0.25,
              decoration: BoxDecoration(
                color: user.isOnline ? AppColors.online : AppColors.offline,
                borderRadius: BorderRadius.circular(AppRadii.r32),
                border: Border.all(color: AppColors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
