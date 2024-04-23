import 'package:carousel_slider/carousel_slider.dart';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MapListeningLessonScreen extends StatefulWidget {
  const MapListeningLessonScreen({super.key});

  @override
  State<MapListeningLessonScreen> createState() =>
      _MapListeningLessonScreenState();
}

class _MapListeningLessonScreenState extends State<MapListeningLessonScreen>
    with WidgetsBindingObserver {
  String text =
      "Welcome to our random topic! Get ready to explore some interesting  questions we've  prepared for you. Did you know that they say cats can jump higher than dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thoughts! And you, if you were to be a scientist for a day, what would you research? Discuss and share your opinions with us on these intriguing questions. Remember, there are no right or wrong answers, only endless curiosity and exploration!\n\n"
      "Welcome to our random topic! Get ready  to explo";

  List<String> parts = [];
  List<String> anwsers = [];
  var _isKeyboardVisible = false;
  int page = 1;
  bool isListening = false;

  CarouselController buttonCarouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    splitText(text);
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
        Spacer(),
        _listening(),
        // Visibility(visible: !_isKeyboardVisible, child: _buildButton()),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Flexible(
                child: ScalableButton(
                  onTap: () {
                    page -= 1;
                    setState(() {});
                  },
                  child: CustomButtomImageColorWidget(
                    smallButton: true,
                    child: Center(
                      child: StrokeTextWidget(
                        text: "Previous",
                        size: AppSizes.maxWidth < 350 ? 14 : 20,
                        colorStroke: Color(0xFFD18A5A),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Flexible(
                child: ScalableButton(
                  onTap: () {
                    page += 1;
                    setState(() {});
                  },
                  child: CustomButtomImageColorWidget(
                    smallButton: true,
                    child: Center(
                      child: StrokeTextWidget(
                        text: "Next",
                        size: AppSizes.maxWidth < 350 ? 14 : 20,
                        colorStroke: Color(0xFFD18A5A),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
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
              print("record");
              setState(() {
                isListening = !isListening;
              });
            },
            child: Image.asset(
              isListening
                  ? Assets.ic_playing_listening
                  : Assets.ic_notplay_listening,
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
    return Flexible(
      child: Stack(
        children: [
          Container(
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
                  height: AppSizes.maxHeight / 3,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  scrollDirection: Axis.horizontal),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 16,
              right: 16,
              child: Image(image: AssetImage(Assets.img_line_table)))
        ],
      ),
    );
  }

  List<Widget> _listAnswer() {
    List<Widget> itemList = [];
    for (int i = 0; i < 4; i++) {
      itemList.add(_answer(i));
    }
    return itemList;
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

  Widget _answer(int i, {Function? ontap}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: CustomButtomImageColorWidget(
        redBlurColor: true,
        child:
            Text("Đáp án", style: TextStyle(fontSize: 24, color: Colors.white)),
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
          canPop: false,
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
                  mobile: _buildContent(),
                  tablet: _buildContent(),
                  desktop: _buildContent())),
        ),
      ),
    );
  }
}
