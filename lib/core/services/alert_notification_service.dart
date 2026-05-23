import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/call.dart';
import '../../data/repositories/call_repository.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/calling_controller.dart';
import '../../presentation/widgets/app_dialog.dart';
import 'callkit_service.dart';

/// Centralized service for handling AlertNotification from both
/// NotificationService (FCM) and WebSocketService.
class AlertNotificationService {
  // Singleton pattern
  static final AlertNotificationService _instance =
      AlertNotificationService._internal();

  factory AlertNotificationService() => _instance;

  AlertNotificationService._internal();

  /// Handles AlertNotification from both NotificationService (FCM) and WebSocketService.
  /// Centralized logic to avoid duplication and ensure consistent handling.
  Future<void> handleAlertNotification(AlertNotification alert) async {
    if (alert.notificationType == NotificationType.incomingCall) {
      try {
        await CallRepository.instance().markCallRinging(
          call: Call(uuid: alert.uuid),
        );
      } catch (e) {
        debugPrint(
          'AlertNotificationService: Failed to mark call ringing - $e',
        );
      }
      // showCallNotification returns false if already shown (deduplication)
      await CallkitService().showCallNotification(alert);
    }

    if (alert.notificationType == NotificationType.callEnded) {
      if (alert.reason == AlertReason.insufficientBalance) {
        AppDialog.showToast(
          'Call ended due to insufficient balance in customer account',
        );
      } else if (alert.reason == AlertReason.customerEnded) {
        AppDialog.showToast('Call ended by customer');
      }
      if (Get.isRegistered<CallingController>()) {
        Get.find<CallingController>().callEnd(fromNotification: true);
      }
    }

    if (alert.notificationType == NotificationType.agentOnlineStatusChange) {
      if (Get.isRegistered<AuthController>()) {
        Get.find<AuthController>().getUserProfile();
      }
    }

    if (alert.notificationType == NotificationType.withdrawalStatusChanged ||
        alert.notificationType == NotificationType.agentAccountStatusChanged) {
      if (Get.isRegistered<AuthController>()) {
        Get.find<AuthController>().getUserProfile();
      }
    }
  }
}
