import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/maps/map_model.dart';
import 'package:chicken_combat/model/maps/user_map_model.dart';
import 'package:chicken_combat/presentation/map/map1_screen.dart';
import 'package:chicken_combat/presentation/map/map2_screen.dart';
import 'package:chicken_combat/presentation/map/map3_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:flutter/material.dart';

class ListMapLessonScreen extends StatefulWidget {
  final String type;
  final bool isLesson;
  List<UserMapModel> items = [];

  ListMapLessonScreen({super.key, this.type = "", required this.isLesson, required this.items});

  @override
  State<ListMapLessonScreen> createState() => _ListMapLessonScreenState();
}

class _ListMapLessonScreenState extends State<ListMapLessonScreen> {

  List<MapModel> _listMap = [];
  List<UserMapModel> itemMaps = [];

  @override
  void initState() {
    super.initState();
    itemMaps = widget.items;
    _listMap = Globals.mapsModel;
    _listMap = List.generate(_listMap.length, (index) => _listMap[index]);
  }

  @override
  void dispose() {
    super.dispose();
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
        ..._listMaps()
      ],
    );
  }

  List<Widget> _listMaps() {
    List<Widget> itemList = [];
    for (int i = 0; i < _listMap.length; i++) {
      String mapId = _listMap[i].id;
      bool isLock = !itemMaps.any((userMap) => userMap.collectionMap == mapId);
      itemList.add(_map(i, _listMap[i], isLock));
    }
    return itemList;
  }

  Widget _map(int index, MapModel model, bool isLock) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButtomImageColorWidget(
        orangeColor: index == 0 && !isLock,
        blueColor: index == 1 && !isLock,
        redBlurColor: index == 2 && !isLock,
        child: Stack(
          children: [
            Center(
              child: Text(model.namemap,
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            Positioned(
                top: 0,
                bottom: 0,
                right: AppSizes.maxWidth / 5,
                child: (isLock)
                    ? ImageIcon(
                        AssetImage(Assets.ic_block),
                        color: Colors.white,
                      )
                    : Container())
          ],
        ),
        onTap: () async {
          AudioManager.playSoundEffect(AudioFile.sound_tap);
          if (isLock) {
            return;
          }
          switch (index) {
            case 0:
            Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Map1Screen(type: widget.type,isLesson: widget.isLesson,)));
            case 1:
              Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Map2Screen(type: widget.type,isLesson: widget.isLesson)));
              break;
            case 2:
            Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Map3Screen(type: widget.type,isLesson: widget.isLesson)));
              break;
            default:
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          _buildContent(),
        ],
      ),
    );
  }
}
