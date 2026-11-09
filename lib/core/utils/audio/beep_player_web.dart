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
    int frequency = 950,
    int durationMs = 200,
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
            gain.gain.setValueAtTime(0, now);
            gain.gain.linearRampToValueAtTime(0.6, now + 0.02);
            gain.gain.exponentialRampToValueAtTime(0.001, now + ${durationMs / 1000});
            osc.connect(gain);
            gain.connect(ctx.destination);
            osc.start(now);
            osc.stop(now + ${durationMs / 1000});
          } catch(e) {}
        })();
        '''
      ]);
    } catch (_) {}
  }
}
