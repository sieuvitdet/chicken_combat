import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:flutter/material.dart';

class WritingStudyScreen extends StatefulWidget {
  const WritingStudyScreen({super.key});

  @override
  State<WritingStudyScreen> createState() => _WritingStudyScreenState();
}

class _WritingStudyScreenState extends State<WritingStudyScreen>
    with WidgetsBindingObserver {
  TextEditingController _controller = TextEditingController();
  String text =
      "Welcome to our random topic! Get ready to explore some interesting [text] questions we've [text] prepared for you. Did you know that they say cats can jump higher than dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thoughts! And you, if you were to be a scientist for a day, what would you research? Discuss and share your opinions with us on these intriguing questions. Remember, there are no right or wrong answers, only endless curiosity and exploration!\n\n"
      "Welcome to our random topic! Get ready [text] to explore some interesting questions we've prepared for you. Did you know that they say cats can jump higher than dogs? Do you think this statement is true or false? What do you think about taking care of the green environment around us? Share your thoughts! And you, if you were to be a scientist for a day, what would you research? Discuss and share your opinions with us on these intriguing questions. Remember, there are no right or wrong answers, only endless curiosity and exploration!";

  List<String> parts = [];
  List<String> anwsers = [];
  var _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    parts = text.split('[text]');

    anwsers.add("");
    for (int i = 0; i < parts.length - 1; i++) {
      anwsers.add("");
    }
  }

  List<InlineSpan> _listTextSpan() {
    List<InlineSpan> textSpans = [];

    for (int i = 0; i < parts.length; i++) {
      int count = i + 1;
      textSpans.add(
        TextSpan(
          text: parts[i],
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );
      textSpans.add(i < parts.length - 1
          ? TextSpan(
              text: anwsers[i] == "" ? "[...$count...]" : anwsers[i],
              style: TextStyle(color: Colors.white, fontSize: 16))
          : TextSpan(text: ""));
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.amber,
          body: Column(
            children: [
              SizedBox(height: AppSizes.statusBarHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      image: AssetImage(Assets.chicken_flapping_swing_gif),
                      height: 100,
                      fit: BoxFit.fill),
                  Text(
                    "Level 1",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: RichText(
                    text: TextSpan(children: _listTextSpan()),
                  ),
                ),
              )),
              Visibility(visible: !_isKeyboardVisible, child: _buildButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.red,
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      height: 60,
      child: Center(
        child: Text(
          "Next",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
