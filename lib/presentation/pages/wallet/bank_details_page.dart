import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingle_talk_agent/core/theme/app_spacings.dart';

import '../../../core/config/app_assets_mapper.dart';
import '../../../core/theme/app_sizes.dart';
import '../../controllers/bank_details_controller.dart';
import '../../widgets/index.dart';

class BankDetailsPage extends GetView<BankDetailsController> {
  const BankDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppText('Bank Account Details')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(AppSpacings.s16),
                children: [
                  ShakeView(
                    controller: controller.shakeControllerName,
                    child: AppInputText(
                      controller: controller.textEditingControllerName,
                      hintText: 'Enter Name Here',
                      showHintAsLabel: false,
                      label: 'Account Holder Name',
                      prefixIcon: SizedBox(
                        height: 24,
                        width: 24,
                        child: Center(
                          child: AppSvgAsset(AppAssetsMapper.icPerson),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: AppSpacings.s8),
                  ShakeView(
                    controller: controller.shakeControllerBankName,
                    child: AppInputText(
                      controller: controller.textEditingControllerBankName,
                      hintText: 'Enter Bank Name Here',
                      showHintAsLabel: false,
                      label: 'Bank Name',
                      prefixIcon: SizedBox(
                        height: 24,
                        width: 24,
                        child: Center(
                          child: AppSvgAsset(AppAssetsMapper.icBank),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: AppSpacings.s8),
                  ShakeView(
                    controller: controller.shakeControllerAccountNumber,
                    child: AppInputText(
                      controller: controller.textEditingControllerAccountNumber,
                      hintText: 'Enter Account Number Here',
                      showHintAsLabel: false,
                      label: 'Account Number',
                      keyboardType: TextInputType.number,
                      prefixIcon: SizedBox(
                        height: 24,
                        width: 24,
                        child: Center(
                          child: AppSvgAsset(AppAssetsMapper.icCard),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(height: AppSpacings.s8),
                  ShakeView(
                    controller: controller.shakeControllerIFSCCode,
                    child: AppInputText(
                      controller: controller.textEditingControllerIFSCCode,
                      hintText: 'Enter IFSC Code Here',
                      showHintAsLabel: false,
                      textCapitalization: TextCapitalization.characters,
                      label: 'IFSC Code',
                      prefixIcon: SizedBox(
                        height: 24,
                        width: 24,
                        child: Center(
                          child: AppSvgAsset(AppAssetsMapper.icDocument),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: AppSpacings.s16,
              ),
              child: AppButton(
                text: 'Save Bank Details',
                onPressed: controller.onSubmitBankDetailsPressed,
                height: AppSizes.appButtonHeightLarge,
              ),
            ),
            const SizedBox(height: AppSpacings.s16),
          ],
        ),
      ),
    );
  }
}
