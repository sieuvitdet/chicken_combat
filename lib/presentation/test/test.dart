import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class testscreen extends StatefulWidget {
  const testscreen({super.key});

  @override
  State<testscreen> createState() => _testscreenState();
}

class _testscreenState extends State<testscreen> {
  int _totalVolume = 10;
  int _currentVolume = 8;
  int _totalNote = 10;
  int _currentNote = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container( 
            width: 347  ,
            height: AppSizes.maxHeight > 896 ? 500 : 410,
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
                    ),
                     Center(
                        child: Text(
                          "Victory",
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
                    _minus(() {
                      if (_currentVolume <= 0) {
                        return;
                      }
                      setState(() {
                        _currentVolume--;
                      });
                    }),
                    _plus(() {
                      if (_currentVolume >= _totalNote) {
                        return;
                      }
                      setState(() {
                        _currentVolume++;
                      });
                    })
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
      child: GestureDetector(
        onTap: ontap as void Function(),
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
        child: GestureDetector(
          onTap: ontap as void Function(),
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
          if (_currentVolume != 0)
            Expanded(
              flex: _currentVolume,
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
            flex: _totalVolume - _currentVolume,
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
                    _minus(() {
                      if (_currentNote <= 0) {
                        return;
                      }
                      setState(() {
                        _currentNote--;
                      });
                    }),
                    _plus(() {
                      if (_currentNote >= _totalNote) {
                        return;
                      }
                      setState(() {
                        _currentNote++;
                      });
                    })
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
          if (_currentNote != 0)
            Expanded(
              flex: _currentNote,
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
            flex: _totalNote - _currentNote,
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
        Image.asset(
          Assets.ic_exit_popup,
          width: 48,
          fit: BoxFit.fill,
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
