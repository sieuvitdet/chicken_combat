import 'package:chicken_combat/common/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  double _volume = 1.0;

  Future<void> init() async {
    await _audioPlayer.setAsset(AudioFile.sound_background);
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.play();
      }
    });
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void stop() {
    _audioPlayer.stop();
  }

  void changeAudio(String assetPath) async {
    await _audioPlayer.setAsset(assetPath);
    play();
  }

  bool isPlaying() {
    return _audioPlayer.playing;
  }

  void handleAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      pause();
    } else {
      play();
    }
  }

  double get volume => _volume;

  set volume(double value) {
    _volume = value.clamp(0.0, 1.0);
    _audioPlayer.setVolume(_volume);
  }
}