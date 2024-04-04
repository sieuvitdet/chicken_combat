import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:flutter/material.dart';

class CustomButtomImageColorWidget extends StatelessWidget {
  
  final Function? onTap;
  final bool blueColor;
  final bool greenColor;
  final bool orangeColor;
  final bool redBlurColor;
  final bool redColor;
  final bool yellowColor;
  final Widget? child;

  CustomButtomImageColorWidget({this.onTap,this.blueColor = false,this.greenColor = false,this.orangeColor = false,this.redBlurColor = false,this.redColor = false,this.yellowColor = false, this.child});
 
  @override
  Widget build(BuildContext context) {
    return ScalableButton(
      onTap: onTap as void Function()?,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            blueColor ? Assets.img_button_blue : 
            greenColor ? Assets.img_button_green : 
            orangeColor ? Assets.img_button_orange : 
            redBlurColor ? Assets.img_button_red_blur : 
            redColor ? Assets.img_button_red : 
            yellowColor ? Assets.img_button_yellow : Assets.img_button_grey ,
            fit: BoxFit.fill,
            height: 48,
            width: AppSizes.maxWidth),
          child ?? Container()

        ],
      ),
    );
  }
}

class ScalableButton extends StatefulWidget {
  final Function? onTap;
  final Widget child;
  final bool pressedScaleEnabled;

  ScalableButton({
    required this.child,
    this.onTap,
    this.pressedScaleEnabled = true,
  });

  @override
  _ScalableButtonState createState() => _ScalableButtonState();
}

class _ScalableButtonState extends State<ScalableButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.pressedScaleEnabled) {
          setState(() {
            isPressed = true;
          });
        }
      },
      onTapUp: (_) {
        if (widget.pressedScaleEnabled) {
          setState(() {
            isPressed = false;
          });
        }
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onTapCancel: () {
        if (widget.pressedScaleEnabled) {
          setState(() {
            isPressed = false;
          });
        }
      },
      child: Transform.scale(
        scale: isPressed ? 0.98 : 1.0, // Adjust the scaling factor as needed
        child: widget.child,
      ),
    );
  }
}