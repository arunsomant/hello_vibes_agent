import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/services/oem_permission_service.dart';
import '../widgets/index.dart';
import 'auth_controller.dart';

class ConfigurationController {
  final authController = Get.find<AuthController>();
  final _oemPermissionService = OemPermissionService();

  Future<bool> checkDeviceConfigurations() async {
    final permissionsGranted = await _checkPermissions();
    if (!permissionsGranted) {
      _showToast('Please grant all permissions to proceed');
      //openSettings();
    }

    // Check battery optimization on first launch
    if (Platform.isAndroid) {
      await _checkBatteryOptimization();
    }

    return permissionsGranted;
  }

  void openSettings() {
    openAppSettings();
  }

  /// Check and request battery optimization exemption for reliable background execution
  Future<void> _checkBatteryOptimization() async {
    final status = await _oemPermissionService.checkBackgroundPermissions();
    if (!status.batteryOptimizationDisabled) {
      final granted =
          await _oemPermissionService.requestBatteryOptimizationExemption();
      if (!granted) {
        // Show guide for OEM-specific settings
        await _oemPermissionService.showBackgroundPermissionGuide();
      }
    }
  }

  /// Open OEM autostart settings if available
  Future<void> openAutoStartSettings() async {
    final opened = await _oemPermissionService.openAutoStartSettings();
    if (!opened) {
      _showToast('Autostart settings not available on this device');
    }
  }

  /// Request all call-related permissions with OEM handling
  Future<bool> requestCallPermissions() async {
    return await _oemPermissionService.requestAllCallPermissions();
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

    // Request notification permission (Android 13+)
    if (Platform.isAndroid) {
      status = await Permission.notification.request();
      if (status.isPermanentlyDenied) {
        debugPrint('Notification Permission disabled');
        allPermissionsGranted = false;
      }
    }

    return allPermissionsGranted;
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }
}
