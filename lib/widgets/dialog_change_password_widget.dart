import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogChangePasswordWidget extends StatefulWidget {
  const DialogChangePasswordWidget({super.key});

  @override
  State<DialogChangePasswordWidget> createState() =>
      _DialogChangePasswordWidgetState();
}

class _DialogChangePasswordWidgetState
    extends State<DialogChangePasswordWidget> {
  TextEditingController _controllerOldPass = TextEditingController();
  FocusNode _focusNodeOldPass = FocusNode();

  TextEditingController _controllerNewPass = TextEditingController();
  FocusNode _focusNodeNewPass = FocusNode();

  TextEditingController _controllerNewPassAgain = TextEditingController();
  FocusNode _focusNodeNewPassAgain = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: AppSizes.maxWidth * 0.838,
            height: AppSizes.maxHeight * 0.47,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  Assets.img_background_popup,
                  fit: BoxFit.fill,
                  height: AppSizes.maxHeight * 0.49,
                ),
                Column(
                  children: [
                    Container(
                      height: AppSizes.maxHeight * 0.09,
                      child: Center(
                        child: StrokeTextWidget(
                            text: "Đổi mật khẩu",
                            size: AppSizes.maxWidth < 350 ? 20: 30,
                            colorStroke: Colors.red[900]),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xFFEDB371),
                              Color(0xFFFFD383),
                            ],
                          )),
                      child: Column(
                        children: [
                          _oldPass(),
                          _newPass(),
                          _newPassWordAgain(),
                          Container(height: 60),
                          CustomButtomImageColorWidget(
                            orangeColor: true,
                            child: Center(
                              child: StrokeTextWidget(
                                text: "Lưu",
                                size: AppSizes.maxWidth < 350 ? 14 : 20,
                                colorStroke: Color(0xFFD18A5A),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                    SizedBox(
                      height: AppSizes.maxHeight * 0.025,
                    )
                  ],
                ),
                Positioned(
                    right: 16,
                    top: AppSizes.maxHeight * 0.0245,
                    child: ScalableButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image.asset(Assets.ic_close_popup,
                            width: AppSizes.maxWidth * 0.116))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _oldPass() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: AppSizes.maxWidth * 0.03),
          alignment: Alignment.centerLeft,
          width: AppSizes.maxWidth * 0.17,
          height: AppSizes.maxWidth * 0.097,
          child: StrokeTextWidget(
            text: "Mk cũ:",
            size: AppSizes.maxWidth < 350 ? 12 : 16,
            colorStroke: Color(0xFFD18A5A),
          ),
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.only(left: 4.0),
          height: AppSizes.maxHeight * 0.036,
          decoration: BoxDecoration(
              color: Color(0xFFD18A5A),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 0), // Shadow position
                ),
              ]),
          child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: _controllerOldPass,
                        focusNode: _focusNodeOldPass,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          border: InputBorder.none,
                          hintText: "Nhập mật khẩu cũ",
                          isDense: true,
                        )),
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        Assets.ic_coin,
                        width: AppSizes.maxWidth * 0.058,
                        fit: BoxFit.fill,
                      ))
                ],
              )),
        ))
      ],
    );
  }

  Widget _newPass() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: AppSizes.maxWidth * 0.03),
          alignment: Alignment.centerLeft,
          width: AppSizes.maxWidth * 0.17,
          height: AppSizes.maxWidth * 0.097,
          child: StrokeTextWidget(
            text: "MK mới:",
            size: AppSizes.maxWidth < 350 ? 12 : 16,
            colorStroke: Color(0xFFD18A5A),
          ),
        ),
        Expanded(
            child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 4.0),
          height: AppSizes.maxHeight * 0.036,
          decoration: BoxDecoration(
              color: Color(0xFFD18A5A),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 0), // Shadow position
                ),
              ]),
          child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: _controllerNewPass,
                        focusNode: _focusNodeNewPass,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          border: InputBorder.none,
                          hintText: "Nhập mật khẩu mới",
                          isDense: true,
                        )),
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        Assets.ic_coin,
                        width: AppSizes.maxWidth * 0.058,
                        fit: BoxFit.fill,
                      ))
                ],
              )),
        ))
      ],
    );
  }

  Widget _newPassWordAgain() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: AppSizes.maxWidth * 0.02),
          alignment: Alignment.centerLeft,
          width: AppSizes.maxWidth * 0.18,
          height: AppSizes.maxWidth * 0.097,
          child: StrokeTextWidget(
            text: "Nhập lại:",
            size: AppSizes.maxWidth < 350 ? 12 : 14,
            colorStroke: Color(0xFFD18A5A),
          ),
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.only(left: 4.0),
          height: AppSizes.maxHeight * 0.036,
          decoration: BoxDecoration(
              color: Color(0xFFD18A5A),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 0), // Shadow position
                ),
              ]),
          child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: _controllerNewPassAgain,
                        focusNode: _focusNodeNewPassAgain,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          border: InputBorder.none,
                          hintText: "Nhập lại mật khẩu",
                          isDense: true,
                        )),
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        Assets.ic_coin,
                        width: AppSizes.maxWidth * 0.058,
                        fit: BoxFit.fill,
                      ))
                ],
              )),
        ))
      ],
    );
  }
}
