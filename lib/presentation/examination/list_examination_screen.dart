import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/maps/course_map_model.dart';
import 'package:chicken_combat/model/maps/user_map_model.dart';
import 'package:chicken_combat/presentation/examination/list_map_examination_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:flutter/material.dart';

class ListExaminationScreen extends StatefulWidget {
  CourseMapsModel mapModel;

  ListExaminationScreen({required this.mapModel});
  @override
  State<ListExaminationScreen> createState() => _ListExaminationScreenState();
}

class _ListExaminationScreenState extends State<ListExaminationScreen> {
  List<String> _function = ["Speaking", "Listening", "Reading", "Writing"];
  late CourseMapsModel mapsModel;

  @override
  void initState() {
    super.initState();
    mapsModel = widget.mapModel;
  }

  Widget _buildBackground() {
    return BackGroundCloudWidget();
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          fit: BoxFit.contain,
          image: AssetImage(Assets.gif_chicken_white_candy),
          width: AppSizes.maxWidth * 0.34,
          height: AppSizes.maxHeight * 0.2,
        ),
        ..._listMap()
      ],
    );
  }

  List<Widget> _listMap() {
    List<Widget> itemList = [];
    for (int i = 0; i < _function.length; i++) {
      itemList.add(_map(i, _function[i]));
    }
    return itemList;
  }

  Widget _map(int typeId, String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButtomImageColorWidget(
        orangeColor: typeId == 0,
        blueColor: typeId == 1,
        redBlurColor: typeId == 2,
        greenColor: typeId == 3,
        child: Text(type, style: TextStyle(fontSize: 16, color: Colors.white)),
        onTap: () async {
          AudioManager.playSoundEffect(AudioFile.sound_tap);
          List<UserMapModel> items = [];
          switch (typeId) {
            case 0:
              items = mapsModel.speakingCourses;
            case 1:
              items = mapsModel.listeningCourses;
            case 2:
              items = mapsModel.readingCourses;
            case 3:
              items = mapsModel.writingCourses;
          }
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ListMapExaminationScreen(
                    type: type.toLowerCase(),
                    isLesson: false,
                    items: items,
                  )));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFACA44),
      body: Responsive(
        mobile: Center(
          child: Container(
            width: AppSizes.maxWidth,
            height: AppSizes.maxHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                _buildContent(),
              ],
            ),
          ),
        ),
        tablet: Center(
          child: Container(
            width: AppSizes.maxWidth,
            height: AppSizes.maxHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                _buildContent(),
              ],
            ),
          ),
        ),
        desktop: Center(
          child: Container(
            width: AppSizes.maxWidth,
            height: AppSizes.maxHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}