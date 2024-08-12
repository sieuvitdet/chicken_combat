import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/model/maps/user_map_model.dart';
import 'package:chicken_combat/model/user_model.dart';
import 'package:chicken_combat/presentation/home/home_screen.dart';
import 'package:chicken_combat/presentation/login/login_bloc.dart';
import 'package:chicken_combat/presentation/register/register_screen.dart';
import 'package:chicken_combat/utils/generate_hash.dart';
import 'package:chicken_combat/utils/notification_manager.dart';
import 'package:chicken_combat/utils/string_utils.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/custom_textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      _bloc.setErrorUserName(AppLocalizations.text(LangKey.enter_username));
      _bloc.setErrorPassword(AppLocalizations.text(LangKey.enter_password));
      check = false;
    } else if (_userNameController.text.trim() == "") {
      _bloc.setErrorUserName(AppLocalizations.text(LangKey.enter_username));
      check = false;
    } else if (_passwordController.text.trim() == "") {
      _bloc.setErrorPassword(AppLocalizations.text(LangKey.enter_password));
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
          _bloc.setErrorLogin("Username or password is incorrect.");
        }
      } else {
        _bloc.setErrorLogin("Username does not exist.");
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
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                        ],
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
                      hintText: AppLocalizations.text(LangKey.password),
                      hintStyle: AppTextStyles.style13GreyW400,
                      controller: _passwordController,
                      focusNode: _passwordNode,
                      enableBorder: onFocusPassword,
                      radius: 30.0,
                      suffixIcon: snapshot.data!
                          ? Assets.img_eye_close
                          : Assets.img_eye_open,
                      backgroundColor: AppColors.whiteColor,
                      suffixIconColor: AppColors.yellow,
                      error: snapshot1.data,
                      obscureText: snapshot.data,
                      maxLength: 6,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                      ],
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
                    snapshot.data ?? "error",
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
                "ChickBrain",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            _inputForm(),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Padding(
            //     padding: EdgeInsets.only(bottom: 16, top: 16),
            //     child: ScalableButton(
            //       onTap: () {
            //         print("forget");
            //       },
            //       child: Text(
            //         AppLocalizations.text(LangKey.forget_password),
            //         style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.black),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 16),
            _login(),
            _comeInNow(),
            SizedBox(height: AppSizes.maxHeight*0.05),
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
        onTap: () {
          String userName = StringUtils.generateRandomName();
          _addScore(userName);
        }
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

  void _addScore(String _userName) async {
    CustomNavigator.showProgressDialog(context);
    CollectionReference score =
    FirebaseFirestore.instance.collection(FirebaseEnum.score);
    DocumentReference newDocRef =
    await score.add({'PK11': 0, 'PK22': 0, 'username': _userName});
    String scoreId = newDocRef.id;
    _addFinanceDocument(_userName, scoreId);
  }

  void _addFinanceDocument(String _userName, String _score) async {
    CustomNavigator.showProgressDialog(context);
    CollectionReference finance =
    FirebaseFirestore.instance.collection(FirebaseEnum.finance);
    DocumentReference newDocRef =
    await finance.add({'gold': 0, 'diamond': 0, 'userId': _userName});
    String financeId = newDocRef.id;
    // Sau đó, đăng ký người dùng và chuyển đưa financeId
    bool registrationResult =
    await _registerWithFinanceId(_userName, financeId, _score);
    if (registrationResult) {
      print('Đăng ký thành công');
      await Future.delayed(Duration(seconds: 2));
      login(_userName, "");
    } else {
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
      String _userName, String financeId, String _score) async {
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
        'password': "",
        'level': 1, //Mặc định 1
        'financeId': financeId,
        'avatar': 1, //Mặc định 1
        'bag' : bag,
        'useColor' : 'CO01',
        'useSkin' : '',
        'score' : _score,
        'isGuest' : true,
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


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                        text: "${AppLocalizations.text(LangKey.do_not_have_account)}?",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Itim",
                            color: Colors.white),
                        children: [
                      TextSpan(
                          text: "  " + AppLocalizations.text(LangKey.register),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE84C3D)))
                    ])),
              ),
            ),
          ),
        ),
      ),
    );
  }



}
