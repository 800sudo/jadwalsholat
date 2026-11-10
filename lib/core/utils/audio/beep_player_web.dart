// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:js' as js;

class PlatformBeepPlayer {
  static void initUserInteraction() {
    try {
      js.context.callMethod('eval', [
        '''
        (function() {
          try {
            var ctx = window._appAudioCtx || new (window.AudioContext || window.webkitAudioContext)();
            window._appAudioCtx = ctx;
            if (ctx.state === 'suspended') { ctx.resume(); }
          } catch(e) {}
        })();
        '''
      ]);
    } catch (_) {}
  }

  static Future<void> playBeep({
    int frequency = 850,
    int durationMs = 2000,
  }) async {
    try {
      js.context.callMethod('eval', [
        '''
        (function() {
          try {
            var ctx = window._appAudioCtx || new (window.AudioContext || window.webkitAudioContext)();
            window._appAudioCtx = ctx;
            if (ctx.state === 'suspended') { ctx.resume(); }
            var osc = ctx.createOscillator();
            var gain = ctx.createGain();
            osc.type = 'sine';
            osc.frequency.value = $frequency;
            var now = ctx.currentTime;
            var durationSec = ${durationMs / 1000};
            var stopTime = now + durationSec;
            gain.gain.setValueAtTime(0.0001, now);
            gain.gain.linearRampToValueAtTime(0.7, now + 0.05);
            gain.gain.setValueAtTime(0.7, Math.max(now + 0.05, stopTime - 0.05));
            gain.gain.linearRampToValueAtTime(0.0001, stopTime);
            osc.connect(gain);
            gain.connect(ctx.destination);
            osc.start(now);
            osc.stop(stopTime);
          } catch(e) {}
        })();
        '''
      ]);
    } catch (_) {}
  }
}
