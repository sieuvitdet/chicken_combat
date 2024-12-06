import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/course/ask_speaking_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/speech_to_text_service.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/dialog_congratulation_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MapSpeakingLessonScreen extends StatefulWidget {
  final bool isGetReward;
  final int level;
  const MapSpeakingLessonScreen(
      {super.key, this.isGetReward = false, required this.level});

  @override
  State<MapSpeakingLessonScreen> createState() =>
      _MapSpeakingLessonScreenState();
}

class _MapSpeakingLessonScreenState extends State<MapSpeakingLessonScreen>
    with WidgetsBindingObserver {
  List<String> parts = [];
  List<String> anwsers = [];
  var _isKeyboardVisible = false;
  int page = 1;
  int pages = 0;
  bool isTextOverflow = false;
  bool isRecording = false;
  final SpeechToTextService _sttService = SpeechToTextService();
  bool isListening = false;
  int scoreSpeaking = 0;

CarouselSliderController buttonCarouselController = CarouselSliderController();
  ScrollController _controller = ScrollController();

  List<AskSpeakingModel> _speakings = [];
  late QuizSpeakingModel _ask = QuizSpeakingModel(question: "");

  @override
  void initState() {
    super.initState();
    _sttService.init();
    _checkMicrophonePermission();
    WidgetsBinding.instance.addObserver(this);
    AudioManager.stopBackgroundMusic();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _speakings = await _loadAsks();
      if (_speakings.length > 0) {
        _ask = _speakings[0].quiz[0];

        pages = _speakings[0].quiz.length;
        setState(() {});
      }
    });
  }

  Future<void> _checkMicrophonePermission() async {
    PermissionStatus permissionStatus = await Permission.microphone.status;
    if (permissionStatus.isDenied) {
      await Permission.microphone.request();
    } else if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
    AudioManager.isMusicPlaying = false;
    AudioManager.stopBackgroundMusic();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      setState(() {
        isTextOverflow = false;
      });
    } else {
      setState(() {
        isTextOverflow = true;
      });
    }
  }

  Future<List<AskSpeakingModel>> _loadAsks() async {
    List<AskSpeakingModel> loadedAsks = await _getAsk();
    Random random = Random();
    if (loadedAsks.length < 1) {
      throw Exception("Not enough questions to select from.");
    }
    Set<int> usedIndexes = Set<int>();
    List<AskSpeakingModel> selectedAsks = [];
    while (selectedAsks.length < 1) {
      int randomNumber = random.nextInt(loadedAsks.length);
      if (!usedIndexes.contains(randomNumber)) {
        selectedAsks.add(loadedAsks[randomNumber]);
        usedIndexes.add(randomNumber);
      }
    }
    return selectedAsks;
  }

  Future<List<AskSpeakingModel>> _getAsk() async {
    List<AskSpeakingModel> readings = [];
    try {
      FirebaseDatabase database = FirebaseDatabase(
        app: Firebase.app(),
        databaseURL: FirebaseEnum.URL_REALTIME_DATABASE,
      );
      final ref = database.ref(FirebaseEnum.lesson_speaking);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is List) {
          for (var item in data) {
            AskSpeakingModel model = AskSpeakingModel.fromJson(item);
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

  int _getGold(int score) {
    if (widget.isGetReward) {
      int gold = score > 8 * _speakings[0].quiz.length
          ? 15
          : score > 7 * _speakings[0].quiz.length
              ? 10
              : score >= 5 * _speakings[0].quiz.length
                  ? 5
                  : 0;
      return gold;
    } else {
      int gold = score > 8 * _speakings[0].quiz.length
          ? 100
          : score > 7 * _speakings[0].quiz.length
              ? 50
              : score >= 5 * _speakings[0].quiz.length
                  ? 20
                  : 0;
      return gold;
    }
  }

  int _getDiamond(int score) {
    if (widget.isGetReward) {
      int diamond = score > 8 * _speakings[0].quiz.length
          ? 5
          : score > 7 * _speakings[0].quiz.length
              ? 2
              : score >= 5 * _speakings[0].quiz.length
                  ? 1
                  : 0;
      return diamond;
    } else {
      int diamond = score > 8 * _speakings[0].quiz.length
          ? 15
          : score > 7 * _speakings[0].quiz.length
              ? 10
              : score >= 5 * _speakings[0].quiz.length
                  ? 5
                  : 0;
      return diamond;
    }
  }

  Future<void> _updateGold(String _id, int gold) async {
    CollectionReference _finance =
        FirebaseFirestore.instance.collection(FirebaseEnum.finance);

    return _finance
        .doc(_id)
        .update({'gold': gold})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> _updateDiamond(String _id, int dimond) async {
    CollectionReference _finance =
        FirebaseFirestore.instance.collection(FirebaseEnum.finance);

    return _finance
        .doc(_id)
        .update({'diamond': dimond})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  void showPopupWin({bool isWin = false}) {
    int score = scoreSpeaking;
    int gold = _getGold(score);
    int diamond = _getDiamond(score);
    if (score >= 5 * _speakings.length) {
      Globals.financeUser?.gold += gold;
      Globals.financeUser?.diamond += diamond;
      _updateGold(
          Globals.currentUser?.financeId ?? "", Globals.financeUser?.gold ?? 0);
      _updateDiamond(Globals.currentUser?.financeId ?? "",
          Globals.financeUser?.diamond ?? 0);
    }

    isWin
        ? AudioManager.playSoundEffect(AudioFile.sound_victory)
        : AudioManager.playSoundEffect(AudioFile.sound_lose);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return DialogCongratulationWidget(
                isWin: isWin,
                showContinue: false,
                isLesson: true,
                diamond: diamond,
                coin:gold,
                ontapExit: () {
                  Navigator.of(context)
                    ..pop()
                    ..pop(scoreSpeaking >= 5 * pages);
                },
              );
            },
          );
        });
  }

  Widget _buildContent() {
    return Column(
      children: [
        _body(),
        _record(),
        Visibility(visible: !_isKeyboardVisible, child: _buildButton()),
        Container(height: AppSizes.maxHeight * 0.03)
      ],
    );
  }

  Widget _buildBackground() {
    return BackGroundCloudWidget();
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
                        scrollPhysics: NeverScrollableScrollPhysics(),
                        initialPage: page,
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
              left: 16,
              right: 16,
              child: Image(image: AssetImage(Assets.img_line_table))),
          if (isTextOverflow)
            Positioned(
                bottom: 40,
                right: 24,
                child: Container(
                  height: 24,
                  width: 24,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                  child: Center(
                      child: ImageIcon(
                    AssetImage(Assets.ic_down),
                    color: Colors.white,
                    size: 16,
                  )),
                )),
          Positioned(
            bottom: 0,
            height: 60,
            left: 0,
            right: 0,
            child: Image.asset(Assets.img_chicken_learning),
          ),
          Positioned(
              bottom: AppSizes.maxHeight * 0.02,
              right: AppSizes.maxWidth * 0.08,
              child: Text(
                "${page}/${pages}",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }

  Widget _itemReading() {
    return SingleChildScrollView(
      controller: _controller,
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 24),
        child: Text(
          _ask.question,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _record() {
    return Container(
      height: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (_ask.question.contains('score:')) {
                return;
              }
              setState(() {
                isListening = !_sttService.isListening;
              });
              String result = '';
              _sttService.toggleRecording(context, _ask.question, false, (result) {
                setState(() {
                  result = result;
                  scoreSpeaking += (int.tryParse(result) ?? 0);
                  print(scoreSpeaking);
                  if (page == pages) {
                    showPopupWin(isWin: scoreSpeaking >= 5 * _speakings.length);
                    // int score = scoreSpeaking;
                    // int gold = _getGold(score);
                    // int diamond = _getDiamond(score);
                    // if (score >= 5 * _speakings.length) {
                    //   Globals.financeUser?.gold += gold;
                    //   Globals.financeUser?.diamond += diamond;
                    //   _updateGold(Globals.currentUser?.financeId ?? "",
                    //       Globals.financeUser?.gold ?? 0);
                    //   _updateDiamond(Globals.currentUser?.financeId ?? "",
                    //       Globals.financeUser?.diamond ?? 0);
                    // }

                    // GlobalSetting.shared.showPopupCongratulation(
                    //     context, 1, score, gold, diamond,
                    //     numberQuestion: pages, ontapReview: () {
                    //   // Navigator.of(context)..pop()..pop(false);
                    // }, ontapExit: () {
                    //   Navigator.of(context)
                    //     ..pop()
                    //     ..pop(score >= 5 * pages);
                    // });
                    return;
                  }
                });
              }, (question) {
                setState(() {
                  _ask.question = question;
                });
              });
            },
            child: Image.asset(
              isListening ? Assets.ic_mic_recording : Assets.ic_mic,
              width: 48,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              isListening ? "Click to stop" : "Click to reply",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButtomImageColorWidget(
        orangeColor: !isListening,
        child: Text(page == pages ? "Final" : "Next",
            style: TextStyle(fontSize: 24, color: Colors.white)),
        onTap: () {
          {
            if (isListening || page == pages) {
              return;
            }
            page += 1;
            _ask = _speakings[0].quiz[page - 1];
            setState(() {});
          }
        },
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
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFFD700),
                          Color(0xFFFFEA9F)
                        ], // Gradient từ vàng sang đỏ
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4), // Kích thước nút
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
                            Navigator.of(context)
                              ..pop()
                              ..pop(false);
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
            backgroundColor: Color(0xFFFACA44),
            body: Responsive(
                mobile: Stack(
                  children: [_buildBackground(), _buildContent()],
                ),
                tablet: Stack(
                  children: [_buildBackground(), _buildContent()],
                ),
                desktop: Stack(
                  children: [_buildBackground(), _buildContent()],
                ))),
      ),
    );
  }
}
