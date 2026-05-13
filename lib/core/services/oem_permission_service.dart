import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service to handle OEM-specific permissions for background execution,
/// battery optimization, and autostart for calling apps.
class OemPermissionService {
  static final OemPermissionService _instance =
      OemPermissionService._internal();
  factory OemPermissionService() => _instance;
  OemPermissionService._internal();

  /// Check and request all critical permissions for a calling app
  Future<bool> requestAllCallPermissions() async {
    final results = await [
      Permission.camera,
      Permission.microphone,
      Permission.notification,
      Permission.phone,
      Permission.bluetooth,
      Permission.bluetoothConnect,
    ].request();

    final allGranted = results.values.every(
      (status) => status.isGranted || status.isLimited,
    );

    if (Platform.isAndroid) {
      await requestBatteryOptimizationExemption();
    }

    return allGranted;
  }

  /// Request battery optimization exemption (critical for OEM devices like Xiaomi, Samsung, etc.)
  Future<bool> requestBatteryOptimizationExemption() async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.ignoreBatteryOptimizations.status;
    if (status.isGranted) return true;

    final result = await Permission.ignoreBatteryOptimizations.request();
    return result.isGranted;
  }

  /// Open OEM-specific autostart settings
  /// Returns true if opened, false if not supported
  Future<bool> openAutoStartSettings() async {
    if (!Platform.isAndroid) return false;

    final manufacturer = await _getDeviceManufacturer();
    final autoStartIntent = _getAutoStartIntent(manufacturer);

    if (autoStartIntent != null) {
      try {
        const platform = MethodChannel('com.mingletalk.agent/settings');
        final result = await platform.invokeMethod(
          'openAutoStart',
          {'intent': autoStartIntent},
        );
        return result == true;
      } catch (e) {
        debugPrint('Failed to open autostart settings: $e');
        return false;
      }
    }
    return false;
  }

  /// Open battery optimization settings for the app
  Future<void> openBatteryOptimizationSettings() async {
    if (Platform.isAndroid) {
      await openAppSettings();
    }
  }

  /// Show dialog guiding user to enable background permissions
  Future<void> showBackgroundPermissionGuide() async {
    final manufacturer = await _getDeviceManufacturer();
    final guide = _getOemGuide(manufacturer);

    Get.dialog(
      AlertDialog(
        title: const Text('Enable Background Running'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'To receive calls reliably, please enable the following:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(guide),
              const SizedBox(height: 16),
              const Text(
                'This ensures you won\'t miss any incoming calls.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Later'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<String> _getDeviceManufacturer() async {
    try {
      const platform = MethodChannel('com.mingletalk.agent/device_info');
      final manufacturer = await platform.invokeMethod('getManufacturer');
      return (manufacturer as String?)?.toLowerCase() ?? 'unknown';
    } catch (e) {
      return 'unknown';
    }
  }

  String? _getAutoStartIntent(String manufacturer) {
    final intents = {
      'xiaomi': 'com.miui.securitycenter/com.miui.permcenter.autostart.AutoStartManagementActivity',
      'redmi': 'com.miui.securitycenter/com.miui.permcenter.autostart.AutoStartManagementActivity',
      'oppo': 'com.coloros.safecenter/com.coloros.safecenter.permission.startup.StartupAppListActivity',
      'realme': 'com.coloros.safecenter/com.coloros.safecenter.permission.startup.StartupAppListActivity',
      'vivo': 'com.vivo.permissionmanager/com.vivo.permissionmanager.activity.BgStartUpManagerActivity',
      'oneplus': 'com.oneplus.security/com.oneplus.security.chainlaunch.view.ChainLaunchAppListActivity',
      'huawei': 'com.huawei.systemmanager/com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity',
      'honor': 'com.huawei.systemmanager/com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity',
      'samsung': 'com.samsung.android.lool/com.samsung.android.sm.battery.ui.BatteryActivity',
      'asus': 'com.asus.mobilemanager/com.asus.mobilemanager.autostart.AutoStartActivity',
      'letv': 'com.letv.android.letvsafe/com.letv.android.letvsafe.AutobootManageActivity',
      'meizu': 'com.meizu.safe/com.meizu.safe.permission.PermissionMainActivity',
      'tecno': 'com.transsion.phonemanager/com.transsion.phonemanager.permission.PermissionActivity',
      'infinix': 'com.transsion.phonemanager/com.transsion.phonemanager.permission.PermissionActivity',
    };
    return intents[manufacturer];
  }

  String _getOemGuide(String manufacturer) {
    final guides = {
      'xiaomi': '''
1. Go to Settings > Apps > Manage Apps > Mingle Talk Agent
2. Enable "Autostart"
3. Go to Battery Saver > No restrictions
4. In Security app > Permissions > Autostart, enable the app''',
      'redmi': '''
1. Go to Settings > Apps > Manage Apps > Mingle Talk Agent
2. Enable "Autostart"
3. Go to Battery Saver > No restrictions
4. In Security app > Permissions > Autostart, enable the app''',
      'oppo': '''
1. Go to Settings > App Management > App List > Mingle Talk Agent
2. Enable "Allow Auto Startup"
3. Go to Battery > Power saving exclusions > Add app
4. Enable "Allow background activity"''',
      'realme': '''
1. Go to Settings > App Management > App List > Mingle Talk Agent
2. Enable "Allow Auto Startup"
3. Go to Battery > Power saving exclusions > Add app''',
      'vivo': '''
1. Go to Settings > More Settings > Applications > Autostart
2. Enable Mingle Talk Agent
3. Go to Battery > Background power consumption > Don't restrict''',
      'oneplus': '''
1. Go to Settings > Apps > App Management > Mingle Talk Agent
2. Enable "Auto Launch"
3. Go to Battery > Battery Optimization > Don't optimize''',
      'huawei': '''
1. Go to Settings > Apps > Apps > Mingle Talk Agent
2. Enable "Auto-launch"
3. Go to Battery > App launch > Set to "Manage manually"
4. Enable all toggles (Auto-launch, Secondary launch, Run in background)''',
      'honor': '''
1. Go to Settings > Apps > Apps > Mingle Talk Agent
2. Enable "Auto-launch"
3. Go to Battery > App launch > Set to "Manage manually"
4. Enable all toggles''',
      'samsung': '''
1. Go to Settings > Apps > Mingle Talk Agent > Battery
2. Select "Unrestricted"
3. Go to Device Care > Battery > App power management
4. Add to "Apps that won't be put to sleep"''',
    };

    return guides[manufacturer] ??
        '''
1. Go to Settings > Apps > Mingle Talk Agent
2. Enable "Autostart" or "Auto-launch" if available
3. Go to Battery settings and disable optimization for this app
4. Allow background activity''';
  }

  /// Check if all background permissions are properly configured
  Future<BackgroundPermissionStatus> checkBackgroundPermissions() async {
    final camera = await Permission.camera.isGranted;
    final microphone = await Permission.microphone.isGranted;
    final notification = await Permission.notification.isGranted;

    bool batteryOptimized = true;
    if (Platform.isAndroid) {
      batteryOptimized =
          await Permission.ignoreBatteryOptimizations.isGranted;
    }

    return BackgroundPermissionStatus(
      cameraGranted: camera,
      microphoneGranted: microphone,
      notificationGranted: notification,
      batteryOptimizationDisabled: batteryOptimized,
      allGranted: camera && microphone && notification && batteryOptimized,
    );
  }
}

class BackgroundPermissionStatus {
  final bool cameraGranted;
  final bool microphoneGranted;
  final bool notificationGranted;
  final bool batteryOptimizationDisabled;
  final bool allGranted;

  BackgroundPermissionStatus({
    required this.cameraGranted,
    required this.microphoneGranted,
    required this.notificationGranted,
    required this.batteryOptimizationDisabled,
    required this.allGranted,
  });
}

