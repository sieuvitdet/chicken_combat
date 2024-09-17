import 'package:carousel_slider/carousel_slider.dart';
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/examination/map_writing_examination_screen.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/custom_listview_widget.dart';
import 'package:flutter/material.dart'  hide CarouselController;

class MapWritingLessonScreen extends StatefulWidget {
  const MapWritingLessonScreen({super.key});

  @override
  State<MapWritingLessonScreen> createState() => _MapWritingLessonScreenState();
}

class _MapWritingLessonScreenState extends State<MapWritingLessonScreen> with WidgetsBindingObserver {
  // String text = "";
  String text1 =
      "Welcome to our random topic! Get ready to explore some interesting [text] questions we've [text] prepared for you. Did you know that they say cats can jump higher than dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thoughts! And you, if you were to be a scientist for a day, what would you research? Discuss and share your opinions with us on these intriguing questions. Remember, there are no right or wrong answers, only endless curiosity and exploration!\n\n"
      "Welcome to our [text] random topic! Get ready [text]to o our ";

  String text2 =
      "Welcome [text] questions we've [text] prepared for you. Did you know that they say cats can jump higher than [text] dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thoughts! And you, if you were to be a scientist for a day, what would you research? Discuss and share your opinions with us on these intriguing questions. Remember, there are no right or wrong answers, only endless curiosity and exploration!\n\n"
      "Welcome to our random topic! Get ready [text] to explore some interesting questions we've prepared for you.";

  String text3 =
      "Welcome [text] questions we've [text] prepared for you. Did you know that they say cats can jump higher than [text] dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thoughts! And you, if you were to be a scientist for a day, what would you research? Discuss and share your opinions with us on these intriguing questions. Remember, there are no right or wrong answers, only endless curiosity and exploration!\n\n"
      "Welcome to our random topic! Get ready [text] to explore some interesting questions we've prepared for you.";

  String text4 =
      "Welcome [text] questions we've [text] prepared for you. Did you know that they say cats can jump higher than [text] dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thoughts! And you, if you were to be a scientist for a day, what would you research? Discuss and share your opinions with us on these intriguing questions. Remember, there are no right or wrong answers, only endless curiosity and exploration!\n\n"
      "Welcome to our random topic! Get ready [text] to explore some interesting questions we've prepared for you.";

  String text5 =
      "Welcome [text] questions we've [text] prepared for you. Did you know that they say cats can jump higher than [text] dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thoughts! And you, if you were to be a scientist for a day, what would you research? Discuss and share your opinions with us on these intriguing questions. Remember, there are no right or wrong answers, only endless curiosity and exploration!\n\n"
      "Welcome to our to explore some interesting questions we've prepared for you.";

  var _isKeyboardVisible = false;
  int page = 0;
  bool isTextOverflow = false;

CarouselSliderController buttonCarouselController = CarouselSliderController();
  ScrollController _controller = ScrollController();

  TextEditingController _anwser1 = TextEditingController();
  FocusNode _focusNodeAnwser1 = FocusNode();

  TextEditingController _anwser2 = TextEditingController();
  FocusNode _focusNodeAnwser2 = FocusNode();

  TextEditingController _anwser3 = TextEditingController();
  FocusNode _focusNodeAnwser3 = FocusNode();

  TextEditingController _anwser4 = TextEditingController();
  FocusNode _focusNodeAnwser4 = FocusNode();

  bool isPressed = false;

  List<String> pages = [];
  List<String> parts = [];
  List<List<String>> _listParts = [];
  List<Pagination> _listStt = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
    WidgetsBinding.instance.addObserver(this);
    _pagination();
    // _listStt = List.generate(numberMap, (index) => index);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    WidgetsBinding.instance.removeObserver(this);
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

  void _pagination() {
    pages.addAll([text1, text2, text3, text4, text5]);
    // _checkTextOverflow(pages[0]);

    splitText(pages);
  }

  void _checkTextOverflow(String text) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if the text overflows
      TextSpan span = TextSpan(style: TextStyle(fontSize: 16.0), text: text);
      TextPainter tp = TextPainter(
          text: span, maxLines: 20, textDirection: TextDirection.ltr);
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

  void splitText(List<String> texts) {
    for (int i = 0; i < texts.length; i++) {
      parts = texts[i].split('[text]');
      _listParts.add(parts);
      _listStt.addAll(List.generate(parts.length,
          (index) => Pagination(stt: (i * 4) + index + 1, anwser: "")));
    }
    setState(() {});
  }

