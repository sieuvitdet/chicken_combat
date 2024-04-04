import 'dart:math';
import 'dart:ui';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/challenge/battle_map/battle_2vs2_screen.dart';
import 'package:chicken_combat/widgets/animation/loading_animation.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

class Loading2vs2ChallengeScreen extends StatefulWidget {
  const Loading2vs2ChallengeScreen({super.key});

  @override
  State<Loading2vs2ChallengeScreen> createState() =>
      _Loading2vs2ChallengeScreenState();
}

class _Loading2vs2ChallengeScreenState extends State<Loading2vs2ChallengeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late AnimationController _controllerChicken1;
  late Animation _animationChicken1;
  late Path _pathChicken1;

  late AnimationController _controllerChicken2;
  late Animation _animationChicken2;
  late Path _pathChicken2;

  late AnimationController _controllerChicken3;
  late Animation _animationChicken3;
  late Path _pathChicken3;
  ////

  late AnimationController _controllerChicken4;
  late Animation _animationChicken4;
  late Path _pathChicken4;

  String _loadingText = 'Matching';
  bool hiddenGifPK = false;

  @override
  void dispose() {
    _controller.dispose();
    _controllerChicken1.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _configAnamation();
    _configChickenFisrt();
    _configChickenSecond();
    _configChickenThird();
    _configChickenFour();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _controllerChicken1.forward();
      _controllerChicken2.forward();
      _controllerChicken3.forward();
      _controllerChicken4.forward();
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        hiddenGifPK = true;
      });
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Battle2Vs2Screen()));
    });
  }

  void _configAnamation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 4.0).animate(_controller)
      ..addListener(() {
        setState(() {
          updateLoadingText();
        });
      });
  }

  void updateLoadingText() {
    int dotsCount = _animation.value.floor() % 3 + 1;
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

  void _configChickenThird() {
    _controllerChicken3 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationChicken3 =
        Tween(begin: 0.0, end: 1.0).animate(_controllerChicken3)
          ..addListener(() {
            setState(() {});
          });
    _controllerChicken3.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });
    _pathChicken3 = drawPathChicken3();
  }

  void _configChickenFour() {
    _controllerChicken4 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationChicken4 =
        Tween(begin: 0.0, end: 1.0).animate(_controllerChicken4)
          ..addListener(() {
            setState(() {});
          });
    _controllerChicken4.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });
    _pathChicken4 = drawPathChicken4();
  }

  Widget _buildBottom() {
    return BackGroundCloudWidget();
  }

  Widget _buildContent() {
    return Stack(
      children: [
        _chicken1(),
        _chickenTeam1(),
        _chicken2(),
        _chickenTeam2(),

        !hiddenGifPK
            ? Positioned(
                top: AppSizes.maxHeight / 2.4,
                left: 0,
                right: 0,
                child: Image.asset(
                  Assets.gif_pk,
                  fit: BoxFit.contain,
                  width: AppSizes.maxWidth * 0.1,
                  height: AppSizes.maxHeight * 0.1,
                ),
              )
            : Positioned(
                top: AppSizes.maxHeight / 2.4,
                left: 0,
                right: 0,
                child: Image.asset(
                  Assets.img_pk,
                  fit: BoxFit.contain,
                  width: AppSizes.maxWidth * 0.1,
                  height: AppSizes.maxHeight * 0.1,
                ),
              ),

        // Positioned(
        //     top: 0,
        //     child: CustomPaint(
        //       painter: PathPainter(_pathChicken1),
        //     ),
        //   ),
        // Positioned(
        //     top: 0,
        //     child: CustomPaint(
        //       painter: PathPainter(_pathChicken2),
        //     ),
        //   ),

        // Positioned(
        //     top: 0,
        //     child: CustomPaint(
        //       painter: PathPainter(_pathChicken3),
        //     ),
        //   ),

        // Positioned(
        //     top: 0,
        //     child: CustomPaint(
        //       painter: PathPainter(_pathChicken4),
        //     ),
        //   ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: AnimatedBuilder(
                animation: _controller,
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

        // Positioned(
        //   top: 0,
        //   left: AppSizes.maxWidth/2,
        //   child: Container(
        //   height: 1000,
        //   width: 1,
        //   color: Colors.red,
        // )),

        // Positioned(
        //   left: 0,
        //   top: AppSizes.maxHeight/2,

        //   child: Container(
        //   height: 1,
        //   width: 1000,
        //   color: Colors.blue,
        // ))
      ],
    );
  }

  Widget _chicken1() {
    return Positioned(
      top: calculateChicken1(_animationChicken1.value).dy,
      left: calculateChicken1(_animationChicken1.value).dx,
      child: Container(
        width: AppSizes.maxWidth * 0.2,
        child: Column(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(0),
              child: ShakeWidget(
                duration: const Duration(seconds: 10),
                shakeConstant: ShakeDefaultConstant1(),
                autoPlay: true,
                child: Image.asset(
                  Assets.img_chicken_blue,
                  fit: BoxFit.contain,
                  width: AppSizes.maxWidth * 0.18,
                  height: AppSizes.maxHeight * 0.12,
                ),
              ),
            ),
            Text("Kimtaeheeeee",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 13))
          ],
        ),
      ),
    );
  }

  Widget _chicken2() {
    return Positioned(
      top: calculateChicken2(_animationChicken2.value).dy,
      left: calculateChicken2(_animationChicken2.value).dx,
      child: Container(
        width: AppSizes.maxWidth * 0.2,
        child: Column(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: ShakeWidget(
                duration: const Duration(seconds: 10),
                shakeConstant: ShakeDefaultConstant1(),
                autoPlay: true,
                child: Image.asset(
                  Assets.img_chicken_black,
                  fit: BoxFit.contain,
                  width: AppSizes.maxWidth * 0.18,
                  height: AppSizes.maxHeight * 0.12,
                ),
              ),
            ),
            Text("HarryMaguire",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 12))
          ],
        ),
      ),
    );
  }

  Widget _chickenTeam1() {
    return Positioned(
      top: calculateChicken3(_animationChicken3.value).dy,
      left: calculateChicken3(_animationChicken3.value).dx,
      child: Container(
        width: AppSizes.maxWidth * 0.2,
        child: Column(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(0),
              child: ShakeWidget(
                duration: const Duration(seconds: 10),
                shakeConstant: ShakeDefaultConstant1(),
                autoPlay: true,
                child: Image.asset(
                  Assets.img_chicken_red,
                  fit: BoxFit.contain,
                  width: AppSizes.maxWidth * 0.1,
                  height: AppSizes.maxHeight * 0.1,
                ),
              ),
            ),
            Text("Miraaaaaa",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 12))
          ],
        ),
      ),
    );
  }

  Widget _chickenTeam2() {
    return Positioned(
      top: calculateChicken4(_animationChicken4.value).dy,
      left: calculateChicken4(_animationChicken4.value).dx,
      child: Container(
        width: AppSizes.maxWidth * 0.2,
        child: Column(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(0),
              child: ShakeWidget(
                duration: const Duration(seconds: 10),
                shakeConstant: ShakeDefaultConstant1(),
                autoPlay: true,
                child: Image.asset(
                  Assets.img_chicken_white,
                  fit: BoxFit.contain,
                  width: AppSizes.maxWidth * 0.1,
                  height: AppSizes.maxHeight * 0.1,
                ),
              ),
            ),
            Text("LeeMiraeeee",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 13))
          ],
        ),
      ),
    );
  }

  Path drawPathChicken1() {
    Path path = Path();
    double maxWidth = AppSizes.maxWidth;
    double maxHeight = AppSizes.maxHeight;
    path.moveTo(0, AppSizes.maxHeight / 4);
    path.quadraticBezierTo(maxWidth / 4, maxHeight / 4,
        maxWidth / 2.55 - maxWidth * 0.2, maxHeight / 2.6);

    return path;
  }

  Path drawPathChicken3() {
    Path path = Path();
    double maxWidth = AppSizes.maxWidth;
    double maxHeight = AppSizes.maxHeight;
    path.moveTo(0, AppSizes.maxHeight / 4);
    path.quadraticBezierTo(maxWidth / 4, maxHeight / 4,
        maxWidth / 2.3 - 2 * maxWidth * 0.205, maxHeight / 2.3);

    return path;
  }

  Path drawPathChicken2() {
    Path path = Path();
    double maxWidth = AppSizes.maxWidth;
    double maxHeight = AppSizes.maxHeight;
    path.moveTo(maxWidth, AppSizes.maxHeight / 4);
    path.quadraticBezierTo(maxWidth - maxWidth / 4, maxHeight / 4,
        maxWidth / 1.65, maxHeight / 2.6);

    return path;
  }

  Path drawPathChicken4() {
    Path path = Path();
    double maxWidth = AppSizes.maxWidth;
    double maxHeight = AppSizes.maxHeight;
    path.moveTo(maxWidth, AppSizes.maxHeight / 4);
    path.quadraticBezierTo(maxWidth - maxWidth / 4, maxHeight / 4,
        maxWidth / 1.8 + maxWidth * 0.21, maxHeight / 2.3);

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

  Offset calculateChicken3(value) {
    PathMetrics pathMetrics = _pathChicken3.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value)!;
    return pos.position;
  }

  Offset calculateChicken4(value) {
    PathMetrics pathMetrics = _pathChicken4.computeMetrics();
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
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildBottom(),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }
}
