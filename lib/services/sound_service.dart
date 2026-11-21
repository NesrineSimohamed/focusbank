import 'sound_service_io.dart'
    if (dart.library.js_interop) 'sound_service_web.dart';

class SoundService {
  static final SoundService instance = SoundService._internal();
  factory SoundService() => instance;
  SoundService._internal();

  PlatformSoundPlayer? _platformPlayer;
  PlatformSoundPlayer get _safePlayer =>
      _platformPlayer ??= PlatformSoundPlayer();

  /// Starts looping the session completion notification sound until [stopAlarm] is called.
  Future<void> startSessionCompleteAlarm() => _safePlayer.startLoop();

  /// Stops the looping notification sound immediately.
  Future<void> stopAlarm() => _safePlayer.stop();

  bool get isPlaying => _safePlayer.isPlaying;
}
