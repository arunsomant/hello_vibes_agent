import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/services/callkit_service.dart';
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
  final videoOn = true.obs;
  final LiveKitService liveKitService = LiveKitService.initialize();

  Room? get room => liveKitService.room;
  EventsListener<RoomEvent>? _roomListener;
  Rx<RemoteParticipant?> participant = Rx<RemoteParticipant?>(null);
  Rx<LocalParticipant?> localParticipant = Rx<LocalParticipant?>(null);

  String livekitUrl = '';
  String livekitToken = '';

  final participantVideoEnabled = false.obs;

  final participantAudioEnabled = false.obs;

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
    liveKitService.dispose();
    CallkitService().dismissAllCallNotification();
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

  void onVideoTap() {
    _startHideTimer();
    videoOn.toggle();
    liveKitService.setVideoEnabled(videoOn.value);
  }

  void onFlipCameraTap() {
    liveKitService.flipCamera();
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
        final videoCall = callType == CallType.video;
        await liveKitService.connect(
          livekitUrl,
          livekitToken,
          enableVideo: videoCall,
        );
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
      await CallkitService().dismissCallNotification(
        CallAlertNotification(
          uuid: call.uuid,
          customerName: call.participant.name,
        ),
      );
      final response = await callRepository.endCall(call: call);
      if (response.success) {
        Get.back();
        if (Get.isRegistered<LandingController>() && duration.value > 0) {
          Get.find<LandingController>().checkForPendingReview();
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
      debugPrint('LIVEKIT_EVENT - RoomDisconnectedEvent: ${event.reason}');
      _endCall();
      _roomListener?.dispose();
      liveKitService.dispose();
    });

    _roomListener?.on<RoomConnectedEvent>((event) {
      callStatus(CallStatus.agentJoined);
      _startIncrementingDuration();
      print('LIVEKIT_EVENT - RoomConnectedEvent: ${event.room.name}');
      localParticipant(event.room.localParticipant);
      if (event.room.remoteParticipants.isNotEmpty) {
        participant(event.room.remoteParticipants[0]);
      }
      _saveCallDetails();
    });
    _roomListener?.on<LocalTrackPublishedEvent>((event) {
      if (event.publication.kind == TrackType.AUDIO) {
        micOn(true);
      } else if (event.publication.kind == TrackType.VIDEO) {
        videoOn(true);
      }
      localParticipant(event.participant);
      localParticipant.refresh();
    });
    _roomListener?.on<TrackPublishedEvent>((event) {
      debugPrint(
        'LIVEKIT_EVENT - TrackPublishedEvent:  ${event.publication.kind}',
      );
      if (event.publication.kind == TrackType.VIDEO) {
        participantVideoEnabled(
          event.participant.videoTrackPublications.firstOrNull?.muted != true,
        );
      }
      participantAudioEnabled(
        event.participant.audioTrackPublications.firstOrNull?.muted != true,
      );
    });

    /*_roomListener?.on<ParticipantConnectedEvent>((event) {
      _startIncrementingDuration();
      print('LIVEKIT_EVENT - ParticipantConnectedEvent: ${event.participant.identity}');
      callStatus(CallStatus.agentJoined);
      participant = event.participant;
    });*/

    _roomListener?.on<ParticipantDisconnectedEvent>((event) {
      participant(null);
      print(
        'LIVEKIT_EVENT - ParticipantDisconnectedEvent: ${event.participant.identity}',
      );
      callStatus(CallStatus.ended);
      _disconnectLiveKit();
    });
    _roomListener?.on<TrackMutedEvent>((event) {
      if (event.participant is RemoteParticipant) {
        if (event.publication.kind == TrackType.AUDIO) {
          participantAudioEnabled(false);
        } else if (event.publication.kind == TrackType.VIDEO) {
          participantVideoEnabled(false);
        }
        _showToast(
          'Remote user turned ${event.publication.kind == TrackType.AUDIO ? 'audio' : 'video'} off',
        );
      }
    });
    _roomListener?.on<TrackSubscribedEvent>((event) {
      debugPrint(
        'LIVEKIT_EVENT - TrackSubscribedEvent: ${event.publication.kind}',
      );
      if (event.publication.kind == TrackType.VIDEO) {
        participant(event.participant);
        update();
      }
    });
    _roomListener?.on<TrackUnmutedEvent>((event) {
      if (event.participant is RemoteParticipant) {
        if (event.publication.kind == TrackType.AUDIO) {
          participantAudioEnabled(true);
        } else if (event.publication.kind == TrackType.VIDEO) {
          participantVideoEnabled(true);
        }
        _showToast(
          'Remote user turned ${event.publication.kind == TrackType.AUDIO ? 'audio' : 'video'} on',
        );
      }
    });
  }

  void _saveCallDetails() async {
    try {
      print('EEEEEEE1');
      await callRepository.saveCallDetails(call);
    } catch (e) {
      print('EEEEEEE');
      print(e);
    }
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }
}
