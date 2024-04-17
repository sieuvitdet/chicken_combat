import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';

class CustomDialogWithTitleButtonWidget extends StatelessWidget {
  final Function? ontap;
  final String title;
  final String? titleButton;

  CustomDialogWithTitleButtonWidget(
      {this.ontap, required this.title, this.titleButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: AppSizes.maxWidth * 0.868,
          height: AppSizes.maxHeight * 0.38,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.img_bg_popup_confirm,
                fit: BoxFit.fill,
                width: AppSizes.maxWidth * 0.868,
                height: AppSizes.maxHeight * 0.4,
              ),
              Column(
                children: [
                  Container(height: AppSizes.maxHeight * 0.0535),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: AppSizes.maxHeight*0.0267),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xFFEDB371),
                            Color(0xFFFFD383),
                          ],
                        )),
                    child: Column(
                      children: [
                        StrokeTextWidget(
                          text: title,
                          size: AppSizes.maxWidth < 350 ? 16 : 24,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: AppSizes.maxHeight*0.03),
                          child: _btnBottom(),
                        )
                      ],
                    ),
                  )),
                  SizedBox(
                    height: AppSizes.maxHeight * 0.025,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btnBottom() {
    return CustomButtomImageColorWidget(
      onTap: () {
        AudioManager.playSoundEffect(AudioFile.sound_tap);  // Play sound effect
        if (ontap != null) {
          ontap!();  // Call the provided onTap function if it exists
        }
      },
      orangeColor: true,
      child: Center(
        child: StrokeTextWidget(
          text: titleButton ?? "Đồng ý",
          size: AppSizes.maxWidth < 350 ? 14 : 20,
          colorStroke: Color(0xFFD18A5A),
        ),
      ),
    );
  }
}
