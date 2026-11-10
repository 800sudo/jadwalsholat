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

  /// Memutar suara beep tunggal dengan durasi tertentu
  static Future<void> playSingleBeep({
    int frequency = 850,
    int durationMs = 2000,
  }) async {
    await PlatformBeepPlayer.playBeep(
      frequency: frequency,
      durationMs: durationMs,
    );
  }

  /// Memutar rangkaian suara beep peringatan:
  /// Default: 4 kali beep @ 2 detik (2000 ms), jeda 600 ms,
  /// lalu 1 kali beep panjang penutup @ 4 detik (4000 ms).
  static Future<void> playWarningBeepSequence({
    int count = 4,
    int initialDurationMs = 2000,
    int pauseMs = 600,
    int finalDurationMs = 4000,
  }) async {
    if (_isPlaying) return;
    _isPlaying = true;

    try {
      // 4 kali beep awal @ 2 detik dengan jeda 600 ms
      for (int i = 0; i < count; i++) {
        await PlatformBeepPlayer.playBeep(
          frequency: 850,
          durationMs: initialDurationMs,
        );
        await Future.delayed(
          Duration(milliseconds: initialDurationMs + pauseMs),
        );
      }

      // 1 kali beep penutup panjang @ 4 detik
      await PlatformBeepPlayer.playBeep(
        frequency: 850,
        durationMs: finalDurationMs,
      );
      await Future.delayed(Duration(milliseconds: finalDurationMs + 200));
    } finally {
      _isPlaying = false;
    }
  }

  /// Alias kompatibilitas
  static Future<void> playTripleBeep() => playWarningBeepSequence();
}
