import 'dart:async';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/model/maps/user_map_model.dart';
import 'package:chicken_combat/presentation/register/register_bloc.dart';
import 'package:chicken_combat/utils/generate_hash.dart';
import 'package:chicken_combat/utils/string_utils.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/custom_dialog_with_title_button_widget.dart';
import 'package:chicken_combat/widgets/custom_textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  bool isGuest;
  RegisterScreen({required this.isGuest});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _rePasswordController = TextEditingController();
  FocusNode _userNameNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  FocusNode _rePasswordNode = FocusNode();
  bool onFocusUserName = false;
  bool onFocusPassword = false;
  bool onFocusRePassword = false;
  late RegisterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = RegisterBloc(context);
    _userNameController.text = StringUtils.generateRandomName();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFFFACA44),
        body: Container(
          width: AppSizes.maxWidth,
          height: AppSizes.maxHeight,
          child: Stack(
            children: [
              _buildBackground(),
              _body(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _userNameController.dispose();
    _userNameNode.dispose();
    _passwordController.dispose();
    _passwordNode.dispose();
    _rePasswordController.dispose();
    _rePasswordNode.dispose();
    super.dispose();
  }

  bool checkValidInputField() {
    FocusScope.of(context).unfocus();
    _bloc.setErrorUserName('');
    _bloc.setErrorPassword('');
    _bloc.setErrorRePassword('');
    bool check = true;
    if (_userNameController.text.trim().length == 0 &&
        _passwordController.text.trim().length == 0 &&
        _rePasswordController.text.trim().length == 0) {
      _bloc.setErrorUserName(AppLocalizations.text(LangKey.enter_username));
      _bloc.setErrorPassword(AppLocalizations.text(LangKey.enter_password));
      _bloc.setErrorRePassword(AppLocalizations.text(LangKey.enter_password));
      check = false;
    } else {
      if (_userNameController.text.trim().length == 0) {
        _bloc.setErrorUserName(AppLocalizations.text(LangKey.enter_username));
        check = false;
      }
      if (_passwordController.text.trim().length == 0) {
        _bloc.setErrorPassword(AppLocalizations.text(LangKey.enter_password));
        check = false;
      }
      if (_rePasswordController.text.trim().length == 0) {
        _bloc.setErrorRePassword(AppLocalizations.text(LangKey.enter_password));
        check = false;
      } else {
        if (_passwordController.text.trim().length > 0 &&
            _passwordController.text.trim().length < 4) {
          _bloc.setErrorPassword("Password from 4 to 6 characters");
          check = false;
        }
        if (_rePasswordController.text.trim().length > 0 &&
            _rePasswordController.text.trim().length < 4) {
          _bloc.setErrorRePassword("Password from 4 to 6 characters");
          check = false;
        } else {
          if (_passwordController.text.trim() !=
              _rePasswordController.text.trim()) {
            _bloc.setErrorRePassword("Passwords do not match");
            check = false;
          }
        }
      }
    }
    return check;
  }

  Future<bool> _validateUserName(String _userName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(FirebaseEnum.userdata)
          .get();

      List<String> docIds = [];
      querySnapshot.docs.forEach((doc) {
        docIds.add(doc.id);
      });
      for (String doc in docIds) {
        if (doc == _userName) {
          return false;
        }
      }
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  List<Map<String, dynamic>> convertUserMapModelListToMapList(List<UserMapModel> userMapModels) {
    return userMapModels.map((userMapModel) => {
      'collectionMap': userMapModel.collectionMap,
      'level': userMapModel.level,
      'isCourse': userMapModel.isCourse,
    }).toList();
  }

  Future<bool> _registerWithFinanceId(
      String _userName, String _password, String financeId, String _score) async {
    List<String> bag = ['CO01'];
    List<UserMapModel> courseMaps = [];
    courseMaps.add(UserMapModel(collectionMap: 'MAP01', level: 1, isCourse: 'listening',isComplete: false));
    courseMaps.add(UserMapModel(collectionMap: 'MAP01', level: 1, isCourse: 'reading',isComplete: false));
    courseMaps.add(UserMapModel(collectionMap: 'MAP01', level: 1, isCourse: 'speaking',isComplete: false));
    List<Map<String, dynamic>> courseMapsData = convertUserMapModelListToMapList(courseMaps);

    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection(FirebaseEnum.userdata);

      await users.doc(_userName).set({
        'username': _userNameController.text,
        'password': _password,
        'level': 1, //Mặc định 1
        'financeId': financeId,
        'avatar': 1, //Mặc định 1
        'bag' : bag,
        'useColor' : 'CO01',
        'useSkin' : '',
        'score' : _score,
        'courseMaps' : courseMapsData,
        'checkingMaps' : courseMapsData
      });
      CustomNavigator.hideProgressDialog();
      return true;
    } catch (error) {
      CustomNavigator.hideProgressDialog();
      print("Error: $error");
      return false;
    }
  }

  void showPopup(String _username, String _password) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return CustomDialogWithTitleButtonWidget(
                title: AppLocalizations.text(LangKey.registration_success),
                ontap: () {
                  Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pop([_username, _password]);
                },
              );
            },
          );
        });
  }

  void _addFinanceDocument(String _userName, String _score) async {
    CustomNavigator.showProgressDialog(context);
    CollectionReference finance =
        FirebaseFirestore.instance.collection(FirebaseEnum.finance);
    DocumentReference newDocRef =
        await finance.add({'gold': 0, 'diamond': 0, 'userId': _userName});
    String financeId = newDocRef.id;
    // Sau đó, đăng ký người dùng và chuyển đưa financeId
    final String key = _userName;
    final String originalString = _rePasswordController.text.trim();
    String encryptedString = GenerateHash.encryptString(originalString, key);
    print("Encrypted String: $encryptedString");
    bool registrationResult =
        await _registerWithFinanceId(_userName, encryptedString, financeId, _score);
    if (registrationResult) {
      print('Đăng ký thành công');
      showPopup(_userName, originalString);
    } else {
      _bloc.setErrorRegister('Không thể cập nhật thông tin ví');
    }
  }

  void _addScore(String _userName) async {
    CustomNavigator.showProgressDialog(context);
    CollectionReference score =
    FirebaseFirestore.instance.collection(FirebaseEnum.score);
    DocumentReference newDocRef =
    await score.add({'PK11': 0, 'PK22': 0, 'username': _userName});
    String scoreId = newDocRef.id;
    final String key = _userName;
    final String originalString = _rePasswordController.text.trim();
    String encryptedString = GenerateHash.encryptString(originalString, key);
    print("Encrypted String: $encryptedString");
    _addFinanceDocument(_userName, scoreId);
  }

  Widget _body() {
    return SingleChildScrollView(
        controller: _scrollController,
        physics: NeverScrollableScrollPhysics(),
        child: Container(
            height: AppSizes.maxHeight,
            width: AppSizes.maxWidth,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: AppSizes.maxHeight * 0.1,
                      ),
                      Image(
                        fit: BoxFit.contain,
                        image: AssetImage(Assets.chicken_flapping_swing_gif),
                        width: AppSizes.maxWidth * 0.5,
                        height: AppSizes.maxHeight * 0.2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Text(
                          AppLocalizations.text(LangKey.register),
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      _inputForm(),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: CustomButtomImageColorWidget(
                      orangeColor: true,
                      child: Center(
                          child: Text(AppLocalizations.text(LangKey.register),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.white))),
                      onTap: () async {
                        if (checkValidInputField()) {
                          String userName = StringUtils.convertToLowerCase(
                              _userNameController.text);
                          if (await _validateUserName(userName)) {
                            _addScore(userName);
                          } else {
                            _bloc.setErrorUserName("Tên tài khoản đã tồn tại");
                          }
                        }
                      }),
                )
              ],
            )));
  }
 
  Widget _inputForm() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder(
              stream: _bloc.outputErrorUserName,
              initialData: "",
              builder: (context, snapshot) {
                return StreamBuilder(
                    stream: _bloc.outputUserName,
                    initialData: false,
                    builder: (context, snapshot1) {
                      return CustomTextField(
                        hintText: "Tên tài khoản",
                        hintStyle: AppTextStyles.style13GreyW400,
                        controller: _userNameController,
                        focusNode: _userNameNode,
                        enableBorder: onFocusUserName,
                        radius: 30.0,
                        suffixIcon:
                            snapshot1.data! ? Assets.img_eye_close : null,
                        suffixIconColor: AppColors.grey15,
                        backgroundColor: AppColors.whiteColor,
                        onSuffixIconTap: () => {
                          _userNameController.clear(),
                          _bloc.setUserName(false),
                        },
                        require: false,
                        limitInput: 10,
                        textInputAction: TextInputAction.next,
                        error: snapshot.data,
                        onChanged: (event) {
                          _bloc.setErrorString('');
                          _bloc.setErrorUserName('');
                        },
                        onSubmitted: (event) {},
                      );
                    });
              }),
          Container(
            height: 16,
          ),
          StreamBuilder(
              stream: _bloc.outputErrorPassword,
              initialData: "",
              builder: (_, snapshot1) {
                return StreamBuilder(
                  stream: _bloc.outputPassword,
                  initialData: true,
                  builder: (_, snapshot) {
                    return CustomTextField(
                      hintText: AppLocalizations.text(LangKey.input_password),
                      hintStyle: AppTextStyles.style13GreyW400,
                      controller: _passwordController,
                      focusNode: _passwordNode,
                      enableBorder: onFocusPassword,
                      radius: 30.0,
                      suffixIcon: snapshot.data!
                          ? Assets.img_eye_close
                          : Assets.img_eye_open,
                      backgroundColor: AppColors.whiteColor,
                      suffixIconColor: AppColors.grey15,
                      error: snapshot1.data,
                      obscureText: snapshot.data,
                      // require: false,
                      onSuffixIconTap: () => _bloc.setPassword(!snapshot.data!),
                      onChanged: (event) {
                        _bloc.setErrorString('');
                        _bloc.setErrorPassword('');
                      },
                      onSubmitted: (_) => {},
                    );
                  },
                );
              }),
          Container(
            height: 16,
          ),
          StreamBuilder(
              stream: _bloc.outputErrorRePassword,
              initialData: "",
              builder: (_, snapshot1) {
                return StreamBuilder(
                  stream: _bloc.outputRePassword,
                  initialData: true,
                  builder: (_, snapshot) {
                    return CustomTextField(
                      hintText: AppLocalizations.text(LangKey.input_password_again),
                      hintStyle: AppTextStyles.style13GreyW400,
                      controller: _rePasswordController,
                      focusNode: _rePasswordNode,
                      enableBorder: onFocusRePassword,
                      radius: 30.0,
                      suffixIcon: snapshot.data!
                          ? Assets.img_eye_close
                          : Assets.img_eye_open,
                      backgroundColor: AppColors.whiteColor,
                      suffixIconColor: AppColors.grey15,
                      error: snapshot1.data,
                      obscureText: snapshot.data,
                      // require: false,
                      onSuffixIconTap: () =>
                          _bloc.setRePassword(!snapshot.data!),
                      onChanged: (event) {
                        _bloc.setErrorString('');
                        _bloc.setErrorRePassword('');
                      },
                      onSubmitted: (_) => {},
                    );
                  },
                );
              }),
          StreamBuilder(
            stream: _bloc.outputErrorRegister,
            initialData: "",
            builder: (_, snapshot) {
              if (snapshot.hasData && snapshot.data != "") {
                return Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    snapshot.data ?? "Lỗi",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          // _forgot_password(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return BackGroundCloudWidget();
  }
}
