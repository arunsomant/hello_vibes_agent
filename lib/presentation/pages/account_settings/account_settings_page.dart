import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacings.dart';
import '../../controllers/account_settings_controller.dart';
import '../../widgets/index.dart';

class AccountSettingsPage extends GetView<AccountSettingsController> {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppText('Accounts & Settings')),
      body: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          color: AppColors.backgroundRaised,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadii.r10),
            topRight: Radius.circular(AppRadii.r10),
          ),
        ),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppSpacings.s16),
          shrinkWrap: true,
          children: [
            AppProfileTile(
              onPressed: controller.onCommunityGuidelinesPressed,
              assetIcon: AppAssetsMapper.icCommunity,
              title: 'Community Guidelines ',
            ),
            _buildDivider(),
            AppProfileTile(
              onPressed: controller.onSafetyCenterPressed,
              assetIcon: AppAssetsMapper.icFileShield,
              title: 'Safety Center',
            ),
            _buildDivider(),
            AppProfileTile(
              onPressed: controller.onHelpSupportPressed,
              assetIcon: AppAssetsMapper.icHeadset,
              title: 'Help & Support',
            ),
            _buildDivider(),
            AppProfileTile(
              onPressed: controller.onPrivacyPolicyPressed,
              assetIcon: AppAssetsMapper.icSecurity,
              title: 'Privacy Policy',
            ),
            _buildDivider(),
            AppProfileTile(
              onPressed: controller.onTermsConditionsPressed,
              assetIcon: AppAssetsMapper.icDocument,
              title: 'Terms & Conditions',
            ),
            _buildDivider(),
            AppProfileTile(
              isDestructive: true,
              onPressed: onDeleteAccountPressed,
              assetIcon: AppAssetsMapper.icDelete,
              title: 'Delete Account',
            ),
            _buildDivider(),
            AppProfileTile(
              isDestructive: true,
              onPressed: onLogoutPressed,
              assetIcon: AppAssetsMapper.icLogout,
              title: 'Logout',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacings.s8,
        horizontal: AppSpacings.s32,
      ),
      child: Divider(height: 0, color: AppColors.borderDivider),
    );
  }


  void onDeleteAccountPressed() {
    AppDialog.showAlertDialog(
      negativeText: 'Yes, Delete',
      positiveText: 'Cancel',
      title: 'Are you sure you want to delete your account ?',
      textHeight: 50,
      positiveOnPressed: () {
        Get.back();
      },
      negativeOnPressed: controller.onDeleteAccountPressed,
    );
  }

  void onLogoutPressed() {
    AppDialog.showAlertDialog(
      negativeText: 'Yes, Logout',
      positiveText: 'Cancel',
      title: 'Are you sure you want to logout ?',
      textHeight: 50,
      positiveOnPressed: () {
        Get.back();
      },
      negativeOnPressed: controller.onLogoutPressed,
    );
  }
}
