import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/dialog_congratulation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

class Battle2Vs2Screen extends StatefulWidget {
  const Battle2Vs2Screen({super.key});

  @override
  State<Battle2Vs2Screen> createState() => _Battle2Vs2ScreenState();
}

class _Battle2Vs2ScreenState extends State<Battle2Vs2Screen>  with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late AnimationController _controllerWaterLeftToRight;
  late Animation _animationWaterLeftToRight;
  late Path _pathWaterLeftToRight;

  late AnimationController _controllerWaterRightToLeft;
  late Animation _animationWaterRightToLeft;
  late Path _pathWaterRightToLeft;

  late AnimationController _controllerFirst;
  late Animation<double> _animationFirst;
  int _currentEnemyBlood = 10;
  int _currentMyBlood = 10;
  late Timer _timer;
  int _start = 30;
  int _total = 10;
  double _topWaterShot = 0.0;
  bool? isEnemyWin = null;
  bool? waterShotLeftToRight = null;
  bool _isTomato = false;
  // int currentVolume = 5;
  // int currentNote = 5;

  @override
  void initState() {
    super.initState();
    _topWaterShot = AppSizes.maxHeight > 800 ? AppSizes.maxHeight * 0.4 - AppSizes.maxHeight * 0.14 : AppSizes.maxHeight * 0.36 - AppSizes.maxHeight * 0.14;
    _configAnimation();
    _configWaterShotAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _startTimer();
    });
  }

  _configAnimation() {
    _controllerFirst = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animationFirst =
        Tween<double>(begin: 0.0, end: -60.0).animate(_controllerFirst)
          ..addListener(() {
            setState(() {
              // Rebuild the widget when animation value changes
            });
          });

    _controllerFirst.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          _controllerFirst.reset();
          isEnemyWin = null;
          if (_currentMyBlood == 0) {
            showPopupWin(isWin: false);
          } else {
            _start = 30;
            _startTimer();
          }
        });
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0.0, end: 60.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // Rebuild the widget when animation value changes
        });
      });

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          _controller.reset();
          isEnemyWin = null;
          if (_currentEnemyBlood == 0) {
            showPopupWin(isWin: true);
          } else {
            _start = 30;
            _startTimer();
          }
        });
      }
    });
  }

  void _configWaterShotAnimation() {
    _controllerWaterLeftToRight =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationWaterLeftToRight =
        Tween(begin: 0.0, end: 1.0).animate(_controllerWaterLeftToRight)
          ..addListener(() {
            setState(() {});
          });
    _controllerWaterLeftToRight.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          _controllerWaterLeftToRight.reset();
          waterShotLeftToRight = null;
          isEnemyWin = false;
          _controller.forward();
        });
      }
    });
    _pathWaterLeftToRight = drawPathLeftToRight();

    _controllerWaterRightToLeft =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationWaterRightToLeft =
        Tween(begin: 0.0, end: 1.0).animate(_controllerWaterRightToLeft)
          ..addListener(() {
            setState(() {});
          });
    _controllerWaterRightToLeft.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          _controllerWaterRightToLeft.reset();
          waterShotLeftToRight = null;
          isEnemyWin = true;
          _controllerFirst.forward();
        });
      }
    });
    _pathWaterRightToLeft = drawPathRightToLeft();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          _timer.cancel();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Path drawPathLeftToRight() {
    Path path = Path();
    path.moveTo(16 + AppSizes.maxWidth * 0.18, _topWaterShot);
    path.quadraticBezierTo(AppSizes.maxWidth / 2, _topWaterShot,
        AppSizes.maxWidth - (40 + AppSizes.maxWidth * 0.18), _topWaterShot);
    return path;
  }

  Offset calculateLeftToRight(value) {
    PathMetrics pathMetrics = _pathWaterLeftToRight.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value)!;
    return pos.position;
  }

  Path drawPathRightToLeft() {
    Path path = Path();
    path.moveTo(
        AppSizes.maxWidth - (40 + AppSizes.maxWidth * 0.18), _topWaterShot);
    path.quadraticBezierTo(AppSizes.maxWidth / 2, _topWaterShot,
        16 + AppSizes.maxWidth * 0.18, _topWaterShot);
    return path;
  }

  Offset calculateRightToLeft(value) {
    PathMetrics pathMetrics = _pathWaterRightToLeft.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value)!;
    return pos.position;
  }

  Widget _header() {
    return Container(
      color: Colors.amber,
      height: AppSizes.maxHeight * 0.35,
      child: Stack(
        children: [
          Image(
            image: AssetImage(Assets.gif_background_sea),
            fit: BoxFit.fill,
            height: AppSizes.maxHeight,
            width: AppSizes.maxWidth,
          ),
          _menu(),
          Positioned(
            bottom: 8,
            left: 16,
            child: _myChicken(_total),
          ),
          if (waterShotLeftToRight != null && waterShotLeftToRight!)
            Positioned(
              top: calculateLeftToRight(_animationWaterLeftToRight.value).dy,
              left: calculateLeftToRight(_animationWaterLeftToRight.value).dx,
              child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(0),
                  child: Image.asset(
                    _isTomato ? Assets.img_tomato : Assets.img_water_shot,
                    fit: BoxFit.contain,
                    width: _isTomato
                        ? AppSizes.maxWidth * 0.1
                        : AppSizes.maxWidth * 0.06,
                  )),
            ),
          Positioned(
            bottom: 8,
            right: 16,
            child: _enemyChicken(_total),
          ),
          if (waterShotLeftToRight != null && !waterShotLeftToRight!)
            Positioned(
              top: calculateRightToLeft(_animationWaterRightToLeft.value).dy,
              left: calculateRightToLeft(_animationWaterRightToLeft.value).dx,
              child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: Image.asset(
                    _isTomato ? Assets.img_tomato : Assets.img_water_shot,
                    fit: BoxFit.contain,
                    width: _isTomato
                        ? AppSizes.maxWidth * 0.1
                        : AppSizes.maxWidth * 0.06,
                  )),
            ),
        ],
      ),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: SingleChildScrollView(
                  child: Text(
                    "Welcome to our random topic! Get ready to explore some interesting questions we've prepared for you. Did you know that they say cats can jump higher than dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thoughts! Get ready to explore some interesting questions we've prepared for you. Did you know that they say cats can jump higher than dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thought Get ready to explore some interesting questions we've prepared for you. Did you know that they say cats can jump higher than dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thought ",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageIcon(
                  AssetImage(Assets.ic_boom),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    "$_start s",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image(
              image: AssetImage(Assets.img_line_table),
            ))
      ],
    );
  }

  Widget _myChicken(int total) {
    return Column(
      children: [
        Text(
          "Black Team",
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        (isEnemyWin != null && isEnemyWin!)
            ? Row(
              children: [
                Transform.rotate(
                angle: _animationFirst.value *
                    3.1415926535 /
                    120, // Convert degrees to radians
                origin:
                    Offset(0, 20), // Set the origin to BottomLeft coordinate
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: ShakeWidget(
                    duration: const Duration(seconds: 10),
                    shakeConstant: ShakeDefaultConstant1(),
                    autoPlay: true,
                    child: Image.asset(
                      Assets.img_chicken_fall,
                      fit: BoxFit.contain,
                      width: AppSizes.maxWidth * 0.08,
                    ),
                  ),
                )), 
                Transform.rotate(
                angle: _animationFirst.value *
                    3.1415926535 /
                    360, // Convert degrees to radians
                origin:
                    Offset(0, 20), // Set the origin to BottomLeft coordinate
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: ShakeWidget(
                    duration: const Duration(seconds: 10),
                    shakeConstant: ShakeDefaultConstant1(),
                    autoPlay: true,
                    child: Image.asset(
                      Assets.img_chicken_fall,
                      fit: BoxFit.contain,
                      width: AppSizes.maxWidth * 0.1,
                    ),
                  ),
                ))
              ],
            )
            : Row(
              children: [
                Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(0),
                child: ShakeWidget(
                  duration: const Duration(seconds: 10),
                  shakeConstant: ShakeDefaultConstant1(),
                  autoPlay: true,
                  child: Image.asset(
                    Assets.img_chicken_black,
                    fit: BoxFit.contain,
                    width: AppSizes.maxWidth * 0.09,
                  ),
                ),
              ),Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(0),
                child: ShakeWidget(
                  duration: const Duration(seconds: 10),
                  shakeConstant: ShakeDefaultConstant1(),
                  autoPlay: true,
                  child: Image.asset(
                    Assets.img_chicken_black,
                    fit: BoxFit.contain,
                    width: AppSizes.maxWidth * 0.1,
                  ),
                ),
              )
              ],
            ),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
              color: Color(0xFF484848),
              borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            children: [
              Text("HP",
                  style: TextStyle(color: Color(0xFFFBC23A), fontSize: 12)),
              Container(
                height: 12,
                width: AppSizes.maxWidth / 4,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  children: [
                    if (_currentMyBlood != 0)
                      Expanded(
                        flex: _currentMyBlood,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFFE4949),
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(8.0),
                                    right: Radius.circular(
                                        _currentMyBlood == 10 ? 8.0 : 0))),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8)),
                      ),
                    Expanded(
                      flex: total - _currentMyBlood,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(8.0),
                                  right: Radius.circular(8.0)))),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Text(
          "${(_currentMyBlood / total * 100).toInt()}/100",
          style: TextStyle(color: Colors.white, fontSize: 14),
        )
      ],
    );
  }

  Widget _enemyChicken(int total) {
    return Column(
      children: [
        Text(
          "Covid Team",
          style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold),
        ),
        (isEnemyWin != null && !isEnemyWin!)
            ? Row(
              children: [
                Transform.rotate(
                angle: _animation.value *
                    3.1415926535 /
                    180, // Convert degrees to radians
                origin:
                    Offset(0, 20), // Set the origin to BottomLeft coordinate
                child: ShakeWidget(
                  duration: const Duration(seconds: 10),
                  shakeConstant: ShakeDefaultConstant1(),
                  autoPlay: true,
                  child: Image.asset(
                    Assets.img_chicken_fall,
                    fit: BoxFit.contain,
                    width: AppSizes.maxWidth * 0.1,
                  ),
                )),Transform.rotate(
                angle: _animation.value *
                    3.1415926535 /
                    120, // Convert degrees to radians
                origin:
                    Offset(0, 20), // Set the origin to BottomLeft coordinate
                child: ShakeWidget(
                  duration: const Duration(seconds: 10),
                  shakeConstant: ShakeDefaultConstant1(),
                  autoPlay: true,
                  child: Image.asset(
                    Assets.img_chicken_fall,
                    fit: BoxFit.contain,
                    width: AppSizes.maxWidth * 0.09,
                  ),
                ))
              ],
            )
            : Row(
              children: [
                Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(pi),
                child: ShakeWidget(
                  duration: const Duration(seconds: 10),
                  shakeConstant: ShakeDefaultConstant1(),
                  autoPlay: true,
                  child: Image.asset(
                    Assets.img_chicken_blue,
                    fit: BoxFit.contain,
                    width: AppSizes.maxWidth * 0.1,
                  ),
                ),
              ),Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(pi),
                child: ShakeWidget(
                  duration: const Duration(seconds: 10),
                  shakeConstant: ShakeDefaultConstant1(),
                  autoPlay: true,
                  child: Image.asset(
                    Assets.img_chicken_green,
                    fit: BoxFit.contain,
                    width: AppSizes.maxWidth * 0.09,
                  ),
                ),
              )
              ],
            ),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
              color: Color(0xFF484848),
              borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            children: [
              Text("HP",
                  style: TextStyle(color: Color(0xFFFBC23A), fontSize: 12)),
              Container(
                height: 12,
                width: AppSizes.maxWidth / 4,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  children: [
                    if (_currentEnemyBlood != 0)
                      Expanded(
                        flex: _currentEnemyBlood,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFFE4949),
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(8.0),
                                    right: Radius.circular(
                                        _currentEnemyBlood == 10 ? 8.0 : 0))),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8)),
                      ),
                    Expanded(
                      flex: total - _currentEnemyBlood,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(8.0),
                                  right: Radius.circular(8.0)))),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Text(
          "${(_currentEnemyBlood / total * 100).toInt()}/100",
          style: TextStyle(color: Colors.white, fontSize: 14),
        )
      ],
    );
  }

  List<Widget> _listAnswer() {
    List<Widget> itemList = [];
    for (int i = 0; i < 4; i++) {
      itemList.add(_answer(i, ontap: () {
        switch (i) {
          case 0:
            // check trả lời đúng sai , đúng thì dừng thời gian -
            _timer.cancel();
            if (_currentEnemyBlood == 0) {
              return;
            } else {
              setState(() {
                _currentEnemyBlood -= 2;
                print(_currentEnemyBlood);
                waterShotLeftToRight = true;
                _controllerWaterLeftToRight.forward();
              });
            }
          case 1:
            // check trả lời đúng sai , đúng thì dừng thời gian -
            _timer.cancel();
            if (_currentMyBlood == 0) {
              return;
            } else {
              _currentMyBlood -= 2;
              setState(() {
                waterShotLeftToRight = false;
                _controllerWaterRightToLeft.forward();
              });
            }
            break;

          case 2:
            break;

          case 3:
            _startTimer();
            break;
          default:
        }
      }));
    }
    return itemList;
  }

  void showPopupWin({bool isWin = false}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return DialogCongratulationWidget(
                isWin: isWin,
                ontapExit: () {
                  Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pop();
                },
              );
            },
          );
        });
  }

  Widget _answer(int i, {Function? ontap}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButtomImageColorWidget(
        orangeColor: i == 0,
        blueColor: i == 1,
        yellowColor: i == 2,
        redBlurColor: i == 3,
        child:
            Text("Đáp án", style: TextStyle(fontSize: 24, color: Colors.white)),
        onTap: ontap,
      ),
    );
  }

  Widget _menu() {
    return Positioned(
      right: 16,
      top: AppSizes.statusBarHeight,
      child: InkWell(
        onTap: () {
          GlobalSetting.shared.showPopup(context, onTapClose: () {
            Navigator.of(context).pop();
          }, onTapExit: () {
            Navigator.of(context)
              ..pop()
              ..pop()
              ..pop();
          }, onTapContinous: () {
            Navigator.of(context).pop();
          }, onTapPlayBack: () {
            Navigator.of(context).pop();
          });
        },
        child: ImageIcon(
          AssetImage(Assets.ic_menu),
          size: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _header(),
            Expanded(
                child: Container(
                    width: AppSizes.maxWidth,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Color(0xFFE97428)),
                        color: Color(0xFF467865)),
                    child: _body())),
            ..._listAnswer(),
            SizedBox(
              height: AppSizes.bottomHeight,
            )
          ],
        ),
      ),
    );
  }
}
