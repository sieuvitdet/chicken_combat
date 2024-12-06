import 'dart:math';
import 'dart:ui';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/widgets/animation/loading_dots.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:flutter/material.dart';

class LoadingReadyChallengeScreen extends StatefulWidget {
  LoadingReadyChallengeScreen();

  @override
  State<LoadingReadyChallengeScreen> createState() =>
      _LoadingReadyChallengeScreenState();
}

class _LoadingReadyChallengeScreenState
    extends State<LoadingReadyChallengeScreen> with TickerProviderStateMixin {
  late AnimationController _controllerLeft;
  late AnimationController _controllerRight;
  late Animation<double> _animationLeft;
  late Animation<double> _animationRight;

  bool hiddenGifPK = false;

  late AudioManager _audioManager;
  void initState() {
    super.initState();
    _configAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        hiddenGifPK = true;
      });
    });
    _audioManager = AudioManager();
    AudioManager.initVolumeListener();
    AudioManager.playRandomBackgroundMusic();
  }

  @override
  void dispose() {
    _controllerLeft.dispose();
    _controllerRight.dispose();
    _audioManager.dispose();
    super.dispose();
  }

  void _configAnimation() {
    // Initialize the animation controller for the left chicken
    _controllerLeft = AnimationController(
      duration: const Duration(milliseconds: 500),  // Increased duration for clearer effect
      vsync: this,
    );
    // Left chicken starts off-screen to the left (-1.0 * width) and moves to its place (0.0)
    _animationLeft = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controllerLeft,
        curve: Curves.easeOut,
      ),
    );

    // Initialize the animation controller for the right chicken
    _controllerRight = AnimationController(
      duration: const Duration(milliseconds: 500),  // Matched duration for symmetry
      vsync: this,
    );
    // Right chicken starts off-screen to the right (1.0 * width) and moves to its place (0.0)
    _animationRight = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controllerRight,
        curve: Curves.easeOut,
      ),
    );

    // Start the animations when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllerLeft.forward();
      _controllerRight.forward();
    });
  }

  Widget _buildBottom() {
    return BackGroundCloudWidget();
  }

  Widget _buildContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Transform.translate(
                        offset: Offset(MediaQuery.of(context).size.width * _animationLeft.value, 0),
                        child: Column(
                          children: [
                            Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(0),
                              child: Image.asset(
                                Assets.img_chicken_green,
                                fit: BoxFit.contain,
                                width: AppSizes.maxWidth * 0.15,
                              ),
                            ),
                            Text(
                              "Gà 111",
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      !hiddenGifPK
                          ? Image.asset(
                        Assets.gif_pk,
                        fit: BoxFit.contain,
                        width: AppSizes.maxWidth * 0.25,
                        height: AppSizes.maxHeight * 0.1,
                      )
                          : Image.asset(
                        Assets.img_pk,
                        fit: BoxFit.contain,
                        width: AppSizes.maxWidth * 0.25,
                        height: AppSizes.maxHeight * 0.1,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Transform.translate(
                        offset: Offset(MediaQuery.of(context).size.width * _animationRight.value, 0),
                        child: Column(
                          children: [
                            Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(pi),
                              child: Image.asset(
                                Assets.img_chicken_green,
                                fit: BoxFit.contain,
                                width: AppSizes.maxWidth * 0.15,
                              ),
                            ),
                            Text(
                              "Gà 111",
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          bottom: 24,
          left: 16,
          right: 16,
          child: Column(
            children: [
              LoadingDots(
                text: 'Đang chờ đối thủ',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 8,),
              CustomButtomImageColorWidget(
                orangeColor: true,
                child: Text('Sẵng sàng',
                    style: TextStyle(fontSize: 24, color: Colors.white)),
                onTap: () {
                  // Your tap callback here
                },
              ),
            ],
          ),
        ),
        Positioned(
          top: 40,
          left: 8,
          child: GestureDetector(
            onTap: () {

            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xFFFF6666),
        body: Responsive(
            mobile: Container(
              child: Stack(
                fit: StackFit.loose,
                children: [
                  _buildBottom(),
                  _buildContent(),
                ],
              ),
            ),
            tablet: Container(
              child: Stack(
                fit: StackFit.loose,
                children: [
                  _buildBottom(),
                  _buildContent(),
                ],
              ),
            ),
            desktop: Container(
              child: Stack(
                fit: StackFit.loose,
                children: [
                  _buildBottom(),
                  _buildContent(),
                ],
              ),
            )),
      ),
    );
  }
}
