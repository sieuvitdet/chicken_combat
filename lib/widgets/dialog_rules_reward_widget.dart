import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';

class DialogRulesRewardWidget extends StatefulWidget {
  const DialogRulesRewardWidget({super.key});

  @override
  State<DialogRulesRewardWidget> createState() => _DialogRulesRewardWidgetState();
}

class _DialogRulesRewardWidgetState extends State<DialogRulesRewardWidget> {
    Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: AppSizes.maxWidth * 0.838,
          height: AppSizes.maxHeight * 0.47,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.img_background_popup,
                fit: BoxFit.fill,
                height: AppSizes.maxHeight * 0.49,
              ),
              Column(
                children: [
                  Container(
                    height: AppSizes.maxHeight * 0.09,
                    child: Center(
                      child: StrokeTextWidget(
                          text: "Thể lệ",
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
                    child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Text(
                                   "Cột mốc\n",
                                   style: TextStyle(fontSize: 16,color: Colors.black),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              WidgetSpan(
                                child: Text(
                                   "Mức 1: Người chơi A làm mức 1 sẽ đạt được phần thưởng tương ứng",
                                   style: TextStyle(fontSize: 16,color: Colors.black),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              WidgetSpan(
                                child: Text(
                                   "Mức 1: Người chơi A làm mức 1 sẽ đạt được phần thưởng tương ứng",
                                   style: TextStyle(fontSize: 16,color: Colors.black),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              WidgetSpan(
                                child: Text(
                                   "Mức 1: Người chơi A làm mức 1 sẽ đạt được phần thưởng tương ứng",
                                   style: TextStyle(fontSize: 16,color: Colors.black),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                  )),
                  SizedBox(
                    height: AppSizes.maxHeight * 0.025,
                  )
                ],
              ),
              Positioned(
                  right: 16,
                  top: AppSizes.maxHeight * 0.0245,
                  child: ScalableButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(Assets.ic_close_popup,
                          width: AppSizes.maxWidth * 0.116))),
            ],
          ),
        ),
      ),
    );
  }
}