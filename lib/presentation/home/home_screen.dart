import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/user_model.dart';
import 'package:chicken_combat/presentation/challenge/list_challenge_screen.dart';
import 'package:chicken_combat/presentation/examination/list_examination_screen.dart';
import 'package:chicken_combat/presentation/lesson/list_lesson_screen.dart';
import 'package:chicken_combat/presentation/shopping/shopping_screen.dart';
import 'package:chicken_combat/utils/shared_pref_key.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/dialog_account_widget.dart';
import 'package:chicken_combat/widgets/dialog_congratulation_level_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  UserModel? _userModel;

  @override
  void initState() {
    super.initState();
    parseUserModelFormSharePref();
  }

  void parseUserModelFormSharePref() {
      _userModel?.id =  GlobalSetting.prefs.getString(SharedPrefsKey.id_user);
      _userModel?.username =  GlobalSetting.prefs.getString(SharedPrefsKey.username);
      _userModel?.level =  GlobalSetting.prefs.getString(SharedPrefsKey.level);
      _userModel?.financeId =  GlobalSetting.prefs.getString(SharedPrefsKey.finance_id);
      _userModel?.avatar =  GlobalSetting.prefs.getString(SharedPrefsKey.avatar);
  }

  Widget _function() {
    return Container(
      width: AppSizes.maxWidth,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          _action(0, "Bài học", () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ListLessonScreen()));
          }),
          _action(1, "Kiểm tra", () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ListExaminationScreen()));
          }),
          _action(2, "Thử thách", () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ListChallengeScreen()));
          })
        ],
      ),
    );
  }

  Widget _info() {
    return Container(
      margin: EdgeInsets.only(top: AppSizes.sizeAppBar / 2),
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ScalableButton(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                  void Function(void Function()) setState) {
                                return DialogCongratulationLevelWidget(ontapExit: () {
                                  Navigator.of(context).pop();
                                },);
                              },
                            );
                          });
                    },
                    child: Image(
                      image: AssetImage(Assets.img_avatar), 
                      width: AppSizes.maxHeight * 0.055,
                      height: AppSizes.maxHeight * 0.055,
                    ),
                  ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                            "Duc",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text("Level 1",
                            overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
          Row(
            children: [
              _itemRow("200", Assets.ic_coin, ontap: () {
              }),
              SizedBox(width: 4),
              _itemRow("2000", Assets.ic_diamond, ontap: () {}),
              SizedBox(width: 4),
              _itemRow("Cửa hàng", Assets.ic_shop, ontap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return ShoppingScreen();
                        },
                      );
                    });
              })
            ],
          )
        ],
      ),
    );
  }

  Widget _body() {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(top: 8),
      width: Responsive.isMobile(context)
          ? AppSizes.maxWidth
          : AppSizes.maxWidthTablet,
      child: Image(fit: BoxFit.cover, image: AssetImage(Assets.gif_snow_home)),
    ));
  }

  Widget _action(int iD, String name, Function onTap) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: CustomButtomImageColorWidget(
        yellowColor: iD == 0,
        blueColor: iD == 1,
        redBlurColor: iD == 2,
        child: Center(
            child: Text(name,
                style: TextStyle(fontSize: 24, color: Colors.white))),
        onTap: onTap as void Function()?,
      ),
    );
  }

  Widget _itemRow(String text, String icon, {Function? ontap}) {
    return GestureDetector(
      onTap: ontap as void Function()?,
      child: Container(
        height: AppSizes.maxHeight * 0.055,
        width: AppSizes.maxWidth * 0.18,
        decoration: BoxDecoration(
            color: Color(0xFF97381A),
            borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(icon),
                width: AppSizes.maxHeight * 0.0223,
                height: AppSizes.maxHeight * 0.0223,
              ),
              Text(
                text,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: AppSizes.maxWidth < 350 ? 10.0 : 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFA9C20),
      body: Responsive(
        desktop: Center(
          child: Container(
            // width: AppSizes.maxWidth,
            height: AppSizes.maxHeight,
            child: Column(
              children: [_info(), _body(), _function()],
            ),
          ),
        ),
        mobile: Center(
          child: Container(
            // width: AppSizes.maxWidth,
            height: AppSizes.maxHeight,
            child: Column(
              children: [_info(), _body(), _function()],
            ),
          ),
        ),
        tablet: Center(
          child: Container(
            // width: AppSizes.maxWidth,
            height: AppSizes.maxHeight,
            child: Column(
              children: [_info(), _body(), _function()],
            ),
          ),
        ),
      ),
    );
  }
}
