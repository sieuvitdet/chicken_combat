
import 'dart:math';

import 'package:chicken_combat/model/user_model.dart';
import 'package:chicken_combat/utils/shared_pref.dart';
import 'package:chicken_combat/widgets/custom_route.dart';
import 'package:chicken_combat/widgets/dialog_menu_action_widget.dart';
import 'package:flutter/material.dart';

class GlobalSetting {
  static final _singleton = GlobalSetting._internal();
  factory GlobalSetting() => _singleton;
  GlobalSetting._internal();
  static GlobalSetting get shared => _singleton;

static int currentVolume = 0;

static int currentNote = 0;

static late SharedPrefs prefs;

 void showPopup(BuildContext context,{Function? onTapClose,Function? onTapContinous,Function? onTapExit}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return DialogMenuActionWidget(
                currentNote: GlobalSetting.currentNote,
                currentVolume: GlobalSetting.currentVolume,
                onTapClose: onTapClose,
                onTapContinous: onTapContinous,
                onTapExit: onTapExit,
                plusNote: () {
                  if (GlobalSetting.currentNote >= 10) {
                    return;
                  }
                  setState(() {
                    GlobalSetting.currentNote++;
                  });
                },
                minusNote: () {
                  if (GlobalSetting.currentNote <= 0) {
                    return;
                  }
                  setState(() {
                    GlobalSetting.currentNote--;
                  });
                },
                plusVolume: () {
                  if (GlobalSetting.currentVolume >= 10) {
                    return;
                  }
                  setState(() {
                    GlobalSetting.currentVolume++;
                  });
                },
                minusVolume: () {
                  if (GlobalSetting.currentVolume <= 0) {
                    return;
                  }
                  setState(() {
                    GlobalSetting.currentVolume--;
                  });
                },
              );
            },
          );
        });
  }

  void showPopupWithContext(BuildContext context,Widget screen) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return screen;
            },
          );
        });
  }


}

class Globals {
  static SharedPrefs? prefs;
  static UserModel? currentUser;
}


class CustomNavigator {

  static popToScreen(BuildContext context, Widget screen, {bool root = true}) {
    Navigator.of(context, rootNavigator: root).popUntil(
        (route) => route.settings.name == screen.runtimeType.toString());
  }

  static popToRoot(BuildContext context, {bool root = true}) {
    Navigator.of(context, rootNavigator: root)
        .popUntil((route) => route.isFirst);
  }

  static pop(BuildContext context, {dynamic object, bool root = true}) {
    if (object == null)
      Navigator.of(context, rootNavigator: root).pop();
    else
      Navigator.of(context, rootNavigator: root).pop(object);
  }

  static pushReplacement(BuildContext context, Widget screen,
      {bool root = true}) {
    // Analysis.accessApplication(screen: screen);
    Navigator.of(context, rootNavigator: root).removeHUD();
    Navigator.of(context, rootNavigator: root)
        .pushReplacement(CustomRoute(page: screen));
  }

  static popToRootAndPushReplacement(BuildContext context, Widget screen,
      {bool root = true}) {
    //Analysis.accessApplication(screen: screen);
    Navigator.of(context, rootNavigator: root)
        .popUntil((route) => route.isFirst);
    Navigator.of(context, rootNavigator: root)
        .pushReplacement(CustomRoute(page: screen));
  }



  static showCustomBottomDialog(BuildContext context, Widget screen,
      {bool root = true, isScrollControlled = true}) {
    return showModalBottomSheet(
        context: context,
        useRootNavigator: root,
        isScrollControlled: isScrollControlled,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            child: screen,
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }


  static late ProgressDialog _pr;
  static showProgressDialog(BuildContext context) {
      _pr = ProgressDialog(context);
      _pr.show();
  }

  static hideProgressDialog() {
    if (_pr.isShowing()) {
      _pr.hide();
    }
  }

}

extension NavigatorStateExtension on NavigatorState {
  removeHUD() {
    bool isHUDOn = false;
    popUntil((route) {
      if (route.settings.name == "HUD") {
        isHUDOn = true;
      }
      return true;
    });

    if(isHUDOn)
      CustomNavigator.hideProgressDialog();
  }
}

class ProgressDialog {
  bool _isShowing = false;

  BuildContext buildContext;

  ProgressDialog(this.buildContext);

  show() {
    _showDialog();
    _isShowing = true;
  }

  bool isShowing() {
    return _isShowing;
  }

  hide() {
    _isShowing = false;
    CustomNavigator.pop(buildContext);
  }

  _showDialog() {
    Navigator.of(buildContext, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: false,
        settings: RouteSettings(name: "HUD"),
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return PopScope(
            child: Scaffold(
              backgroundColor: Colors.black.withOpacity(0.3),
              body: Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.amber,),
                ),
              ),
            ),
            canPop: false,
          );
        },
      ),
    );
  }
}