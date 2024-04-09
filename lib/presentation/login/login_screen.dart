
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/home/home_screen.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/dialog_comfirm_widget.dart';
import 'package:chicken_combat/widgets/dialog_congratulation_level_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:false,
      child: Scaffold(
        backgroundColor: Color(0xFFFACA44),
        body: Center(
          child: Container(
            width: AppSizes.maxWidth,
            height: AppSizes.maxHeight,
            child: Stack(
              children: [
                _buildBackground(),
                _body()
              ],
            ),
          ),
        ),
        // body: Responsive(mobile: _body(),tablet: _body(),desktop: _body(),),
        bottomNavigationBar: Container(
              height: 80,
              color: Color(0xFFFACA44),
              child: Center(
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
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white),
              child: TextField(
                  decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.all(12.0),
                border: InputBorder.none,
                hintText: "Tên đăng nhập",
                isDense: true,
              )),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white),
              child: TextField(
                  decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.all(12.0),
                border: InputBorder.none,
                hintText: "Mật khẩu",
                isDense: true,
              )),
            ),
            InkWell(
              onTap: () {
                print("forget");
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, top: 16),
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
        redBlurColor: true,
        child: Center(
            child: Text("Đăng nhập",
                style: TextStyle(fontSize: 24, color: Colors.white))),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen()));
        },
      ),
    );
  }
  Widget _comeinNow() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: CustomButtomImageColorWidget(
        redBlurColor: true,
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
                           return DialogConfirmWidget(cancel: () {
                            Navigator.of(context).pop();
                           },
                           agree: () {
                            Navigator.of(context).pop(true);
                           },);
                          
                        },
                      );
                    });
        },
      ),
    );
  }
}
