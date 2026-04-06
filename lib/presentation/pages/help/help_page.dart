import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacings.dart';
import '../../../core/utils/app_launcher.dart';
import '../../controllers/help_controller.dart';
import '../../widgets/index.dart';

class HelpPage extends GetView<HelpController> {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppText('Help & Support')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacings.s16),
          children: [
            _buildAccordion(
              'How don receive a call?',
              ' To receive a call, simply ensure that you have "Available" status enabled in your home page. When a call comes in, you will receive a notification. Click on the notification to answer the call and connect with the person. If you have any issues with receiving calls, please contact our support team for assistance.',
            ),
            _buildDivider(),
            _buildAccordion(
              'How can I withdraw my earnings?',
              'To withdraw your earnings, go to the "Wallet" section in your account settings. From there, you can choose your preferred bank account. Follow the prompts to complete the transaction. If you encounter any problems during the withdrawal process, please reach out to our support team for help.',
            ),
            _buildDivider(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacings.s20,
                vertical: AppSpacings.s24,
              ),
              decoration: BoxDecoration(
                color: AppColors.backgroundRaised,
                borderRadius: BorderRadius.circular(AppRadii.r16),
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacings.s24),
                  const AppText(
                    'Still have questions?',
                    type: AppTextType.t20sb,
                  ),
                  const SizedBox(height: AppSpacings.s8),
                  AppText(
                    'Can’t find the answer you’re looking for? Please contact our friendly team.',
                    type: AppTextType.t16r,
                  ),
                  const SizedBox(height: AppSpacings.s24),
                  AppButton(
                    text: 'Get in touch',
                    onPressed: () {
                      AppDialog.showBottomSheet(
                        /* title: 'Still need help ?',*/
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppInkWell(
                              onTap: () {
                                Get.back();
                                AppLauncher.mail(AppConfig.supportMail);
                              },
                              child: _buildMenuItem(
                                asset: AppAssetsMapper.icDocument,
                                title: 'Mail',
                                subtitle:
                                    'For further assistance, please email us',
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacings.s16,
                              ),
                              child: Divider(),
                            ),
                            AppInkWell(
                              onTap: () {
                                Get.back();
                                AppLauncher.openWhatsApp(
                                  AppConfig.supportNumber,
                                  'Hello, I need assistance with the app.',
                                );
                              },
                              child: _buildMenuItem(
                                asset: AppAssetsMapper.icCommunity,
                                title: 'Chat',
                                subtitle:
                                    'For more support, chat with us on WhatsApp for better assistance.',
                              ),
                            ),
                            const SizedBox(height: AppSpacings.s16),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordion(String header, content) {
    return Accordion(
      enableRightIcon: true,
      opened: false,
      header: AppText(header, type: AppTextType.t16m),
      children: [AppText(content)],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacings.s32),
      child: Divider(height: 1),
    );
  }

  Widget _buildMenuItem({
    required String asset,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacings.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppSvgAsset(asset, color: AppColors.iconPrimary),
          const SizedBox(width: AppSpacings.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, type: AppTextType.t16m),
                AppText(subtitle, type: AppTextType.t12r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
