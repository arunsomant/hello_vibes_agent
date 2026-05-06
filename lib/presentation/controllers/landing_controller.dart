import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';

import '../../core/services/callkit_service.dart';
import '../../core/services/firebase_message_service.dart';
import '../../core/services/websocket_service.dart';
import '../../data/models/call.dart';
import '../../data/models/user.dart';
import '../../data/repositories/call_repository.dart';
import '../../data/repositories/firebase_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../pages/landing/welcome_dialog.dart';
import '../pages/rating/rating_dialog.dart';
import '../routes/app_routes.dart';
import '../widgets/index.dart';
import 'auth_controller.dart';
import 'configuration_controller.dart';

class LandingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final UserRepository userRepository;
  final FirebaseRepository firebaseRepository;
  final CallRepository callRepository;

  LandingController({
    required this.userRepository,
    required this.firebaseRepository,
    required this.callRepository,
  });

  User get user => Get.find<AuthController>().user.value;

  late TabController tabController = TabController(length: 3, vsync: this);

  final activeTabIndex = 0.obs;

  var showBottomBar = true.obs;

  double scrollPosition = 0;

  @override
  void onInit() {
    tabController.addListener(() {
      activeTabIndex(tabController.index);
    });
    _updateFirebaseToken();
    checkForPendingReview();
    super.onInit();
  }

  @override
  void onReady() {
    _showWelcomeDialog();
    _checkForActiveCalls();
    Get.find<WebSocketService>().init();
    super.onReady();
  }

  @override
  void dispose() {
    Get.find<WebSocketService>().dispose();
    super.dispose();
  }

  void _checkForActiveCalls() async {
    try {
      await Future.delayed(Duration(microseconds: 500));
      var currentCall = await _getCurrentCall();
      if (currentCall != null &&
          (currentCall['accepted'] == true ||
              currentCall['isAccepted'] == true ||
              currentCall['isCallConnected'] == true)) {
        if (currentCall != null) {
          final call = AlertNotification.fromMap(Map<String, dynamic>.from(currentCall['extra']));
          final uuid = call.uuid;
          final customerName = call.customerName;
          if (call.callType == CallType.video) {
            _navigateToVideoCalling(uuid, customerName);
          } else {
            _navigateToVoiceCalling(uuid, customerName);
          }
        }
      }
    } catch (e) {
      debugPrint('Exception while checking active calls: $e');
    }
  }

  Future<dynamic> _getCurrentCall() async {
    try {
      final List<dynamic> calls = await FlutterCallkitIncoming.activeCalls();
      if (calls.isNotEmpty) {
        return calls[0];
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Exception while fetching active calls: $e');
    }
  }

  void _navigateToVoiceCalling(dynamic uuid, dynamic customerName) {
    Get.toNamed(
      AppRoutes.voiceCalling,
      arguments: CallingArguments(
        uuid: uuid,
        user: User(name: customerName ?? 'Unknown Caller'),
        callType: CallType.audio,
      ),
    );
  }

  void _navigateToVideoCalling(dynamic uuid, dynamic customerName) {
    Get.toNamed(
      AppRoutes.videoCalling,
      arguments: CallingArguments(
        uuid: uuid,
        user: User(name: customerName ?? 'Unknown Caller'),
        callType: CallType.video,
      ),
    );
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axisDirection == AxisDirection.down ||
        notification.metrics.axisDirection == AxisDirection.up) {
      final double currentScrollPosition = notification.metrics.pixels;
      if ((currentScrollPosition > scrollPosition + 10) &&
          showBottomBar.isTrue) {
        showBottomBar(false);
      } else if ((currentScrollPosition < scrollPosition) &&
          showBottomBar.isFalse) {
        showBottomBar(true);
      }
      scrollPosition = currentScrollPosition;
    }
    return false;
  }

  void _updateFirebaseToken() async {
    try {
      bool tokenSaved = await firebaseRepository.getDeviceDetailsAdded();
      if (!tokenSaved) {
        final token = await FirebaseMessageService().getToken();
        final String? voIPToken = await CallkitService().getVoIPToken();
        String deviceType = 'Unknown';
        if (GetPlatform.isAndroid) {
          deviceType = 'android';
        } else if (GetPlatform.isIOS) {
          deviceType = 'ios';
        }
        if (token != null && token.isNotEmpty) {
          var response = await firebaseRepository.updateFirebaseToken(
            firebaseToken: token,
            voIPToken: voIPToken ?? '',
            deviceType: deviceType,
          );
          firebaseRepository.saveDeviceDetailsAdded(response.success);
        }
      }
    } catch (_) {}
  }

  void onTabClicked(int index) {
    tabController.animateTo(index);
  }

  void checkForPendingReview() async {
    try {
      final call = await callRepository.getCallDetails();
      if (call.uuid.isNotEmpty) {
        askForCallingExperience(call);
      }
    } catch (_) {}
  }

  void askForCallingExperience(Call call) {
    AppDialog.showBottomSheet(
      isDismissible: false,
      child: RatingDialog(),
      arguments: RatingDialogArguments(call: call),
    );
  }

  void onOnlineStatusChanged(bool isOnline) async {
    final onlineStatus = user.isOnline;
    _onlineStatusChange(isOnline, user);
    bool permissionsGranted = true;
    if (isOnline) {
      final configurationController = Get.find<ConfigurationController>();
      permissionsGranted = await configurationController
          .checkDeviceConfigurations();
      if (!permissionsGranted) {
        configurationController.openSettings();
      }
    }
    if (permissionsGranted) {
      try {
        final response = await userRepository.onlineStatusUpdate(user);
        if (!response.success) {
          _onlineStatusChange(onlineStatus, user);
          _showToast(response.message);
        }
      } catch (_) {
        _onlineStatusChange(onlineStatus, user);
      }
    } else {
      _onlineStatusChange(onlineStatus, user);
    }
  }

  void _onlineStatusChange(bool isOnline, User user) {
    Get.find<AuthController>().user(user.copyWith(isOnline: isOnline));
  }

  void _showWelcomeDialog() async {
    if (!await userRepository.getWelcomeDialogShown()) {
      AppDialog.showDialog(
        isDismissible: false,
        child: WelcomeDialog(
          onIAgreePressed: () {
            _onWelcomeDialogIAgreePressed();
            Get.back();
          },
        ),
      );
    }
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }

  void _onWelcomeDialogIAgreePressed() {
    userRepository.saveWelcomeDialogShown(true);
  }
}
