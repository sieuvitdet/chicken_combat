
import 'package:chicken_combat/widgets/dialog_menu_action_widget.dart';
import 'package:flutter/material.dart';

class GlobalSetting {
  static final _singleton = GlobalSetting._internal();
  factory GlobalSetting() => _singleton;
  GlobalSetting._internal();
  static GlobalSetting get shared => _singleton;

static int currentVolume = 0;

static int currentNote = 0;

 void showPopup(BuildContext context,{Function? onTapClose,Function? onTapContinous,Function? onTapExit,Function? onTapPlayBack}) {
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
                onTapPlayBack: onTapPlayBack,
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


}