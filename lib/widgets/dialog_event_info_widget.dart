import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';

class DialogEventInfoWidget extends StatelessWidget {

  final Function? agree;
  final String? title;


  DialogEventInfoWidget({this.agree, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: AppSizes.maxWidth * 0.86,
          height: AppSizes.maxHeight > 850 ? AppSizes.maxHeight* 0.5 : AppSizes.maxHeight*0.55,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.img_bg_popup_confirm,
                fit: BoxFit.fill,
                width: AppSizes.maxWidth * 0.84,
                height: AppSizes.maxHeight > 850 ? AppSizes.maxHeight*0.58 : AppSizes.maxHeight*0.55,
              ),
              Column(
                children: [
                  Container(height: AppSizes.maxHeight*0.0535),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                              text: title ?? AppLocalizations.text(LangKey.confirm_purchase), size: AppSizes.maxWidth < 350 ? 8 : 16, textAlign: TextAlign.start,),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [_confirm()]),
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    height: AppSizes.maxHeight*0.03,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirm() {
    return ScalableButton(
        onTap: agree,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              Assets.img_button_popup_confirm,
              height: AppSizes.maxHeight*0.053,
            ),
            StrokeTextWidget(
              text: AppLocalizations.text(LangKey.agree),
              size: AppSizes.maxWidth < 350 ? 16 : 24,
            )
          ],
        ));
  }
}

