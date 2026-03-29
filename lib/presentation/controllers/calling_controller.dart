import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/services/livekit_service.dart';
import '../../data/models/call.dart';
import '../../data/models/user.dart';
import '../../data/repositories/call_repository.dart';
import '../widgets/index.dart';
import 'landing_controller.dart';

class CallingController extends GetxController {
  final CallRepository callRepository;

  CallingController({required this.callRepository});

  final user = User().obs;

  final callStatus = CallStatus.none.obs;

  String uuid = '';

  Call call = Call();

  CallType callType = CallType.none;

  final duration = 0.obs;

  Timer? _timer;

  final busyCall = false.obs;

  final DraggableScrollableController bottomSheetController =
      DraggableScrollableController();
  late final bottomSheetSize = (bottomSheetMaximumHeight / Get.height).obs;
  late final bottomSheetMaximumSize =
      (bottomSheetMaximumHeight / Get.height).obs;
  final double bottomSheetInitialSize = 0.04;
  final double bottomSheetMaximumHeight = 140.0;
  Timer? _hideTimer;
  bool _isCallControlsVisible = true;
  final loudSpeakerOn = false.obs;
  final micOn = true.obs;
  final LiveKitService liveKitService = LiveKitService.initialize();

  Room? get room => liveKitService.room;
  EventsListener<RoomEvent>? _roomListener;
  Participant? participant;

  String livekitUrl = '';
  String livekitToken = '';

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is CallingArguments) {
      user(args.user);
      uuid = args.uuid;
      callType = args.callType;
      _checkConfigurations();
    } else {
      throw ArgumentError(
        'Expected argument of type CallingArguments, but got ${args.runtimeType}',
      );
    }
    bottomSheetController.addListener(() {
      _isCallControlsVisible =
          bottomSheetController.size > bottomSheetInitialSize;
      bottomSheetSize(bottomSheetController.size);
    });
    _startHideTimer();
    super.onInit();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _hideTimer?.cancel();
    _disconnectLiveKit();
    _roomListener?.dispose();
    super.onClose();
  }

  void _startIncrementingDuration() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      duration.value++;
    });
  }

  void _showControls() {
    if (bottomSheetController.isAttached) {
      bottomSheetController.animateTo(
        bottomSheetMaximumSize.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      _startHideTimer();
    }
  }

  void _startHideTimer() {
    _cancelHideTimer();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      _toggleControls();
    });
  }

  void _toggleControls() {
    if (_isCallControlsVisible) {
      _hideControls();
    } else {
      _showControls();
    }
  }

  void _cancelHideTimer() {
    _hideTimer?.cancel();
  }

  void _hideControls() {
    if (bottomSheetController.isAttached) {
      bottomSheetController.animateTo(
        bottomSheetInitialSize,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
      _cancelHideTimer();
    }
  }

  void onScreenTap() {
    _toggleControls();
  }

  void onVolumeTap() {
    _startHideTimer();
    loudSpeakerOn.toggle();
    liveKitService.setSpeakerphoneOn(loudSpeakerOn.value);
  }

  void onCallEndTap() {
    _disconnectLiveKit();
  }

  void onMicTap() {
    _startHideTimer();
    micOn.toggle();
    liveKitService.setMicEnabled(micOn.value);
  }

  void _checkConfigurations() async {
    final permissionsGranted = await _checkPermissions();
    if (!permissionsGranted) {
      _showToast('Please grant all permissions to proceed with the call');
      Get.back();
      openAppSettings();
    } else {
      _acceptCall(uuid: uuid);
    }
  }

  void _acceptCall({required String uuid}) async {
    try {
      busyCall(true);
      callStatus(CallStatus.initiated);
      final response = await callRepository.acceptCall(uuid: uuid);
      if (response.success) {
        callStatus(CallStatus.ringing);
        livekitUrl = response.livekitUrl;
        livekitToken = response.token;
        call = response.call;
        _initLiveKit();
      } else {
        callStatus(CallStatus.ended);
        _disconnectLiveKit();
        _delayedBack();
        _showToast(response.message);
      }
    } catch (_) {
      callStatus(CallStatus.ended);
      _delayedBack();
      _showToast('Failed to create call');
    } finally {
      busyCall(false);
    }
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

  Future<void> _initLiveKit() async {
    try {
      if (room != null) {
        _roomListener = room!.createListener();
        _listenToRoomEvents();
        await liveKitService.connect(livekitUrl, livekitToken);
        final videoCall = callType == CallType.video;
        loudSpeakerOn(videoCall);
        liveKitService.setSpeakerphoneOn(videoCall);
        _startCall();
      }
    } catch (e) {
      _showToast('Failed to initialize call');
    }
  }

  void _endCall() async {
    try {
      final response = await callRepository.endCall(call: call);
      if (response.success) {
        Get.back();
        if (Get.isRegistered<LandingController>() && duration.value > 0) {
          Get.find<LandingController>().askForCallingExperience(
            call.participant,
          );
        }
      } else {
        _showToast(response.message);
      }
    } catch (_) {
      _showToast('Failed to end call');
    } finally {}
  }

  void _startCall() async {
    try {
      final response = await callRepository.startCall(call: call);
      if (!response.success) {
        _showToast('Failed to connect call');
        _disconnectLiveKit();
        _delayedBack();
      } else {
        callStatus(CallStatus.agentJoined);
      }
    } catch (_) {
      _showToast('Failed to end call');
    } finally {}
  }

  void _disconnectLiveKit() async {
    await liveKitService.disconnect();
  }

  void _delayedBack() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      Get.back();
    });
  }

  void _listenToRoomEvents() {
    _roomListener?.on<RoomDisconnectedEvent>((event) {
      callStatus(CallStatus.ended);
      print('LIVEKIT_EVENT - RoomDisconnectedEvent: ${event.reason}');
      _roomListener?.dispose();
      _endCall();
    });

    _roomListener?.on<RoomConnectedEvent>((event) {
      callStatus(CallStatus.agentJoined);
      _startIncrementingDuration();
      print('LIVEKIT_EVENT - RoomConnectedEvent: ${event.room.name}');
    });

    /*_roomListener?.on<ParticipantConnectedEvent>((event) {
      _startIncrementingDuration();
      print('LIVEKIT_EVENT - ParticipantConnectedEvent: ${event.participant.identity}');
      callStatus(CallStatus.agentJoined);
      participant = event.participant;
    });*/

    _roomListener?.on<ParticipantDisconnectedEvent>((event) {
      participant = null;
      print(
        'LIVEKIT_EVENT - ParticipantDisconnectedEvent: ${event.participant.identity}',
      );
      callStatus(CallStatus.ended);
      _disconnectLiveKit();
    });
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }
}
