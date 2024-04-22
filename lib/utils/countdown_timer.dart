import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int seconds;
  final TextStyle? textStyle;
  final Function onTimerComplete;

  CountdownTimer({
    Key? key,
    this.seconds = 60,
    required this.onTimerComplete,
    this.textStyle
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _counter;
  late Timer _timer;

  void _startTimer() {
    _counter = widget.seconds;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        _timer.cancel();
        widget.onTimerComplete();
      }
    });
  }

  void resetTimer() {
    _startTimer();
  }
  // Assuming you have a GlobalKey for your CountdownTimer
  //GlobalKey<_CountdownTimerState> countdownTimerKey = GlobalKey<_CountdownTimerState>();

// Somewhere in your code, when you need to reset the timer:
  //countdownTimerKey.currentState?.resetTimer();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_counter}s',
      style: widget.textStyle
    );
  }
}