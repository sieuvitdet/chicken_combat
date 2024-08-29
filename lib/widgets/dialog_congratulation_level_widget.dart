import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';

class DialogCongratulationLevelWidget extends StatelessWidget {
  final Function? ontapReview;
  final Function? ontapExit;
  final Function? ontapContinue;
  final int score;
  final int gold;
  final int diamond;
  final int? level;
  final bool? showReview;
  final bool? showContinue;
  final int numberQuestion;

  DialogCongratulationLevelWidget(
      {this.ontapReview,this.ontapContinue ,this.ontapExit,required this.score,required this.gold, required this.diamond, this.level,this.showReview = false,this.showContinue = false, this.numberQuestion = 0});

  @override
  Widget build(BuildContext context) {
    print(numberQuestion);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: AppSizes.maxWidth*0.838,
          height: AppSizes.maxHeight > 850 ? AppSizes.maxHeight * 0.44 : AppSizes.maxHeight * 0.55,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.img_background_popup,
                fit: BoxFit.fill,
                width: AppSizes.maxWidth * 0.838,
                height: AppSizes.maxHeight > 850 ? AppSizes.maxHeight * 0.45 :AppSizes.maxHeight * 0.55,
              ),
              Column(
                children: [
                  Container(
                    height: AppSizes.maxWidth*0.01,
                  ),
                  Center(
                    child: Text(
                      "Level ${level}",
                      style: TextStyle(fontSize: AppSizes.maxWidth < 350 ? 35 : 40, color: Colors.white),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.maxWidth*0.04, vertical: AppSizes.maxHeight*0.01),
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
                        _threeStar(),
                        _gif(),
                        SizedBox(height: 8.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _listAction())
                      ],
                    ),
                  )),
                  SizedBox(
                    height: AppSizes.maxHeight*0.0268,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _threeStar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Transform.rotate(
          angle: -20 * 3.14 / 180,
          child: score >= 5*numberQuestion ? _starYellow() : _starWhite(),
        ),
        SizedBox(height: 24,)
          ],
        ),
        Column(
          children: [
             score >= 7*numberQuestion ? _starYellow() : _starWhite(),
            StrokeTextWidget(text: "${score.toDouble()}",size: AppSizes.maxWidth < 350 ? 30 : 40,colorStroke: Color(0xFF974026),)
          ],
        ),
        Column(
          children: [
            Transform.rotate(
          angle: 20 * 3.14 / 180,
          child: score >= 9*numberQuestion ? _starYellow() : _starWhite(),
        ),
        SizedBox(height: 24,)
          ],
        ),
      ],
    );
  }

  Widget _starWhite() {
    return Image.asset(
            Assets.img_star_white,
            width: AppSizes.maxWidth*0.167,
          );
  }

  Widget _starYellow() {
    return Image.asset(
            Assets.img_star,
            width: AppSizes.maxWidth*0.167,
          );
  }

  Widget _gif() {
    return Container(
      height: AppSizes.maxHeight > 850 ? AppSizes.maxHeight * 0.08 : AppSizes.maxHeight * 0.1,
      margin: EdgeInsets.symmetric(
          horizontal: AppSizes.maxHeight * 0.0386),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0xFFB96747),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
            color: Color(0xFFD18A5A), borderRadius: BorderRadius.circular(50)),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(AppLocalizations.text(LangKey.your_reward),
                    style: TextStyle(
                        color: Color(0xFFB96747),
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.maxWidth < 350 ? 12 : 16))),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSizes.maxWidth * 0.058),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_gold(), _dimond()],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _gold() {
    return Row(
      children: [
        Image.asset(
          Assets.ic_coin,
          width: AppSizes.maxWidth * 0.05,
          height: AppSizes.maxWidth * 0.05,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: AppSizes.maxWidth * 0.019,
          ),
          child: Text(
            "${gold}",
            style: TextStyle(
                color: Colors.white,
                fontSize: AppSizes.maxWidth < 350 ? 10 : 14),
          ),
        )
      ],
    );
  }

  Widget _dimond() {
    return Row(
      children: [
        Image.asset(
          Assets.ic_diamond,
          width: AppSizes.maxWidth * 0.05,
          height: AppSizes.maxWidth * 0.05,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.only(left: AppSizes.maxWidth * 0.019),
          child: Text(
            "${gold}",
            style: TextStyle(
                color: Colors.white,
                fontSize: AppSizes.maxWidth < 350 ? 10 : 14),
          ),
        )
      ],
    );
  }

  List<Widget> _listAction() {
    List<Widget> _list = [];
    if ((showReview ?? false)) {
      _list.add(_itemReview());
    _list.add(SizedBox(width: AppSizes.maxWidth*0.116,));
    }

    if (showContinue ?? false) {
      _list.add(_itemNext());
      _list.add(SizedBox(width: AppSizes.maxWidth*0.116,));
    }
    _list.add(_itemExit());
    return _list;
  }

  Widget _itemReview() {
    return Column(
      children: [
        GestureDetector(
            onTap: ontapReview as void Function()?,
            child: Image.asset(
              Assets.ic_playgame_popup,
              width:  AppSizes.maxWidth*0.116,
              fit: BoxFit.fill,
            )),
        Text(
         AppLocalizations.text(LangKey.review),
          style: TextStyle(fontSize:AppSizes.maxWidth < 350 ? 16 : 24, color: Colors.white),
        )
      ],
    );
  }

  Widget _itemNext() {
    return Column(
      children: [
        GestureDetector(
            onTap: ontapContinue as void Function()?,
            child: Image.asset(
              Assets.ic_playgame_popup,
              width:  AppSizes.maxWidth*0.116,
              fit: BoxFit.fill,
            )),
        Text(
         AppLocalizations.text(LangKey.continuee),
          style: TextStyle(fontSize:AppSizes.maxWidth < 350 ? 16 : 24, color: Colors.white),
        )
      ],
    );
  }


  Widget _itemExit() {
    return Column(
      children: [
        ScalableButton(
          onTap: ontapExit as void Function()?,
          child: Image.asset(
            Assets.ic_exit_popup,
            width:  AppSizes.maxWidth*0.116,
            fit: BoxFit.fill,
          ),
        ),
        Text(
          AppLocalizations.text(LangKey.exit),
          style: TextStyle(fontSize:AppSizes.maxWidth < 350 ? 16 : 24, color: Colors.white),
        )
      ],
    );
  }
}
