import 'dart:math';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/battle/room_v2_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/presentation/challenge/battle_map/battle_2vs2_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/countdown_timer.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/animation/loading_dots.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomWait2v2Screen extends StatefulWidget {
  final RoomV2Model room;

  RoomWait2v2Screen(this.room);

  @override
  State<RoomWait2v2Screen> createState() => _RoomWait2v2ScreenState();
}

class _RoomWait2v2ScreenState extends State<RoomWait2v2Screen> with TickerProviderStateMixin {

  bool hiddenGifPK = true;
  bool isMatch = false;
  bool isOutRoom = false;
  RoomV2Model? _room;
  late AudioManager _audioManager;

  @override
  void initState() {
    super.initState();
    setupData();
    _audioManager = AudioManager();
    AudioManager.initVolumeListener();
    AudioManager.playRandomBackgroundMusic();
  }
  @override
  void dispose() {
    super.dispose();
  }

  void setupData() {
    _listenRoom(widget.room.id);
  }

  UserInfoRoomV2? getCurrentUserInfo() {
    if (isOutRoom) {
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

  void toggleHiddenGifPK() async {
    hiddenGifPK = false;
    print("hiddenGifPK is now set to false");
    await Future.delayed(Duration(seconds: 3));
    hiddenGifPK = true;
    print("hiddenGifPK is now set back to true");
  }

  bool isReadyBattle() {
    if (_room?.users == null) {
      print("Room data is not available.");
      return false;
    }
    bool allReady = _room!.users.every((userInfo) => userInfo.ready);
    return allReady;
  }

  Future<void> _listenRoom(String _id) async {
    CollectionReference room =
        FirebaseFirestore.instance.collection(FirebaseEnum.roomV2);
    room.doc(_id).snapshots().listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          if (!isOutRoom) {
            _room = RoomV2Model.fromSnapshot(documentSnapshot);
            if (_room!.users.length == 4) {
              isMatch = true;
              if(isReadyBattle()) {
                toggleHiddenGifPK();
                Future.delayed(Duration(seconds: 2), () {
                  if (_room != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Battle2Vs2Screen(room: _room)));
                  }
                });
              }
            } else {
              isMatch = false;
            }
          }
        });
      }
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
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(0),
                            child: Image.asset(
                              getCurrentTeamUserInfo()?.usecolor != null
                                  ? ExtendedAssets.getAssetByCode(
                                      getCurrentTeamUserInfo()!.usecolor)
                                  : Assets.ic_chicken_hidden,
                              fit: BoxFit.contain,
                              width: AppSizes.maxWidth * 0.12,
                            ),
                          ),
                          Container(
                            width: AppSizes.maxWidth * 0.16,
                            child: Expanded(
                              child: Center(
                                child: Text(
                                  getCurrentTeamUserInfo()?.username ?? '...',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        children: [
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(0),
                            child: Image.asset(
                              ExtendedAssets.getAssetByCode(
                                  getCurrentUserInfo()?.usecolor ?? 'CO01'),
                              fit: BoxFit.contain,
                              width: AppSizes.maxWidth * 0.16,
                            ),
                          ),
                          Container(
                            width: AppSizes.maxWidth * 0.16,
                            child: Expanded(
                              child: Center(
                                child: Text(
                                  getCurrentUserInfo()?.username ?? '...',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ),
                          )
                        ],
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

                      Column(
                        children: [
                          Transform(
                            alignment: Alignment.center,
                            transform: isMatch
                                ? Matrix4.rotationY(pi)
                                : Matrix4.rotationY(0),
                            child: Image.asset(
                                getListOtherUserNotTeamInfo()!.isNotEmpty ?
                                ExtendedAssets.getAssetByCode(getListOtherUserNotTeamInfo()![0].usecolor) :
                                Assets.ic_chicken_hidden,
                              fit: BoxFit.contain,
                              width: AppSizes.maxWidth * 0.16,
                            ),
                          ),
                          Container(
                            width: AppSizes.maxWidth * 0.16,
                            child: Text(
                                getListOtherUserNotTeamInfo()!.isNotEmpty ?
                                getListOtherUserNotTeamInfo()![0].username :
                                '...',
                              style: TextStyle(fontSize: 14, color: Colors.white,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        children: [
                          Transform(
                            alignment: Alignment.center,
                            transform: isMatch
                                ? Matrix4.rotationY(pi)
                                : Matrix4.rotationY(0),
                            child: Image.asset(
                              getListOtherUserNotTeamInfo()?.length == 2 ?
                              ExtendedAssets.getAssetByCode(getListOtherUserNotTeamInfo()![1].usecolor) :
                              Assets.ic_chicken_hidden,
                              fit: BoxFit.contain,
                              width: AppSizes.maxWidth * 0.12,
                            ),
                          ),
                          Container(
                            width: AppSizes.maxWidth * 0.16,
                            child: Text(
                              getListOtherUserNotTeamInfo()?.length == 2 ?
                              getListOtherUserNotTeamInfo()![1].username :
                              '...',
                              style: TextStyle(fontSize: 14, color: Colors.white,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                  isMatch
                      ? Container()
                      : CountdownTimer(
                    textStyle:
                    TextStyle(fontSize: 24, color: Colors.white),
                    seconds: 120,
                    onTimerComplete: () {
                        removeRoomById(_room!.id);
                        Navigator.of(context)..pop()..pop();
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
                orangeColor: getCurrentUserInfo()?.ready == false ? true : false,
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
              if(_room?.users.length == 1) {
                  removeRoomById(_room!.id);
              } else {
                  updateUserRoomById(_room!);
              }
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

  Future<void> updateUserRoomById(RoomV2Model room) async {
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

  Future<void> removeRoomById(String roomId) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseEnum.roomV2)
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

  Future<void> updateUserReady(RoomV2Model room) async {
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
