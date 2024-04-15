import 'dart:math';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';

class DialogRandomGiftWidget extends StatelessWidget {
  final Function? ontap;
  final String type;

  DialogRandomGiftWidget({this.ontap, required this.type});

  Widget build(BuildContext context) {
    String content = "";
    int gold = 0;
    String chicken = Assets.getRandomImage();
    String chickenPremium = Assets.getRandomImagePremium();
    final random = Random();
    switch (type) {
      case "gold":
        gold = random.nextInt(10) + 20;
        content = "Chúc mừng bạn nhận được ${gold} vàng";
        break;
      case "chicken":
        content = "Chúc mừng bạn nhận được vật phẩm";
        break;

      case "chicken_premium":
        content = "Chúc mừng bạn nhận được vật phẩm hiếm";
        break;
      default:
    }

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
                width: AppSizes.maxWidth * 0.8,
                height: AppSizes.maxHeight * 0.49,
              ),
              Column(
                children: [
                  Container(
                    height: AppSizes.maxHeight * 0.09,
                    child: Center(
                      child: StrokeTextWidget(
                          text: "Thông báo",
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
                    child: Column(
                      children: [
                        if (type == "gold") _buildGold(gold),
                        if (type == "chicken") _buildChickenReward(chicken),
                        if (type == "chicken_premium")
                          _buildChickenPremiumReward(chickenPremium),
                        SizedBox(height: 8.0),
                        StrokeTextWidget(
                            text: content,
                            size: AppSizes.maxWidth < 350 ? 16 : 20,
                            colorStroke: Colors.red[900]),
                        SizedBox(height: AppSizes.maxHeight * 0.02),
                        _btnBottom()
                      ],
                    ),
                  )),
                  SizedBox(
                    height: AppSizes.maxHeight * 0.025,
                  )
                ],
              ),
              // Positioned(
              //     right: 16,
              //     top: AppSizes.maxHeight * 0.0245,
              //     child: ScalableButton(
              //         onTap: () {
              //           Navigator.of(context).pop();
              //         },
              //         child: Image.asset(Assets.ic_close_popup,
              //             width: AppSizes.maxWidth * 0.116))),
            ],
          ),
        ),
      ),
    );
  }

  _buildChickenReward(String assest) {
    return Image.asset(assest,
        height: AppSizes.maxHeight * 0.1, fit: BoxFit.fill);
  }

  _buildChickenPremiumReward(String assest) {
    return Image.asset(assest,
        height: AppSizes.maxHeight * 0.1, fit: BoxFit.fill);
  }

  _buildGold(int gold) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
              Assets.img_coin_border_white,
              fit: BoxFit.fill,
              width: 24,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("${gold}",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
            )
        ],
      ),
    );
  }

  Widget _btnBottom() {
    return CustomButtomImageColorWidget(
      onTap: ontap,
      orangeColor: true,
      child: Center(
        child: StrokeTextWidget(
          text: "Đồng ý",
          size: AppSizes.maxWidth < 350 ? 14 : 20,
          colorStroke: Color(0xFFD18A5A),
        ),
      ),
    );
  }
}
