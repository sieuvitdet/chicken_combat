import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/challenge/loading_2vs2_challenge_screen.dart';
import 'package:chicken_combat/presentation/challenge/loading_challenge_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:flutter/material.dart';

class ListChallengeScreen extends StatefulWidget {
  const ListChallengeScreen({super.key});

  @override
  State<ListChallengeScreen> createState() => _ListChallengeScreenState();
}

class _ListChallengeScreenState extends State<ListChallengeScreen> {
  late AudioManager _audioManager;

  @override
  void initState() {
    super.initState();
    _audioManager = AudioManager();
    AudioManager.initVolumeListener();
    AudioManager.playRandomBackgroundMusic();
  }

  @override
  void dispose() {
    super.dispose();
  }
  Widget _buildBackground() {
    return Stack(
      children: [
        BackGroundCloudWidget(),
        Positioned(
            top: AppSizes.maxHeight * 0.06,
            left: 8.0,
            child: IconTheme(
              data: IconThemeData(size: 24.0), // Set the size here
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios,color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ))
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          fit: BoxFit.contain,
          image: AssetImage(Assets.gif_chicken_black_dance),
          width: AppSizes.maxWidth * 0.3,
          height: AppSizes.maxHeight * 0.18,
        ),
        _1vs1(),
        _2vs2()
      ],
    );
  }

  Widget _1vs1() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: CustomButtomImageColorWidget(
        redBlurColor: true,
        child: Center(
            child: Text("1 vs 1",
                style: TextStyle(fontSize: 24, color: Colors.white))),
        onTap: () {
          AudioManager.playSoundEffect(AudioFile.sound_tap);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoadingChallegenScreen()));
        },
      ),
    );
  }

  Widget _2vs2() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: CustomButtomImageColorWidget(
        blueColor: true,
        child: Center(
            child: Text("2 vs 2",
                style: TextStyle(fontSize: 24, color: Colors.white))),
        onTap: () {
          AudioManager.playSoundEffect(AudioFile.sound_tap);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Loading2V2ChallegenScreen()));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onPopInvoked: (didPop) {
      //   AudioManager.playBackgroundMusic(AudioFile.sound_background);
      // },
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xFFFACA44),
        body: Responsive(mobile: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            _buildContent(),
          ],
        ),tablet: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            _buildContent(),
          ],
        ),desktop: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            _buildContent(),
          ],
        ),),
      ),
    );
  }
}
