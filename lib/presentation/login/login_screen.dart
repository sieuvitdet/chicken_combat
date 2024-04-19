import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/model/user_model.dart';
import 'package:chicken_combat/presentation/home/home_screen.dart';
import 'package:chicken_combat/presentation/login/login_bloc.dart';
import 'package:chicken_combat/presentation/register/register_screen.dart';
import 'package:chicken_combat/utils/generate_hash.dart';
import 'package:chicken_combat/utils/string_utils.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/custom_textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
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

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _bloc = LoginBloc(context);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userNameNode.dispose();
    _passwordController.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  bool checkValidInputField() {
    FocusScope.of(context).unfocus();
    _bloc.setErrorUserName('');
    _bloc.setErrorPassword('');
    bool check = true;
    if (_userNameController.text.trim() == "" &&
        _passwordController.text.trim() == "") {
      _bloc.setErrorUserName("Vui lòng nhập tên đăng nhập");
      _bloc.setErrorPassword("Vui lòng nhập mật khẩu");
      check = false;
    } else if (_userNameController.text.trim() == "") {
      _bloc.setErrorUserName("Vui lòng tên đăng nhập");
      check = false;
    } else if (_passwordController.text.trim() == "") {
      _bloc.setErrorUserName("Vui lòng tên đăng nhập");
      check = false;
    }
    return check;
  }

  void login(String _username, String _password) async {
    final String userName = _username;
    String key = StringUtils.convertToLowerCase(userName);
    final String originalString = _password;
    String encryptedString = GenerateHash.encryptString(originalString, key);
    print("Encrypted String: $encryptedString");
    CustomNavigator.showProgressDialog(context);
    CollectionReference users = firestore.collection(FirebaseEnum.userdata);
    await users.doc(key).get().then((DocumentSnapshot documentSnapshot) {
      CustomNavigator.hideProgressDialog();
      if (documentSnapshot.exists) {
        print('Document exists on the database'); 
        UserModel user = UserModel.fromSnapshot(documentSnapshot);
        if (user.password == encryptedString) {
           _bloc.setupLogin(user);
           Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen()));
        } else {
          _bloc.setErrorLogin("Tên đăng nhập hoặc mật khẩu không đúng.");
        }
      } else {
        _bloc.setErrorLogin("Tên đăng nhập không tồn tại.");
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
                        hintText: AppLocalizations.text(LangKey.account_name),
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
                      hintText: "Nhập mật khẩu",
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
              child: Text(AppLocalizations.text(LangKey.login),
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
            child: Text(AppLocalizations.text(LangKey.come_in_now),
                style: TextStyle(fontSize: 24, color: Colors.white))),
        onTap: () {}
          // showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return StatefulBuilder(
          //         builder: (BuildContext context,
          //             void Function(void Function()) setState) {
          //           return DialogConfirmWidget(
          //             cancel: () {
          //               Navigator.of(context).pop();
          //             },
          //             agree: () {
          //               Navigator.of(context).pop(true);
          //             },
          //           );
          //         },
          //       );
          //     });
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
              onTap: () async {
               List<String>? _result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RegisterScreen(isGuest: false)));
                    if (_result != null && _result.length > 1) {
                      login(_result[0],_result[1]);
                    }
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
