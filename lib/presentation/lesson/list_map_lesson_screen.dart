import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/model/maps/map_model.dart';
import 'package:chicken_combat/model/maps/user_map_model.dart';
import 'package:chicken_combat/model/store_model.dart';
import 'package:chicken_combat/model/user_model.dart';
import 'package:chicken_combat/presentation/map/map1_screen.dart';
import 'package:chicken_combat/presentation/map/map2_screen.dart';
import 'package:chicken_combat/presentation/map/map3_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/shared_pref_key.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListMapLessonScreen extends StatefulWidget {
  final String type;
  final bool isLesson;
  List<UserMapModel> items = [];

  ListMapLessonScreen(
      {super.key, this.type = "", required this.isLesson, required this.items});

  @override
  State<ListMapLessonScreen> createState() => _ListMapLessonScreenState();
}

class _ListMapLessonScreenState extends State<ListMapLessonScreen> with WidgetsBindingObserver, SingleTickerProviderStateMixin{
  List<MapModel> _listMap = [];
  List<UserMapModel> itemMaps = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int locationMap1 = 0;
  int locationMap2 = 0;
  late AudioManager _audioManager;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    itemMaps = widget.items;
    _listMap = Globals.mapsModel;
    _listMap = List.generate(_listMap.length, (index) => _listMap[index]);
    getUserInfo();
    _audioManager = AudioManager();
  }

  @override
  void dispose() {
    super.dispose();
  }

   void getUserInfo() {
    CollectionReference users = firestore.collection(FirebaseEnum.userdata);
    users
        .doc(Globals.prefs!.getString(SharedPrefsKey.id_user))
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        UserModel user = UserModel.fromSnapshot(documentSnapshot);
        Globals.currentUser = user;

        if (widget.type != "" && widget.type == "reading") {
          locationMap1 =
              Globals.currentUser!.courseMapModel.readingCourses.first.level;

          locationMap2 =
              Globals.currentUser!.courseMapModel.readingCourses.length > 1
                  ? Globals.currentUser!.courseMapModel.readingCourses[1]
                          .level
                  : 1;
          itemMaps = Globals.currentUser?.courseMapModel.readingCourses ?? [];
        } else if (widget.type != "" && widget.type == "listening") {
          locationMap1 = Globals
                  .currentUser!.courseMapModel.listeningCourses.first.level;
          locationMap2 =
              Globals.currentUser!.courseMapModel.listeningCourses.length > 1
                  ? Globals.currentUser!.courseMapModel.listeningCourses[1]
                          .level
                  : 1;
          itemMaps =
              Globals.currentUser?.courseMapModel.listeningCourses ?? [];
        } else if (widget.type != "" && widget.type == "speaking") {
          locationMap1 = Globals
                  .currentUser!.courseMapModel.speakingCourses.first.level;
          locationMap2 =
              Globals.currentUser!.courseMapModel.speakingCourses.length > 1
                  ? Globals.currentUser!.courseMapModel.speakingCourses[1]
                          .level 
                  : 1;
          itemMaps =
              Globals.currentUser?.courseMapModel.speakingCourses ?? [];
        }
        setState(() {});
      }
    });
  }


  Widget _buildBackground() {
    return Stack(
      children: [
        BackGroundCloudWidget(),
        Positioned(
          top: MediaQuery.of(context).padding.top / 2,
          left: 16.0,
          child: SafeArea(
            child: Positioned(
              top: AppSizes.maxHeight * 0.05,
              left: AppSizes.maxWidth * 0.03,
              child: GestureDetector(
                onTap: () {
                  // Hàm xử lý khi nhấn nút Back
                  Navigator.pop(context, true);
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
          image: AssetImage(ExtendedAssets.getAssetByCode("NOEL")),
          width: AppSizes.maxWidth * 0.3,
          height: AppSizes.maxHeight * 0.15,
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              var result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Map1Screen(
                        type: widget.type,
                        isLesson: widget.isLesson,
                        location: locationMap1,
                      )));
              if (result) {
                AudioManager.playRandomBackgroundMusic();
                getUserInfo();
              }
              break;
            case 1:
              var result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Map2Screen(
                      type: widget.type, isLesson: widget.isLesson,location: locationMap2)));
              if (result) {
                AudioManager.playRandomBackgroundMusic();
                getUserInfo();
              }
              break;
            case 2:
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Map3Screen(
                      type: widget.type, isLesson: widget.isLesson)));
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

