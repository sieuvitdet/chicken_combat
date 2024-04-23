import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';

class DialogConfirmWidget extends StatelessWidget {
  final Function? agree;
  final Function? cancel;
  final String? title;

  DialogConfirmWidget({this.agree, this.cancel,this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: AppSizes.maxWidth*0.838,
          height: AppSizes.maxHeight > 850 ? AppSizes.maxHeight*0.3 : AppSizes.maxHeight*0.35,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.img_bg_popup_confirm,
                fit: BoxFit.fill,
                width: AppSizes.maxWidth*0.838,
          height: AppSizes.maxHeight > 850 ? AppSizes.maxHeight*0.28 : AppSizes.maxHeight*0.35,
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
                            text: title ?? AppLocalizations.text(LangKey.confirm_purchase), size: AppSizes.maxWidth < 350 ? 16 : 24,),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [_cancel(),_confirm()]),
                        )
                      ],
                    ),
                  )),
                  SizedBox(
                    height: AppSizes.maxHeight*0.025,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cancel() {
    return ScalableButton(
        onTap: cancel,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              Assets.img_button_popup_confirm,
              height: AppSizes.maxHeight*0.053,
            ),
            StrokeTextWidget(
              text:AppLocalizations.text(LangKey.cancel),
              size:AppSizes.maxWidth < 350 ? 16 : 24,
            )
          ],
        ));
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
