import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
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
  final Function? plusVolume; 
  final Function? minusVolume;
  final Function? plusNote; 
  final Function? minusNote;

  DialogMenuActionWidget({this.currentVolume = 0,this.currentNote = 0,this.minusVolume,this.onTapContinous,this.onTapExit,this.onTapClose,this.plusVolume,this.minusNote,this.plusNote});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Container( 
            width: AppSizes.maxWidth*0.838,
            height: AppSizes.maxHeight*0.47,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  Assets.img_background_popup,
                  fit: BoxFit.fill,
                  height: AppSizes.maxHeight*0.49,
                ),
                Column(
                  children: [
                    Container(
                      height: AppSizes.maxHeight*0.09,
                      child: Center(
                        child: Text(
                          "Cài đặt",
                          style: TextStyle(fontSize:AppSizes.maxWidth < 350 ? 30 : 40, color: Colors.white),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _listAction())
                        ],
                      ),
                    )),
                    SizedBox(
                      height: AppSizes.maxHeight*0.025,
                    )
                  ],
                ),
                Positioned(
                    right: 16,
                    top: AppSizes.maxHeight*0.0245,
                    child: ScalableButton(
                      onTap: onTapClose as void Function(),
                      child: Image.asset(Assets.ic_close_popup, width: AppSizes.maxWidth*0.116))),
              ],
            ),
          ),
        ),
    );
  }

  Widget _itemVolume() {
    return Container(
      height: AppSizes.maxHeight*0.07,
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
              child: Image.asset(Assets.ic_volume_popup, width: AppSizes.maxWidth*0.0773),
            ),
            Expanded(
                child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: AppSizes.maxHeight*0.0446,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                        child: Container(
                      height: AppSizes.maxHeight*0.0179,
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
      top: AppSizes.maxHeight*0.009,
      left: -(AppSizes.maxWidth*0.011),
      child: ScalableButton(
        onTap: ontap as void Function()?,
        child: Image.asset(
          Assets.ic_minus,
          fit: BoxFit.fill,
        ),
      ),
      width: AppSizes.maxHeight*0.0268,
      height: AppSizes.maxHeight*0.0268,
    );
  }

  Widget _plus(Function? ontap) {
    return Positioned(
        top: AppSizes.maxHeight*0.009,
      right: -AppSizes.maxWidth*0.011,
        child: ScalableButton(
          onTap: ontap as void Function()?,
          child: Image.asset(
            Assets.ic_plus,
            fit: BoxFit.fill,
          ),
        ),
        width: AppSizes.maxHeight*0.0268,
        height: AppSizes.maxHeight*0.0268);
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
      height:  AppSizes.maxHeight*0.07,
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
              child: Image.asset(Assets.ic_note_music_popup, width: AppSizes.maxWidth*0.0773),
            ),
            Expanded(
                child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: AppSizes.maxHeight*0.0443,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                        child: Container(
                      height: AppSizes.maxHeight*0.0179,
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
    _list.add(Container(width: AppSizes.maxWidth*0.116,));
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
              width: AppSizes.maxWidth*0.114,
              fit: BoxFit.fill,
            )),
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            "Tiếp tục",
            style: TextStyle(fontSize: AppSizes.maxWidth < 350 ? 16 : 24 , color: Colors.white),
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
            width: AppSizes.maxWidth*0.114,
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            "Thoát",
            style: TextStyle(fontSize:AppSizes.maxWidth < 350 ? 16 : 24, color: Colors.white),
          ),
        )
      ],
    );
  }
}
