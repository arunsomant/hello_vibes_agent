import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_spacings.dart';
import '../../../data/models/user.dart';
import '../index.dart';

class MTAppBar extends StatelessWidget {
  const MTAppBar({
    super.key,
    required this.user,
    this.onOnlineStatusChanged,
  });

  final User user;

  final Function(bool value)? onOnlineStatusChanged;

  String get profileName => user.name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s16,
        vertical: AppSpacings.s8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSpacings.s8,
        children: [
          AppLogo(height: 48, width: 48),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  'Hello${profileName.isNotEmpty ? ' ${profileName.split(' ').first}' : ' Guest'},',
                  type: AppTextType.t20b,
                ),
                const AppText('Welcome back!', type: AppTextType.t14r),
              ],
            ),
          ),
          OnlineStatusButton(
            value: user.isOnline,
            onChanged: (value){
              onOnlineStatusChanged?.call(value);
            },
          ),
        ],
      ),
    );
  }
}
