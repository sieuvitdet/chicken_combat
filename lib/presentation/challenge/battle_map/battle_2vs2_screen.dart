import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/battle/room_model.dart';
import 'package:chicken_combat/model/battle/room_v2_model.dart';
import 'package:chicken_combat/model/course/ask_examination_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/model/store_model.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/countdown_timer.dart';
import 'package:chicken_combat/utils/string_utils.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/dialog_congratulation_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

import 'bloc/battle_2vs2_bloc.dart';

class Battle2Vs2Screen extends StatefulWidget {

  RoomV2Model? room;

  Battle2Vs2Screen({required this.room});

  @override
  State<Battle2Vs2Screen> createState() => _Battle2Vs2ScreenState();
}

class _Battle2Vs2ScreenState extends State<Battle2Vs2Screen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late Battle2vs2Bloc _bloc;

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

  late AnimationController _controllerGun;
  late Animation<double> _animationGun;

  int _currentEnemyBlood = 10, _currentMyBlood = 10, _total = 10;
  double _topWaterShot = 0.0, maxWidthTomato = 0.0;

  bool? isEnemyWin, waterShotLeftToRight;
  bool _isTomato = false, _startDelayed = false, _isOutRoom = false, _showQuestion = false, _isClick = false, _isShowPopup = false;

  RoomV2Model? _room;

  StatusBattle? _battle;
  int askPosition = 0;

  String? currentTeam, otherTeam;

  @override
  void initState() {
    super.initState();
    _bloc = Battle2vs2Bloc(context, widget.room!);
    _topWaterShot = (AppSizes.maxHeight > 800 ? (_isTomato ? 0.38 : 0.4) : (_isTomato ? 0.34 : 0.36))
        * AppSizes.maxHeight - AppSizes.maxHeight * 0.14;
    maxWidthTomato = AppSizes.maxWidthTablet > 0 ? AppSizes.maxWidthTablet : AppSizes.maxWidth;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _configAnimation();
      _configWaterShotAnimation();
      currentTeam = StringUtils.generateRandomTeam();
      otherTeam = StringUtils.generateRandomTeam();
    });
    _listenRoom(widget.room?.id ?? '');
    _listenBattle(widget.room?.status ?? '');
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controllerFirst.dispose();
    _controllerGun.dispose();
    _controllerWaterLeftToRight.dispose();
    _controllerWaterRightToLeft.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> _listenRoom(String _id) async {
    try {
      CollectionReference room =
      FirebaseFirestore.instance.collection(FirebaseEnum.roomV2);
      room.doc(_id).snapshots().listen((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          _room = RoomV2Model.fromSnapshot(documentSnapshot);
          if (_room?.users.length == 1) {
            if (_currentEnemyBlood != 0 && !_isOutRoom) {
              showPopupWin(isWin: true);
              setState(() {
                _isShowPopup = true;
              });
            }
          }
        }
      });
    } catch (e) {
      print('Error accessing Firestore: $e');
    }
  }

  Future<void> _listenBattle(String _id) async {
    try {
      CollectionReference room =
      FirebaseFirestore.instance.collection(FirebaseEnum.battlestatus);
      room.doc(_id).snapshots().listen((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            _battle = StatusBattle.fromSnapshot(documentSnapshot);
            _handleRoomUpdate(_battle!);
          });
        }
      });
    } catch (e) {
      print('Error accessing Firestore: $e');
    }
  }



  UserInfoRoomV2? getCurrentUserInfo() {
    if (_isOutRoom) {
      return null;
    }
    try {
      return _room?.users
          .firstWhere((user) => user.userId == Globals.currentUser?.id);
    } catch (e) {
      print("Current user not found in room.");
      throw Exception("Current user not found in room.");
    }
  }

  UserInfoRoomV2? getCurrentTeamUserInfo() {
    try {
      var currentUser = getCurrentUserInfo();
      if (currentUser == null) {
        print("No current user information available.");
        return null;
      }
      if (_room!.users.length == 1) {
        print("No current user information available.");
        return null;
      }
      var teamUser = _room?.users.firstWhere(
              (user) =>
          user.userId != Globals.currentUser?.id &&
              user.team == currentUser.team,
          orElse: () => throw Exception("Error finding other users: $e"));
      return teamUser;
    } catch (e) {
      print("Error finding a team member: $e");
      return null;
    }
  }

  List<UserInfoRoomV2>? getListOtherUserNotTeamInfo() {
    UserInfoRoomV2? currentUser = getCurrentUserInfo();
    if (currentUser == null) {
      print("No current user information available.");
      return [];
    }
    if (_room!.users.length == 1) {
      print("No current user information available.");
      return [];
    }
    try {
      List<UserInfoRoomV2> otherUsers = _room?.users
          .where((user) =>
      user.userId != Globals.currentUser?.id &&
          user.team != currentUser.team)
          .toList() ??
          [];
      if (otherUsers.isEmpty) {
        print("No other users found in room.");
        return [];
      }
      return otherUsers;
    } catch (e) {
      print("Error finding other users: $e");
      throw Exception("Error finding other users: $e");
    }
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
            _isShowPopup = true;
            showPopupWin(isWin: false);
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
            _isShowPopup = true;
            showPopupWin(isWin: true);
          }
        });
      }
    });

    _controllerGun = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animationGun =
        Tween<double>(begin: 0.0, end: -30.0).animate(_controllerGun)
          ..addListener(() {
            setState(() {
              // Rebuild the widget when animation value changes
            });
          });

    _controllerGun.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          _controllerGun.reset();
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
    path.moveTo(maxWidth - (40 + maxWidth * 0.18), _topWaterShot);
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
      width: AppSizes.maxWidthTablet > 0
          ? AppSizes.maxWidthTablet
          : AppSizes.maxWidth,
      child: Stack(
        children: [
          Image(
            image: AssetImage(Assets.gif_background_solo),
            fit: BoxFit.fill,
            height: AppSizes.maxHeight,
            width: AppSizes.maxWidthTablet > 0
                ? AppSizes.maxWidthTablet
                : AppSizes.maxWidth,
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
                  transform: Matrix4.rotationY(pi),
                  child: calculateLeftToRight(_animationWaterLeftToRight.value).dx <= (maxWidthTomato - (maxWidthTomato*0.5)) ? Image.asset(
                    _isTomato ? Assets.img_tomato : Assets.img_water_shot,
                    fit: BoxFit.contain,
                    width: _isTomato
                        ? AppSizes.maxWidth * 0.1
                        : AppSizes.maxWidth * 0.06,
                  ): Image.asset(
                    _isTomato ? Assets.img_tomato_broken : Assets.img_water_shot,
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
                  transform: Matrix4.rotationY(0),
                  child:calculateRightToLeft(_animationWaterRightToLeft.value).dx >= (maxWidthTomato - (maxWidthTomato*0.55)) ? Image.asset(
                    _isTomato ? Assets.img_tomato : Assets.img_water_shot,
                    fit: BoxFit.contain,
                    width: _isTomato
                        ? AppSizes.maxWidth * 0.1
                        : AppSizes.maxWidth * 0.06,
                  ):  Image.asset(
                    _isTomato ? Assets.img_tomato_broken : Assets.img_water_shot,
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
              child: StreamBuilder(
                  stream: _bloc.outputAsk,
                  builder: (context, snapshot) {
                    AskExaminationModel? ask = snapshot.data;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: SingleChildScrollView(
                        child: _showQuestion
                            ? Text(
                          ask!.Question,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          textAlign: TextAlign.start,
                        )
                            : CountdownTimer(
                          showIcon: false,
                          textStyle: TextStyle(
                              fontSize: 46, color: Colors.white),
                          seconds: 3,
                          onTimerComplete: () {
                            if (!_isShowPopup) {
                              setState(() {
                                _showQuestion = true;
                              });
                            }
                          },
                        ),
                      ),
                    );
                  }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _showQuestion
                    ? CountdownTimer(
                  showIcon: true,
                  textStyle: TextStyle(fontSize: 12, color: Colors.white),
                  seconds: 10,
                  onTimerComplete: () {
                    _showQuestion = false;
                    _bloc.currentQuestionPosition =
                        _bloc.currentQuestionPosition + 1;
                    _bloc.getQuestion();
                    if (_currentEnemyBlood == 0) {
                      _isShowPopup = true;
                      showPopupWin(isWin: false);
                    } else {
                      _currentEnemyBlood -= 2;
                    }
                    if (_currentMyBlood == 0) {
                      _isShowPopup = true;
                      showPopupWin(isWin: false);
                    } else {
                      _currentMyBlood -= 2;
                    }
                    setState(() {});
                  },
                )
                    : Container(),
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
          currentTeam  ?? '',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        (isEnemyWin != null && isEnemyWin!)
            ? Stack(
                children: [
                  Row(
                    children: [
                      Transform.rotate(
                          angle: _animationFirst.value *
                              3.1415926535 /
                              120, // Convert degrees to radians
                          origin: Offset(
                              0, 20), // Set the origin to BottomLeft coordinate
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
                          origin: Offset(
                              0, 20), // Set the origin to BottomLeft coordinate
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
                  ),
                ],
              )
            : Stack(
                children: [
                  Row(
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(0),
                        child: ShakeWidget(
                          duration: const Duration(seconds: 10),
                          shakeConstant: ShakeDefaultConstant1(),
                          autoPlay: true,
                          child: Image.asset(
                            getCurrentTeamUserInfo()?.usecolor != null
                                ? ExtendedAssets.getAssetByCode(
                                getCurrentTeamUserInfo()!.usecolor)
                                : ExtendedAssets.getAssetByCode('CO01'),
                            fit: BoxFit.contain,
                            width: AppSizes.maxWidth * 0.09,
                          ),
                        ),
                      ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(0),
                        child: ShakeWidget(
                          duration: const Duration(seconds: 10),
                          shakeConstant: ShakeDefaultConstant1(),
                          autoPlay: true,
                          child: Image.asset(
                            ExtendedAssets.getAssetByCode(
                                getCurrentUserInfo()?.usecolor ?? 'CO01'),
                            fit: BoxFit.contain,
                            width: AppSizes.maxWidth * 0.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // if ((waterShotLeftToRight != null && waterShotLeftToRight!)) Transform.rotate(
                  //     angle: _animationGun.value *
                  //         3.1415926535 /
                  //         120,
                  //     child: Transform.rotate(
                  //       angle: 70,
                  //       child: Image.asset(
                  //         Assets.ic_gun,
                  //         fit: BoxFit.contain,
                  //         width: 50,
                  //         height: 50,
                  //       ),
                  //     ))
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
          otherTeam ?? '',
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        (isEnemyWin != null && !isEnemyWin!)
            ? Row(
                children: [
                  Transform.rotate(
                      angle: _animation.value *
                          3.1415926535 /
                          180, // Convert degrees to radians
                      origin: Offset(
                          0, 20), // Set the origin to BottomLeft coordinate
                      child: ShakeWidget(
                        duration: const Duration(seconds: 10),
                        shakeConstant: ShakeDefaultConstant1(),
                        autoPlay: true,
                        child: Image.asset(
                          Assets.img_chicken_fall,
                          fit: BoxFit.contain,
                          width: AppSizes.maxWidth * 0.1,
                        ),
                      )),
                  Transform.rotate(
                      angle: _animation.value *
                          3.1415926535 /
                          120, // Convert degrees to radians
                      origin: Offset(
                          0, 20), // Set the origin to BottomLeft coordinate
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
                        getListOtherUserNotTeamInfo()!.isNotEmpty ?
                        ExtendedAssets.getAssetByCode(getListOtherUserNotTeamInfo()?[0].usecolor ?? 'CO01') :
                        ExtendedAssets.getAssetByCode('CO01'),
                        fit: BoxFit.contain,
                        width: AppSizes.maxWidth * 0.1,
                      ),
                    ),
                  ),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: ShakeWidget(
                      duration: const Duration(seconds: 10),
                      shakeConstant: ShakeDefaultConstant1(),
                      autoPlay: true,
                      child: Image.asset(
                        getListOtherUserNotTeamInfo()!.isNotEmpty ?
                        ExtendedAssets.getAssetByCode(getListOtherUserNotTeamInfo()?[1].usecolor ?? 'CO01') :
                        ExtendedAssets.getAssetByCode('CO01'),
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

  void _blood(bool isBloodCurrent) {
    if (isBloodCurrent) {
      if (_currentEnemyBlood == 0) {
        return;
      } else {
        setState(() {
          _currentEnemyBlood -= 2;
          waterShotLeftToRight = true;
          _controllerWaterLeftToRight.forward();
        });
      }
    } else {
      if (_currentMyBlood == 0) {
        return;
      } else {
        _currentMyBlood -= 2;
        setState(() {
          waterShotLeftToRight = false;
          _controllerWaterRightToLeft.forward();
        });
      }
    }
  }

  void _handleRoomUpdate(StatusBattle model) {
    if (model.userid.isEmpty) {
      print('Received update without user id, ignoring.');
      return;
    }
    if (_currentEnemyBlood == 0 || _currentMyBlood == 0) {
      print('emptys');
      return;
    }
    bool isCurrentTeam = getCurrentUserInfo()?.team == model.userid;
    bool isAnswerCorrect = model.correct;
    int position = model.askPosition;
    _bloc.currentQuestionPosition = position + 1;
    if ((isCurrentTeam && isAnswerCorrect) || (!isCurrentTeam && !isAnswerCorrect)) {
      _blood(true);
      if (!_isClick && !_isShowPopup) {
        _bloc.getQuestion();
      }
    } else {
      _blood(false);
      if (!_isClick && !_isShowPopup) {
        _bloc.getQuestion();
      }
    }
    _showQuestion = false;
    setState(() {});
  }

  List<Widget> _listAnswer() {
    List<Widget> itemList = [];
    for (int i = 0; i < 4; i++) {
      itemList.add(_answer(i, onTap: () async {
        _isClick = true;
        await _bloc.setSelected(i);
        await _bloc.onCheckAsk(getCurrentUserInfo()!.team.toString() ,i, _battle!);
        setState(() {
          _isClick = false;
        });
      }));
    }
    return itemList;
  }

  Future<void> updateUserRoomById(RoomV2Model room) async {
    try {
      setState(() {
        _isOutRoom = true;
      });
      await room.updateUsersRemove(room.users);
      Navigator.of(context)
        ..pop()
        ..pop()
        ..pop()
        ..pop();
    } catch (e) {
      print('Failed to update room: $e');
    }
  }

  Future<void> removeRoomById(String roomId) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseEnum.roomV2)
          .doc(roomId)
          .delete();
      Navigator.of(context)
        ..pop()
        ..pop()
        ..pop()
        ..pop();
      print("Room successfully deleted");
    } catch (e) {
      print("Error removing room: $e");
      throw Exception("Failed to remove the room: $e");
    }
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
                  if(_room?.users.length == 1) {
                    removeRoomById(widget.room?.id ?? '');
                  } else {
                    updateUserRoomById(widget.room!);
                  }
                  AudioManager.stopBackgroundMusic();
                },
              );
            },
          );
        });
  }

  Widget _answer(int i, {Function? onTap}) {
    return StreamBuilder(
        stream: _bloc.outputAnswer,
        builder: (context, snapshot) {
          List<String>? answer = snapshot.data;
          return StreamBuilder(
              stream: _bloc.outputSelected,
              builder: (context, snapshot) {
                int? selected = snapshot.data;
                askPosition = askPosition + 1;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: CustomButtomImageColorWidget(
                    redBlurColor: selected != i,
                    redColor: selected == i,
                    child: Text(answer?[i] ?? "",
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                    onTap: () {
                      if (onTap != null) {
                        onTap();
                      }
                      AudioManager.pauseBackgroundMusic();
                      AudioManager.playSoundEffect(AudioFile.sound_tomato_fly);
                    },
                  ),
                );
              }
          );
        }
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
            if(_room?.users.length == 1) {
              removeRoomById(widget.room?.id ?? '');
            } else {
              updateUserRoomById(widget.room!);
            }
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
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Responsive(mobile: Column(
          children: [
            _header(),
            Expanded(
                child: Container(
                    width: AppSizes.maxWidthTablet > 0
                        ? AppSizes.maxWidthTablet
                        : AppSizes.maxWidth,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Color(0xFFE97428)),
                        color: Color(0xFF467865)),
                    child: _body())),
            if (_showQuestion) ..._listAnswer(),
            SizedBox(
              height: AppSizes.bottomHeight,
            )
          ],
        ), tablet: Column(
          children: [
            _header(),
            Expanded(
                child: Container(
                    width: AppSizes.maxWidthTablet > 0
                        ? AppSizes.maxWidthTablet
                        : AppSizes.maxWidth,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Color(0xFFE97428)),
                        color: Color(0xFF467865)),
                    child: _body())),
            if (_showQuestion) ..._listAnswer(),
            SizedBox(
              height: AppSizes.bottomHeight,
            )
          ],
        ), desktop: Column(
          children: [
            _header(),
            Expanded(
                child: Container(
                    width: AppSizes.maxWidthTablet > 0
                        ? AppSizes.maxWidthTablet
                        : AppSizes.maxWidth,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Color(0xFFE97428)),
                        color: Color(0xFF467865)),
                    child: _body())),
            if (_showQuestion) ..._listAnswer(),
            SizedBox(
              height: AppSizes.bottomHeight,
            )
          ],
        )),
      ),
    );
  }
}
