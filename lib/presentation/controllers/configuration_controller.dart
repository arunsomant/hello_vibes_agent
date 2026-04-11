import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/index.dart';
import 'auth_controller.dart';

class ConfigurationController {
  final authController = Get.find<AuthController>();

  Future<bool> checkDeviceConfigurations() async {
    final permissionsGranted = await _checkPermissions();
    if (!permissionsGranted) {
      _showToast('Please grant all permissions to proceed');
      //openSettings();
    }
    return permissionsGranted;
  }

  void openSettings() {
    openAppSettings();
  }

  Future<bool> _checkPermissions() async {
    bool allPermissionsGranted = true;
    PermissionStatus status = await Permission.bluetooth.request();
    if (status.isPermanentlyDenied) {
      debugPrint('Bluetooth Permission disabled');
      allPermissionsGranted = false;
    }
    status = await Permission.bluetoothConnect.request();
    if (status.isPermanentlyDenied && lkPlatformIs(PlatformType.android)) {
      debugPrint('Bluetooth Connect Permission disabled');
      allPermissionsGranted = false;
    }
    status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      debugPrint('Camera Permission disabled');
      allPermissionsGranted = false;
    }
    status = await Permission.microphone.request();
    if (status.isPermanentlyDenied) {
      debugPrint('Microphone Permission disabled');
      allPermissionsGranted = false;
    }
    return allPermissionsGranted;
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }
}
