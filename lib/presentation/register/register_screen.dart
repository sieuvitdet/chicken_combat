import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
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
  FocusNode _userNameNode = FocusNode();
  FocusNode _passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _userNameController.dispose();
    _userNameNode.dispose();
    _passwordController.dispose();
    _passwordNode.dispose();
    super.dispose();
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
                    "Đăng ký",
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
                      controller: _userNameController,
                      focusNode: _userNameNode,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(12.0),
                        border: InputBorder.none,
                        hintText: "Tên đăng nhập",
                        isDense: true,
                      )),
                ),
                SizedBox(height: AppSizes.sizeAppBar,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white),
                  child: TextField(
                      controller: _passwordController,
                      focusNode: _passwordNode,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(12.0),
                        border: InputBorder.none,
                        hintText: "Mật khẩu",
                        isDense: true,
                      )),
                ),
              ],
            )));
  }

  Widget _buildBackground() {
    return BackGroundCloudWidget();
  }
}
