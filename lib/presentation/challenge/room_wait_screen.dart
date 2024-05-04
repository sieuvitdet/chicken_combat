import 'dart:math';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/battle/room_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/model/store_model.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/countdown_timer.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/animation/loading_dots.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'battle_map/battle_1vs1_screen.dart';

class RoomWaitScreen extends StatefulWidget {
  final RoomModel room;
  RoomWaitScreen(this.room);

  @override
  State<RoomWaitScreen> createState() => _RoomWaitScreenState();
}

class _RoomWaitScreenState extends State<RoomWaitScreen>
    with TickerProviderStateMixin {
  bool hiddenGifPK = true;
  bool isMatch = false;
  bool isOutRoom = false;
  RoomModel? _room;

  void initState() {
    super.initState();
    setupData();
    Future.delayed(Duration.zero, () {
      AudioManager.playRandomBackgroundMusic();
    });
  }

  void setupData() {
    _room = widget.room;
    _listenRoom(_room?.id ?? '');
  }

  UserInfoRoom? getCurrentUserInfo() {
    try {
      return _room?.users.firstWhere((user) => user.userId == Globals.currentUser?.id);
    } catch (e) {
      print("Current user not found in room.");
    }
    return null;
  }

  UserInfoRoom? getOtherUserInfo() {
    try {
      return _room?.users.firstWhere((user) => user.userId != Globals.currentUser?.id);
    } catch (e) {
      print("No other users found in room.");
    }
    return null;
  }

  UserInfoRoom? _currentInfo(bool printCurrentUser) {
    UserInfoRoom? userInfo;
    if (!isOutRoom) {
      if (printCurrentUser) {
        userInfo = getCurrentUserInfo();
      } else {
        userInfo = getOtherUserInfo();
      }
    }
    return userInfo;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _listenRoom(String _id) async {
    CollectionReference room =
    FirebaseFirestore.instance.collection(FirebaseEnum.room);
    room.doc(_id).snapshots().listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(()  {
          if (!isOutRoom) {
            _room = RoomModel.fromSnapshot(documentSnapshot);
            if (_room!.users.length == 1) {
              isMatch = false;
            } else {
              isMatch = true;
              if(isReadyBattle()) {
                toggleHiddenGifPK();
                Future.delayed(Duration(seconds: 3), () {
                  if (_room != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Battle1Vs1Screen(room: _room)));
                  }
                });
              }
            }
          }
        });
      }
    });
  }

  void toggleHiddenGifPK() async {
    hiddenGifPK = false;
    print("hiddenGifPK is now set to false");
    await Future.delayed(Duration(seconds: 3));
    hiddenGifPK = true;
    print("hiddenGifPK is now set back to true");
  }

  bool isReadyBattle()  {
    UserInfoRoom? currentUserInfo = getCurrentUserInfo();
    if (currentUserInfo == null || !currentUserInfo.ready) {
      return false;
    }
    UserInfoRoom? otherUserInfo = getOtherUserInfo();
    if (otherUserInfo == null || !otherUserInfo.ready) {
      return false;
    }
    return true;
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
                      Column(
                        children: [
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(0),
                            child: Image.asset(
                              ExtendedAssets.getAssetByCode(_currentInfo(true)?.usecolor ?? 'SK01'),
                              fit: BoxFit.contain,
                              width: AppSizes.maxWidth * 0.16,
                            ),
                          ),
                          Container(
                            width: AppSizes.maxWidth * 0.16,
                            child: Text(
                              _currentInfo(true)!.username,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        ],
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
                      Column(
                        children: [
                          Transform(
                            alignment: Alignment.center,
                            transform: isMatch
                                ? Matrix4.rotationY(pi)
                                : Matrix4.rotationY(0),
                            child: Image.asset(
                              isMatch
                                  ? ExtendedAssets.getAssetByCode(_currentInfo(false)?.usecolor ?? 'SK01')
                              : Assets.ic_chicken_hidden,
                              fit: BoxFit.contain,
                              width: AppSizes.maxWidth * 0.16,
                            ),
                          ),
                          Container(
                            width: AppSizes.maxWidth * 0.16,
                            child: Text(
                              isMatch ? _currentInfo(false)!.username : '...',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  isMatch
                      ? Container()
                      : CountdownTimer(
                          textStyle:
                              TextStyle(fontSize: 24, color: Colors.white),
                          seconds: 60,
                          onTimerComplete: () {
                            removeRoomById(_room!.id);
                          },
                        ),
                ],
              )
            ],
          ),
        ),
        isMatch
            ? Positioned(
                bottom: 32,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    LoadingDots(
                      text: AppLocalizations.text(LangKey.waiting_for_opponents),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    CustomButtomImageColorWidget(
                      orangeColor: _currentInfo(true)?.ready == false ? true : false,
                      child: Text(AppLocalizations.text(LangKey.ready),
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      onTap: () {
                        updateUserReady(_room!);
                      },
                    ),
                  ],
                ),
              )
            : Container(),
        Positioned(
          top: AppSizes.maxHeight * 0.06,
          left: 8.0,
          child: GestureDetector(
            onTap: () {
              isMatch
                  ? updateUserRoomById(_room!)
                  : removeRoomById(_room!.id);
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

  Future<void> removeRoomById(String roomId) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseEnum.room)
          .doc(_room!.id)
          .delete();
      await FirebaseFirestore.instance
          .collection(FirebaseEnum.battlestatus)
          .doc(_room!.status)
          .delete();
      Navigator.of(context)..pop()..pop();
    } catch (e) {
      print("Error removing room: $e");
      throw Exception("Failed to remove the room: $e");
    }
  }

  Future<void> updateUserRoomById(RoomModel room) async {
    try {
      setState(() {
        isOutRoom = true;
      });
      await room.updateUsersRemove(room.users);
      Navigator.of(context)..pop()..pop();
    } catch (e) {
      print('Failed to update room: $e');
    }
  }

  Future<void> updateUserReady(RoomModel room) async {
    try {
      await room.updateUsersReady(room.users);
    } catch (e) {
      print('Failed to update room: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        backgroundColor: Color(0xFFFACA44),
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
