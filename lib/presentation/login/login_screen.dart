import 'package:chicken_combat/common/assets.dart';
import 'dart:async';

import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/model/user_model.dart';
import 'package:chicken_combat/presentation/home/home_screen.dart';
import 'package:chicken_combat/presentation/login/login_bloc.dart';
import 'package:chicken_combat/presentation/register/PhoneRegisterScreen.dart';
import 'package:chicken_combat/utils/shared_pref_key.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/utils/validator.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/custom_textfield_widget.dart';
import 'package:chicken_combat/widgets/dialog_comfirm_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _userNameNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  bool onFocusUserName = false;
  bool onFocusPassword = false;
  late LoginBloc _bloc;

  ScrollController _scrollController = ScrollController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _bloc = LoginBloc(context);
    _scrollController = ScrollController();
  }

      @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool checkValidInputField() {
    FocusScope.of(context).unfocus();
    _bloc.setErrorUserName('');
    _bloc.setErrorPassword('');
    bool check = true;
    if (_userNameController.text.trim() == "" &&
        _passwordController.text.trim() == "") {
      _bloc.setErrorUserName("Vui lòng nhập số điện thoại");
      _bloc.setErrorPassword("Vui lòng nhập mật khẩu");
      check = false;
    } else if (_userNameController.text.trim() == "") {
      _bloc.setErrorUserName("Vui lòng nhập số điện thoại");
      check = false;
    } else if (_passwordController.text.trim() == "") {
      if (!Validators().isValidPhone(_userNameController.text.trim())) {
        _bloc.setErrorUserName("Số điện thoại không đúng định dạng");
      }
      _bloc.setErrorUserName("Vui lòng nhập số điện thoại");
      check = false;
    } else {
      if (!Validators().isValidPhone(_userNameController.text.trim())) {
        _bloc.setErrorUserName("Số điện thoại không đúng định dạng");
        check = false;
      } else {
        check = true;
      }
    }
    return check;
  }

  void login(String _phone, String _password) async {
    CustomNavigator.showProgressDialog(context);
    if (_phone.isEmpty || _password.isEmpty) {
      print('Phone or password is Empty');
      return;
    }
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirebaseEnum.userdata);
    await users.doc(_phone).get().then((DocumentSnapshot documentSnapshot) {
      CustomNavigator.hideProgressDialog();
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        UserModel user = UserModel.fromSnapshot(documentSnapshot);
        if (user.id == _phone && user.password == _password) {
          _bloc.setupLogin(user);
          print('User ID: ${user.id}');
          print('User Phone Number: ${user.phoneNumber}');
          print('User Password: ${user.password}');
          print('User Full Name: ${user.fullName}');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen()));
        } else {
          _bloc.setErrorLogin("Số điện thoại hoặc mật khẩu không đúng.");
        }
      } else {
        _bloc.setErrorLogin("Số điện thoại không tồn tại.");
      }
    }).catchError((error) {
      _bloc.setErrorLogin("${error}");
    });
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
                        hintText: "Số điện thoại",
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
                        isPhone: true,
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
                      hintText: "Nhập mật khẩu",
                      hintStyle: AppTextStyles.style13GreyW400,
                      suffixIcon: snapshot.data!
                          ? Assets.img_eye_close
                          : Assets.img_eye_open,
                      controller: _passwordController,
                      focusNode: _passwordNode,
                      enableBorder: onFocusPassword,
                      error: snapshot1.data,
                      backgroundColor: AppColors.whiteColor,
                      suffixIconColor: AppColors.grey15,
                      obscureText: snapshot.data,
                      radius: 30.0,
                      // require: false,
                      onSuffixIconTap: () => _bloc.setPassword(!snapshot.data!),
                      onChanged: (event) {
                        _bloc.setErrorString('');
                        _bloc.setErrorPassword('');
                      },
                      onSubmitted: (_) => {},
                      isPassWord: true,
                    );
                  },
                );
              }),
          StreamBuilder(
            stream: _bloc.outputErrorLogin,
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

  Widget _body() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        height: AppSizes.maxHeight,
        width: AppSizes.maxWidth,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              fit: BoxFit.contain,
              image: AssetImage(Assets.chicken_flapping_swing_gif),
              width: AppSizes.maxWidth * 0.5,
              height: AppSizes.maxHeight * 0.2,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                "Học giả gà con",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            _inputForm(),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 16, top: 16),
                child: ScalableButton(
                  onTap: () {
                    print("forget");
                  },
                  child: Text(
                    "Quên mật khẩu?",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            _login(),
            _comeInNow()
          ],
        ),
      ),
    );
  }

  Widget _login() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: CustomButtomImageColorWidget(
          orangeColor: true,
          child: Center(
              child: Text("Đăng nhập",
                  style: TextStyle(fontSize: 24, color: Colors.white))),
          onTap: () {
                if (checkValidInputField()) { login(_userNameController.text, _passwordController.text); }
              }),
    );
  }

  Widget _comeInNow() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: CustomButtomImageColorWidget(
        orangeColor: true,
        child: Center(
            child: Text("Vào ngay",
                style: TextStyle(fontSize: 24, color: Colors.white))),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return DialogConfirmWidget(
                      cancel: () {
                        Navigator.of(context).pop();
                      },
                      agree: () {
                        Navigator.of(context).pop(true);
                      },
                    );
                  },
                );
              });
        },
      ),
    );
  }

    @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xFFFACA44),
        body: Center(
          child: Container(
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
        bottomNavigationBar: Container(
          height: 80,
          color: Color(0xFFFACA44),
          child: Center(
            child: InkWell(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PhoneRegisterScreen()))
              },
              child: RichText(
                  text: TextSpan(
                      text: "Bạn chưa có tài khoản?",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Itim",
                          color: Colors.white),
                      children: [
                    TextSpan(
                        text: "  " + "Đăng ký",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE84C3D)))
                  ])),
            ),
          ),
        ),
      ),
    );
  }
  }
