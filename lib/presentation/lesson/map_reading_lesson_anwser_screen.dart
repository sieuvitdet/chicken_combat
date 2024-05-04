import 'package:carousel_slider/carousel_slider.dart';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/course/ask_lesson_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/dialog_comfirm_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MapReadingLessonAnwserScreen extends StatefulWidget {
  final bool isGetReward;
  final int level;
  final List<QuizModel> asks;
  MapReadingLessonAnwserScreen(
      {this.isGetReward = false, required this.level, required this.asks});

  @override
  State<MapReadingLessonAnwserScreen> createState() =>
      _MapReadingLessonAnwserScreenState();
}

class _MapReadingLessonAnwserScreenState
    extends State<MapReadingLessonAnwserScreen> with WidgetsBindingObserver {
  String text = "";

  String text2 =
      "Welcome  questions we've  prepared for you. Did you know that they say cats can jump higher than dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thoughts! And you, if you were to be a scientist for a day, what would you research? Discuss and share your opinions with us on these intriguing questions. Remember, there are no right or wrong answers, only endless curiosity and exploration!\n\n"
      "Welcome to our random topic! Get ready  to explore some interesting questions we've prepared for you.";

  List<String> parts = [];
  var _isKeyboardVisible = false;
  int page = 1;
  int pages = 0;
  List<String> results = [];
  List<int> positions = [];

  CarouselController buttonCarouselController = CarouselController();

  late QuizModel _ask = QuizModel(
      Question: "",
      Answer: "",
      Options: OptionQuizModel(A: "", B: "", C: "", D: ""));
  List<QuizModel> _asks = [];
  List<String> answers = [];
  bool review = false;

  @override
  void initState() {
    super.initState();
    AudioManager.pauseBackgroundMusic();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _asks = widget.asks;
      if (_asks.length > 0) {
        _ask = _asks[0];
        answers = [
          _ask.Options.A ?? "",
          _ask.Options.B ?? "",
          _ask.Options.C ?? "",
          _ask.Options.D ?? ""
        ];
        // splitText(_ask.Question);

        for (int i = 0; i < _asks.length; i++) {
          print(_asks[i].Answer);
          print(_asks[i].Question);
          positions.add(-1);
          results.add("");
        }
      }
      pages = _asks.length;
      setState(() {});
    });
  }

  int _checkScore() {
    int score = 0;
    for (int i = 0; i < _asks.length; i++) {
      if (results[i] == _asks[i].Answer) {
        score += 10;
      }
    }
    return score;
  }

  int _getGold(int score) {
    if (widget.isGetReward) {
      int gold = score > 8 * _asks.length
          ? 15
          : score > 7 * _asks.length
              ? 10
              : score >= 5 * _asks.length
                  ? 5
                  : 0;
      return gold;
    } else {
      int gold = score > 8 * _asks.length
          ? 100
          : score > 7 * _asks.length
              ? 50
              : score >= 5 * _asks.length
                  ? 20
                  : 0;
      return gold;
    }
  }

  int _getDiamond(int score) {
    if (widget.isGetReward) {
      int diamond = score > 8 * _asks.length
          ? 5
          : score > 7 * _asks.length
              ? 2
              : score >= 5 * _asks.length
                  ? 1
                  : 0;
      return diamond;
    } else {
      int diamond = score > 8 * _asks.length
          ? 15
          : score > 7 * _asks.length
              ? 10
              : score >= 5 * _asks.length
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
      mainAxisSize: MainAxisSize.min,
      children: [
        _body(),
        ..._listAnswer(),
        Spacer(),
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
                    _ask = _asks[page - 1];
                    answers = [
                      _ask.Options.A ?? "",
                      _ask.Options.B ?? "",
                      _ask.Options.C ?? "",
                      _ask.Options.D ?? ""
                    ];
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
                          ..pop(score >= 5 * _asks.length);
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
                              if (score >= 5 * _asks.length) {
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
                                  numberQuestion: _asks.length,
                                  ontapReview: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pop();
                                setState(() {
                                  review = true;
                                  page = 1;
                                  _ask = _asks[page - 1];
                                  answers = [
                                    _ask.Options.A ?? "",
                                    _ask.Options.B ?? "",
                                    _ask.Options.C ?? "",
                                    _ask.Options.D ?? ""
                                  ];
                                });
                              }, ontapExit: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pop()
                                  ..pop()
                                  ..pop(score >= 5 * _asks.length);
                              }, showReivew: !review);
                            },
                            cancel: () {
                              Navigator.of(context).pop();
                            },
                          ));
                      return;
                    }
                    page += 1;
                    _ask = _asks[page - 1];
                    answers = [
                      _ask.Options.A ?? "",
                      _ask.Options.B ?? "",
                      _ask.Options.C ?? "",
                      _ask.Options.D ?? ""
                    ];
                    ;
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
      itemList.add(_answer(answers[i], i, ontap: () {
        positions[page - 1] = i;
        results[page - 1] = i == 0
            ? "A"
            : i == 1
                ? "B"
                : i == 2
                    ? "C"
                    : "D";
        setState(() {});
      }));
    }
    return itemList;
  }

  Widget _itemReading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        _ask.Question,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _answer(String answer, int i, {Function? ontap}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: (!review)
          ? CustomButtomImageColorWidget(
              redBlurColor: positions[page - 1] != i,
              redColor: positions[page - 1] == i,
              child: Text(answer,
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              onTap: ontap,
            )
          : CustomButtomImageColorWidget(
              redBlurColor: _asks[page - 1].Answer !=
                  (i == 0
                      ? "A"
                      : i == 1
                          ? "B"
                          : i == 2
                              ? "C"
                              : "D"),
              greenColor: _asks[page - 1].Answer ==
                  (i == 0
                      ? "A"
                      : i == 1
                          ? "B"
                          : i == 2
                              ? "C"
                              : "D"),
              child: Text(answer,
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              onTap: ontap,
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
                leading: (!review) ? IconTheme(
                  data: IconThemeData(size: 24.0), // Set the size here
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ) : Container(),
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
    );
  }
}
