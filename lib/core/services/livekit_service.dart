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

  Future<void> connect(
    String url,
    String token, {
    bool audioOnly = true,
  }) async {
    await room?.prepareConnection(url, token);
    await _room?.connect(url, token);
    await room?.localParticipant?.setMicrophoneEnabled(true);
  }

  Future<void> disconnect() async {
    try {
      if (room != null) {
        await room?.localParticipant?.unpublishAllTracks();
        await room?.disconnect();
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
        print('could not publish audio: $error');
      }
    }
  }

  Future<void> setSpeakerphoneOn(bool on) async {
    try {
      await room!.setSpeakerOn(on, forceSpeakerOutput: on);
    } catch (e) {
      print(e);
    }
  }

  Future<void> startAudio() async {
    try {
      await room!.startAudio();
    } catch (e) {
      print(e);
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
