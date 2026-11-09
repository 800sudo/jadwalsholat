import 'dart:async';

import 'beep_player_stub.dart'
    if (dart.library.html) 'beep_player_web.dart'
    if (dart.library.io) 'beep_player_io.dart';

class BeepSoundHelper {
  BeepSoundHelper._();

  static bool _isPlaying = false;

  /// Mempersiapkan AudioContext saat interaksi user pertama kali (remote/tap)
  static void initUserInteraction() {
    PlatformBeepPlayer.initUserInteraction();
  }

  /// Memutar suara beep tunggal
  static Future<void> playSingleBeep({int durationMs = 180}) async {
    await PlatformBeepPlayer.playBeep(durationMs: durationMs);
  }

  /// Memutar suara beep 3 kali dengan jeda (BEEP - BEEP - BEEP)
  static Future<void> playTripleBeep() async {
    if (_isPlaying) return;
    _isPlaying = true;

    try {
      for (int i = 0; i < 3; i++) {
        await PlatformBeepPlayer.playBeep(durationMs: 180);
        if (i < 2) {
          await Future.delayed(const Duration(milliseconds: 300));
        }
      }
    } finally {
      _isPlaying = false;
    }
  }
}
