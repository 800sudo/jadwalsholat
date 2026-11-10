import 'dart:async';

import 'package:flutter/services.dart';

class PlatformBeepPlayer {
  static const MethodChannel _channel = MethodChannel(
    'com.jadwalsholat.tv/beep',
  );

  static void initUserInteraction() {}

  static Future<void> playBeep({
    int frequency = 850,
    int durationMs = 2000,
  }) async {
    try {
      final res = await _channel.invokeMethod<bool>('playBeep', {
        'frequency': frequency,
        'durationMs': durationMs,
      });
      if (res != true) {
        await SystemSound.play(SystemSoundType.alert);
      }
    } catch (_) {
      try {
        await SystemSound.play(SystemSoundType.alert);
      } catch (_) {}
    }
  }
}
