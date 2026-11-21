import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class PlatformSoundPlayer {
  AudioPlayer? _player;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  AudioPlayer get _safePlayer => _player ??= AudioPlayer();

  Future<void> startLoop() async {
    try {
      final player = _safePlayer;
      await player.stop();
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(1.0);
      await player.play(AssetSource('sounds/session_complete.wav'));
      _isPlaying = true;
    } catch (e) {
      debugPrint('IO SoundService startLoop error: $e');
    }
  }

  Future<void> stop() async {
    try {
      _isPlaying = false;
      await _player?.stop();
    } catch (e) {
      debugPrint('IO SoundService stop error: $e');
    }
  }
}
