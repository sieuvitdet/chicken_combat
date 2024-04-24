import 'dart:math';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/battle/room_v2_model.dart';
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

  void initState() {
    super.initState();
    setupData();
    Future.delayed(Duration.zero, () {
      AudioManager.playRandomBackgroundMusic();
    });
  }

  void setupData() {
    _listenRoom(widget.room.id ?? '');
  }

  UserInfoRoomV2? getCurrentUserInfo() {
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
      if (_room?.users.length == 1) {
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
      throw Exception("Error finding a team member: $e");
    }
  }

  List<UserInfoRoomV2>? getListOtherUserNotTeamInfo() {
    UserInfoRoomV2? currentUser = getCurrentUserInfo();
    if (currentUser == null) {
      print("No current user information available.");
      return [];
    }
    if (_room!.users.length <= 2) {
      print("No current user information available.");
      return null;
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

  Future<void> _listenRoom(String _id) async {
    CollectionReference room =
        FirebaseFirestore.instance.collection(FirebaseEnum.roomV2);
    room.doc(_id).snapshots().listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          _room = RoomV2Model.fromSnapshot(documentSnapshot);
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
                                getListOtherUserNotTeamInfo()!.length == 1 ?
                                ExtendedAssets.getAssetByCode(getListOtherUserNotTeamInfo()![0].usecolor) :
                                Assets.ic_chicken_hidden,
                              fit: BoxFit.contain,
                              width: AppSizes.maxWidth * 0.16,
                            ),
                          ),
                          Container(
                            width: AppSizes.maxWidth * 0.16,
                            child: Text(
                                getListOtherUserNotTeamInfo()!.length == 1 ?
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
                              getListOtherUserNotTeamInfo()!.length == 2 ?
                              ExtendedAssets.getAssetByCode(getListOtherUserNotTeamInfo()![0].usecolor) :
                              Assets.ic_chicken_hidden,
                              fit: BoxFit.contain,
                              width: AppSizes.maxWidth * 0.12,
                            ),
                          ),
                          Container(
                            width: AppSizes.maxWidth * 0.16,
                            child: Text(
                              getListOtherUserNotTeamInfo()!.length == 2 ?
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
                    seconds: 60,
                    onTimerComplete: () {
                      //removeRoomById(_room!.id);
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
                orangeColor: true,
                //_currentInfo(true)?.ready == false ? true : false,
                child: Text(AppLocalizations.text(LangKey.ready),
                    style: TextStyle(fontSize: 24, color: Colors.white)),
                onTap: () {
                  //updateUserReady(_room!);
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
              // isMatch
              //     ? updateUserRoomById(_room!)
              //     : removeRoomById(_room!.id);
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
