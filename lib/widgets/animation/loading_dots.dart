import 'dart:async';
import 'package:flutter/material.dart';

class LoadingDots extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int dotCount;
  final Duration duration;

  LoadingDots({
    Key? key,
    required this.text,
    required this.style,
    this.dotCount = 3,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _LoadingDotsState createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots> {
  late Timer _timer;
  int _currentDotCount = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.duration, (Timer t) {
      setState(() {
        _currentDotCount = (_currentDotCount + 1) % (widget.dotCount + 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String dots = '.' * _currentDotCount;
    return Container(
      width: double.infinity, // Ensures the container takes up all available width
      alignment: Alignment.center, // Centers the text within the container
      child: Text(
        '${widget.text}$dots',
        style: widget.style,
        textAlign: TextAlign.center,
      ),
    );
  }
}