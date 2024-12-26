import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

class AudioManager with WidgetsBindingObserver {
  static final AudioPlayer _backgroundAudioPlayer = AudioPlayer();
  static final AudioPlayer _voiceAudioPlayer = AudioPlayer();
  static final AudioPlayer _soundEffectPlayer = AudioPlayer();

  static late bool isMusicPlaying = false;

  static void initVolumeListener() {
    FlutterVolumeController.addListener((double volume) async {
      await _backgroundAudioPlayer.setVolume(volume);
      await _voiceAudioPlayer.setVolume(volume);
      await _soundEffectPlayer.setVolume(volume);
    });
  }

  static final List<String> soundFiles = [
    "audio/sound_background.mp3",
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
  ];

  AudioManager() {
    WidgetsBinding.instance.addObserver(this);
  }

  static Future<void> playBackgroundMusic(String filePath) async {
    isMusicPlaying = true;
    await _backgroundAudioPlayer.setReleaseMode(ReleaseMode.loop);
    try {
      await _backgroundAudioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static Future<void> playRandomBackgroundMusic() async {
    isMusicPlaying = true;
    Random random = Random();
    int index = random.nextInt(soundFiles.length);
    String filePath = soundFiles[index];
    final audioPlayer = AudioPlayer();
    final AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.ambient,
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: false,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.assistanceSonification,
        audioFocus: AndroidAudioFocus.gain,

      ),
    );
    AudioPlayer.global.setAudioContext(audioContext);
    await _backgroundAudioPlayer.setReleaseMode(ReleaseMode.loop);
    try {
      await _backgroundAudioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static Future<void> playRandomChickenSing() async {
    isMusicPlaying = true;
    Random random = Random();
    int index = random.nextInt(soundChickenSingFiles.length);
    String filePath = soundChickenSingFiles[index];
    final AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.ambient,
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: false,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.assistanceSonification,
        audioFocus: AndroidAudioFocus.gain,
      ),
    );
    AudioPlayer.global.setAudioContext(audioContext);
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
    isMusicPlaying = false;
    await _backgroundAudioPlayer.stop();
  }

  static Future<void> pauseBackgroundMusic() async {
    await _backgroundAudioPlayer.pause();
  }

  static Future<void> resumeBackgroundMusic() async {
    isMusicPlaying = true;
    await _backgroundAudioPlayer.resume();
  }

  static Future<void> playSoundEffect(String filePath) async {
    isMusicPlaying = true;
    await _soundEffectPlayer.play(AssetSource(filePath));
  }

  static Future<void> setVolume(double volume) async {
    await _backgroundAudioPlayer.setVolume(volume);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      pauseBackgroundMusic();
    } else if (state == AppLifecycleState.resumed) {
      if (isMusicPlaying == true) {
        playRandomBackgroundMusic();
      } else {
        pauseBackgroundMusic();
      }
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    FlutterVolumeController.removeListener();
  }
}
