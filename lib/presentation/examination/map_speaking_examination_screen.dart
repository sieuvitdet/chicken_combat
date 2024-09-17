import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/course/ask_examination_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/speech_to_text_service.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart' hide CarouselController ;
import 'package:permission_handler/permission_handler.dart';

class MapSpeakingExaminationScreen extends StatefulWidget {
  final bool isGetReward;
  final int level;
  const MapSpeakingExaminationScreen(
      {super.key, this.isGetReward = false, required this.level});

  @override
  State<MapSpeakingExaminationScreen> createState() =>
      _MapSpeakingExaminationScreenState();
}

class _MapSpeakingExaminationScreenState
    extends State<MapSpeakingExaminationScreen> with WidgetsBindingObserver {
  List<String> parts = [];
  List<String> anwsers = [];
  var _isKeyboardVisible = false;
  int page = 1;
  int pages = 0;
  bool isTextOverflow = false;
  int scoreSpeaking = 0;

CarouselSliderController buttonCarouselController = CarouselSliderController();
  ScrollController _controller = ScrollController();

  final SpeechToTextService _sttService = SpeechToTextService();
  String _text = '';
  bool isListening = false;
  List<AskExaminationModel> _speakings = [];
  late AskExaminationModel _ask = AskExaminationModel(
      Question: "", Answer: "", A: "", B: "", C: "", D: "", Script: "");

  @override
  void initState() {
    super.initState();
    _sttService.init();
    _checkMicrophonePermission();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _speakings = await _loadAsks();
      if (_speakings.length > 0) {
        _ask = _speakings[page - 1];
        pages = _speakings.length;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    //AudioManager.playBackgroundMusic(AudioFile.sound_pk1);
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

  Future<void> _checkMicrophonePermission() async {
    PermissionStatus permissionStatus = await Permission.microphone.status;
    if (permissionStatus.isDenied) {
      await Permission.microphone.request();
    } else if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
    AudioManager.stopBackgroundMusic();
  }

  Future<List<AskExaminationModel>> _loadAsks() async {
    List<AskExaminationModel> loadedAsks = await _getAsk();
    Random random = Random();
    if (loadedAsks.length < 5) {
      throw Exception("Not enough questions to select from.");
    }
    Set<int> usedIndexes = Set<int>();
    List<AskExaminationModel> selectedAsks = [];
    while (selectedAsks.length < 5) {
      int randomNumber = random.nextInt(loadedAsks.length);
      if (!usedIndexes.contains(randomNumber)) {
        selectedAsks.add(loadedAsks[randomNumber]);
        usedIndexes.add(randomNumber);
      }
    }
    return selectedAsks;
  }

  Future<List<AskExaminationModel>> _getAsk() async {
    List<AskExaminationModel> readings = [];
    try {
      FirebaseDatabase database = FirebaseDatabase(
        app: Firebase.app(),
        databaseURL: FirebaseEnum.URL_REALTIME_DATABASE,
      );
      final ref = database.ref(FirebaseEnum.examination_speaking);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is List) {
          for (var item in data) {
            AskExaminationModel model = AskExaminationModel.fromJson(item);
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
      int gold = score > 9 * _speakings.length
          ? 15
          : score > 7 * _speakings.length
              ? 10
              : score >= 5 * _speakings.length
                  ? 5
                  : 0;
      return gold;
    } else {
      int gold = score > 9 * _speakings.length
          ? 100
          : score > 7 * _speakings.length
              ? 50
              : score >= 5 * _speakings.length
                  ? 20
                  : 0;
      return gold;
    }
  }

  int _getDiamond(int score) {
    if (widget.isGetReward) {
      int diamond = score > 9 * _speakings.length
          ? 5
          : score > 7 * _speakings.length
              ? 2
              : score >= 5 * _speakings.length
                  ? 1
                  : 0;
      return diamond;
    } else {
      int diamond = score > 9 * _speakings.length
          ? 15
          : score > 7 * _speakings.length
              ? 10
              : score >= 5 * _speakings.length
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

  Widget _buildContent() {
    return Column(
      children: [
        _body(),
        _record(),
        //  Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 16),
        //   child: Row(
        //     children: [
        //       Flexible(
        //         child: CustomButtomImageColorWidget(
        //           onTap: () {
        //             if (page == 1) {
        //               return;
        //             }
        //             page -= 1;
        //             _ask = _speakings[page - 1];
        //             setState(() {});
        //           },
        //           smallButton: true,
        //           smallOrangeColor: page > 1,
        //           smallGrayColor: page == 1,
        //           child: Center(
        //             child: StrokeTextWidget(
        //               text: "Previous",
        //               size: AppSizes.maxWidth < 350 ? 14 : 20,
        //               colorStroke: Color(0xFFD18A5A),
        //             ),
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         width: 16,
        //       ),
        //       Flexible(
        //         child: CustomButtomImageColorWidget(
        //           onTap: () {
        //             // if (page == pages) {
        //             //   GlobalSetting.shared.showPopupWithContext(
        //             //       context,
        //             //       DialogConfirmWidget(
        //             //         title:
        //             //             AppLocalizations.text(LangKey.confirm_submit),
        //             //         agree: () async {
        //             //           // Navigator.of(context).pop();
        //             //           int score = _checkScore();
        //             //           int gold = _getGold(score);
        //             //           int diamond = _getDiamond(score);
        //             //           if (score > 5) {
        //             //             Globals.financeUser?.gold += gold;
        //             //             Globals.financeUser?.diamond += diamond;
        //             //             _updateGold(
        //             //                 Globals.currentUser?.financeId ?? "",
        //             //                 Globals.financeUser?.gold ?? 0);
        //             //             _updateDiamond(
        //             //                 Globals.currentUser?.financeId ?? "",
        //             //                 Globals.financeUser?.diamond ?? 0);
        //             //           }

        //             //           GlobalSetting.shared.showPopupCongratulation(
        //             //               context, 1, score, gold, diamond,
        //             //               ontapContinue: () {
        //             //             // Navigator.of(context)..pop()..pop(false);
        //             //           }, ontapExit: () {
        //             //             Navigator.of(context)
        //             //               ..pop()
        //             //               ..pop()
        //             //               ..pop(score > 5);
        //             //           });
        //             //         },
        //             //         cancel: () {
        //             //           Navigator.of(context).pop();
        //             //         },
        //             //       ));
        //             //   return;
        //             // }
        //             page += 1;
        //             _ask = _speakings[page - 1];
        //             setState(() {});
        //           },
        //           smallButton: true,
        //           smallOrangeColor: true,
        //           child: Center(
        //             child: StrokeTextWidget(
        //               text: page == pages ? "Final" : "Next",
        //               size: AppSizes.maxWidth < 350 ? 14 : 20,
        //               colorStroke: Color(0xFFD18A5A),
        //             ),
        //           ),
        //         ),
        //       )
        //     ],
        //   ),

        // ),

        Visibility(visible: !_isKeyboardVisible, child: _buildButton()),
        Container(height: AppSizes.maxHeight * 0.03)
        // Visibility(visible: !_isKeyboardVisible, child: _buildButton()),
        // Container(
        //   height: AppSizes.bottomHeight,
        // )
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
              )),
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
          _ask.Script,
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
              if (_ask.Script.contains('score:')) {
                  return;
                }
              setState(() {
                isListening = !_sttService.isListening;
              });
              String result = '';
              _sttService.toggleRecording(context, _ask.Script, false, (result) {
                setState(() {
                  result = result;
                  scoreSpeaking += (int.tryParse(result) ?? 0);
                  if (page == pages) {
                    int score = scoreSpeaking;
                    int gold = _getGold(score);
                    int diamond = _getDiamond(score);
                    if (score >= 5 * _speakings.length) {
                      Globals.financeUser?.gold += gold;
                      Globals.financeUser?.diamond += diamond;
                      _updateGold(Globals.currentUser?.financeId ?? "",
                          Globals.financeUser?.gold ?? 0);
                      _updateDiamond(Globals.currentUser?.financeId ?? "",
                          Globals.financeUser?.diamond ?? 0);
                    }
                    GlobalSetting.shared.showPopupCongratulation(
                        context, 1, score, gold, diamond,
                        numberQuestion: _speakings.length, ontapReview: () {
                    }, ontapExit: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop(score >= 5 * _speakings.length);
                    });
                    return;
                  }
                });
              }, (question) {
                _ask.Script = question;
                setState(() {
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
        child:
            Text("Next", style: TextStyle(fontSize: 24, color: Colors.white)),
        onTap: () {
          {
            if (isListening || page == pages) {
              return;
            }
            page += 1;
            _ask = _speakings[page - 1];
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
                backgroundColor: Colors.transparent,
                leading: IconTheme(
                  data: IconThemeData(size: 24.0), // Set the size here
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      AudioManager.resumeBackgroundMusic();
                      Navigator.of(context).pop();
                    },
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
                title: Text("Level 1",
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
