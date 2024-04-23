import 'dart:async';
import 'package:chicken_combat/common/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int seconds;
  final TextStyle? textStyle;
  final Function onTimerComplete;
  final bool showIcon;
  bool isBoom;

  CountdownTimer({
    Key? key,
    this.seconds = 60,
    required this.onTimerComplete,
    this.textStyle,
    this.showIcon = false,
    this.isBoom = false
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _counter;
  late Timer _timer;

  void _startTimer() {
    _counter = widget.seconds;
    widget.isBoom = false;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
          widget.isBoom = _counter <= 3;  // Set to true when counter is 3 or less
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

  void stopTimer() {
    if (_timer.isActive) {
      _timer.cancel();
      setState(() {
        _counter = widget.seconds;
      });
    }
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.showIcon ? AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          transform: widget.isBoom ? (Matrix4.rotationZ(0.05) ..translate(-3.0, 0.0)) : Matrix4.identity(),
          child: Image.asset(Assets.ic_boom, width: 24.0),
        ) : SizedBox.shrink(),
        Text(
          '${_counter}s',
          style: widget.textStyle?.copyWith(
            color: widget.isBoom ? Colors.red : widget.textStyle?.color,
          ) ?? TextStyle(
            color: widget.isBoom ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }
}