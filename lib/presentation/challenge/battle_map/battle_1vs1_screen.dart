import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/battle/room_model.dart';
import 'package:chicken_combat/model/course/ask_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/model/store_model.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/dialog_congratulation_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

class Battle1Vs1Screen extends StatefulWidget {
  final RoomModel room;

  Battle1Vs1Screen({required this.room});

  @override
  State<Battle1Vs1Screen> createState() => _Battle1Vs1ScreenState();
}

class _Battle1Vs1ScreenState extends State<Battle1Vs1Screen>
    with TickerProviderStateMixin, WidgetsBindingObserver  {
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
  bool _isTomato = true;

  double maxWidthTomato = 0.0;

  late RoomModel _room;

  late AskModel _ask;
  List<AskModel> _asks = [];
  List<String> answers = [];

  int? result;

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    if (_isTomato) {
      _topWaterShot = AppSizes.maxHeight > 800 ? AppSizes.maxHeight * 0.38 - AppSizes.maxHeight * 0.14 : AppSizes.maxHeight * 0.34 - AppSizes.maxHeight * 0.14;
    } else {
      _topWaterShot = AppSizes.maxHeight > 800 ? AppSizes.maxHeight * 0.4 - AppSizes.maxHeight * 0.14 : AppSizes.maxHeight * 0.36 - AppSizes.maxHeight * 0.14;
    }
    maxWidthTomato = AppSizes.maxWidthTablet > 0
        ? AppSizes.maxWidthTablet
        : AppSizes.maxWidth;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _configAnimation();
      _configWaterShotAnimation();
      _startTimer();
      _loadAsk();
      _listenRoom(_room.id);
    });
    AudioManager.playBackgroundMusic(AudioFile.sound_pk1);
    WidgetsBinding.instance.addObserver(this);
  }

   void dispose() {
    _controller.dispose();
    _controllerWaterLeftToRight.dispose();
    _controllerWaterRightToLeft.dispose();
    _controllerFirst.dispose();
    _controller.removeListener(() { });
    _controllerFirst.removeListener(() { });
    _controllerWaterLeftToRight.removeListener(() { });
    _controllerWaterRightToLeft.removeListener(() { });
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _loadAsk() {
    if (_room.asks.isNotEmpty) {
      _asks = _room.asks;
    }
  }

  bool _checkWaitBattle() {
    if (_room.users.length == 1) {
      return true;
    } else {
      return false;
    }
  }

  UserInfoRoom _currentInfo(bool printCurrentUser) {
    UserInfoRoom? userInfo;

    if (printCurrentUser) {
      userInfo = _room.users.firstWhere(
              (user) => user.userId == Globals.currentUser?.id,
          orElse: () => throw Exception("Current user not found in room.")
      );
    } else {
      userInfo = _room.users.firstWhere(
              (user) => user.userId != Globals.currentUser?.id,
          orElse: () => throw Exception("No other users found in room.")
      );
    }
    return userInfo;
  }

  Future<void> removeRoomById(String roomId) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseEnum.room)  // Make sure this matches the exact name of your collection
          .doc(roomId)
          .delete();
      print("Room successfully deleted");
    } catch (e) {
      print("Error removing room: $e");
      throw Exception("Failed to remove the room: $e");
    }
  }

  Future<void> _listenRoom(String _id) async {
    CollectionReference room =
    FirebaseFirestore.instance.collection(FirebaseEnum.room);
    room.doc(_id).snapshots().listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        setState(() {
            _room = RoomModel.fromSnapshot(documentSnapshot);
        });
      }
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
    double maxWidth = AppSizes.maxWidthTablet > 0
        ? AppSizes.maxWidthTablet
        : AppSizes.maxWidth;
    path.moveTo(16 + maxWidth * 0.18, _topWaterShot);
    path.quadraticBezierTo(maxWidth / 2, _topWaterShot - (_isTomato ? 50 : 0),
        maxWidth - (40 + maxWidth * 0.18), _topWaterShot);
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
    double maxWidth = AppSizes.maxWidthTablet > 0
        ? AppSizes.maxWidthTablet
        : AppSizes.maxWidth;
    path.moveTo(
        maxWidth - (40 + maxWidth * 0.18), _topWaterShot);
    path.quadraticBezierTo(maxWidth / 2, _topWaterShot - (_isTomato ? 50 : 0),
        16 + maxWidth * 0.18, _topWaterShot);
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
      width: AppSizes.maxWidthTablet > 0 ? AppSizes.maxWidthTablet : AppSizes.maxWidth,
      child: Stack(
        children: [
          Image(
            image: AssetImage(Assets.gif_background_sea),
            fit: BoxFit.fill,
            height: AppSizes.maxHeight,
            width: AppSizes.maxWidthTablet > 0 ? AppSizes.maxWidthTablet : AppSizes.maxWidth,
          ),
          _menu(),
          Positioned(
            bottom: 8,
            left: _checkWaitBattle() ? (AppSizes.maxWidth / 2.5) -
                (AppSizes.maxWidth * 0.1 / 2) : 16,
            // Center _myChicken if _checkWaitBattle is true
            child: _myChicken(_total),
          ),
          if (_checkWaitBattle()) ...[],
          // No enemy chicken when _checkWaitBattle is true
          if (!_checkWaitBattle()) // Only show _enemyChicken if _checkWaitBattle is false
            Positioned(
              bottom: 8,
              right: 16,
              child: _enemyChicken(_total),
            ),
          // Your existing water shot logic
          if (waterShotLeftToRight != null && waterShotLeftToRight!)
            Positioned(
              top: calculateLeftToRight(_animationWaterLeftToRight.value).dy,
              left: calculateLeftToRight(_animationWaterLeftToRight.value).dx,
              child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child:
                  calculateLeftToRight(_animationWaterLeftToRight.value).dx <=
                      (maxWidthTomato - (maxWidthTomato * 0.5)) ?
                  Image.asset(
                    _isTomato ? Assets.img_tomato : Assets.img_water_shot,
                    fit: BoxFit.contain,
                    width: _isTomato ? AppSizes.maxWidth * 0.1 : AppSizes
                        .maxWidth * 0.06,
                  ) : Image.asset(
                    _isTomato ? Assets.img_tomato_broken : Assets.img_water_shot,
                    fit: BoxFit.contain,
                    width: _isTomato ? AppSizes.maxWidth * 0.1 : AppSizes
                        .maxWidth * 0.06,
                  )),
            ),
          if (waterShotLeftToRight != null && !waterShotLeftToRight!)
            Positioned(
              top: calculateRightToLeft(_animationWaterRightToLeft.value).dy,
              left: calculateRightToLeft(_animationWaterRightToLeft.value).dx,
              child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: calculateRightToLeft(_animationWaterRightToLeft.value)
                      .dx >= (maxWidthTomato - (maxWidthTomato * 0.55)) ?
                  Image.asset(
                    _isTomato ? Assets.img_tomato : Assets.img_water_shot,
                    fit: BoxFit.contain,
                    width: _isTomato ? AppSizes.maxWidth * 0.1 : AppSizes
                        .maxWidth * 0.06,
                  ) :  Image.asset(
                    _isTomato ? Assets.img_tomato_broken : Assets.img_water_shot,
                    fit: BoxFit.contain,
                    width: _isTomato ? AppSizes.maxWidth * 0.1 : AppSizes
                        .maxWidth * 0.06,
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
                    _checkWaitBattle() ? "Đang chờ đối thủ $_start s"
                        : _ask.Question,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
            _checkWaitBattle() ? Container()
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset((Assets.ic_boom),width: 24),
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
              height: AppSizes.maxHeight*0.02,
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
          _currentInfo(true).username,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        (isEnemyWin != null && isEnemyWin!)
            ? Transform.rotate(
                angle: _animationFirst.value *
                    3.1415926535 /
                    180, // Convert degrees to radians
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
            : Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(0),
                child: ShakeWidget(
                  duration: const Duration(seconds: 10),
                  shakeConstant: ShakeDefaultConstant1(),
                  autoPlay: true,
                  child: Image.asset(
                    ExtendedAssets.getAssetByCode(_currentInfo(true).usecolor),
                    fit: BoxFit.contain,
                    width: AppSizes.maxWidth * 0.1,
                  ),
                ),
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
          _currentInfo(false).username,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        (isEnemyWin != null && !isEnemyWin!)
            ? Transform.rotate(
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
                ))
            : Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(pi),
                child: ShakeWidget(
                  duration: const Duration(seconds: 10),
                  shakeConstant: ShakeDefaultConstant1(),
                  autoPlay: true,
                  child: Image.asset(
                    ExtendedAssets.getAssetByCode( _currentInfo(false).usecolor),
                    fit: BoxFit.contain,
                    width: AppSizes.maxWidth * 0.1,
                  ),
                ),
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
    for (int i = 0; i < answers.length; i++) {
      itemList.add(_answer(answers[i], i, ontap: () {
        if (_checkWaitBattle()) {
              AudioManager.stopBackgroundMusic();
              removeRoomById(_room.id);
              Navigator.of(context)
                ..pop()
                ..pop()..pop();
        } else {
            if(AskModel.answerToIndex(_ask.Answer) == i) {

            } else {

            }
        }
        // switch (i) {
        //   case 0:
        //     // check trả lời đúng sai , đúng thì dừng thời gian -
        //   if (_checkWaitBattle()) {
        //     AudioManager.stopBackgroundMusic();
        //     removeRoomById(_room.id);
        //     Navigator.of(context)
        //       ..pop()
        //       ..pop()..pop();
        //   } else {
        //     _timer.cancel();
        //     if (_currentEnemyBlood == 0) {
        //       return;
        //     } else {
        //       setState(() {
        //         _currentEnemyBlood -= 2;
        //         print(_currentEnemyBlood);
        //         waterShotLeftToRight = true;
        //         _controllerWaterLeftToRight.forward();
        //       });
        //     }
        //   }
        //   case 1:
        //     // check trả lời đúng sai , đúng thì dừng thời gian -
        //     _timer.cancel();
        //     if (_currentMyBlood == 0) {
        //       return;
        //     } else {
        //       _currentMyBlood -= 2;
        //       setState(() {
        //         waterShotLeftToRight = false;
        //         _controllerWaterRightToLeft.forward();
        //       });
        //     }
        //     break;
        //
        //   case 2:
        //     break;
        //
        //   case 3:
        //     _startTimer();
        //     break;
        //   default:
        // }
      }));
    }
    return itemList;
  }

  void showPopupWin({bool isWin = false}) {
    AudioManager.pauseBackgroundMusic();
    AudioManager.playSoundEffect(AudioFile.sound_victory);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return DialogCongratulationWidget(
                isWin: isWin,
                ontapExit: () {
                  AudioManager.stopBackgroundMusic();
                  Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pop()
                    ..pop();
                    /////
                },
              );
            },
          );
        });
  }

  Widget _answer(String answer, int i, {Function? ontap}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButtomImageColorWidget(
        orangeColor: i == 0,
        blueColor: i == 1,
        yellowColor: i == 2,
        redBlurColor: i == 3,
        child:
            Text(answer, style: TextStyle(fontSize: 24, color: Colors.white)),
        onTap: () {
          if (ontap != null) {
            ontap();
          }
          AudioManager.pauseBackgroundMusic();
          AudioManager.playSoundEffect(AudioFile.sound_tomato_fly);
        },
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
            AudioManager.stopBackgroundMusic();
            Navigator.of(context)
              ..pop()
              ..pop()
              ..pop()
              ..pop();
          }, onTapContinous: () {
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
        backgroundColor: Colors.amber,
        body: Responsive(mobile: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _header(),
            Expanded(
                child: Container(
                    width: AppSizes.maxWidthTablet > 0 ? AppSizes.maxWidthTablet : AppSizes.maxWidth,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Color(0xFFE97428)),
                        color: Color(0xFF467865)),
                    child: _body())),
            ..._listAnswer(),
            SizedBox(
              height: AppSizes.bottomHeight,
            )
          ],
        ),tablet: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _header(),
            Expanded(
                child: Container(
                    width: AppSizes.maxWidthTablet > 0 ? AppSizes.maxWidthTablet : AppSizes.maxWidth,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Color(0xFFE97428)),
                        color: Color(0xFF467865)),
                    child: _body())),
            ..._listAnswer(),
            SizedBox(
              height: AppSizes.bottomHeight,
            )
          ],
        ),desktop: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _header(),
            Expanded(
                child: Container(
                    width: AppSizes.maxWidthTablet > 0 ? AppSizes.maxWidthTablet : AppSizes.maxWidth,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Color(0xFFE97428)),
                        color: Color(0xFF467865)),
                    child: _body())),
            ... _listAnswer(),
            SizedBox(
              height: AppSizes.bottomHeight,
            )
          ],
        ),),
      ),
    );
  }
}
