import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  CustomScaffold({required this.body, this.backgroundColor});

  final Widget body;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(mobile: body, tablet: body, desktop: body),
      backgroundColor: backgroundColor,
    );
  }
}