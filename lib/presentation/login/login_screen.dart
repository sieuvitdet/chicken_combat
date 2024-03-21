
import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/home/home_screen.dart';
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
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.yellow[600],
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: AppSizes.maxHeight,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         
          Container(
          margin: EdgeInsets.only(bottom: 8.0),
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage("assets/images/chicken_dancing.gif"),
            width: AppSizes.maxWidth * 0.3,
            height: AppSizes.maxHeight * 0.18,
          ),
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
          InkWell(
            onTap: () {
              print("login");
                
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 16.0),
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Color(0xFFE84C3D)),
              child: Center(
                child: Text(
                  "Đăng nhập",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              print("goo");
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Color(0xFFE84C3D)),
              child: Center(
                child: Text(
                  "Vào ngay",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
            ),
          )
        ],
              ),
              ),
      ),
      bottomNavigationBar: Container(
            height: 80,
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
    );
  }
}
