import 'dart:math';
import 'dart:ui';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/widgets/group_mountain_sea_widget.dart';
import 'package:flutter/material.dart';

class Map3Screen extends StatefulWidget {
  const Map3Screen({super.key});

  @override
  State<Map3Screen> createState() => _Map3ScreenState();
}

class _Map3ScreenState extends State<Map3Screen> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  bool enableScroll = true;
  final random = Random();
  double maxScroll = 0.0;
  int numberMountain = 10;
  int distance = 100;
  int location = 0;
  List<double> _listPadding = [12, 24, 12, 24, 12, 12, 24, 12, 12, 24, 12];
  double currentPadding = 0.0;
  double nextPadding = 0.0;

  late AnimationController _controller;
  late Animation _animation;
  late Path _path;
  double heightContent = 0.0;
  double multiple = 0.2;

  late AnimationController _controller1;
  late Animation<Offset> _animation1;

  @override
  void initState() {
    super.initState();
    _configUI();
    _configChickkenDance();
    _configMapShake();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }



  void _configUI() {
    currentPadding = _listPadding[0];
    nextPadding = _listPadding[1];
    heightContent = AppSizes.maxHeight * multiple * (numberMountain + 2);
    location = 0;
  }

  void _configChickkenDance() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          print(location);
          if (location == (numberMountain - 2)) {
            return;
          }
          _controller.reset();
          location += 1;
          _path = drawPath();
        });
      }
    });
    _path = drawPath();
  }

  void _configMapShake() {
    _controller1 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation1 = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.05, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller1.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBottom() {
    return Container(
      height: heightContent,
      child: Image.asset(Assets.img_background_blue, fit: BoxFit.cover),
    );
  }

  Widget _buildContent() {
    return Container(
      width: AppSizes.maxWidth,
      height: heightContent,
      child: Stack(
        children: [
          ...(_buildItemList()).map((e) => e).toList(),
          Positioned(
            top: calculate(_animation.value).dy,
            left: calculate(_animation.value).dx,
            child: Transform(
              alignment: Alignment.center,
              transform: location % 2 == 0
                  ? Matrix4.rotationY(0)
                  : Matrix4.rotationY(pi),
              child: AnimatedBuilder(
                  animation: _animation1,
                  builder: (context, child) {
                    return Transform.translate(
                      offset:
                          _animation1.value * 200, // Adjust the curve radius here
                      child: child,
                    );
                  },
                  child: Image.asset(Assets.gif_chicken_swimming, fit: BoxFit.fitHeight,width: AppSizes.maxWidth * 0.2,
                  height: AppSizes.maxWidth * 0.2),
                    ),
            ),
          ),
          // Positioned(
          //   top: 0,
          //   child: CustomPaint(
          //     painter: PathPainter(_path),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _item(int i, double bottom) {
    return Positioned(
        bottom: i * AppSizes.maxHeight * multiple + bottom,
        child: AnimatedBuilder(
                animation: _animation1,
                builder: (context, child) {
                  return Transform.translate(
                    offset:
                        _animation1.value * 200, // Adjust the curve radius here
                    child: child,
                  );
                },
                child: GroupMountainSea(
                heightMountain:AppSizes.maxHeight > 800 ? AppSizes.maxHeight * 0.13 : AppSizes.maxHeight* 0.15,
                isLeft: i % 2 == 0,
                horizontal: _listPadding[i] * AppSizes.maxWidth / 414,
                count: i + 1,
                onTap: () => {
                  if (i < numberMountain)
                    {
                      currentPadding = _listPadding[i + 1],
                      nextPadding =
                          i > (numberMountain - 2) ? 0.0 : _listPadding[i + 2],
                      _scrollToTop(maxScroll -
                          (location * (distance + 60) * AppSizes.maxHeight / 896)),
                      _controller.forward(),
                    }
                },
              ),
        )
            );
  }

  List<Widget> _buildItemList() {
    List<Widget> itemList = [];
    for (int i = 0; i < numberMountain; i++) {
      itemList.add(_item(i, 15*AppSizes.maxHeight/896));
    }

    return itemList;
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
    maxScroll = _scrollController.position.maxScrollExtent;
  }

  void _scrollToTop(double position) {
    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  Path drawPath() {
    Path path = Path();
    double bottomChicken = AppSizes.maxHeight > 800 ? 60 : 80;
    double bottom = heightContent - bottomChicken - AppSizes.maxHeight * multiple;
    double left = currentPadding * AppSizes.maxWidth / 414;
    double nextleft = nextPadding * AppSizes.maxWidth / 414;
    double width = AppSizes.maxWidth * 0.42;
    double maxWidth = AppSizes.maxWidth;
    double maxHeight = AppSizes.maxHeight;
    if (location == 0) {
      path.moveTo(left + width / 3, bottom);
      path.quadraticBezierTo(
          left + width,
          bottom - maxHeight * multiple,
          maxWidth - nextleft - width / 1.5,
          bottom - maxHeight * multiple);
    } else if (location == 1) {
      path.moveTo(maxWidth - left - width / 1.5, bottom - maxHeight * multiple);
      path.quadraticBezierTo(
          left + width / 3,
          bottom - 2 * maxHeight * multiple,
          nextleft + width / 2,
          bottom - 2 * maxHeight * multiple);
    } else if (location == 2) {
      path.moveTo(left + width / 2, bottom - 2 * maxHeight * multiple);
      path.quadraticBezierTo(
          left + width / 2,
          bottom - 2 * maxHeight * multiple,
          maxWidth - nextleft - width / 1.5,
          bottom - 3 * maxHeight * multiple);
    } else if (location == 3) {
      path.moveTo(
          maxWidth - left - width / 1.5, bottom - 3 * maxHeight * multiple); 
      path.quadraticBezierTo(  
          left + width / 2,
          bottom - 4 * maxHeight * multiple,
          nextleft + width / 2,
          bottom - 4 * maxHeight * multiple);
    } else if (location == 4) {
      path.moveTo(left + width / 2, bottom - 4 * maxHeight * multiple);
      path.quadraticBezierTo(
          left + width / 2,
          bottom - 4 * maxHeight * multiple,
          maxWidth - nextleft - width / 1.5,
          bottom - 5 * maxHeight * multiple);
    } else if (location == 5) {
      path.moveTo(
          maxWidth - left - width / 1.5, bottom - 5 * maxHeight * multiple);
      path.quadraticBezierTo(
          left + width / 2,
          bottom - 6 * maxHeight * multiple,
          nextleft + width / 2,
          bottom - 6 * maxHeight * multiple);
    } else if (location == 6) {
      path.moveTo(left + width / 2, bottom - 6 * maxHeight * multiple);
      path.quadraticBezierTo(
          left + width / 2,
          bottom - 6 * maxHeight * multiple,
          maxWidth - nextleft - width / 1.5,
          bottom - 7 * maxHeight * multiple);
    } else if (location == 7) {
      path.moveTo(
          maxWidth - left - width / 1.5, bottom - 7 * maxHeight * multiple);
      path.quadraticBezierTo(
          left + width / 2,
          bottom - 8 * maxHeight * multiple,
          nextleft + width / 2,
          bottom - 8 * maxHeight * multiple);
    } else if (location == 8) {
      path.moveTo(left + width / 2, bottom - 8 * maxHeight * multiple);
      path.quadraticBezierTo(
          left + width / 2,
          bottom - 8 * maxHeight * multiple,
          maxWidth - nextleft - width / 1.5,
          bottom - 9 * maxHeight * multiple);
    } else if (location == 9) {
      path.moveTo(
          maxWidth - left - width / 1.5, bottom - 9 * maxHeight * multiple);
      path.quadraticBezierTo(
          left + width / 2,
          bottom - 11.4 * maxHeight * multiple,
          nextleft + width / 2,
          bottom - 10 * maxHeight * multiple);
    }

    print(left + width / 3);
    print(left + width / bottom);

    return path;
  }

  Offset calculate(value) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value)!;
    return pos.position;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        // appBar: AppBar(centerTitle: true, title: Text("Đức")),
        backgroundColor: Color(0xffFFF0AB),
        body: SingleChildScrollView(
            controller: _scrollController,
            physics: ClampingScrollPhysics(),
            child: Stack(
              children: [_buildBottom(), _buildContent()],
            )),
      ),
    );
  }}

class PathPainter extends CustomPainter {
  Path path;

  PathPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(this.path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
