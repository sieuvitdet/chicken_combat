import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogShieldWiget extends StatefulWidget {
  final Function? ontap;
  final bool isShowHalo;
  final String imgage;
  final String? type;

  DialogShieldWiget({this.ontap,this.isShowHalo = false, required this.imgage,required this.type});

  @override
  State<DialogShieldWiget> createState() => _DialogShieldWigetState();
}

class _DialogShieldWigetState extends State<DialogShieldWiget> {
  @override
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: AppSizes.maxWidth * 0.9,
          height: AppSizes.maxHeight * 0.58,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.img_background_popup,
                fit: BoxFit.fill,
                width: AppSizes.maxWidth * 0.89,
                height: AppSizes.maxHeight * 0.58,
              ),
              Column(
                children: [
                  Container(
                    height: AppSizes.maxHeight * 0.09,
                    child: Center(
                      child: StrokeTextWidget(
                          text: AppLocalizations.text(LangKey.notification),
                          size: AppSizes.maxWidth < 350 ? 30 : 40,
                          colorStroke: Colors.red[900]),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    width: AppSizes.maxWidth * 0.8,
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
                    child: Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        if (widget.isShowHalo) Positioned(
                          top: -AppSizes.maxHeight * 0.15,
                          left: 0,
                          right: 0,
                          child: Image.asset(
                            Assets.img_halo,
                            width: AppSizes.maxWidth,
                            height: AppSizes.maxHeight * 0.5,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Column(
                          children: [
                            StrokeTextWidget(
                                text: "Passed the barrier successfully",
                                size: AppSizes.maxWidth < 350 ? 16 : 24,
                                colorStroke: Colors.red[900]),
                            Image.asset(
                              widget.imgage,
                              width: AppSizes.maxWidth * 0.4,
                              fit: BoxFit.fill,
                            ),
                            StrokeTextWidget(
                                text: "God of ${widget.type}",
                                size: AppSizes.maxWidth < 350 ? 16 : 24,
                                colorStroke: Colors.red[900]),
                            Spacer(),
                            _buildButton()
                          ],
                        ),
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

  Widget _buildButton() {
    return CustomButtomImageColorWidget(
      onTap: widget.ontap,
      orangeColor: true,
      child: Center(
        child: StrokeTextWidget(
          text: AppLocalizations.text(LangKey.agree),
           size: AppSizes.maxWidth < 350 ? 12 : 16,
          colorStroke: Color(0xFFD18A5A),
        ),
      ),
    );
  }
}
