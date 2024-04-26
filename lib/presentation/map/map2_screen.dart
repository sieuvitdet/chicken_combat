import 'dart:math';
import 'dart:ui';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/examination/map_listening_examination_screen.dart';
import 'package:chicken_combat/presentation/examination/map_reading_examination_screen.dart';
import 'package:chicken_combat/presentation/examination/map_speaking_examination_screen.dart';
import 'package:chicken_combat/presentation/examination/map_writing_examination_screen.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/background_cloud_map2_widget.dart';
import 'package:chicken_combat/widgets/group_mountain_green_widget.dart';
import 'package:flutter/material.dart';

class Map2Screen extends StatefulWidget {
  final String? type;
  final bool isLesson;
  final int location;
  Map2Screen({this.type,required this.isLesson,required this.location});

  @override
  State<Map2Screen> createState() => _Map2ScreenState();
}

class _Map2ScreenState extends State<Map2Screen> with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  bool enableScroll = true;
  final random = Random();
  double maxScroll = 0.0;
  int numberMountain = 6;
  int distance = 100;
  int location = 0;
  List<double> _listPadding = [10, 12, 16, 24, 12, 24, 12, 24, 12, 24, 12];
  double currentPadding = 0.0;
  double nextPadding = 0.0;

  late AnimationController _controller;
  late Animation _animation;
  late Path _path;
  double heightContent = 0.0;
  double multiple = 0.138;
  bool _isReload = false;

  @override
  void initState() {
    super.initState();
    currentPadding = _listPadding[0];
    nextPadding = _listPadding[1];
    heightContent = AppSizes.maxHeight * multiple * (numberMountain + 3);
    location = 0;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildBottom() {
    return BackgroundCloudMap2Widget(heightContent: heightContent,);
  }

  Widget _buildContent() {
    return Center(
      child: Container(
        width: AppSizes.maxWidth,
        height: heightContent,
        child: Stack(
          children: [
            _mountainBottom(),
            ...(_buildItemList()).map((e) => e).toList(),
            Positioned(
              top: calculate(_animation.value).dy,
              left: calculate(_animation.value).dx,
              child: Transform(
                alignment: Alignment.center,
                transform: location % 2 == 0
                    ? Matrix4.rotationY(0)
                    : Matrix4.rotationY(pi),
                child: Image.asset(Assets.chicken_flapping_swing_gif, fit: BoxFit.contain,width: AppSizes.maxWidth * 0.2 ,
                  height: AppSizes.maxHeight * 0.11),
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
      ),
    );
  }

  Widget _mountainBottom() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        child: Container(
          child: Image(
            fit: BoxFit.cover,
            image: AssetImage(Assets.img_bottom_mountain_green),
            width: AppSizes.maxWidth * 0.9,
            height: AppSizes.maxWidth*0.5,
          ),
        ),
      ),
    );
  }

  Widget _item(int i, double bottom) {
    return Positioned(
        bottom: i * AppSizes.maxHeight * multiple + bottom,
        child: Group_Mountain_Green(
          heightMountain:AppSizes.maxHeight*0.15,
          isLeft: i % 2 == 0,
          horizontal: _listPadding[i] * AppSizes.maxWidth / 414,
          count: i + 1,
          onTap: () async {
            if (i > location) {
                return;
              }
              bool? result = null;
              if (widget.type != "" && widget.type == "reading") {
                result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MapReadingExaminationScreen()));
              } else if (widget.type != "" && widget.type == "listening") {
                result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MapListeningExaminationScreen(isGetReward: i < location,level: location+1,)));
              } else if (widget.type != "" && widget.type == "speaking") {
               result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MapSpeakingExaminationScreen()));
              }  else if (widget.type != "" && widget.type == "writing") {
               result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MapWritingExaminationScreen()));
              }

              if (result != null && result == true && i == location) {
                _isReload = true;
                if (i < numberMountain) {
                  currentPadding = _listPadding[i + 1];
                nextPadding = i > (numberMountain - 2) ? 0.0 : _listPadding[i + 2];
                _scrollToTop(maxScroll - (location * (distance + 60)));
                _controller.forward();
                }
              }
          },

          isStorehouse: i == 5,
          isTruck: i == 5,
          isTreeLeft: i == 4,
          isTreeRight: i == 2 || i == 3,
          isSmallTruck: i == 4,
          isCloud: i == 4,
          isBush: i == 1 || i == 2 || i == 4 || i == 5,
          isStart: i == 0,
          isFarmerWaterTheTree: i == 3,

        ));
  }

  List<Widget> _buildItemList() {
    List<Widget> itemList = [];
    for (int i = 0; i < numberMountain; i++) {
      itemList.add(_item(i, 120*AppSizes.maxHeight/896));
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
    double bottomChicken = AppSizes.maxHeight*0.25;
    double bottom = heightContent -
        bottomChicken -
        AppSizes.maxHeight * multiple;
        print(AppSizes.maxHeight);
    double left = currentPadding * AppSizes.maxWidth / 414;
    double nextleft = nextPadding * AppSizes.maxWidth / 414;
    double width = AppSizes.maxWidth * 0.42;
    double maxWidth = AppSizes.maxWidth;
    double maxHeight = AppSizes.maxHeight;
    if (location == 0) {
      path.moveTo(left + width / 3, bottom);
      path.quadraticBezierTo(left + width / 3, bottom - 2.4 * maxHeight * multiple,
          maxWidth - nextleft - width / 1.3, bottom - maxHeight * multiple);
    } else if (location == 1) {
      path.moveTo(maxWidth - left - width / 1.3, bottom - maxHeight * multiple);
      path.quadraticBezierTo(left + width / 3, bottom - 3.4 * maxHeight * multiple,
          nextleft + width / 3, bottom - 2 * maxHeight * multiple);
    } else if (location == 2) {
      path.moveTo(left + width / 3, bottom - 2 * maxHeight * multiple);
      path.quadraticBezierTo(left + width / 2, bottom - 3.4 * maxHeight * multiple,
          maxWidth - nextleft - width, bottom - 3 * maxHeight * multiple);
    } else if (location == 3) {
      path.moveTo(
          maxWidth - left - width, bottom - 3 * maxHeight * multiple);
      path.quadraticBezierTo(left + width / 2, bottom - 5.4 * maxHeight * multiple,
          nextleft + width / 2, bottom - 4 * maxHeight * multiple);
    } else if (location == 4) {
      path.moveTo(left + width / 2, bottom - 4 * maxHeight * multiple);
      path.quadraticBezierTo(left + width / 2, bottom - 6 * maxHeight * multiple,
          maxWidth - nextleft - width / 1.5, bottom - 5 * maxHeight * multiple);
    } else if (location == 5) {
      path.moveTo(
          maxWidth - left - width / 1.5, bottom - 5 * maxHeight * multiple);
      path.quadraticBezierTo(left + width / 2, bottom - 7.4 * maxHeight * multiple,
          nextleft + width / 2, bottom - 6 * maxHeight * multiple);
    } else if (location == 6) {
      path.moveTo(left + width / 2, bottom - 6 * maxHeight * multiple);
      path.quadraticBezierTo(left + width / 2, bottom - 8 * maxHeight * multiple,
          maxWidth - nextleft - width / 1.5, bottom - 7 * maxHeight * multiple);
    } else if (location == 7) {
      path.moveTo(
          maxWidth - left - width / 1.5, bottom - 7 * maxHeight * multiple);
      path.quadraticBezierTo(left + width / 2, bottom - 9.4 * maxHeight * multiple,
          nextleft + width / 2, bottom - 8 * maxHeight * multiple);
    } else if (location == 8) {
      path.moveTo(left + width / 2, bottom - 8 * maxHeight * multiple);
      path.quadraticBezierTo(left + width / 2, bottom - 10 * maxHeight * multiple,
          maxWidth - nextleft - width / 1.5, bottom - 9 * maxHeight * multiple);
    } else if (location == 9) {
      path.moveTo(
          maxWidth - left - width / 1.5, bottom - 9 * maxHeight * multiple);
      path.quadraticBezierTo(
          left + width / 2,
          bottom - 11.4 * maxHeight * multiple,
          nextleft + width / 2,
          bottom - 10 * maxHeight * multiple);
    }

    return path;
  }

  Offset calculate(value) {
    print("calculate $value");
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
        backgroundColor: Color(0xFf89E6F3),
        body: Stack(
            children: [
              SingleChildScrollView(
                  controller: _scrollController,
                  physics: ClampingScrollPhysics(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [_buildBottom(), _buildContent()],
                  )),
              Positioned(
                top: MediaQuery.of(context)
                    .padding
                    .top, // Đảm bảo không bị che bởi notch
                left: 0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              )
            ],
          ),
      ),
    );
  }
}