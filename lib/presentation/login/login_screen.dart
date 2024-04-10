import 'package:chicken_combat/common/assets.dart';
import 'dart:async';

import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/user_model.dart';
import 'package:chicken_combat/presentation/home/home_screen.dart';
import 'package:chicken_combat/presentation/login/login_bloc.dart';
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
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
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
                FutureBuilder<DocumentSnapshot>(
                  future: users.doc("0924002700").get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Text(
                          "Full Name: ${data['name']} phone: ${data['phone']}");
                    }

                    return Text("loading");
                  },
                )
              ],
            ),
          ),
        ),
        // body: Responsive(mobile: _body(),tablet: _body(),desktop: _body(),),
        bottomNavigationBar: Container(
              height: 80,
              color: Color(0xFFFACA44),
              child: Center(
                child: InkWell(
                  onTap: () => {},
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
          // _forgot_password(),
        ],
      ),
    );
  }

  Future<void> addUser() {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
    return users
        .doc("0559237978")
        .set({
          'name': "Gà đỏ", // John Doe
          'password': "123456", // Stokes and Sons
          'phone': "0559237978" // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login(String _phone, String _password) async {
    if (_phone.isEmpty || _password.isEmpty) {
        print('Phone or password is Empty');
        return;
    }

    CollectionReference users = FirebaseFirestore.instance.collection('userdata');
    await users.doc(_phone).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        UserModel user = UserModel.fromSnapshot(documentSnapshot);
        if (user.id == _phone && user.password == _password) {
          print('User ID: ${user.id}');
          print('User Phone Number: ${user.phoneNumber}');
          print('User Password: ${user.password}');
          print('User Full Name: ${user.fullName}');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen()));
        } else {
          print('Phone or password faild');
        }
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
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
            _comeinNow()
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
          _bloc.setErrorUserName("Số điện thoại không tồn tại");
          _bloc.setErrorPassword("Sai mật khẩu");
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => HomeScreen()));
        },
        onTap: () => login(_phoneController.text, _passwordController.text),
      ),
    );
  }

  Widget _comeinNow() {
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
                    // return DialogCongratulationLevelWidget(ontapExit: () {
                    //   Navigator.of(context).pop();
                    // },
                    // );
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
}
