import 'dart:math';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/battle/room_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/countdown_timer.dart';
import 'package:chicken_combat/widgets/animation/loading_dots.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _listenRoom(String _id) async {
    CollectionReference room =
    FirebaseFirestore.instance.collection(FirebaseEnum.room);
    room.doc(_id).snapshots().listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          _room = RoomModel.fromSnapshot(documentSnapshot);
          if(_room!.users.length > 1) {
            isMatch = true;
          } else {
            isMatch = false;
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
                      Column(
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
                                  ? Assets.img_chicken_green
                                  : Assets.ic_chicken_hidden,
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
                    ],
                  ),
                  isMatch
                      ? Container()
                      : CountdownTimer(
                          textStyle:
                              TextStyle(fontSize: 24, color: Colors.white),
                          seconds: 60,
                          onTimerComplete: () {
                            removeRoomById(widget.room.id);
                          },
                        ),
                ],
              )
            ],
          ),
        ),
        isMatch
            ? Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    LoadingDots(
                      text: 'Đang chờ đối thủ',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(
                      height: 8,
                    ),
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
              )
            : Container(),
        Positioned(
          top: AppSizes.maxHeight * 0.06,
          left: 8.0,
          child: GestureDetector(
            onTap: () {
              isMatch
                  ? updateUserRoomById(widget.room)
                  : removeRoomById(widget.room.id);
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
          .doc(roomId)
          .delete();
      Navigator.of(context)..pop()..pop();
    } catch (e) {
      print("Error removing room: $e");
      throw Exception("Failed to remove the room: $e");
    }
  }

  Future<void> updateUserRoomById(RoomModel room) async {
    await room.updateUsersRemove();
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
