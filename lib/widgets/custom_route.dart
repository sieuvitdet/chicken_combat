import 'package:flutter/material.dart';

class CustomRoute extends MaterialPageRoute {
  final Widget page;
  CustomRoute({required this.page}) : super(builder: (context) => page);

  @override
  // TODO: implement settings
  RouteSettings get settings =>
      RouteSettings(name: page.runtimeType.toString());
}