import 'dart:async';

import 'package:flutter/services.dart';

class PlatformBeepPlayer {
  static const MethodChannel _channel = MethodChannel(
    'com.jadwalsholat.tv/beep',
  );

  static void initUserInteraction() {}

  static Future<void> playBeep({
    int frequency = 950,
    int durationMs = 200,
  }) async {
    try {
      final res = await _channel.invokeMethod<bool>('playBeep', {
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
