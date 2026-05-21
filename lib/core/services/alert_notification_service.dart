import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingle_talk_agent/data/models/call.dart';
import 'package:mingle_talk_agent/data/repositories/call_repository.dart';
import 'package:mingle_talk_agent/presentation/controllers/auth_controller.dart';
import 'package:mingle_talk_agent/presentation/widgets/index.dart';

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
      await CallkitService().dismissCallNotification(alert);
    }

    if (alert.notificationType == NotificationType.agentOnlineStatusChange) {
      if (Get.isRegistered<AuthController>()) {
        Get.find<AuthController>().getUserProfile();
      }
    }

    if (alert.notificationType == NotificationType.withdrawalStatusChanged || alert.notificationType == NotificationType.agentAccountStatusChanged) {
      if (Get.isRegistered<AuthController>()) {
        Get.find<AuthController>().getUserProfile();
      }
    }
  }
}
