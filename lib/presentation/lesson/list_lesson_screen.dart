import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/lesson/list_map_lesson_screen.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:flutter/material.dart';

class ListLessonScreen extends StatefulWidget {
  const ListLessonScreen({super.key});

  @override
  State<ListLessonScreen> createState() => _ListLessonScreenState();
}

class _ListLessonScreenState extends State<ListLessonScreen> {
  List<String> _function = ["Speaking", "Listening", "Reading"];
  @override
  void initState() {
    super.initState();
  }

  Widget _buildBackground() {
    return BackGroundCloudWidget();
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          fit: BoxFit.fitHeight,
          image: AssetImage(Assets.chicken_flapping_swing_gif),
          width: AppSizes.maxWidth * 0.3,
          height: AppSizes.maxHeight * 0.18,
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
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ListMapLessonScreen(type: type.toLowerCase(),isLesson: true,)));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(mobile: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          _buildContent(),
        ],
      ), tablet: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          _buildContent(),
        ],
      ), desktop: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          _buildContent(),
        ],
      )),
    );
  }
}
