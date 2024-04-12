import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final Key? key;
  final FocusNode? focusNode;
  final TextSelectionControls? selectionControls;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final String? suffixIcon;
  final Color? suffixIconColor;
  final double? suffixSize;
  final Color? backgroundColor;
  final Function? onSuffixIconTap;
  final String? prefixIcon;
  final Widget? prefixChild;
  final Color? prefixIconColor;
  final Function? onPrefixIconTap;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final bool? autofocus;
  final bool? readOnly;
  final Function? onTap;
  final bool? enableBorder;
  final int? maxLines;
  final int? maxLength;
  final bool? isPhone;
  final bool? isEmail;
  final bool? isStreet;
  final bool? isPassWord;
  final TextStyle? style;
  final int? limitInput;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? verticalMargin;
  final double? horizontalMargin;
  final String? error;
  final double? radius;
  final Widget? suffixChild;
  final TextAlign? textAlign;
  final Border? border;
  final TextCapitalization? textCapitalization;
  final String? label;
  final TextStyle? styleLabel;
  final bool? require;

  CustomTextField(
      {this.key,
      this.focusNode,
      this.controller,
      this.hintText,
      this.labelText,
      this.suffixIcon,
      this.suffixIconColor,
      this.onSuffixIconTap,
      this.obscureText = false,
      this.keyboardType,
      this.textInputAction,
      this.onSubmitted,
      this.inputFormatters,
      this.onChanged,
      this.autofocus,
      this.readOnly = false,
      this.onTap,
      this.enableBorder = false,
      this.maxLines,
      this.maxLength,
      this.isPhone = false,
      this.style,
      this.limitInput = 255,
      this.verticalPadding,
      this.horizontalPadding,
      this.horizontalMargin = 0.0,
      this.verticalMargin = 0.0,
      this.error = "",
      this.prefixIcon,
      this.prefixIconColor,
      this.onPrefixIconTap,
      this.radius = 8.0,
      this.backgroundColor,
      this.hintStyle,
      this.suffixSize,
      this.suffixChild,
      this.textCapitalization,
      this.selectionControls,
      this.textAlign,
      this.border,
      this.require = false,
      this.prefixChild,
      this.label,
      this.styleLabel,
      this.isEmail = false,
      this.isStreet = false,
      this.isPassWord = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null
            ? Container(
                margin: EdgeInsets.only(bottom: 4),
                child: RichText(
                    text: TextSpan(
                        text: label,
                        style: styleLabel ??
                            TextStyle(
                                fontSize: 13,
                                color: Color(0xFF707885),
                                fontWeight: FontWeight.w500),
                        children: [
                      require ?? false
                          ? TextSpan(
                              text: "*", style: TextStyle(color: Colors.red))
                          : TextSpan()
                    ])),
              )
            : Container(),
        Container(
          margin: EdgeInsets.only(
              top: horizontalMargin ?? 0,
              left: verticalMargin ?? 0,
              right: verticalMargin ?? 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 8.0)),
              color: backgroundColor ??
                  ((error != "")
                      ? Colors.white
                      : (enableBorder ?? false
                          ? Colors.white
                          : Color(0xFFF6F6F6))),
              border: border ??
                  Border.all(
                      width: 1.0,
                      color: (error != "")
                          ? Colors.red
                          : (enableBorder ?? false
                              ? Colors.amber
                              : Color(0xFFF5F5F5)),
                      style: BorderStyle.solid)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (prefixIcon != null)
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding ?? 8,
                    ),
                    child: Image.asset(
                      prefixIcon ?? Assets.img_eye_close,
                      fit: BoxFit.contain,
                      width: AppSizes.maxWidth * 0.058,
                    ),
                  ),
                  onTap: onPrefixIconTap as void Function()?,
                )
              else if (prefixChild != null)
                prefixChild!,
              Flexible(
                child: TextField(
                  key: key,
                  focusNode: focusNode ?? FocusNode(),
                  controller: controller ?? TextEditingController(),
                  selectionControls: selectionControls,
                  keyboardType: isPhone ?? false
                      ? TextInputType.number
                      : (obscureText ?? false
                          ? TextInputType.visiblePassword
                          : (keyboardType ?? TextInputType.text)),
                  textInputAction: textInputAction ?? TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: (prefixIcon == null && prefixChild == null)
                        ? EdgeInsets.only(
                            left: horizontalPadding ?? 16,
                            top: verticalPadding ?? 10.0,
                            bottom: verticalPadding ?? 10.0)
                        : EdgeInsets.symmetric(
                            vertical: verticalPadding ?? 10.0,
                          ),
                    hintText: hintText,
                    hintStyle: hintStyle ??
                        TextStyle(
                            fontSize: 16,
                            color: AppColors.greyTextField,
                            fontWeight: FontWeight.w400),
                    labelText: labelText,
                    labelStyle: hintStyle ?? AppTextStyles.style15GreyTextW400,
                    isDense: true,
                    border: InputBorder.none,
                    counterText: "",
                  ),
                  style: style ??
                      TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                  obscureText: obscureText ?? false,
                  onSubmitted: onSubmitted,
                  inputFormatters: isPhone ?? false
                      ? [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(limitInput),
                        ]
                      : [
                          if (inputFormatters != null) ...inputFormatters!,
                          // FilteringTextInputFormatter.allow(
                          //     RegExp(r'[0-9a-zA-Z!@#$%^&*]'))
                        ],
                  onChanged: onChanged,
                  autofocus: autofocus ?? false,
                  maxLines: maxLines ?? 1,
                  textAlign: textAlign ?? TextAlign.start,
                  maxLength: maxLength,
                  readOnly: readOnly ?? false,
                  onTap: onTap as void Function()?,
                  textCapitalization:
                      textCapitalization ?? TextCapitalization.none,
                ),
              ),
              if (suffixIcon != null || suffixChild != null)
                suffixChild ??
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding ?? 8,
                        ),
                        child: Image.asset(
                          suffixIcon ?? Assets.img_eye_close,
                          width: suffixSize ?? AppSizes.maxWidth * 0.058,
                          color: suffixIconColor ?? Colors.amber,
                        ),
                      ),
                      onTap: onSuffixIconTap as void Function()?,
                    )
            ],
          ),
        ),
        if (error != "")
          error != "."
              ? Container(
                  margin: EdgeInsets.only(bottom: 16, top: 4, right: 8),
                  child: Text(
                    error ?? "",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : Container()
      ],
    );
  }
}

class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp validCharacters = RegExp(r'^[a-zA-Z0-9@.]+$');

    // Check if the new input matches the allowed characters
    if (validCharacters.hasMatch(newValue.text)) {
      int atSymbolCount =
          newValue.text.split('').where((char) => char == '@').length;
      if (atSymbolCount <= 1) {
        return newValue;
      } else {
        return oldValue;
      }
    } else {
      return oldValue;
    }
  }
}

class SingleAtSymbolInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int atSymbolCount =
        newValue.text.split('').where((char) => char == '@').length;

    // Allow the input if there's only one "@" character, otherwise, revert to the old value
    if (atSymbolCount <= 1) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
