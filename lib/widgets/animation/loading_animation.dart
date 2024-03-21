import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  final Offset offsetSpeed;
  final List<Color> colors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];
  final double width;
  final double height;

  LoadingAnimation(
      {Key? key,
      required this.offsetSpeed,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  State<LoadingAnimation> createState() => _MyAnimatedLoadingState();
}

class _MyAnimatedLoadingState extends State<LoadingAnimation> {
  late List<Node> nodes;
  late double width;

  @override
  void initState() {
    super.initState();
    width = widget.width / (widget.colors.length);

    nodes = List.generate(widget.colors.length, (index) {
      return Node(
        rect: Rect.fromCenter(
            center: Offset(index * width + width / 2, widget.height / 2),
            width: width,
            height: widget.height),
        color: widget.colors[index],
      );
    });

    List<Node> tempNodes = <Node>[];
    for (int i = -widget.colors.length; i <= -1; i++) {
      tempNodes.add(Node(
        rect: Rect.fromCenter(
            center: Offset(i * width + width / 2, widget.height / 2),
            width: width,
            height: widget.height),
        color: widget.colors.first,
      ));
    }

    for (int i = 0; i < tempNodes.length; i++) {
      tempNodes[i].color = widget.colors[i];
    }

    nodes.addAll(tempNodes);

    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _calculateNewPositions();
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0), color: Colors.orange),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        child: CustomPaint(
          size: Size(widget.width, widget.height),
          painter: MyCustomPaint(nodes: nodes),
        ),
      ),
    );
  }

  void _calculateNewPositions() {
    for (final node in nodes) {
      final offset = node.rect.center;

      if (offset.dx - width / 2 >= widget.width) {
        node.rect = Rect.fromCenter(
            center: Offset(
                    (-width / 2) * (widget.colors.length * 2) + width / 2,
                    widget.height / 2) +
                widget.offsetSpeed,
            width: width,
            height: widget.height);
      } else {
        node.rect = Rect.fromCenter(
            center: offset + widget.offsetSpeed,
            width: width,
            height: widget.height);
      }
    }
  }
}

class Node {
  Rect rect;
  Color color;

  Node({required this.rect, required this.color});

  @override
  String toString() {
    return 'Node{rect: $rect, color: $color}\n';
  }
}

class MyCustomPaint extends CustomPainter {
  List<Node> nodes;

  MyCustomPaint({required this.nodes});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < nodes.length; i++) {
      final Path path = Path();
      final Rect rect = nodes[i].rect;

      path.moveTo(rect.left + rect.width / 2, rect.top);
      path.lineTo(rect.right, rect.top);
      path.lineTo(rect.right - rect.width / 2, rect.bottom);
      path.lineTo(rect.left, rect.bottom);
      path.close();

      canvas.drawPath(path, Paint()..color = nodes[i].color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
