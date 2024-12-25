import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/maps/course_map_model.dart';
import 'package:chicken_combat/model/maps/user_map_model.dart';
import 'package:chicken_combat/presentation/lesson/list_map_lesson_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/shared_pref_key.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/utils/video_dialog.dart';
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
        // Positioned(
        //     top: AppSizes.maxHeight * 0.05,
        //     left: AppSizes.maxWidth * 0.02,
        //     child:
        //     // IconTheme(
        //     //   data: IconThemeData(size: 24.0), // Set the size here
        //     //   child: IconButton(
        //     //     icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
        //     //     onPressed: () {
        //     //       Navigator.of(context).pop(true);
        //     //     },
        //     //   ),
        //     // )
        // )
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16.0,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFFFEA9F)], // Gradient từ vàng sang đỏ
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Kích thước nút
              child: Icon(
                Icons.arrow_back_outlined,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          fit: BoxFit.contain,
          image: AssetImage(ExtendedAssets.getAssetByCode("TET")),
          width: AppSizes.maxWidth * 0.3,
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

  void showVideoDialogIfNeeded(BuildContext context, GestureTapCallback onTap, String video) async {
    bool? doNotShowAgain = Globals.prefs!.getBool(SharedPrefsKey.doNotShowAgainLession);
    if (doNotShowAgain == null || !doNotShowAgain) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return VideoDialog(onTap: onTap, urlVideo: video, keyPrefs: SharedPrefsKey.doNotShowAgainLession);
        },
      );
    } else {
      onTap();
    }
  }

  Widget _map(int typeId, String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
          showVideoDialogIfNeeded(context, () {
            Navigator.of(context).push(
              MaterialPageRoute(
              builder: (context) =>
                  ListMapLessonScreen(
                  type: type.toLowerCase(), isLesson: true, items: items)
              ));
          }, typeId == 0 ? 'assets/video/speaking_1.mp4' : typeId == 1 ? 'assets/video/listening_1.mp4' : 'assets/video/reading_1.mp4');
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
