import 'package:flutter/material.dart';

class StrokeTextWidget extends StatelessWidget {

  final String text;
  final double? size;
  final Color? colorStroke;

  StrokeTextWidget({required this.text,this.size,this.colorStroke});
 

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: <Widget>[
            Text(
              textAlign: TextAlign.center,
              text,
              style: TextStyle(
                fontSize: size ?? 24,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = colorStroke ??Color(0xFF9C4615),
              ),
            ),
            // Solid text as fill.
            Text(
              textAlign: TextAlign.center,
              text,
              style: TextStyle(
                fontSize: size ?? 24,
                color: Colors.white,
              ),
            ),
          ],
        );
  }
}