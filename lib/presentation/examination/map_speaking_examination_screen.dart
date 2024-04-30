import 'package:carousel_slider/carousel_slider.dart';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/utils/speech_to_text_service.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:flutter/material.dart';

class MapSpeakingExaminationScreen extends StatefulWidget {
  const MapSpeakingExaminationScreen({super.key});

  @override
  State<MapSpeakingExaminationScreen> createState() =>
      _MapSpeakingExaminationScreenState();
}

class _MapSpeakingExaminationScreenState
    extends State<MapSpeakingExaminationScreen> with WidgetsBindingObserver {
  String text = "What color do you get when you mix red and blue?";
  String text2 =
      "Welcome  questions we've  prepared for you. Did you know that they say cats can jump higher than dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thoughts! And you, if you were to be a scientist for a day, what would you research? Discuss and share your opinions with us on these intriguing questions. Remember, there are no right or wrong answers, only endless curiosity and exploration!\n\n"
      "Welcome to our random topic! Get ready  to explore some interesting questions we've prepared for you.";

  List<String> parts = [];
  List<String> anwsers = [];
  var _isKeyboardVisible = false;
  int page = 1;
  bool isTextOverflow = false;

  CarouselController buttonCarouselController = CarouselController();
  ScrollController _controller = ScrollController();

  final SpeechToTextService _sttService = SpeechToTextService();
  String _text = '';
  String _responseText = '';
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
    _checkTextOverflow();
    _sttService.init();
    WidgetsBinding.instance.addObserver(this);
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

  void _checkTextOverflow() {
    print((AppSizes.maxHeight -
            AppSizes.bottomHeight -
            AppSizes.statusBarHeight -
            48 -
            80) ~/
        16.round());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if the text overflows
      TextSpan span = TextSpan(style: TextStyle(fontSize: 16.0), text: text);
      TextPainter tp = TextPainter(
          text: span, maxLines: 28, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: MediaQuery.of(context).size.width);
      bool newTextOverflow = tp.didExceedMaxLines;
      print(newTextOverflow);

      // Update isTextOverflow if necessary
      if (newTextOverflow != isTextOverflow) {
        setState(() {
          isTextOverflow = newTextOverflow;
        });
      }
    });
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
        _record(),
        Visibility(visible: !_isKeyboardVisible, child: _buildButton()),
        Container(
          height: AppSizes.bottomHeight,
        )
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
          )
        ],
      ),
    );
  }

  Widget _itemReading() {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          controller: _controller,
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 24),
            child: RichText(
              text: TextSpan(children: _listTextSpan()),
            ),
          ),
        )),
      ],
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
              setState(() {
                isListening = !_sttService.isListening;
              });
              _sttService.toggleRecording(text, false, (result) {
                setState(() {
                  text = result;
                  _responseText = result;
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
        orangeColor: true,
        child:
            Text("Next", style: TextStyle(fontSize: 24, color: Colors.white)),
        onTap: () {
          page += 1;
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
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconTheme(
                  data: IconThemeData(size: 24.0), // Set the size here
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios,color: Colors.grey,),
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
