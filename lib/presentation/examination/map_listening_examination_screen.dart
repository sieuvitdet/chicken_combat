import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/course/ask_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class MapListeningExaminationScreen extends StatefulWidget {
  const MapListeningExaminationScreen({super.key});

  @override
  State<MapListeningExaminationScreen> createState() =>
      _MapListeningExaminationScreenState();
}

class _MapListeningExaminationScreenState
    extends State<MapListeningExaminationScreen> with WidgetsBindingObserver {
  String text = "";

  String text2 = "";

  List<String> parts = [];
  List<String> anwsers = [];
  var _isKeyboardVisible = false;
  int page = 1;
  bool isListening = false;
  final FlutterTts flutterTts = FlutterTts();

  CarouselController buttonCarouselController = CarouselController();

  late AskModel _ask;
  List<AskModel> _asks = [];
  List<String> answers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    splitText(text);
    _loadAsks();
    _checkMicrophonePermission();
  }


  Future<void> _checkMicrophonePermission() async {
    PermissionStatus permissionStatus = await Permission.microphone.status;
    if (permissionStatus.isDenied) {
      await Permission.microphone.request();
    } else if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _loadAsks() async {
    List<AskModel> loadedAsks = await _getAsk();
    Random random = Random();
    int randomNumber = random.nextInt(loadedAsks.length - 1) + 1;
    setState(() {
      _asks = loadedAsks;
      _ask = loadedAsks[randomNumber];
      answers =  [_ask.A, _ask.B, _ask.C, _ask.D];
      text = _ask.Question;
    });
  }

  Future<List<AskModel>> _getAsk() async {
    List<AskModel> listeningList = [];

    try {
      FirebaseDatabase database = FirebaseDatabase(
        app: Firebase.app(),
        databaseURL: FirebaseEnum.URL_REALTIME_DATABASE,
      );
      final ref = database.ref(FirebaseEnum.listening);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is List) {
          for (var item in data) {
            AskModel model = AskModel.fromJson(item);
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

  void splitText(String text) {
    parts = text.split('');
    anwsers.add("");
    for (int i = 0; i < parts.length - 1; i++) {
      anwsers.add("");
    }
  }

  List<InlineSpan> _listTextSpan() {
    List<InlineSpan> textSpans = [];
    textSpans.add(
      TextSpan(
        text: text,
        style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Itim"),
      ),
    );

    return textSpans;
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
        _listening(),
        Visibility(visible: !_isKeyboardVisible, child: _buildButton()),
        Container(
          height: AppSizes.bottomHeight,
        )
      ],
    );
  }

   Widget _listening() {
    return Container(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              !isListening ? _speak(_ask.Script) : _stop();
              print("record");
              setState(() {
                isListening = !isListening;
              });
            },
            child: Image.asset(
              isListening ? Assets.ic_playing_listening : Assets.ic_notplay_listening,
              height: 48,
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
                    items: [_itemReading(), _itemReading()],
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
        ],
      ),
    );
  }

  List<Widget> _listAnswer() {

    List<Widget> itemList = [];
    for (int i = 0; i < answers.length; i++) {
      itemList.add(_answer(answers[i], i));
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
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 24),
              child: RichText(
                text: TextSpan(children: _listTextSpan()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _answer(String answer, int i, {Function? ontap}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: CustomButtomImageColorWidget(
        redBlurColor: true,
        child:
            Text(answer, style: TextStyle(fontSize: 24, color: Colors.white)),
        onTap: ontap,
      ),
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
          page += 1;
          splitText(text2);
          setState(() {});
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
        child:
            PopScope(
              canPop: false,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconTheme(
                    data: IconThemeData(size: 24.0), // Set the size here
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () {
                          GlobalSetting.shared.showPopup(context,onTapClose: () {
                            Navigator.of(context).pop();
                          },
                          onTapExit: () {
                            Navigator.of(context)..pop()..pop(false);
                          },
                          onTapContinous: () {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Image.asset(Assets.ic_menu, height: 24)),
                    )
                  ],
                  title: Text("Level 1",
                      style: TextStyle(color: Colors.black, fontSize: 28,fontWeight: FontWeight.w500))),
                backgroundColor: Color(0xFFFACA44), body: Responsive(mobile: _buildContent(), tablet: _buildContent(), desktop: _buildContent())),
            ),
      ),
    );
  }
}
