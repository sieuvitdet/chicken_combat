import 'package:carousel_slider/carousel_slider.dart';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/course/ask_lesson_listen_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/dialog_comfirm_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class MapListeningLessonAnwserScreen extends StatefulWidget {
  final bool isGetReward;
  final int level;
  final List<QuizModel> quizs;
  const MapListeningLessonAnwserScreen(
      {super.key,
      this.isGetReward = false,
      required this.level,
      required this.quizs});

  @override
  State<MapListeningLessonAnwserScreen> createState() =>
      _MapListeningLessonAnwserScreenState();
}

class _MapListeningLessonAnwserScreenState
    extends State<MapListeningLessonAnwserScreen> with WidgetsBindingObserver {
  String text = "";
  List<String> results = [];
  List<int> positions = [];
  var _isKeyboardVisible = false;
  int page = 1;
  int pages = 0;
  bool isListening = false;
  bool review = false;
  final FlutterTts flutterTts = FlutterTts();

  CarouselController buttonCarouselController = CarouselController();

  late QuizModel _quiz = QuizModel(answer: "", listen: {}, idImage: []);
  List<QuizModel> _quizs = [];
  List<String> answers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkMicrophonePermission();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _quizs = widget.quizs;
      if (_quizs.length > 0) {
        _quiz = _quizs[0];
        answers.addAll(_quiz.idImage);

        for (int i = 0; i < _quizs.length; i++) {
          positions.add(-1);
          results.add("");
        }
      }
      pages = _quiz.idImage.length;
      setState(() {});
    });
  }

  Future<void> _checkMicrophonePermission() async {
    PermissionStatus permissionStatus = await Permission.microphone.status;
    if (permissionStatus.isDenied) {
      await Permission.microphone.request();
    } else if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
    AudioManager.pauseBackgroundMusic();
  }

  int _checkScore() {
    int score = 0;
    for (int i = 0; i < _quizs.length; i++) {
      if (results[i] == _quizs[i].answer) {
        score += 10;
      }
    }
    return score;
  }

  int _getGold(int score) {
    if (widget.isGetReward) {
      int gold = score > 9 * _quizs.length
          ? 15
          : score > 7 * _quizs.length
              ? 10
              : score >= 5 * _quizs.length
                  ? 5
                  : 0;
      return gold;
    } else {
      int gold = score > 9 * _quizs.length
          ? 100
          : score > 7 * _quizs.length
              ? 50
              : score >= 5 * _quizs.length
                  ? 20
                  : 0;
      return gold;
    }
  }

  int _getDiamond(int score) {
    if (widget.isGetReward) {
      int diamond = score > 9 * _quizs.length
          ? 5
          : score > 7 * _quizs.length
              ? 2
              : score >= 5 * _quizs.length
                  ? 1
                  : 0;
      return diamond;
    } else {
      int diamond = score > 9 * _quizs.length
          ? 15
          : score > 7 * _quizs.length
              ? 10
              : score >= 5 * _quizs.length
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

  Widget _buildContent() {
    return Column(
      children: [
        _body(),
        ..._listAnswer(),
        // Spacer(),
        _listening(),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Flexible(
                child: CustomButtomImageColorWidget(
                  onTap: () {
                    if (page == 1) {
                      return;
                    }
                    page -= 1;
                    _quiz = _quizs[page - 1];
                    setState(() {});
                  },
                  smallButton: true,
                  smallOrangeColor: page > 1,
                  smallGrayColor: page == 1,
                  child: Center(
                    child: StrokeTextWidget(
                      text: "Previous",
                      size: AppSizes.maxWidth < 350 ? 14 : 20,
                      colorStroke: Color(0xFFD18A5A),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Flexible(
                child: CustomButtomImageColorWidget(
                  onTap: () {
                    if (page == pages) {
                      if (review) {
                        int score = _checkScore();
                        Navigator.of(context)
                          ..pop()
                          ..pop(score >= 5 * _quizs.length);
                        return;
                      }
                      GlobalSetting.shared.showPopupWithContext(
                          context,
                          DialogConfirmWidget(
                            title:
                                AppLocalizations.text(LangKey.confirm_submit),
                            agree: () async {
                              // Navigator.of(context).pop();
                              int score = _checkScore();
                              int gold = _getGold(score);
                              int diamond = _getDiamond(score);
                              if (score >= 5 * pages) {
                                Globals.financeUser?.gold += gold;
                                Globals.financeUser?.diamond += diamond;
                                _updateGold(
                                    Globals.currentUser?.financeId ?? "",
                                    Globals.financeUser?.gold ?? 0);
                                _updateDiamond(
                                    Globals.currentUser?.financeId ?? "",
                                    Globals.financeUser?.diamond ?? 0);
                              }

                              GlobalSetting.shared.showPopupCongratulation(
                                  context, 1, score, gold, diamond,
                                  numberQuestion: pages,
                                  ontapReview: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pop();
                                setState(() {
                                  review = true;
                                  page = 1;
                                 _quiz = _quizs[page - 1];
                                });
                              }, ontapExit: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pop()
                                  ..pop()
                                  ..pop(score >= 5 * pages);
                              }, showReivew: !review);
                            },
                            cancel: () {
                              Navigator.of(context).pop();
                            },
                          ));
                      return;
                    }
                    page += 1;
                    _quiz = _quizs[page - 1];
                    setState(() {});
                  },
                  smallButton: true,
                  smallOrangeColor: true,
                  child: Center(
                    child: StrokeTextWidget(
                      text: page == pages
                          ? review
                              ? "Exit"
                              : "Final"
                          : "Next",
                      size: AppSizes.maxWidth < 350 ? 14 : 20,
                      colorStroke: Color(0xFFD18A5A),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(height: AppSizes.maxHeight * 0.03)
      ],
    );
  }

  Widget _listening() {
    return Container(
      height: AppSizes.maxHeight * 0.12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              !isListening ? _speak(_quiz.listen['A'] ?? '') : _stop();
              print("record");
              setState(() {
                isListening = !isListening;
              });
            },
            child: Image.asset(
              isListening
                  ? Assets.ic_playing_listening
                  : Assets.ic_notplay_listening,
              height: AppSizes.maxHeight * 0.06,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              isListening ? "Click to stop" : "Click to play",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
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
                    items: [_listColorAnswer()],
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
              left: AppSizes.maxWidth * 0.04,
              right: AppSizes.maxWidth * 0.04,
              child: Image(image: AssetImage(Assets.img_line_table))),
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

  List<Widget> _listAnswer() {
    List<Widget> itemList = [];
    for (int i = 0; i < answers.length; i++) {
      // itemList.add(_answer(answers[i], i, ontap: () {
      //   positions[page - 1] = i;
      //   results[page - 1] = i == 0
      //       ? "A"
      //       : i == 1
      //           ? "B"
      //           : i == 2
      //               ? "C"
      //               : "D";
      //   setState(() {});
      // }));
    }
    return itemList;
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('en-US'); // Thiết lập ngôn ngữ
    await flutterTts.setPitch(0.7); // Thiết lập cường độ giọng nói
    await flutterTts.setSpeechRate(0.4); // Thiết lập tốc độ giọng nói
    await flutterTts.setVolume(1); // Thiết lập âm lượng
    await flutterTts.speak(text); // Chuyển văn bản thành giọng nói
    flutterTts.setCompletionHandler(() {
      isListening = !isListening;
      setState(() {});
    });
  }

  Future<void> _stop() async {
    await flutterTts.stop();
  }

  Widget _answer(int i, {Function? ontap}) {
    return ScalableButton(
      onTap: ontap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            ExtendedAssets.getAssetByCodeColor(_quiz.idImage[i]),
            fit: BoxFit.cover,
            width: AppSizes.maxWidth / 2,
          ),
          if (review)
            Center(
              child: IconTheme(
                data: IconThemeData(
                    size: _quiz.idImage[i] == _quiz.answer
                        ? 40.0
                        : 30.0), // Set the size here
                child: _quiz.idImage[i] == _quiz.answer
                    ? Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.green,
                      )
                    : Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2.0, color: Colors.red)),
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
              ),
            ),
          if (!review &&
              results[page - 1] != "" &&
              results[page - 1] == _quiz.idImage[i])
            IconTheme(
              data: IconThemeData(size: 20.0), // Set the size here
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.green,
              ),
            )
        ],
      ),
    );
  }

  Widget _listColorAnswer() {
    return Wrap(
      runSpacing: 8,
      children: List.generate(
        _quiz.idImage.length,
        (index) {
          return _answer(index, ontap: () {
            results[page - 1] = _quiz.idImage[index];
            setState(() {});
          });
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
        child: PopScope(
          canPop: true,
          child: Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: Container(),
                  // leading: IconTheme(
                  //   data: IconThemeData(size: 24.0), // Set the size here
                  //   child: IconButton(
                  //     icon: Icon(
                  //       Icons.arrow_back_ios,
                  //       color: Colors.grey,
                  //     ),
                  //     onPressed: () {
                  //       Navigator.of(context).pop();
                  //     },
                  //   ),
                  // ),
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
                  mobile: _buildContent(),
                  tablet: _buildContent(),
                  desktop: _buildContent())),
        ),
      ),
    );
  }
}
