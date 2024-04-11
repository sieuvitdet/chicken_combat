import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/widgets/background_cloud_general_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPRegisterScreen extends StatefulWidget {
  final String phone;

  const OTPRegisterScreen(this.phone);

  @override
  State<OTPRegisterScreen> createState() => _OTPRegisterScreenState();
}

class _OTPRegisterScreenState extends State<OTPRegisterScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController _scrollController = ScrollController();
  TextEditingController _otpController = TextEditingController();
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _callOTP();
  }

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
                          "Nhập mã OTP",
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
                            controller: _otpController,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              contentPadding: EdgeInsets.all(12.0),
                              border: InputBorder.none,
                              hintText: "OTP",
                              isDense: true,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  String convertToInternationalPhoneNumber(String phoneNumber) {
    String cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (cleanedPhoneNumber.startsWith('0')) {
      return '+84${cleanedPhoneNumber.substring(1)}';
    } else {
      return cleanedPhoneNumber;
    }
  }

  Future<void> _callOTP() async {
    String internationalPhoneNumber = convertToInternationalPhoneNumber(widget.phone);
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: internationalPhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Xử lý đăng nhập tự động nếu mã OTP được gửi và xác minh tự động thành công
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException error) {
          // Xử lý lỗi khi xác minh số điện thoại thất bại
          print('Verification failed: ${error.message}');
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          // Xử lý khi mã OTP được gửi đi thành công
          // Thường bạn sẽ hiển thị một màn hình nhập mã OTP ở đây
          print('OTP sent successfully to ${internationalPhoneNumber}');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Xử lý khi hết thời gian tự động nhận mã OTP
          print('Auto retrieval timeout for OTP with verification ID: $verificationId');
        },
      );
    } catch (e) {
      // Xử lý các lỗi khác có thể xảy ra trong quá trình gọi OTP
      print('An error occurred while calling OTP: $e');
    }
  }

  Widget _buildBackground() {
    return BackGroundCloudWidget();
  }
}
