import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:flutter/material.dart';

class CustomButtomImageColorWidget extends StatelessWidget {
  final Function? onTap;
  final bool blueColor;
  final bool greenColor;
  final bool orangeColor;
  final bool redBlurColor;
  final bool redColor;
  final bool yellowColor;
  final bool smallButton;
  final bool smallOrangeColor;
  final bool smallGrayColor;
  final Widget? child;

  CustomButtomImageColorWidget(
      {this.onTap,
      this.blueColor = false,
      this.greenColor = false,
      this.orangeColor = false,
      this.redBlurColor = false,
      this.redColor = false,
      this.yellowColor = false,
      this.smallButton = false,
      this.smallGrayColor = false,
      this.smallOrangeColor = false,
      this.child});

  @override
  Widget build(BuildContext context) {
    return ScalableButton(
      onTap: onTap as void Function()?,
      child: Stack(
        alignment: Alignment.center,
        children: [
          !smallButton ? Image.asset(
              blueColor
                  ? Assets.img_button_blue
                  : greenColor
                      ? Assets.img_button_green
                      : orangeColor
                          ? Assets.img_button_orange
                          : redBlurColor
                              ? Assets.img_button_red_blur
                              : redColor
                                  ? Assets.img_button_red
                                  : yellowColor
                                      ? Assets.img_button_yellow
                                      : smallButton
                                          ? Assets.img_button_small_orange
                                          : Assets.img_button_grey,
              fit: BoxFit.fill,
              height: AppSizes.maxHeight * 0.0535,
              width: AppSizes.maxWidth) : Image.asset(
              smallOrangeColor
                  ? Assets.img_button_small_orange : Assets.img_button_small_gray
                      ,
              fit: BoxFit.fill,
              height: AppSizes.maxHeight * 0.0535,
              width:  AppSizes.maxWidth/2),
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
        AudioManager.playSoundEffect(AudioFile.sound_tap);
        if (widget.pressedScaleEnabled) {
          setState(() {
            isPressed = true;
          });
        }
      },
      onTapUp: (_) {
        AudioManager.playSoundEffect(AudioFile.sound_tap);
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
        AudioManager.playSoundEffect(AudioFile.sound_tap);
        if (widget.pressedScaleEnabled) {
          setState(() {
            isPressed = false;
          });
        }
      },
      child: Transform.scale(
        scale: isPressed ? 0.98 : 1.0,
        child: widget.child,
      ),
    );
  }
}
