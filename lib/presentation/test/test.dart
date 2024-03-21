import 'package:flutter/material.dart';

class testscreen extends StatefulWidget {
  const testscreen({super.key});

  @override
  State<testscreen> createState() => _testscreenState();
}

class _testscreenState extends State<testscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(width: 50, height: 50, color: Colors.red,),
      ),
    );
  }
}