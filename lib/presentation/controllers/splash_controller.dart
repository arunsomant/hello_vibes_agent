import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/utils/app_launcher.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../widgets/app_dialog.dart';
import 'auth_controller.dart';

class SplashController extends GetxController {
  SplashController({
    required this.authRepository,
    required this.userRepository,
  });

  final AuthRepository authRepository;

  final UserRepository userRepository;

  final _authController = Get.find<AuthController>();

  @override
  void onInit() {
    _checkVersion();
    super.onInit();
  }

  void _checkVersion() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );
      await remoteConfig.fetchAndActivate();
      int versionMinimum = 0;
      int versionCurrent = 0;
      String updateUrl = '';
      bool underMaintenance = false;
      if (Platform.isAndroid) {
        versionMinimum = remoteConfig.getInt(
          'android_agent_app_minimum_version',
        );
        versionCurrent = remoteConfig.getInt(
          'android_agent_app_current_version',
        );
        updateUrl = remoteConfig.getString('android_agent_app_update_url');
        underMaintenance = remoteConfig.getBool(
          'android_agent_app_under_maintenance',
        );
      } else if (Platform.isIOS) {
        versionMinimum = remoteConfig.getInt('ios_agent_app_minimum_version');
        versionCurrent = remoteConfig.getInt('ios_agent_app_current_version');
        updateUrl = remoteConfig.getString('ios_agent_app_update_url');
        underMaintenance = remoteConfig.getBool(
          'ios_agent_app_under_maintenance',
        );
      }
      final skippedVersion = await userRepository.getSkippedVersionUpdate();
      final (_, appVersion) = await _authController.getVersionCode();

      if (underMaintenance && !kDebugMode) {
        AppDialog.showAlertDialog(
          isDismissible: false,
          caption: 'We\'re under maintenance',
          childSizeRatio: 0.32,
          title:
              'Please check back soon, we\'re working hard to bring you a better experience.',
          positiveText: 'Retry',
          positiveOnPressed: () {
            Get.back();
            _checkVersion();
          },
        );
        return;
      }
      if (appVersion < versionMinimum && !kDebugMode) {
        AppDialog.showAlertDialog(
          isDismissible: false,
          caption: 'Update required',
          childSizeRatio: 0.32,
          title:
              'You are using an old version of this app. Please update your app to continue.',
          positiveText: 'Update',
          positiveOnPressed: () {
            AppLauncher.openUrl(updateUrl);
          },
        );
      } else if (appVersion < versionCurrent &&
          skippedVersion < versionCurrent &&
          !kDebugMode) {
        AppDialog.showAlertDialog(
          isDismissible: false,
          caption: 'New version available',
          childSizeRatio: 0.32,
          title:
              'There is a new version available for download. Do you want to update to the latest version?',
          positiveText: 'Update',
          positiveOnPressed: () {
            AppLauncher.openUrl(updateUrl);
          },
          negativeOnPressed: () {
            userRepository.saveSkippedVersionUpdate(versionCurrent);
            Get.back();
            _gotoLanding();
          },
          negativeText: 'No Thanks',
        );
      } else {
        _gotoLandingWithDelay();
      }
    } catch (_) {
      AppDialog.showAlertDialog(
        isDismissible: false,
        caption: 'Network Error',
        childSizeRatio: 0.32,
        title:
            'A network error has occurred. Please make sure you are connected to the internet and try again.',
        positiveText: 'Retry',
        positiveOnPressed: () {
          Get.back();
          _checkVersion();
        },
      );
    }
  }

  void _gotoLandingWithDelay() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      _gotoLanding();
    });
  }

  void _gotoLanding() {
    _authController.gotoLandingPage();
  }
}
