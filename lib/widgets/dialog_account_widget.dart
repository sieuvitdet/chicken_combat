import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/model/ranking/ranking_model.dart';
import 'package:chicken_combat/model/user_model.dart';
import 'package:chicken_combat/presentation/login/login_screen.dart';
import 'package:chicken_combat/presentation/ranking/ranking_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/shared_pref_key.dart';
import 'package:chicken_combat/utils/string_utils.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/custom_route.dart';
import 'package:chicken_combat/widgets/custom_textfield_widget.dart';
import 'package:chicken_combat/widgets/dialog_change_password_widget.dart';
import 'package:chicken_combat/widgets/dialog_comfirm_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogAccountWidget extends StatefulWidget {
  const DialogAccountWidget({super.key});

  @override
  State<DialogAccountWidget> createState() => _DialogAccountWidgetState();
}

class _DialogAccountWidgetState extends State<DialogAccountWidget> {
  UserModel? _userModel;
  RankingModel? _currentScore;
  List<RankingModel> _rankingScore = [];

  TextEditingController _userNameController = TextEditingController();
  FocusNode _userNameNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _userModel = Globals.currentUser;
    _initializeData();
    _userNameController.text = _userModel?.username ?? "";
  }

  Future<void> _initializeData() async {
    await _getScore();
  }

  Future<void> _getScore() async {
    CollectionReference score =
        FirebaseFirestore.instance.collection(FirebaseEnum.score);
    await score.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        RankingModel model = RankingModel.fromSnapshot(doc);
        _rankingScore.add(model);
      });
      if (_rankingScore.isNotEmpty) {
        _currentScore = _rankingScore
            .firstWhere((ranking) => ranking.id == _userModel?.score);
      }
      setState(() {});
    });
  }

  Future<void> _updateUserName(String _idUser, String newUserName) async {
    CollectionReference _user =
        FirebaseFirestore.instance.collection(FirebaseEnum.userdata);

    return _user
        .doc(_idUser)
        .update({'username': newUserName})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> _saveFabVisibility() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFabVisible', true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: AppSizes.maxWidth * 0.868,
            height: AppSizes.maxHeight > 850
                ? AppSizes.maxHeight * 0.5
                : AppSizes.maxHeight * 0.55,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  Assets.img_background_popup,
                  fit: BoxFit.fill,
                  width: AppSizes.maxWidth * 0.888,
                  height: AppSizes.maxHeight * 0.5,
                ),
                Column(
                  children: [
                    Container(
                      height: AppSizes.maxHeight * 0.09,
                      child: Center(
                        child: StrokeTextWidget(
                            text: AppLocalizations.text(LangKey.account),
                            size: AppSizes.maxWidth < 350 ? 30 : 40,
                            colorStroke: Colors.red[900]),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                          Container(height: AppSizes.maxHeight * 0.02),
                          CustomButtomImageColorWidget(
                            onTap: () {
                              GlobalSetting.shared.showPopupWithContext(
                                  context,
                                  DialogConfirmWidget(
                                    title: AppLocalizations.text(LangKey.confirm_logout),
                                    agree: () async {
                                      Globals.prefs!.setBool(SharedPrefsKey.is_login, false);
                                      Navigator.of(context).pop();
                                      Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
                                      Navigator.of(context, rootNavigator: true).pushReplacement(CustomRoute(page: LoginScreen()));
                                      _saveFabVisibility();
                                    },
                                    cancel: () {
                                      Navigator.of(context).pop();
                                    },
                                  ));
                            },
                            orangeColor: true,
                            child: Center(
                              child: StrokeTextWidget(
                                text: AppLocalizations.text(LangKey.logout),
                                 size: AppSizes.maxWidth < 350 ? 12 : 16,
                                colorStroke: Color(0xFFD18A5A),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          CustomButtomImageColorWidget(
                            onTap: () {
                              GlobalSetting.shared.showPopupWithContext(
                                  context,
                                  DialogConfirmWidget(
                                    title:
                                        AppLocalizations.text(LangKey.confirm_delete_account),
                                    agree: () async {
                                      deleteAccount(context);
                                    },
                                    cancel: () {
                                      Navigator.of(context).pop();
                                    },
                                  ));
                            },
                            orangeColor: true,
                            child: Center(
                              child: StrokeTextWidget(
                                text: AppLocalizations.text(LangKey.delete_account),
                                 size: AppSizes.maxWidth < 350 ? 12 : 16,
                                colorStroke: Color(0xFFD18A5A),
                              ),
                            ),
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
                          AudioManager.playSoundEffect(AudioFile.sound_tap);
                          if (Globals.currentUser!.username !=
                              _userNameController.text) {
                            GlobalSetting.shared.showPopupWithContext(
                                context,
                                DialogConfirmWidget(
                                  title:
                                      AppLocalizations.text(LangKey.confirm_change_name),
                                  agree: () {
                                    Navigator.of(context).pop();
                                    _updateUserName(Globals.currentUser!.id,
                                        _userNameController.text);
                                  },
                                  cancel: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _userNameController.text =
                                          Globals.currentUser!.username;
                                    });
                                  },
                                ));
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Image.asset(Assets.ic_close_popup,
                            width: AppSizes.maxWidth * 0.116))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  deleteAccount(BuildContext context) async {
    try {
      CollectionReference _user =
          FirebaseFirestore.instance.collection(FirebaseEnum.userdata);

      return _user.doc(Globals.currentUser!.id).delete().then((value) {
        Navigator.of(context).pop();
        Navigator.of(context, rootNavigator: true)
            .popUntil((route) => route.isFirst);
        Navigator.of(context, rootNavigator: true)
            .pushReplacement(CustomRoute(page: LoginScreen()));
      });
    } catch (e) {
      print('Error deleting account: $e');
    }
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
                "Level ${_userModel?.level ?? 1}",
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
          margin: EdgeInsets.only(right: AppSizes.maxWidth * 0.03),
          alignment: Alignment.center,
          width: AppSizes.maxWidth * 0.17,
          height: AppSizes.maxWidth * 0.097,
          child: StrokeTextWidget(
            text: "${AppLocalizations.text(LangKey.account)}:",
            size: AppSizes.maxWidth < 350 ? 10 : 14,
            colorStroke: Color(0xFFD18A5A),
          ),
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.only(left: 4.0),
          height: AppSizes.maxHeight * 0.04,
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
          child: CustomTextField(
            error: "",
            backgroundColor: Colors.transparent,
            verticalPadding: 0,
            horizontalPadding: 0,
            border: Border.all(color: Colors.transparent),
            style: TextStyle(fontSize: 13, color: Colors.white),
            hintText: AppLocalizations.text(LangKey.account_name),
            controller: _userNameController,
            focusNode: _userNameNode,
            limitInput: 10,
            textInputAction: TextInputAction.done,
            maxLines: 1,
          ),
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
          child: StrokeTextWidget(
            text: "${AppLocalizations.text(LangKey.password)}:",
            size: AppSizes.maxWidth < 350 ? 12 : 14,
            colorStroke: Color(0xFFD18A5A),
          ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "******",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
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
                        child: Image.asset(
                          Assets.img_change_password,
                          width: AppSizes.maxWidth * 0.058,
                          fit: BoxFit.fill,
                        ),
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
          child: StrokeTextWidget(
            text: AppLocalizations.text(LangKey.ranking),
            size: AppSizes.maxWidth < 350 ? 12 : 14,
            colorStroke: Color(0xFFD18A5A),
          ),
        ),
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
                      _showRanking(0);
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
                              StrokeTextWidget(
                                text: "1vs1",
                                size: AppSizes.maxWidth < 350 ? 6 : 8,
                                colorStroke: Color(0xFFD18A5A),
                              )
                            ],
                          ),
                        ),
                        StrokeTextWidget(
                          text:
                              '${StringUtils.formatNumber(_currentScore?.PK11 ?? 0)}',
                          size: AppSizes.maxWidth < 350 ? 10 : 14,
                          colorStroke: Color(0xFFD18A5A),
                        )
                      ],
                    ),
                  ),
                  ScalableButton(
                    onTap: () {
                      _showRanking(1);
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 4.0),
                          height: AppSizes.maxWidth * 0.097,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(Assets.img_green_circle),
                              StrokeTextWidget(
                                text: "2vs2",
                                size: AppSizes.maxWidth < 350 ? 6 : 8,
                                colorStroke: Color(0xFFD18A5A),
                              )
                            ],
                          ),
                        ),
                        StrokeTextWidget(
                          text:
                              '${StringUtils.formatNumber(_currentScore?.PK22 ?? 0)}',
                          size: AppSizes.maxWidth < 350 ? 10 : 14,
                          colorStroke: Color(0xFFD18A5A),
                        )
                      ],
                    ),
                  )
                ],
              )),
        ))
      ],
    );
  }

  void _showRanking(int tab) {
    AudioManager.playSoundEffect(AudioFile.sound_tap);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return RankingScreen(
                currentScore: _currentScore,
                rankingScore: _rankingScore,
                tab: tab,
              );
            },
          );
        });
  }
}
