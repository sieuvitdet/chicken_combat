import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'OTPRegisterScreen.dart';

class PhoneRegisterScreen extends StatefulWidget {
  const PhoneRegisterScreen({super.key});

  @override
  State<PhoneRegisterScreen> createState() => _PhoneRegisterScreenState();
}

class _PhoneRegisterScreenState extends State<PhoneRegisterScreen> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _phoneController = TextEditingController();

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
    _phoneController.dispose();
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
                            controller: _phoneController,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              contentPadding: EdgeInsets.all(12.0),
                              border: InputBorder.none,
                              hintText: "Số điện thoại",
                              isDense: true,
                            )),
                      ),
                    ],
                  ),
                ),
                _checkPhoneNumber()
              ],
            )));
  }

  void _verifyPhoneDb(String _phone) async {
    if (_phone.isEmpty) {
      print('phone empty');
      return;
    }
    await FirebaseFirestore.instance
        .collection(FirebaseEnum.userdata)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.id == _phone) {
          print('Existing phone number');
          return;
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OTPRegisterScreen(_phone)));
        }
      });
    });
  }

  Widget _checkPhoneNumber() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: CustomButtomImageColorWidget(
        orangeColor: true,
        child: Center(
            child: Text("Đăng ký",
                style: TextStyle(fontSize: 24, color: Colors.white))),
        onTap: () => _verifyPhoneDb(_phoneController.text),
      ),
    );
  }

  Widget _buildBackground() {
    return BackGroundCloudWidget();
  }
}
