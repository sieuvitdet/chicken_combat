import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class AudioManager {
  static final AudioPlayer _backgroundAudioPlayer = AudioPlayer();
  static final AudioPlayer _soundEffectPlayer = AudioPlayer();

  static final List<String> soundFiles = [
    "audio/sound_map_1.mp3",
    "audio/sound_background_2.mp3",
    "audio/sound_background_3.mp3"
  ];

  static void playBackgroundMusic(String filePath) async {
    await _backgroundAudioPlayer.setReleaseMode(ReleaseMode.loop);
    try {
      await _backgroundAudioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static void playRandomBackgroundMusic() async {
    Random random = Random();
    int index = random.nextInt(soundFiles.length);
    String filePath = soundFiles[index];
    await _backgroundAudioPlayer.setReleaseMode(ReleaseMode.loop);
    try {
      await _backgroundAudioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static void stopBackgroundMusic() async {
    await _backgroundAudioPlayer.stop();
  }

  static void pauseBackgroundMusic() async {
    await _backgroundAudioPlayer.pause();
  }

  static void resumeBackgroundMusic() async {
    await _backgroundAudioPlayer.resume();
  }

  static void playSoundEffect(String filePath) async {
    await _soundEffectPlayer.play(AssetSource(filePath));
  }

  static void setVolume(double volume) async {
    await _backgroundAudioPlayer.setVolume(volume);
  }
}