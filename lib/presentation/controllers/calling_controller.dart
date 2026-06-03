import 'dart:async';

import 'package:flutter/material.dart' hide ConnectionState;
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/services/callkit_service.dart';
import '../../core/services/livekit_service.dart';
import '../../core/services/lock_screen_service.dart';
import '../../data/models/call.dart';
import '../../data/models/user.dart';
import '../../data/repositories/call_repository.dart';
import '../routes/app_routes.dart';
import '../widgets/index.dart';
import 'calls_controller.dart';
import 'configuration_controller.dart';
import 'landing_controller.dart';
import 'transactions_controller.dart';

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
  final CallkitService _callkitService = CallkitService();

  final participantVideoEnabled = false.obs;

  final participantAudioEnabled = false.obs;

  bool isClientInitiateEndCall = false;

  bool _isDismissingCallkitProgrammatically = false;

  bool endCallBusy = false;

  bool _callTerminated = false;

  @override
  void onInit() {
    // Enable showing over lock screen for calling
    debugPrint('CallingController.onInit: Enabling lock screen');
    LockScreenService().enableShowOnLockScreen();

    final args = Get.arguments;
    if (args is CallingArguments) {
      user(args.user);
      uuid = args.uuid;
      callType = args.callType;
      // Default will be set after checking audio devices in _setDefaultAudioOutput
      loudSpeakerOn(false);
      if (callType == CallType.video) {
        WakelockPlus.enable();
      }
      _checkConfigurations();
    } else {
      throw ArgumentError(
        'Expected argument of type CallingArguments, but got ${args.runtimeType}',
      );
    }
    LockScreenService().enableShowOnLockScreen();
    _callkitService.initCallkitListeners(
      onCallEnd: (callData) {
        if (_isDismissingCallkitProgrammatically) return;
        onCallEndTap();
      },
    );
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
    // Disable showing over lock screen when leaving calling screen
    debugPrint('CallingController.onClose: Disabling lock screen');
    LockScreenService().disableShowOnLockScreen();
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _hideTimer?.cancel();
    _dismissCallNotification(isProgrammatically: false);
    _roomListener?.dispose();
    liveKitService.dispose();
    WakelockPlus.disable();
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
    if (callType == CallType.video) {
      _hideTimer = Timer(const Duration(seconds: 3), () {
        _toggleControls();
      });
    }
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
    isClientInitiateEndCall = true;
    callEnd();
  }

  void callEnd({bool fromNotification = false}) {
    if (_roomListener == null ||
        _roomListener!.isDisposed ||
        room == null ||
        room?.connectionState == ConnectionState.disconnected) {
      _endCall();
    } else {
      _disconnectLiveKit();
    }
    _dismissCallNotification(isProgrammatically: fromNotification);
  }

  void callForceEnd() async {
    if (room != null &&
        room?.connectionState == ConnectionState.disconnected &&
        callStatus.value != CallStatus.ended) {
      _showToast('Call disconnected');
      _dismissCallNotification(isProgrammatically: true);
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }
      if (Get.currentRoute == AppRoutes.videoCalling ||
          Get.currentRoute == AppRoutes.voiceCalling) {
        Get.back();
      }
      _afterCallEnded();
    }
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
    final configurationController = Get.find<ConfigurationController>();
    final permissionsGranted = await configurationController
        .checkDeviceConfigurations();
    if (!permissionsGranted) {
      Get.back();
    } else {
      _acceptCall(uuid: uuid);
    }
  }

  /// Sets the default audio output for the call.
  /// For video calls: if an external device (Bluetooth/headset) is connected,
  /// route audio to that device (loudspeaker off). Otherwise, enable loudspeaker.
  /// For audio calls: always use earpiece unless external device is connected.
  Future<void> _setDefaultAudioOutput() async {
    if (callType == CallType.video) {
      final hasExternalDevice = await liveKitService
          .isExternalAudioDeviceConnected();
      if (hasExternalDevice) {
        // External device connected — don't force loudspeaker
        loudSpeakerOn(false);
        liveKitService.setSpeakerphoneOn(false);
      } else {
        // No external device — enable loudspeaker for video call
        loudSpeakerOn(true);
        liveKitService.setSpeakerphoneOn(true);
      }
    } else {
      // Audio call — use earpiece by default
      loudSpeakerOn(false);
      liveKitService.setSpeakerphoneOn(false);
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
        _callTerminated = false;
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
        await _setDefaultAudioOutput();
        liveKitService.setMicEnabled(micOn.value);
        if (videoCall) {
          liveKitService.setVideoEnabled(videoOn.value);
        }
        _startCall();
      }
    } catch (e) {
      _showToast('Failed to initialize call');
    }
  }

  void _endCall() async {
    if (endCallBusy || _callTerminated) return;
    endCallBusy = true;
    try {
      final response = await callRepository.endCall(
        call: call,
        isClientInitiateEndCall: isClientInitiateEndCall,
      );
      if (response.success || !_callTerminated) {
        _callTerminated = true;
        if (Get.isBottomSheetOpen == true) {
          Get.back();
        }
        Get.back();
        _afterCallEnded();
      } else {
        _showToast(response.message);
      }
    } catch (_) {
      _showToast('Failed to end call');
    } finally {
      endCallBusy = false;
    }
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

  void _dismissCallNotification({required bool isProgrammatically}) {
    _isDismissingCallkitProgrammatically = isProgrammatically;
    _callkitService.dismissAllCallNotification();
  }

  void _delayedBack() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }
      Get.back();
    });
  }

  void _listenToRoomEvents() {
    _roomListener?.on<RoomDisconnectedEvent>((event) {
      callStatus(CallStatus.ended);
      debugPrint('LIVEKIT_EVENT - RoomDisconnectedEvent: ${event.reason}');
      if (!isClientInitiateEndCall) {
        _dismissCallNotification(isProgrammatically: true);
      }
      _endCall();
      _roomListener?.dispose();
      liveKitService.dispose();
    });

    _roomListener?.on<RoomConnectedEvent>((event) {
      callStatus(CallStatus.agentJoined);
      _startIncrementingDuration();
      debugPrint('LIVEKIT_EVENT - RoomConnectedEvent: ${event.room.name}');
      localParticipant(event.room.localParticipant);
      if (event.room.remoteParticipants.isNotEmpty) {
        participant(event.room.remoteParticipants[0]);

        // 🔥 FIX: sync initial track states
        if (participant.value != null) {
          _syncParticipantTracks(participant.value!);
        }
      }
      _saveCallDetails();
    });
    _roomListener?.on<LocalTrackPublishedEvent>((event) {
      /*if (event.publication.kind == TrackType.AUDIO) {
        micOn(true);
      } else if (event.publication.kind == TrackType.VIDEO) {
        videoOn(true);
      }*/
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
      debugPrint(
        'LIVEKIT_EVENT - ParticipantDisconnectedEvent: ${event.participant.identity}',
      );
      if (event.participant is! LocalParticipant) {
        callStatus(CallStatus.ended);
        _disconnectLiveKit();

        _dismissCallNotification(isProgrammatically: true);
      }
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
        if (participant.value != null) {
          _syncParticipantTracks(participant.value!);
        }
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
      await callRepository.saveCallDetails(call);
    } catch (_) {}
  }

  void _showToast(String message) {
    AppDialog.showToast(message);
  }

  void _afterCallEnded() {
    if (Get.isRegistered<LandingController>() && duration.value > 0) {
      Get.find<LandingController>().checkForPendingReview();
    }
    if (Get.isRegistered<CallsController>()) {
      Future.delayed(const Duration(seconds: 4)).then((_) {
        Get.find<CallsController>().onRefresh();
      });
    }
    if (Get.isRegistered<TransactionsController>()) {
      Future.delayed(const Duration(seconds: 4)).then((_) {
        Get.find<TransactionsController>().onRefreshPressed();
      });
    }
  }

  void _syncParticipantTracks(RemoteParticipant p) {
    final videoPub = p.videoTrackPublications.firstOrNull;
    final audioPub = p.audioTrackPublications.firstOrNull;

    if (callType == CallType.video) {
      participantVideoEnabled(
        videoPub != null && videoPub.subscribed && videoPub.muted != true,
      );
    }

    participantAudioEnabled(
      audioPub != null && audioPub.subscribed && audioPub.muted != true,
    );
  }
}
