import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class AudioManager {
  static final AudioPlayer _backgroundAudioPlayer = AudioPlayer();
  static final AudioPlayer _voiceAudioPlayer = AudioPlayer();

  static final AudioPlayer _soundEffectPlayer = AudioPlayer();

  static final List<String> soundFiles = [
    "audio/sound_map_1.mp3",
    "audio/sound_background_2.mp3",
    "audio/sound_background_3.mp3"
  ];

  static final List<String> soundChickenSingFiles = [
    "audio/sound_chicken_sing_1.mp3",
    "audio/sound_chicken_sing_2.mp3",
    "audio/sound_chicken_sing_3.mp3",
    "audio/sound_chicken_sing_4.mp3",
    "audio/sound_chicken_sing_5.mp3",
    "audio/sound_chicken_sing_6.mp3",
    "audio/sound_chicken_sing_7.mp3",
  ];

  static Future<void> playBackgroundMusic(String filePath) async {
    await _backgroundAudioPlayer.setReleaseMode(ReleaseMode.loop);
    try {
      await _backgroundAudioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static Future<void> playRandomBackgroundMusic() async {
    Random random = Random();
    int index = random.nextInt(soundFiles.length);
    String filePath = soundFiles[index];
    final audioPlayer = AudioPlayer();
    final AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        defaultToSpeaker: true,
        category: AVAudioSessionCategory.ambient,
        options: [
          AVAudioSessionOptions.defaultToSpeaker,
          AVAudioSessionOptions.mixWithOthers,
        ],
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: false,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.assistanceSonification,
        audioFocus: AndroidAudioFocus.gain,

      ),
    );
    AudioPlayer.global.setGlobalAudioContext(audioContext);
    await _backgroundAudioPlayer.setReleaseMode(ReleaseMode.loop);
    try {
      await _backgroundAudioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static Future<void> playRandomChickenSing() async {
    Random random = Random();
    int index = random.nextInt(soundChickenSingFiles.length);
    String filePath = soundChickenSingFiles[index];
    final AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        defaultToSpeaker: true,
        category: AVAudioSessionCategory.ambient,
        options: [
          AVAudioSessionOptions.defaultToSpeaker,
          AVAudioSessionOptions.mixWithOthers,
        ],
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: false,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.assistanceSonification,
        audioFocus: AndroidAudioFocus.gain,
      ),
    );
    AudioPlayer.global.setGlobalAudioContext(audioContext);
    await _voiceAudioPlayer.setReleaseMode(ReleaseMode.release);
    try {
      await _voiceAudioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }

    _voiceAudioPlayer.onPlayerStateChanged.listen((event) async {
      if (event == PlayerState.completed) {
        print(index);
        if (index == soundChickenSingFiles.length - 1) {
          index = 0;
        } else {
          index += 1;
        }
        String filePath = soundChickenSingFiles[index];
        await _voiceAudioPlayer.setReleaseMode(ReleaseMode.release);
        try {
          await _voiceAudioPlayer.play(AssetSource(filePath));
        } catch (e) {
          print('Error playing sound: $e');
        }
      }
    });
  }

  static Future<void> stopVoiceMusic() async {
    await _voiceAudioPlayer.stop();
  }

  static Future<void> pauseVoiceMusic() async {
    await _voiceAudioPlayer.pause();
  }

  static Future<void> resumeVoiceMusic() async {
    await _voiceAudioPlayer.resume();
  }

  static Future<void> stopBackgroundMusic() async {
    await _backgroundAudioPlayer.stop();
  }

  static Future<void> pauseBackgroundMusic() async {
    await _backgroundAudioPlayer.pause();
  }

  static Future<void> resumeBackgroundMusic() async {
    await _backgroundAudioPlayer.resume();
  }

  static Future<void> playSoundEffect(String filePath) async {
    await _soundEffectPlayer.play(AssetSource(filePath));
  }

  static Future<void> setVolume(double volume) async {
    await _backgroundAudioPlayer.setVolume(volume);
  }
}
