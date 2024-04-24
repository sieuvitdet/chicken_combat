import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/presentation/login/change_password_bloc.dart';
import 'package:chicken_combat/presentation/login/login_screen.dart';
import 'package:chicken_combat/utils/generate_hash.dart';
import 'package:chicken_combat/utils/shared_pref_key.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/custom_dialog_with_title_button_widget.dart';
import 'package:chicken_combat/widgets/custom_route.dart';
import 'package:chicken_combat/widgets/custom_textfield_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DialogChangePasswordWidget extends StatefulWidget {
  const DialogChangePasswordWidget({super.key});

  @override
  State<DialogChangePasswordWidget> createState() =>
      _DialogChangePasswordWidgetState();
}

class _DialogChangePasswordWidgetState
    extends State<DialogChangePasswordWidget> {
  TextEditingController _controllerOldPass = TextEditingController();
  FocusNode _focusNodeOldPass = FocusNode();

  TextEditingController _controllerNewPass = TextEditingController();
  FocusNode _focusNodeNewPass = FocusNode();

  TextEditingController _controllerNewPassAgain = TextEditingController();
  FocusNode _focusNodeNewPassAgain = FocusNode();

  bool secureOldPass = true;
  bool secureNewPass = true;
  bool secureNewPassAgain = true;
  late ChangePasswordBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ChangePasswordBloc(context);
  }

  bool checkValidInputField() {
    FocusScope.of(context).unfocus();
    _bloc.setErrorNewPassword('');
    _bloc.setErrorAgainPassword('');
    _bloc.setErrorPassword('');
    bool check = true;
    bool oldPassSuccess = false;
    if (_controllerOldPass.text.trim() == "") {
      _bloc.setErrorPassword(
          AppLocalizations.text(LangKey.change_pass_enter_old_pass));
      check = false;
    } else {
      String encryptedString = GenerateHash.encryptString(
          _controllerOldPass.text.trim(), Globals.currentUser!.id);
      if (encryptedString != Globals.currentUser!.password) {
        _bloc.setErrorPassword(
            AppLocalizations.text(LangKey.change_pass_old_pass_wrong));
        check = false;
      } else {
        oldPassSuccess = true;
      }
    }
    if (_controllerNewPass.text.trim() == "") {
      _bloc.setErrorNewPassword(
          AppLocalizations.text(LangKey.change_pass_enter_new_pass));
      check = false;
    } else {
      String encryptedString = GenerateHash.encryptString(
          _controllerNewPass.text.trim(), Globals.currentUser!.id);
      if (encryptedString == Globals.currentUser!.password && oldPassSuccess) {
        _bloc.setErrorNewPassword(
            AppLocalizations.text(LangKey.change_pass_not_same_old_pass));
        check = false;
      }
    }
    if (_controllerNewPassAgain.text.trim() == "") {
      _bloc.setErrorAgainPassword(
          AppLocalizations.text(LangKey.change_pass_enter_new_pass_again));
      check = false;
    } else if (_controllerNewPassAgain.text.trim() !=
        _controllerNewPass.text.trim()) {
      _bloc.setErrorAgainPassword(
          AppLocalizations.text(LangKey.change_pass_not_same_new_pass));
      check = false;
    }

    return check;
  }

  Future<void> _updatePassword(String _idUser) async {
    String encryptedString =
        GenerateHash.encryptString(_controllerNewPass.text.trim(), _idUser);
    CollectionReference _user =
        FirebaseFirestore.instance.collection(FirebaseEnum.userdata);

    return _user
        .doc(_idUser)
        .update({'password': encryptedString})
        .then((value) => _triggerBackToLogin())
        .catchError((error) =>
            _bloc.setErrorChangePassword("Failed to update user: $error"));
  }

  _triggerBackToLogin() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return CustomDialogWithTitleButtonWidget(
                title: "Change password success",
                ontap: () {
                  Globals.prefs!.setBool(SharedPrefsKey.is_login, false);
                  Navigator.of(context, rootNavigator: true)
                      .popUntil((route) => route.isFirst);
                  Navigator.of(context, rootNavigator: true)
                      .pushReplacement(CustomRoute(page: LoginScreen()));
                },
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: AppSizes.maxWidth * 0.9,
            height: AppSizes.maxHeight < 850
                ? AppSizes.maxHeight * 0.58
                : AppSizes.maxHeight * 0.5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  Assets.img_background_popup,
                  fit: BoxFit.fill,
                  height: AppSizes.maxHeight < 850
                      ? AppSizes.maxHeight * 0.6
                      : AppSizes.maxHeight * 0.6,
                  width: AppSizes.maxWidth * 0.9,
                ),
                Column(
                  children: [
                    Container(
                      height: AppSizes.maxHeight * 0.09,
                      child: Center(
                        child: StrokeTextWidget(
                            text:
                                AppLocalizations.text(LangKey.change_password),
                            size: AppSizes.maxWidth < 350 ? 20 : 30,
                            colorStroke: Colors.red[900]),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                      margin: EdgeInsets.symmetric(horizontal: 8),
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
                          _oldPass(),
                          _newPass(),
                          _newPassWordAgain(),
                          StreamBuilder(
                            stream: _bloc.outputErrorChangePassword,
                            initialData: "",
                            builder: (_, snapshot) {
                              if (snapshot.hasData && snapshot.data != "") {
                                return Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    snapshot.data ?? "",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                          Spacer(),
                          CustomButtomImageColorWidget(
                            onTap: () {
                              if (checkValidInputField()) {
                                _updatePassword(Globals.currentUser!.id);
                              }
                            },
                            orangeColor: true,
                            child: Center(
                              child: StrokeTextWidget(
                                text: AppLocalizations.text(LangKey.save),
                                size: AppSizes.maxWidth < 350 ? 14 : 20,
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
                    right: 0,
                    top: 0,
                    child: ScalableButton(
                        onTap: () {
                          Navigator.of(context).pop();
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

  Widget _oldPass() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: AppSizes.maxWidth * 0.32,
              height: AppSizes.maxWidth * 0.097,
              child: StrokeTextWidget(
                text: "Old pass:",
                size: AppSizes.maxWidth < 350 ? 12 : 16,
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
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: _bloc.outputPassword,
                          initialData: true,
                          builder: (_, snapshot) {
                            return CustomTextField(
                              hintText: AppLocalizations.text(
                                  LangKey.input_old_password),
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              controller: _controllerOldPass,
                              focusNode: _focusNodeOldPass,
                              verticalPadding: 0,
                              horizontalPadding: 0,
                              verticalMargin: 0,
                              maxLength: 6,
                              suffixIcon: snapshot.data!
                                  ? Assets.img_eye_close
                                  : Assets.img_eye_open,
                              backgroundColor: Colors.transparent,
                              border: Border.all(color: Colors.transparent),
                              suffixIconColor: Colors.amber,
                              obscureText: snapshot.data,
                              // require: false,
                              onSuffixIconTap: () =>
                                  _bloc.setPassword(!snapshot.data!),
                              onChanged: (event) {
                                _bloc.setErrorPassword('');
                              },
                              onSubmitted: (_) => {},
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            ))
          ],
        ),
        StreamBuilder(
            stream: _bloc.outputErrorPassword,
            initialData: "",
            builder: (_, snapshot1) {
              return ((snapshot1.data != "" && snapshot1.hasData))
                  ? Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: AppSizes.maxWidth * 0.32,
                          height: AppSizes.maxWidth * 0.04,
                        ),
                        Expanded(
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(snapshot1.data ?? "",
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                )))
                      ],
                    )
                  : Container();
            }),
      ],
    );
  }

  Widget _newPass() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: AppSizes.maxWidth * 0.32,
              height: AppSizes.maxWidth * 0.097,
              child: StrokeTextWidget(
                text: "New pass:",
                size: AppSizes.maxWidth < 350 ? 12 : 16,
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
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: _bloc.outputNewPassword,
                          initialData: true,
                          builder: (_, snapshot) {
                            return CustomTextField(
                              hintText: AppLocalizations.text(
                                  LangKey.input_new_password),
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              controller: _controllerNewPass,
                              focusNode: _focusNodeNewPass,
                              verticalPadding: 0,
                              horizontalPadding: 0,
                              radius: 30.0,
                              maxLength: 6,
                              suffixIcon: snapshot.data!
                                  ? Assets.img_eye_close
                                  : Assets.img_eye_open,
                              backgroundColor: Colors.transparent,
                              border: Border.all(color: Colors.transparent),
                              suffixIconColor: Colors.amber,
                              obscureText: snapshot.data,
                              // require: false,
                              onSuffixIconTap: () =>
                                  _bloc.setNewPassword(!snapshot.data!),
                              onChanged: (event) {
                                _bloc.setErrorNewPassword('');
                              },
                              onSubmitted: (_) => {},
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            ))
          ],
        ),
        StreamBuilder(
            stream: _bloc.outputErrorNewPassword,
            initialData: "",
            builder: (_, snapshot1) {
              return ((snapshot1.data != "" && snapshot1.hasData))
                  ? Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: AppSizes.maxWidth * 0.32,
                          height: AppSizes.maxWidth * 0.04,
                        ),
                        Expanded(
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        snapshot1.data ?? "",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                )))
                      ],
                    )
                  : Container();
            }),
      ],
    );
  }

  Widget _newPassWordAgain() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: AppSizes.maxWidth * 0.32,
              height: AppSizes.maxWidth * 0.097,
              child: StrokeTextWidget(
                text: "Again New Pass:",
                size: AppSizes.maxWidth < 350 ? 12 : 16,
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
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: _bloc.outputAgainPassword,
                          initialData: true,
                          builder: (_, snapshot) {
                            return CustomTextField(
                              hintText: AppLocalizations.text(
                                  LangKey.input_new_password),
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              controller: _controllerNewPassAgain,
                              focusNode: _focusNodeNewPassAgain,
                              verticalPadding: 0,
                              horizontalPadding: 0,
                              radius: 30.0,
                              maxLength: 6,
                              suffixIcon: snapshot.data!
                                  ? Assets.img_eye_close
                                  : Assets.img_eye_open,
                              backgroundColor: Colors.transparent,
                              border: Border.all(color: Colors.transparent),
                              suffixIconColor: Colors.amber,
                              obscureText: snapshot.data,
                              // require: false,
                              onSuffixIconTap: () =>
                                  _bloc.setAgainPassword(!snapshot.data!),
                              onChanged: (event) {
                                _bloc.setErrorAgainPassword('');
                              },
                              onSubmitted: (_) => {},
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            ))
          ],
        ),
        StreamBuilder(
            stream: _bloc.outputErrorAgainPassword,
            initialData: "",
            builder: (_, snapshot1) {
              return ((snapshot1.data != "" && snapshot1.hasData))
                  ? Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: AppSizes.maxWidth * 0.32,
                          height: AppSizes.maxWidth * 0.04,
                        ),
                        Expanded(
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(snapshot1.data ?? "",
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                )))
                      ],
                    )
                  : Container();
            }),
      ],
    );
  }
}
