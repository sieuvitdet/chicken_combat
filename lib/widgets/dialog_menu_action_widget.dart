import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:flutter/material.dart';

class DialogMenuActionWidget extends StatelessWidget {
  
  final int _totalVolume = 10;
  final int currentVolume;
  final int _totalNote = 10;
  final int currentNote;
  final Function? onTapClose;
  final Function? onTapExit;
  final Function? onTapContinous;
  final Function? onTapPlayBack;
  final Function? plusVolume; 
  final Function? minusVolume;
  final Function? plusNote; 
  final Function? minusNote;

  DialogMenuActionWidget({this.currentVolume = 0,this.currentNote = 0,this.minusVolume,this.onTapContinous,this.onTapExit,this.onTapPlayBack,this.onTapClose,this.plusVolume,this.minusNote,this.plusNote});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Container( 
            width: 347,
            height: 410,
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
                      height: 80,
                      child: Center(
                        child: Text(
                          "Cài đặt",
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
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
                          _itemVolume(),
                          _itemNote(),
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
                Positioned(
                    right: 16,
                    top: 22,
                    child: ScalableButton(
                      onTap: onTapClose as void Function(),
                      child: Image.asset(Assets.ic_close_popup, width: 48))),
              ],
            ),
          ),
        ),
    );
  }

  Widget _itemVolume() {
    return Container(
      height: 65,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0xFFB96747),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
            color: Color(0xFFD18A5A), borderRadius: BorderRadius.circular(50)),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Image.asset(Assets.ic_volume_popup, width: 32),
            ),
            Expanded(
                child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                        child: Container(
                      height: 16,
                      decoration: BoxDecoration(color: Color(0xFFFFD480)),
                      child: _statusVolum(),
                    )),
                    _minus(minusVolume),
                    _plus(plusVolume)
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _minus(Function? ontap) {
    return Positioned(
      top: 8,
      left: -5,
      child: ScalableButton(
        onTap: ontap as void Function()?,
        child: Image.asset(
          Assets.ic_minus,
          fit: BoxFit.fill,
        ),
      ),
      width: 24,
      height: 24,
    );
  }

  Widget _plus(Function? ontap) {
    return Positioned(
        top: 8,
        right: -5,
        child: ScalableButton(
          onTap: ontap as void Function()?,
          child: Image.asset(
            Assets.ic_plus,
            fit: BoxFit.fill,
          ),
        ),
        width: 24,
        height: 24);
  }

  Widget _statusVolum() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFFFD480), borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        children: [
          if (currentVolume != 0)
            Expanded(
              flex: currentVolume,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFFFEC6),
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(8.0),
                        right: Radius.circular(8.0))),
                alignment: Alignment.center,
              ),
            ),
          Expanded(
            flex: _totalVolume - currentVolume,
            child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFFD480),
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(8.0),
                        right: Radius.circular(8.0)))),
          )
        ],
      ),
    );
  }

  Widget _itemNote() {
    return Container(
      height: 65,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0xFFB96747),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
            color: Color(0xFFD18A5A), borderRadius: BorderRadius.circular(50)),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Image.asset(Assets.ic_note_music_popup, width: 32),
            ),
            Expanded(
                child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                        child: Container(
                      height: 16,
                      decoration: BoxDecoration(color: Color(0xFFFFD480)),
                      child: _statusNote(),
                    )),
                    _minus(minusNote),
                    _plus(plusNote)
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _statusNote() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFFFD480), borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        children: [
          if (currentNote != 0)
            Expanded(
              flex: currentNote,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFFFEC6),
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(8.0),
                        right: Radius.circular(8.0))),
                alignment: Alignment.center,
              ),
            ),
          Expanded(
            flex: _totalNote - currentNote,
            child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFFD480),
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(8.0),
                        right: Radius.circular(8.0)))),
          )
        ],
      ),
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
        ScalableButton(
            onTap: onTapContinous as void Function(),
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
        ScalableButton(
          onTap: onTapPlayBack as void Function(),
          child: Image.asset(
            Assets.ic_playagain_popup,
            width: 48,
            fit: BoxFit.fill,
          ),
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
          onTap: onTapExit as void Function(),
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
