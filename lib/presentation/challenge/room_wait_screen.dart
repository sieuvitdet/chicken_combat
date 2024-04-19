import 'dart:math';
import 'dart:ui';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/battle/room_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/countdown_timer.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
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

  String _loadingText = 'Matching';
  bool hiddenGifPK = false;

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      AudioManager.playRandomBackgroundMusic();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildBottom() {
    return BackGroundCloudWidget();
  }

  Widget _buildContent() {
    return Column(
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
            Center(
              child: Image.asset(
                Assets.img_pk,
                fit: BoxFit.fitWidth,
                width: AppSizes.maxWidth * 0.25,
              ),
            ),
            SizedBox(
              width: 24,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(0),
                  child: Image.asset(
                    Assets.ic_chicken_hidden,
                    fit: BoxFit.contain,
                    width: AppSizes.maxWidth * 0.15,
                  ),
                ),
                Text(
                  "...",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )
              ],
            ),
          ],
        ),
        CountdownTimer(
          textStyle: TextStyle(
            fontSize: 24,
            color: Colors.white
          ),
          seconds: 60,
          onTimerComplete: () {
            removeRoomById(widget.room.id);
          },
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black), // Back icon
            onPressed: () {
              removeRoomById(widget.room.id);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
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
