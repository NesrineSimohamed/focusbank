import 'dart:async';
import 'dart:js_interop';
import 'package:flutter/foundation.dart';

@JS('AudioContext')
extension type _AudioContext._(JSObject _) implements JSObject {
  external factory _AudioContext();
  external num get currentTime;
  external _AudioNode get destination;
  external _OscillatorNode createOscillator();
  external _GainNode createGain();
  external JSPromise resume();
  external JSPromise close();
}

@JS()
extension type _AudioNode._(JSObject _) implements JSObject {
  external void connect(_AudioNode destination);
}

@JS()
extension type _AudioParam._(JSObject _) implements JSObject {
  external set value(num v);
  external void setValueAtTime(num value, num startTime);
  external void linearRampToValueAtTime(num value, num endTime);
  external void exponentialRampToValueAtTime(num value, num endTime);
}

@JS()
extension type _OscillatorNode._(JSObject _) implements _AudioNode {
  external set type(String v);
  external _AudioParam get frequency;
  external void start([num when]);
  external void stop([num when]);
}

@JS()
extension type _GainNode._(JSObject _) implements _AudioNode {
  external _AudioParam get gain;
}

class PlatformSoundPlayer {
  _AudioContext? _ctx;
  Timer? _loopTimer;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  void _playChimeOnce() {
    try {
      _ctx ??= _AudioContext();
      final ctx = _ctx!;
      ctx.resume();

      final now = ctx.currentTime.toDouble();
      // Pleasant 4-note celebration chime: C5, E5, G5, C6
      const notes = [
        (523.25, 0.00, 0.35),
        (659.25, 0.18, 0.35),
        (783.99, 0.36, 0.45),
        (1046.50, 0.54, 0.65),
      ];

      for (final (freq, delay, duration) in notes) {
        final osc = ctx.createOscillator();
        final gain = ctx.createGain();
        osc.type = 'sine';
        osc.frequency.setValueAtTime(freq, now + delay);

        gain.gain.setValueAtTime(0.001, now + delay);
        gain.gain.linearRampToValueAtTime(0.28, now + delay + 0.02);
        gain.gain.exponentialRampToValueAtTime(0.001, now + delay + duration);

        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start(now + delay);
        osc.stop(now + delay + duration + 0.02);
      }
    } catch (e) {
      debugPrint('Web SoundService chime error: $e');
    }
  }

  Future<void> startLoop() async {
    await stop();
    _isPlaying = true;
    _playChimeOnce();
    _loopTimer = Timer.periodic(const Duration(milliseconds: 1600), (_) {
      if (_isPlaying) {
        _playChimeOnce();
      }
    });
  }

  Future<void> stop() async {
    _isPlaying = false;
    _loopTimer?.cancel();
    _loopTimer = null;
    try {
      _ctx?.close();
    } catch (_) {}
    _ctx = null;
  }
}
