import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart';

class LiveKitService {
  LiveKitService._(this._room);

  static LiveKitService initialize() {
    final service = LiveKitService._(Room());
    return service;
  }

  Room? _room;

  Room? get room => _room;

  CameraPosition _cameraPosition = CameraPosition.front;

  Future<void> connect(
    String url,
    String token, {
    bool enableVideo = false,
  }) async {
    await room?.prepareConnection(url, token);
    await _room?.connect(url, token);
    await room?.localParticipant?.setMicrophoneEnabled(true);
    if (enableVideo) {
      try {
        LocalVideoTrack localVideo = await LocalVideoTrack.createCameraTrack(
          const CameraCaptureOptions(cameraPosition: CameraPosition.front),
        );
        await room?.localParticipant?.publishVideoTrack(localVideo);
      } catch (_) {}
    }
  }

  Future<void> disconnect() async {
    try {
      if (room != null) {
        await room?.localParticipant?.unpublishAllTracks();
        await room?.disconnect();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> dispose() async {
    try {
      if (room != null) {
        await room?.dispose();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    _room = null;
  }

  Future<bool> tryReconnect(
    String url,
    String token, {
    int maxAttempts = 5,
  }) async {
    if (_room == null) return false;
    int attempt = 0;
    int delayMs = 500;
    while (attempt < maxAttempts) {
      attempt += 1;
      try {
        await Future.delayed(Duration(milliseconds: delayMs));
        await _room!.connect(url, token);
        return true;
      } catch (_) {
        delayMs *= 2;
      }
    }
    return false;
  }

  Future<void> setMicEnabled(bool enabled) async {
    if (_room?.localParticipant != null) {
      try {
        await _room!.localParticipant!.setMicrophoneEnabled(enabled);
      } catch (error) {
        debugPrint('Could not publish audio: $error');
      }
    }
  }

  Future<void> setVideoEnabled(bool enabled) async {
    if (_room?.localParticipant != null) {
      try {
        await _room!.localParticipant!.setCameraEnabled(enabled);
      } catch (error) {
        debugPrint('Could not publish video: $error');
      }
    }
  }

  Future<void> setSpeakerphoneOn(bool on) async {
    try {
      await room!.setSpeakerOn(on, forceSpeakerOutput: on);
    } catch (e) {
      debugPrint('Could not set speaker: $e');
    }
  }

  /// Returns true if an external audio output device (Bluetooth, wired headset) is connected.
  Future<bool> isExternalAudioDeviceConnected() async {
    try {
      final devices = await Hardware.instance.enumerateDevices();
      final audioOutputDevices = devices.where((d) => d.kind == 'audiooutput');
      // Check if any device is not the built-in earpiece or speaker
      return audioOutputDevices.any(
        (d) =>
            d.deviceId.toLowerCase().contains('bluetooth') ||
            d.label.toLowerCase().contains('bluetooth') ||
            d.label.toLowerCase().contains('headset') ||
            d.label.toLowerCase().contains('headphone') ||
            d.deviceId.toLowerCase().contains('wired'),
      );
    } catch (e) {
      debugPrint('Could not enumerate audio devices: $e');
      return false;
    }
  }

  Future<void> startAudio() async {
    try {
      await room!.startAudio();
    } catch (e) {
      debugPrint('Could not start audio: $e');
    }
  }

  Future<void> flipCamera() async {
    final track =
        room?.localParticipant?.videoTrackPublications.firstOrNull?.track;
    if (track is LocalVideoTrack) {
      try {
        CameraPosition newPosition = _cameraPosition == CameraPosition.front
            ? CameraPosition.back
            : CameraPosition.front;
        await track.restartTrack(
          CameraCaptureOptions(cameraPosition: newPosition),
        );
        _cameraPosition = newPosition;
      } catch (e) {
        debugPrint('Failed to flip camera: $e');
      }
    }
  }

  Future initializeAudioSettings() async {
    if (WebRTC.platformIsAndroid) {
      await WebRTC.initialize(
        options: {
          'androidAudioConfiguration': AndroidAudioConfiguration.communication
              .toMap(),
        },
      );
      Helper.setAndroidAudioConfiguration(
        AndroidAudioConfiguration.communication,
      );
    } else if (WebRTC.platformIsIOS) {
      //await WebRTC.initialize();
      await Helper.setAppleAudioConfiguration(
        AppleAudioConfiguration(
          appleAudioCategory: AppleAudioCategory.playAndRecord,
          appleAudioMode: AppleAudioMode.voiceChat,
          appleAudioCategoryOptions: {
            AppleAudioCategoryOption.allowBluetooth,
            AppleAudioCategoryOption.defaultToSpeaker,
          },
        ),
      );
    }
  }
}
