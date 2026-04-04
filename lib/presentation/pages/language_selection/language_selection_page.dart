import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacings.dart';
import '../../../data/models/language.dart';
import '../../controllers/language_selection_controller.dart';
import '../../widgets/index.dart';

class LanguageSelectionPage extends GetView<LanguageSelectionController> {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controller.fromProfile
          ? AppBar(title: AppText('Language Preference'))
          : null,
      body: Stack(
        children: [
          AppBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s16),
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: AppSpacings.s60),
                      AppText(
                        'Languages You Speak Fluently',
                        type: AppTextType.t18b,
                      ),
                      AppText('This will help to find perfect matches for you'),
                      const SizedBox(height: AppSpacings.s24),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Obx(() {
                            final busy = controller.languagesBusy.isTrue;
                            if(!busy && controller.languages.isEmpty) {
                              return AppErrorWidget(
                                asset: AppAssetsMapper.icDocumentText,
                                onPressed: controller.onRefresh,
                                message: 'Empty list',
                              );
                            }
                            return AppShimmer(
                              enable: busy,
                              child: GridView.builder(
                                itemCount: busy
                                    ? 9
                                    : controller.languages.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: AppSpacings.s16,
                                      mainAxisSpacing: AppSpacings.s8,
                                    ),
                                itemBuilder: (context, index) {
                                  Language language = const Language();
                                  if (index < controller.languages.length) {
                                    language = controller.languages[index];
                                  }
                                  return Obx(() {
                                    return AspectRatio(
                                      aspectRatio: 1,
                                      child: MTLanguageTile(
                                        language: language.displayName,
                                        languageCode: language.shortDisplayName,
                                        isSelected: controller.isLanguageSelected(
                                          language,
                                        ),
                                        onPressed: () =>
                                            controller.onLanguagesSelected(index),
                                      ),
                                    );
                                  });
                                },
                              ),
                            );
                          }),
                        ),
                        Obx( () {
                            return AppButton(
                              text: 'Submit',
                              busy: controller.busy.isTrue,
                              onPressed: controller.onSubmitPressed,
                              height: AppSizes.appButtonHeightLarge,
                            );
                          }
                        ),
                        const SizedBox(height: AppSpacings.s16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
