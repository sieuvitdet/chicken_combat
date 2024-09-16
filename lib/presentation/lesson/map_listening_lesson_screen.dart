import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/course/ask_lesson_listen_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/presentation/lesson/map_listening_lesson_anwser_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class MapListeningLessonScreen extends StatefulWidget {
  final bool isGetReward;
  final int level;
  const MapListeningLessonScreen(
      {super.key, this.isGetReward = false, required this.level});

  @override
  State<MapListeningLessonScreen> createState() =>
      _MapListeningLessonScreenState();
}

class _MapListeningLessonScreenState extends State<MapListeningLessonScreen>
    with WidgetsBindingObserver {
  String text = "";
  List<String> parts = [];
  List<String> results = [];
  List<int> positions = [];
  var _isKeyboardVisible = false;
  int page = 1;
  int pages = 0;
  bool isListening = false;
  final FlutterTts flutterTts = FlutterTts();

  CarouselController buttonCarouselController = CarouselController();

  late ContentModel _content = ContentModel(
      idImage: "", pronounce: "", transcription: "", translate: "");
  List<AskLessonListenModel> _asks = [];
  List<String> answers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkMicrophonePermission();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _asks = await _loadAsks();
      if (_asks.length > 0) {
        pages = _asks[0].content.length;
        _content = _asks[0].content[0];
      }
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
    AudioManager.stopBackgroundMusic();
  }

  Future<List<AskLessonListenModel>> _loadAsks() async {
    List<AskLessonListenModel> loadedAsks = await _getAsk();
    Random random = Random();
    if (loadedAsks.length < 1) {
      throw Exception("Not enough questions to select from.");
    }
    Set<int> usedIndexes = Set<int>();
    List<AskLessonListenModel> selectedAsks = [];
    while (selectedAsks.length < 1) {
      int randomNumber = random.nextInt(loadedAsks.length);
      if (!usedIndexes.contains(randomNumber)) {
        selectedAsks.add(loadedAsks[randomNumber]);
        usedIndexes.add(randomNumber);
      }
    }
    return selectedAsks;
  }

  Future<List<AskLessonListenModel>> _getAsk() async {
    List<AskLessonListenModel> listeningList = [];

    try {
      FirebaseDatabase database = FirebaseDatabase(
        app: Firebase.app(),
        databaseURL: FirebaseEnum.URL_REALTIME_DATABASE,
      );
      final ref = database.ref(FirebaseEnum.lesson_listening);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is List) {
          for (var item in data) {
            AskLessonListenModel model = AskLessonListenModel.fromJson(item);
            listeningList.add(model);
          }
        }
      } else {
        print('No data available.');
      }
    } catch (e) {
      print('Error fetching and parsing data: $e');
    }
    return listeningList;
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
        // Visibility(visible: !_isKeyboardVisible, child: _buildButton()),

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
                    _content = _asks[0].content[page - 1];
                    setState(() {});
                  },
                  smallButton: true,
                  smallOrangeColor: page > 1,
                  smallGrayColor: page == 1,
                  child: Center(
                    child: StrokeTextWidget(
                      text: "Back",
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
                      Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MapListeningLessonAnwserScreen(isGetReward: widget.isGetReward,level: widget.level,quizs: _asks[0].quiz,)));
                    } else {
                      page += 1;
                      _content = _asks[0].content[page - 1];
                      // answers = [_ask.A, _ask.B, _ask.C, _ask.D];
                      setState(() {});
                    }
                  },
                  smallButton: true,
                  smallOrangeColor: true,
                  child: Center(
                    child: StrokeTextWidget(
                      text: page == pages ? "Go to test" : "Next",
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
              !isListening ? _speak(_content.pronounce) : _stop();
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

  Widget _itemReading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: _asks.length > 0 ? _contentListenLesson() : Container(),
    );
  }

  Widget _contentListenLesson() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _content.pronounce,
          style:
              TextStyle(fontSize: 24, color: getColorsByCode(_content.idImage)),
        ),
        SizedBox(
          height: AppSizes.maxHeight * 0.02,
        ),
        Text(_content.transcription,
            style: TextStyle(
                fontSize: 24, color: getColorsByCode(_content.idImage))),
        SizedBox(
          height: AppSizes.maxHeight * 0.02,
        ),
        Text(_content.translate,
            style: TextStyle(
                fontSize: 24, color: getColorsByCode(_content.idImage))),
        SizedBox(
          height: AppSizes.maxHeight * 0.02,
        ),
        Image.asset(
          ExtendedAssets.getAssetByCodeColor(_content.idImage),
          width: AppSizes.maxWidth * 0.6,
          height: AppSizes.maxWidth * 0.6,
          fit: BoxFit.fill,
        )
      ],
    );
  }

  Widget _answer(String answer, int i, {Function? ontap}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: CustomButtomImageColorWidget(
        redBlurColor: positions[page - 1] != i,
        redColor: positions[page - 1] == i,
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
        child: PopScope(
          canPop: true,
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

  Color getColorsByCode(String code) {
    Map<String, Color> codeToColor = {
      "TOPIC01_0001": Colors.red,
      "TOPIC01_0002": Colors.blue.shade900,
      "TOPIC01_0003": Colors.green,
      "TOPIC01_0004": Colors.blue,
      "TOPIC01_0005": Colors.white,
      "TOPIC01_0006": Colors.black,
      "TOPIC01_0007": Colors.yellow,
      "TOPIC01_0008": Colors.orange,
      "TOPIC01_0009": Colors.pink,
      "TOPIC01_0010": Colors.brown,
    };

    return codeToColor[code] ?? Colors.white;
  }
}
