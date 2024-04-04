import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:flutter/material.dart';

class DialogCongratulationLevelWidget extends StatelessWidget {
  final Function? ontapContinue;
  final Function? ontapPlayBack;
  final Function? ontapExit;

  DialogCongratulationLevelWidget(
      {this.ontapContinue, this.ontapPlayBack, this.ontapExit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 347,
          height: 420,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.img_background_popup,
                fit: BoxFit.fill,
              ),
              Column(
                children: [
                  Container(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Level 10",
                      style: TextStyle(fontSize: 40, color: Colors.white),
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
                        _threeStar(),
                        _gif(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _threeStar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.rotate(
          angle: -20 * 3.14 / 180,
          child: Image.asset(
            Assets.img_star,
            width: 65,
          ),
        ),
        Column(
          children: [
             _starWhite(),
            Container(
              height: 24,
            )
          ],
        ),
        Transform.rotate(
          angle: 20 * 3.14 / 180,
          child:  _starWhite()
        ),
      ],
    );
  }

  Widget _starWhite() {
    return ImageIcon(AssetImage(Assets.img_star),size: 60,color: Colors.white);
  }

  Widget _gif() {
    return Container(
      height: 65,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
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
                        fontWeight: FontWeight.bold))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
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
          width: 24,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "100",
            style: TextStyle(color: Colors.white),
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
          width: 24,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "100",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  List<Widget> _listAction() {
    List<Widget> _list = [];
    _list.add(_itemPlaygame());
    _list.add(_itemPlayBack());
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
              width: 48,
              fit: BoxFit.fill,
            )),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            "Tiếp tục",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _itemPlayBack() {
    return Column(
      children: [
        Image.asset(
          Assets.ic_playagain_popup,
          width: 48,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            "Quay lại",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
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
            width: 48,
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            "Thoát",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        )
      ],
    );
  }
}
