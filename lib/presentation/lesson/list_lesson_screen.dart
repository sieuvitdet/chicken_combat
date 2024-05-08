import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/maps/course_map_model.dart';
import 'package:chicken_combat/model/maps/user_map_model.dart';
import 'package:chicken_combat/presentation/lesson/list_map_lesson_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:flutter/material.dart';

class ListLessonScreen extends StatefulWidget {
  CourseMapsModel courseMapModel;

  ListLessonScreen({required this.courseMapModel});

  @override
  State<ListLessonScreen> createState() => _ListLessonScreenState();
}

class _ListLessonScreenState extends State<ListLessonScreen> {
  List<String> _function = ["Speaking", "Listening", "Reading"];

  late CourseMapsModel mapsModel;

  @override
  void initState() {
    super.initState();
    mapsModel = widget.courseMapModel;
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        BackGroundCloudWidget(),
        Positioned(
            top: AppSizes.maxHeight * 0.06,
            left: AppSizes.maxWidth * 0.05,
            child: IconTheme(
              data: IconThemeData(size: 24.0), // Set the size here
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios,color: Colors.grey,),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ))
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          fit: BoxFit.contain,
          image: AssetImage(ExtendedAssets.getAssetByCode(Globals.currentUser!.useColor)),
          width: AppSizes.maxWidth * 0.2,
          height: AppSizes.maxHeight * 0.15,
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
          }
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ListMapLessonScreen(
                  type: type.toLowerCase(), isLesson: true, items: items)));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: Responsive(
            mobile: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                _buildContent(),
              ],
            ),
            tablet: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                _buildContent(),
              ],
            ),
            desktop: Stack(
              fit: StackFit.expand,
              children: [
                _buildBackground(),
                _buildContent(),
              ],
            )),
      ),
    );
  }
}
