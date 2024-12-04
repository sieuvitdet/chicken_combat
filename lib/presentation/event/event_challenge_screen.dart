import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/course/ask_examination_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/notification_manager.dart';
import 'package:chicken_combat/widgets/dialog_comfirm_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../common/assets.dart';
import '../../utils/utils.dart';
import '../../widgets/background_cloud_general_widget.dart';
import '../../widgets/custom_button_image_color_widget.dart';
import '../home/home_screen.dart';

class EventChallengeScreen extends StatefulWidget {
  const EventChallengeScreen({super.key});

  @override
  State<EventChallengeScreen> createState() => _EventChallengeScreenState();
}

class _EventChallengeScreenState extends State<EventChallengeScreen>
    with WidgetsBindingObserver {
  String text = "";

  String text2 =
      "Welcome  questions we've  prepared for you. Did you know that they say cats can jump higher than dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thoughts! And you, if you were to be a scientist for a day, what would you research? Discuss and share your opinions with us on these intriguing questions. Remember, there are no right or wrong answers, only endless curiosity and exploration!\n\n"
      "Welcome to our random topic! Get ready  to explore some interesting questions we've prepared for you.";

  List<String> parts = [];
  var _isKeyboardVisible = false;
  int page = 1;
  int pages = 0;
  bool isListening = false;
  List<String> results = [];
  List<int> positions = [];

  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  late AskExaminationModel _ask = AskExaminationModel(
      Question: "", Answer: "", Script: "", A: "", B: "", C: "", D: "");
  List<AskExaminationModel> _asks = [];
  List<String> answers = [];
  bool review = false;

  @override
  void initState() {
    super.initState();
    AudioManager.pauseBackgroundMusic();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _asks = await _loadAsks();
      if (_asks.length > 0) {
        _ask = _asks[0];
        answers = [_ask.A, _ask.B, _ask.C, _ask.D];
        for (int i = 0; i < _asks.length; i++) {
          print(_asks[i].Answer);
          positions.add(-1);
          results.add("");
        }
      }
      pages = _asks.length;
      setState(() {});
    });
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
      final ref = database.ref(FirebaseEnum.event_question);
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

  int _checkScore() {
    int score = 0;
    for (int i = 0; i < _asks.length; i++) {
      if (results[i] == _asks[i].Answer) {
        score += 10;
      }
    }
    return score;
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _body(),
        ..._listAnswer(),
        //Spacer(),
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
                    answers = [_ask.A, _ask.B, _ask.C, _ask.D];
                    setState(() {});
                  },
                  smallButton: true,
                  smallOrangeColor: page > 1,
                  smallGrayColor: page == 1,
                  child: Center(
                    child: StrokeTextWidget(
                      text: "Previous",
                      size: AppSizes.maxWidth < 350 ? 12 : 16,
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
                          ..pop(score >= 5*_asks.length);
                        return;
                      }
                      GlobalSetting.shared.showPopupWithContext(
                          context,
                          DialogConfirmWidget(
                            title: AppLocalizations.text(LangKey.confirm_submit),
                            agree: () async {
                              Navigator.of(context).pop();
                              int score = _checkScore();
                              if(score > 4 * _asks.length) {
                                _updateUseSkinColor(Globals.currentUser!.id);
                                GlobalSetting.shared.showPopupWithContext(
                                    context, DialogConfirmWidget(
                                  title: "Chúc mừng bạn đã hoàn thành thử thách, hãy kiểm tra cửa hàng để nhận quà!",
                                  agree: () {
                                    Navigator.of(context)..pop()..pop()..pop();
                                  },
                                ));
                              } else {
                                GlobalSetting.shared.showPopupWithContext(
                                    context, DialogConfirmWidget(
                                  title: "Chưa chính xác rồi, cố gắng lên nhé!", agree:() {
                                  Navigator.of(context)..pop()..pop();
                                }));
                              }
                            },
                            cancel: () {
                              Navigator.of(context).pop();
                            },
                          ));
                      return;
                    }
                    page += 1;
                    _ask = _asks[page - 1];
                    answers = [_ask.A, _ask.B, _ask.C, _ask.D];
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
                      size: AppSizes.maxWidth < 350 ? 12 : 16,
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

  Future<void> _updateUseSkinColor(String _idUser) async {
    CollectionReference _user = FirebaseFirestore.instance.collection(FirebaseEnum.userdata);

    return _user
        .doc(_idUser)
        .update({
      'bag': FieldValue.arrayUnion(['NOEL_1'])
    })
        .then((value) => NotificationManager.showNotification('Store', 'Item added to your bag successfully, Thanks!'))
        .catchError((error) => print("Failed to add item to bag: $error"));
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
                  padding: EdgeInsets.symmetric(vertical: 8),
                  // height: AppSizes.maxHeight / 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 4, color: Color(0xFFE97428)),
                      color: Color(0xFF467865)),
                  child: CarouselSlider(
                    items: [
                      _itemReading()
                    ],
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                        scrollPhysics: NeverScrollableScrollPhysics(),
                        initialPage: page,
                        viewportFraction: 1,
                        height: AppSizes.maxHeight,
                        enableInfiniteScroll: true,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            ExtendedAssets.getAssetByCodeColor(_ask.Script),
            width: AppSizes.maxWidth * 0.5,
            height: AppSizes.maxWidth * 0.7,
            fit: BoxFit.contain,
          ),
          Text(
            _ask.Question,
            style: TextStyle(fontSize: 20,color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _answer(String answer, int i, {Function? ontap}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: (!review) ? CustomButtomImageColorWidget(
        redBlurColor: positions[page - 1] != i,
        redColor: positions[page - 1] == i,
        child:
        Text(answer, style: TextStyle(fontSize: 16, color: Colors.white)),
        onTap: ontap,
      ) : CustomButtomImageColorWidget(
        redBlurColor: _asks[page-1].Answer != (i == 0
            ? "A"
            : i == 1
            ? "B"
            : i == 2
            ? "C"
            : "D"),
        greenColor:_asks[page-1].Answer == (i == 0
            ? "A"
            : i == 1
            ? "B"
            : i == 2
            ? "C"
            : "D"),
        child:
        Text(answer, style: TextStyle(fontSize: 16, color: Colors.white)),
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
                backgroundColor: Color(0xFFFF6666),
                leading: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.all(6),
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
                        padding: EdgeInsets.all(12),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_outlined,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6666), Color(0xFFFFD1A9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Responsive(
                  mobile: _buildContent(),
                  tablet: _buildContent(),
                  desktop: _buildContent()),
            )),
      ),
    );
  }
}
