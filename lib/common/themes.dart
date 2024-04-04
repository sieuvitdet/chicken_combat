import 'package:flutter/material.dart';

class AppSizes {
  static double maxWidth = 0.0;
  static double maxHeight = 0.0;
  static double statusBarHeight = 0.0;
  static double bottomHeight = 0.0;
  static double sizeAppBar = 0.0;
  static double screenHeight = 0.0;
  static double screenHeightAppBar = 0.0;
  static double scaleWidth = 0.0;
  static double scaleHeight = 0.0;
  //icon

  static init(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    bottomHeight = MediaQuery.of(context).padding.bottom;
    sizeAppBar = statusBarHeight + kToolbarHeight;
    screenHeightAppBar = maxHeight - sizeAppBar;
    screenHeight = maxHeight - statusBarHeight;
    scaleWidth = maxWidth/414;
    scaleHeight = maxHeight/896;
  }

   static bool isSmallScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 800;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width > 800;
  }
}

 