package com.jadwalsholat.tv.jadwal_sholat_tv

import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import android.media.ToneGenerator
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.jadwalsholat.tv/beep"
    private var toneGenerator: ToneGenerator? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "playBeep") {
                val duration = call.argument<Int>("durationMs") ?: 2000
                val frequency = call.argument<Int>("frequency") ?: 850
                thread {
                    playTone(frequency.toDouble(), duration)
                }
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun playTone(freqHz: Double, durationMs: Int) {
        try {
            val sampleRate = 44100
            val numSamples = (durationMs * sampleRate) / 1000
            val buffer = ShortArray(numSamples)
            val twoPi = 2.0 * Math.PI
            val rampSamples = (sampleRate * 50) / 1000 // 50ms fade-in & fade-out
            for (i in 0 until numSamples) {
                val time = i.toDouble() / sampleRate
                val gain = when {
                    i < rampSamples -> i.toDouble() / rampSamples
                    i > numSamples - rampSamples -> (numSamples - i).toDouble() / rampSamples
                    else -> 1.0
                }
                val angle = twoPi * freqHz * time
                buffer[i] = (Math.sin(angle) * 32767 * 0.75 * gain).toInt().toShort()
            }
            val audioTrack = AudioTrack.Builder()
                .setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                )
                .setAudioFormat(
                    AudioFormat.Builder()
                        .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                        .setSampleRate(sampleRate)
                        .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                        .build()
                )
                .setBufferSizeInBytes(numSamples * 2)
                .setTransferMode(AudioTrack.MODE_STATIC)
                .build()

            audioTrack.write(buffer, 0, numSamples)
            audioTrack.play()
            Thread.sleep(durationMs.toLong() + 50)
            audioTrack.stop()
            audioTrack.release()
        } catch (e: Exception) {
            try {
                if (toneGenerator == null) {
                    toneGenerator = ToneGenerator(AudioManager.STREAM_NOTIFICATION, 100)
                }
                toneGenerator?.startTone(ToneGenerator.TONE_CDMA_ALERT_CALL_GUARD, durationMs)
            } catch (_: Exception) {}
        }
    }

    override fun onDestroy() {
        toneGenerator?.release()
        toneGenerator = null
        super.onDestroy()
    }
}