  List<InlineSpan> _listTextSpan() {
    List<InlineSpan> textSpans = [];
    if (_listParts.length > 0) {
      for (int i = 0; i < _listParts[page].length; i++) {
        textSpans.add(
          TextSpan(
            text: _listParts[page][i],
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontFamily: "Itim"),
          ),
        );
        textSpans.add(i < _listParts[page].length - 1
            ? TextSpan(
                text: "[.....${(page * 4) + i + 1}.....]",
                style: TextStyle(
                    color: Colors.red, fontSize: 16, fontFamily: "Itim"))
            : TextSpan(text: ""));
      }

      return textSpans;
    }
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: CustomListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [_body(), ..._listButton()],
        )),
        Visibility(visible: !_isKeyboardVisible, child: _buildButton()),
        Container(
          height: AppSizes.bottomHeight,
        )
      ],
    );
  }

  List<Widget> _listButton() {
    List<Widget> _listWidget = [];
    if (_listParts.length > 0) {
      for (int i = 0; i < _listParts[page].length - 1; i++) {
        _listWidget.add(_answer(
            (page * 4) + i + 1,
            _listStt[(page * 4) + i].anwser ?? "",
            i == 0
                ? _anwser1
                : i == 1
                    ? _anwser2
                    : i == 2
                        ? _anwser3
                        : _anwser4,
            i == 0
                ? _focusNodeAnwser1
                : i == 1
                    ? _focusNodeAnwser2
                    : i == 2
                        ? _focusNodeAnwser3
                        : _focusNodeAnwser4));
      }
    }
    return _listWidget;
  }

  Widget _buildBackground() {
    return BackGroundCloudWidget();
  }

  Widget _body() {
    return Container(
      height: AppSizes.maxHeight / 2.2,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(vertical: 16),
                height: AppSizes.maxHeight / 2.2,
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
                      height: AppSizes.maxHeight / 2.2,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: false,
                      scrollDirection: Axis.horizontal),
                ),
              ),
            ],
          ),
          Positioned(
              bottom: 0,
              left: 16,
              right: 16,
              child: Image(image: AssetImage(Assets.img_line_table))),
          Positioned(
              bottom: AppSizes.maxHeight * 0.02,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScalableButton(
                      onTap: () {
                        if (page <= 0) {
                          return;
                        }
                        setState(() {
                          page--;
                          _anwser1.text = _listStt[(page * 4)].anwser ?? "";
                          _anwser2.text = _listStt[(page * 4) + 1].anwser ?? "";
                          _anwser3.text = _listStt[(page * 4) + 2].anwser ?? "";
                          _anwser4.text = _listStt[(page * 4) + 3].anwser ?? "";
                        });
                      },
                      child: Image.asset(
                        Assets.ic_previous_page,
                        width: AppSizes.maxWidth * 0.058,
                        fit: BoxFit.contain,
                      )),
                  Text(
                    "${page + 1}/${pages.length}",
                    style: TextStyle(color: Colors.white),
                  ),
                  ScalableButton(
                      onTap: () {

                        if (page >= pages.length - 1) {
                          return;
                        }
                        page += 1;
                        _anwser1.text = _listStt[(page * 4)].anwser ?? "";
                        _anwser2.text = _listStt[(page * 4) + 1].anwser ?? "";
                        _anwser3.text = _listStt[(page * 4) + 2].anwser ?? "";
                        _anwser4.text = _listStt[(page * 4) + 3].anwser ?? "";

                        setState(() {});
                      },
                      child: Image.asset(
                        Assets.ic_next_page,
                        width: AppSizes.maxWidth * 0.058,
                        fit: BoxFit.contain,
                      )),
                ],
              )),
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
              text: TextSpan(
                  children: _listParts.length > 0
                      ? _listTextSpan()
                      : [TextSpan(text: "")]),
            ),
          ),
        )),
      ],
    );
  }

  Widget _answer(int stt, String content, TextEditingController _controller,
      FocusNode _focusnode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 48,
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.ic_stt_redblur,
                height: 48,
                fit: BoxFit.fill,
              ),
              Center(
                child: Text(
                  "$stt",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              )
            ],
          ),
          SizedBox(width: 16),
          Expanded(
              child: Stack(
            children: [
              Image.asset(
                Assets.img_frame_textfield,
                height: 48,
                width: AppSizes.maxWidth,
                fit: BoxFit.fill,
              ),
              TextField(
                  controller: _controller,
                  focusNode: _focusnode,
                  onChanged: (value) {
                    _listStt[stt - 1].anwser = value;
                  },
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                    border: InputBorder.none,
                    hintText: "Nhập đáp án",
                    isDense: true,
                  ))
            ],
          ))
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButtomImageColorWidget(
        orangeColor: true,
        child: Text((page == pages.length - 1) ? "Final" : "Next",
            style: TextStyle(fontSize: 24, color: Colors.white)),
        onTap: () {
          if (page >= pages.length - 1) {
            return;
          }
          page += 1;
          _anwser1.text = _listStt[(page * 4)].anwser ?? "";
          _anwser2.text = _listStt[(page * 4) + 1].anwser ?? "";
          _anwser3.text = _listStt[(page * 4) + 2].anwser ?? "";
          _anwser4.text = _listStt[(page * 4) + 3].anwser ?? "";

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
                leading: SizedBox.shrink(),
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
                alignment: Alignment.center,
                children: [_buildBackground(), _buildContent()],
              ),
              tablet: Stack(
                alignment: Alignment.center,
                children: [_buildBackground(), _buildContent()],
              ),
              desktop: Stack(
                alignment: Alignment.center,
                children: [_buildBackground(), _buildContent()],
              ),
            )),
      ),
    );
  }
}
