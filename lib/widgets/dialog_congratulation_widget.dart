import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:flutter/material.dart';

class DialogCongratulationWidget extends StatelessWidget {
  final Function? ontapContinue;
  final Function? ontapExit;
  final bool isWin;

  DialogCongratulationWidget(
      {this.ontapContinue, this.ontapExit, this.isWin = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: AppSizes.maxWidth * 0.838,
          height: AppSizes.maxHeight > 800
              ? AppSizes.maxHeight * 0.614
              : AppSizes.maxHeight * 0.65,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.img_bg_dialog_congratulation,
                fit: BoxFit.fill,
                width: AppSizes.maxWidth * 0.838,
                height: AppSizes.maxHeight > 800
                    ? AppSizes.maxHeight * 0.614
                    : AppSizes.maxHeight * 0.65,
              ),
              Column(
                children: [
                  Container(
                    height: AppSizes.maxHeight * 0.223,
                  ),
                  Center(
                    child: Text(
                      isWin ? "Victory" : "Closer",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _gif(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _listAction())
                      ],
                    ),
                  )),
                  SizedBox(
                    height: 24,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gif() {
    return Container(
      height: AppSizes.maxHeight * 0.0725,
      margin: EdgeInsets.symmetric(
          horizontal: AppSizes.maxHeight * 0.0386, vertical: AppSizes.maxHeight * 0.0178),
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
                child: Text("Your Reward:",
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
            "100",
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
            "100",
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
    _list.add(_itemPlaygame());
    _list.add(Container(
      width: AppSizes.maxWidth * 0.05,
    ));
    _list.add(_itemExit());
    return _list;
  }

  Widget _itemPlaygame() {
    return Column(
      children: [
        GestureDetector(
            onTap: () {},
            child: Image.asset(
              Assets.ic_playgame_popup,
              width: AppSizes.maxWidth * 0.114,
              fit: BoxFit.fill,
            )),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            AppLocalizations.text(LangKey.continuee),
            style: TextStyle(
                fontSize: AppSizes.maxWidth < 350 ? 16 : 24,
                color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _itemExit() {
    return GestureDetector(
      onTap: ontapExit as void Function()?,
      child: Column(
        children: [
          Image.asset(
            Assets.ic_exit_popup,
            width: AppSizes.maxWidth * 0.114,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              AppLocalizations.text(LangKey.exit),
              style: TextStyle(
                  fontSize: AppSizes.maxWidth < 350 ? 16 : 24,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
