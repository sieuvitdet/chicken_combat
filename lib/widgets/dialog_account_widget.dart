import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/ranking/ranking_screen.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/dialog_change_password_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';

class DialogAccountWidget extends StatefulWidget {
  const DialogAccountWidget({super.key});

  @override
  State<DialogAccountWidget> createState() => _DialogAccountWidgetState();
}

class _DialogAccountWidgetState extends State<DialogAccountWidget> {
  @override
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
                          text: "Tài khoản",
                          size: AppSizes.maxWidth < 350 ? 30 : 40,
                          colorStroke: Colors.red[900]),
                    ),
                  ),
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
                        _level(),
                        _nameAccount(),
                        _passWord(),
                        _ranking(),
                        Container(height: AppSizes.maxHeight*0.0335),
                        CustomButtomImageColorWidget(
                          orangeColor: true,
                          child: Center(child: StrokeTextWidget(text: "Đăng xuất",size: AppSizes.maxWidth < 350 ? 14:20,colorStroke:Color(0xFFD18A5A) ,),),
                        )
                      ],
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

  Widget _level() {
    return Row(
      children: [
        Image(
          image: AssetImage(Assets.img_avatar),
          width: AppSizes.maxWidth * 0.2,
          height: AppSizes.maxWidth * 0.12,
          fit: BoxFit.contain,
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.only(left: 4.0),
          height: AppSizes.maxHeight * 0.036,
          decoration: BoxDecoration(
              color: Color(0xFFD18A5A),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 0), // Shadow position
                ),
              ]),
          child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Level 3",
                style: TextStyle(color: Colors.white),
              )),
        ))
      ],
    );
  }

  Widget _nameAccount() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: AppSizes.maxWidth * 0.03),
          alignment: Alignment.centerLeft,
            width: AppSizes.maxWidth * 0.17,
             height: AppSizes.maxWidth * 0.097,
             child: StrokeTextWidget(text: "Tên tk:",size: AppSizes.maxWidth < 350 ? 12 : 16,colorStroke: Color(0xFFD18A5A),),),
        Expanded(
            child: Container(
          padding: EdgeInsets.only(left: 4.0),
          height: AppSizes.maxHeight * 0.036,
          decoration: BoxDecoration(
              color: Color(0xFFD18A5A),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 0), // Shadow position
                ),
              ]),
          child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "LocDY",
                style: TextStyle(color: Colors.white),
              )),
        ))
      ],
    );
  }

  Widget _passWord() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: AppSizes.maxWidth * 0.02),
          alignment: Alignment.centerLeft,
            width: AppSizes.maxWidth * 0.18,
             height: AppSizes.maxWidth * 0.097,
             child: StrokeTextWidget(text: "Mật khẩu:",size: AppSizes.maxWidth < 350 ? 12 : 14,colorStroke: Color(0xFFD18A5A),),),
        Expanded(
            child: Container(
          padding: EdgeInsets.only(left: 4.0),
          height: AppSizes.maxHeight * 0.036,
          decoration: BoxDecoration(
              color: Color(0xFFD18A5A),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 0), // Shadow position
                ),
              ]),
          child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                "***********",
                style: TextStyle(color: Colors.white),
              ), 
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return DialogChangePasswordWidget();
                        },
                      );
                    });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: Image.asset(Assets.img_change_password,width: AppSizes.maxWidth*0.058,fit: BoxFit.fill,),
                ))
                ],
              )),
        ))
      ],
    );
  }

  Widget _ranking() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: AppSizes.maxWidth * 0.02),
          alignment: Alignment.centerLeft,
            width: AppSizes.maxWidth * 0.16,
             height: AppSizes.maxWidth * 0.097,
             child: StrokeTextWidget(text: "Ranking:",size: AppSizes.maxWidth < 350 ? 12 : 14,colorStroke: Color(0xFFD18A5A),),),
        Expanded(
            child: Container(
          padding: EdgeInsets.only(left: 4.0),
          height: AppSizes.maxHeight * 0.036,
    
          child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                ScalableButton(
                  onTap: () {
                    _showRanking();
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 4.0),
                        height: AppSizes.maxWidth * 0.097,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(Assets.img_redblur_circle),
                          StrokeTextWidget(text: "1vs1",size: AppSizes.maxWidth < 350 ? 8: 10,colorStroke: Color(0xFFD18A5A),)
                        ],
                      ),
                      
                      ),
                      StrokeTextWidget(text: "1.254",size: AppSizes.maxWidth < 350 ? 16: 20,colorStroke: Color(0xFFD18A5A),)
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 4.0),
                      height: AppSizes.maxWidth * 0.097,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(Assets.img_green_circle),
                        StrokeTextWidget(text: "2vs2",size: AppSizes.maxWidth < 350 ? 8: 10,colorStroke: Color(0xFFD18A5A),)
                      ],
                    ),
                    
                    ),
                    StrokeTextWidget(text: "---",size: AppSizes.maxWidth < 350 ? 16: 20,colorStroke: Color(0xFFD18A5A),)
                  ],
                )
                ],
              )),
        ))
      ],
    );
  }

  void _showRanking() {
    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return RankingScreen();
                        },
                      );
                    });
  }
}
