
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/course/ask_lesson_model.dart';
import 'package:chicken_combat/model/course/ask_speaking_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/presentation/home/home_screen.dart';
import 'package:chicken_combat/presentation/lesson/map_reading_lesson_anwser_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/shared_pref_key.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class MapReadingLessonScreen extends StatefulWidget {
  final bool isGetReward;
  final int level;
  const MapReadingLessonScreen(
      {super.key, this.isGetReward = false, required this.level});

  @override
  State<MapReadingLessonScreen> createState() => _MapReadingLessonScreenState();
}

class _MapReadingLessonScreenState extends State<MapReadingLessonScreen>
    with WidgetsBindingObserver {
  String text = "";
  var _isKeyboardVisible = false;

CarouselSliderController buttonCarouselController = CarouselSliderController();

  late AskLessonModel _ask = AskLessonModel(
      Script: "", Content: "", Quiz:[]);
  List<AskLessonModel> _asks = [];
  List<String> answers = [];

  @override
  void initState() {
    super.initState();
    AudioManager.pauseBackgroundMusic();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _asks = await _loadAsks();
      if (_asks.length > 0) {
        _ask = _asks[0];
      }
      setState(() {});
    });
  }

  Future<List<AskLessonModel>> _loadAsks() async {
    List<AskLessonModel> loadedAsks = await _getAsk();
    Random random = Random();
    if (loadedAsks.length < 1) {
      throw Exception("Not enough questions to select from.");
    }
    Set<int> usedIndexes = Set<int>();
    List<AskLessonModel> selectedAsks = [];
    while (selectedAsks.length < 1) {
      int randomNumber = random.nextInt(loadedAsks.length);
      if (!usedIndexes.contains(randomNumber)) {
        selectedAsks.add(loadedAsks[randomNumber]);
        usedIndexes.add(randomNumber);
      }
    }
    return selectedAsks;
  }

  Future<List<AskLessonModel>> _getAsk() async {
    List<AskLessonModel> readings = [];
    try {
      FirebaseDatabase database = FirebaseDatabase(
        app: Firebase.app(),
        databaseURL: FirebaseEnum.URL_REALTIME_DATABASE,
      );
      final ref = database.ref(FirebaseEnum.lesson_reading);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is List) {
          for (var item in data) {
            AskLessonModel model = AskLessonModel.fromJson(item);
            readings.add(model);
          }
        }
      } else {
        print('No data available.');
      }
    } catch (e) {
      print('Error fetching and parsing data: $e');
    }
    return readings;
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
    super.didChangeMetrics();
  }

  Future<void> updateCountEvent() async {
    CollectionReference users = FirebaseFirestore.instance.collection(FirebaseEnum.userdata);
    users.doc(Globals.prefs!.getString(SharedPrefsKey.id_user)).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('countEvent')) {
          var countEvent = data['countEvent'];
          print('countEvent: $countEvent');
          users.doc(Globals.prefs!.getString(SharedPrefsKey.id_user)).update({'countEvent': int.parse(countEvent) + 1});
        }
      }
    });
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _body(),
        _buildButton(),
        Container(height: AppSizes.maxHeight * 0.03)
      ],
    );
  }

  Widget _buildButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButtomImageColorWidget(
        orangeColor: true,
        child:
            Text("Next", style: TextStyle(fontSize: 24, color: Colors.white)),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MapReadingLessonAnwserScreen(isGetReward: widget.isGetReward,level: widget.level,asks: _ask.Quiz,)));
        },
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  // height: AppSizes.maxHeight / 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 4, color: Color(0xFFE97428)),
                      color: Color(0xFF467865)),
                  child: CarouselSlider(
                    items: [_itemReading()],
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                        scrollPhysics: BouncingScrollPhysics(),
                        initialPage: 0,
                        viewportFraction: 1,
                        height: AppSizes.maxHeight,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        scrollDirection: Axis.horizontal),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              bottom: 0,
              left: AppSizes.maxWidth * 0.04,
              right: AppSizes.maxWidth * 0.04,
              child: Image(image: AssetImage(Assets.img_line_table))),
        ],
      ),
    );
  }


  Widget _itemReading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: Text(
          _ask.Content,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Color(0xFFFF6666),
                leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.all( 8),
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Kích thước nút
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: GestureDetector(
                        onTap: () {
                          GlobalSetting.shared.showPopup(context,
                              onTapClose: () {
                            Navigator.of(context).pop();
                          }, onTapExit: () {
                            // Navigator.of(context)..pop()..pop()..pop(false);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                (Route<dynamic> route) => false);
                          }, onTapContinous: () {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Image.asset(Assets.ic_menu, height: 24)),
                  )
                ],
                title: Text("Level ${widget.level}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w500))),
            backgroundColor: Color(0xFFFF6666),
            body: Responsive(
                mobile: _buildContent(),
                tablet: _buildContent(),
                desktop: _buildContent())),
      ),
    );
  }
}
