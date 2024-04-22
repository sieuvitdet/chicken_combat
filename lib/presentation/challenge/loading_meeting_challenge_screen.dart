import 'dart:math';
import 'dart:ui';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/battle/room_model.dart';
import 'package:chicken_combat/presentation/challenge/battle_map/battle_1vs1_screen.dart';
import 'package:chicken_combat/presentation/map/map1_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/widgets/animation/loading_animation.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:flutter/material.dart';

class LoadingMeetingChallengeScreen extends StatefulWidget {
  final RoomModel room;

  LoadingMeetingChallengeScreen({required this.room});

  @override
  State<LoadingMeetingChallengeScreen> createState() =>
      _LoadingMeetingChallengeScreenState();
}

class _LoadingMeetingChallengeScreenState
    extends State<LoadingMeetingChallengeScreen> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late Animation<Offset> _animation1;

  late AnimationController _controller3;
  late Animation<double> _animation3;

  late AnimationController _controllerChicken1;
  late Animation _animationChicken1;
  late Path _pathChicken1;

  late AnimationController _controllerChicken2;
  late Animation _animationChicken2;
  late Path _pathChicken2;

  String _loadingText = 'Matching';
  bool hiddenGifPK = false;

  @override
  void dispose() {
    _controller1.dispose();
    _controller3.dispose();
    _controllerChicken1.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _configAnamation();
    _configChickenFisrt();
    _configChickenSecond();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   _configChickenFisrt();
    // _configChickenSecond();

      _controllerChicken1.forward();
      _controllerChicken2.forward();
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        hiddenGifPK = true;
      });
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Battle1Vs1Screen(room: widget.room,)));
    });
    Future.delayed(Duration.zero, () {
      AudioManager.playRandomBackgroundMusic();
    });
  }

  void _configAnamation() {
    _controller1 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    )..repeat(reverse: true);
    _animation1 = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: Curves.easeInOut,
      ),
    );

    _controller3 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation3 = Tween<double>(begin: 1.0, end: 4.0).animate(_controller3)
      ..addListener(() {
        setState(() {
          updateLoadingText();
        });
      });
  }

  void updateLoadingText() {
    int dotsCount = _animation3.value.floor() % 2 + 1;
    _loadingText = 'Matching' + '.' * dotsCount;
  }

  void _configChickenFisrt() {
    _controllerChicken1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationChicken1 =
        Tween(begin: 0.0, end: 1.0).animate(_controllerChicken1)
          ..addListener(() {
            setState(() {});
          });
    _controllerChicken1.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });
    _pathChicken1 = drawPathChicken1();
  }

  void _configChickenSecond() {
    _controllerChicken2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationChicken2 =
        Tween(begin: 0.0, end: 1.0).animate(_controllerChicken2)
          ..addListener(() {
            setState(() {});
          });
    _controllerChicken2.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });
    
    _pathChicken2 = drawPathChicken2();
  }

  Widget _buildBottom() {
    return BackGroundCloudWidget();
  }

  Widget _buildContent() {
    return Stack(
      children: [
        Positioned(
          top: calculateChicken1(_animationChicken1.value).dy,
          left: calculateChicken1(_animationChicken1.value).dx,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(0),
            child: Image.asset(
              Assets.chicken_flapping_swing_gif,
              fit: BoxFit.contain,
              width:  AppSizes.maxWidthTablet > 0 ? AppSizes.maxWidth * 0.33 : AppSizes.maxWidth * 0.2,
              height: AppSizes.maxHeight * 0.12,
            ),
          ),
        ),
        Positioned(
          top: calculateChicken2(_animationChicken2.value).dy,
          left: calculateChicken2(_animationChicken2.value).dx,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(pi),
            child: Image.asset(
              Assets.chicken_flapping_swing_gif,
              fit: BoxFit.contain,
              width: AppSizes.maxWidthTablet > 0 ? AppSizes.maxWidth * 0.33 : AppSizes.maxWidth * 0.2,
              height: AppSizes.maxHeight * 0.12,
            ),
          ),
        ),

        !hiddenGifPK ? Positioned(
          top: AppSizes.maxHeight / 2.8,
          left: 0,
          right: 0,
          child: Image.asset(
            Assets.gif_pk,
            fit: BoxFit.contain,
            width: AppSizes.maxWidth * 0.1,
            height: AppSizes.maxHeight * 0.1,
          ),
        ): Positioned(
          top: AppSizes.maxHeight / 2.8,
          left: 0,
          right: 0,
          child: Image.asset(
            Assets.img_pk,
            fit: BoxFit.contain,
            width: AppSizes.maxWidth * 0.1,
            height: AppSizes.maxHeight * 0.1,
          ),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: AnimatedBuilder(
                animation: _controller3,
                builder: (context, child) {
                  return Text(
                    _loadingText,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  );
                },
              ),
            ),
            Center(
              child: LoadingAnimation(
                offsetSpeed: Offset(1, 0),
                width: 220,
                height: 16,
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ],
    );
  }

  Path drawPathChicken1() {
    Path path = Path();
    double maxWidth = AppSizes.maxWidthTablet > 0 ? AppSizes.maxWidthTablet : AppSizes.maxWidth;
    double maxHeight = AppSizes.maxHeight;
    path.moveTo(0, AppSizes.maxHeight / 4);
    path.quadraticBezierTo(
        maxWidth / 4, maxHeight / 4, maxWidth / 5, maxHeight / 2.8);

    return path;
  }

  Path drawPathChicken2() {
    Path path = Path();
    double maxWidth = AppSizes.maxWidthTablet > 0 ? AppSizes.maxWidthTablet : AppSizes.maxWidth;
    double maxHeight = AppSizes.maxHeight;
    path.moveTo(maxWidth, AppSizes.maxHeight / 4);
    path.quadraticBezierTo(maxWidth - maxWidth / 4, maxHeight / 4,
        maxWidth - 2 * maxWidth / 5, maxHeight / 2.8);

    return path;
  }

  Offset calculateChicken1(value) {
    PathMetrics pathMetrics = _pathChicken1.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value)!;
    return pos.position;
  }

  Offset calculateChicken2(value) {
    PathMetrics pathMetrics = _pathChicken2.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value)!;
    return pos.position;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:false,
      child: Scaffold(
        backgroundColor: Color(0xFFFACA44),
        body: Responsive(mobile: Container(
          child: Stack(
            fit: StackFit.loose,
            children: [
              _buildBottom(),
              _buildContent(),
            ],
          ),
        ), tablet: Container(
          child: Stack(
            fit: StackFit.loose,
            children: [
              _buildBottom(),
              _buildContent(),
            ],
          ),
        ), desktop: Container(
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
