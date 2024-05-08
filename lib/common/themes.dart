import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppSizes {
  static double maxWidth = 0.0;
  static double maxHeight = 0.0;
  static double statusBarHeight = 0.0;
  static double bottomHeight = 0.0;
  static double sizeAppBar = 0.0;
  static double screenHeight = 0.0;
  static double screenHeightAppBar = 0.0;
  static double scaleWidth = 0.0;
  static double scaleHeight = 0.0;
  static double maxWidthTablet = 0.0;
  //icon

  static init(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    bottomHeight = MediaQuery.of(context).padding.bottom;
    sizeAppBar = statusBarHeight + kToolbarHeight;
    screenHeightAppBar = maxHeight - sizeAppBar;
    screenHeight = maxHeight - statusBarHeight;
    scaleWidth = maxWidth/414;
    scaleHeight = maxHeight/896;
    maxWidthTablet = MediaQuery.of(context).size.width;
  }

   static bool isSmallScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 800;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width > 800;
  }
}

class AppColors {
  static const primaryColor = Color(0xFFF36F21);
  static const whiteColor = Color(0xFFFFFFFF);
  static const greyBorderTextBox = Color(0xFFEEEEEE);
  static const greyTextField = Color(0xFFC2C7CF);
  static const grey5 = Color(0xFFF6F6F6);
  static const grey10 = Color(0xFFF5F5F5);
  static const grey15 = Color(0xFF878D97);
  static const grey20 = Color(0xFF707885);
  static const grey25 = Color(0xFF454D59);
  static const blackLight = Color(0xFF071224);
  static const blackColor = Color(0xFF000000);
  static const redError = Color(0xFFFF002E);
  static const blueText = Color(0xFF0085FF);
  static const greenText = Color(0xFF00BC4B);
  static const orange200 = Color(0xFFFFD699);
  static const orange300 = Color(0xFFF6822D);
  static const orange500 = Color(0xFFFF9800);
  static const cyan = Color(0xFF00C9F5);
  static const yellow = Color(0xFFF2C94C);
  static const orangeVoucher = Color(0xFFFFD8C1);
  static const orangeDisVoucher = Color(0xFFE0E3E8);
  static const backgroundVoucherEnable = Color(0xFFFFFAF8);
  static const backgroundVoucherDisable = Color(0xFFFDFDFD);

  static const orangeText = Color(0xFFF36F21);
  static const orangeDark = Color(0xFFD29672);
}

class AppFonts {
  static const font = "SF Pro Display";
}


class AppKeys {
  static const String keyHUD = "HUD";
}

class AppTextSizes {
  static double size10 = 10.0;
  static double size11 = 11.0;
  static double size12 = 12.0;
  static double size13 = 13.0;
  static double size14 = 14.0;
  static double size15 = 15.0;
  static double size16 = 16.0;
  static double size17 = 17.0;
  static double size18 = 18.0;
  static double size20 = 20.0;
  static double size22 = 22.0;
  static double size24 = 24.0;
}

class AppTextStyles {
  ///style 12
  static TextStyle style12BlackW400 = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w400);
  static TextStyle style12PrimaryBold = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold);
  static TextStyle style12PrimaryNormal = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.normal);
  static TextStyle style12WhiteBold = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.bold);
  static TextStyle style12BlackBold = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.blackColor,
      fontWeight: FontWeight.bold);
  static TextStyle style12grey25W400 = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.grey25,
      fontWeight: FontWeight.w400);
  static TextStyle style12WhiteNormal = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.normal);
  static TextStyle style12BlackNormal = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.blackColor,
      fontWeight: FontWeight.normal);
  static TextStyle style12BlackLightNormal = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.blackLight,
      fontWeight: FontWeight.normal);
  static TextStyle style12Grey15W400 = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.grey15,
      fontWeight: FontWeight.w400);
  static TextStyle style12GreenNormal = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.greenText,
      fontWeight: FontWeight.normal);
  static TextStyle style12RedNormal = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.redError,
      fontWeight: FontWeight.normal);
  static TextStyle style12PrimaryW500 = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w500);

  ///style13
  static TextStyle style13BlackBold = TextStyle(
      fontSize: AppTextSizes.size13,
      color: Colors.black,
      fontWeight: FontWeight.bold);
  static TextStyle style13PrimaryNormal = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.normal);
  static TextStyle style13BlackNormal = TextStyle(
      fontSize: AppTextSizes.size13,
      color: Colors.black,
      fontWeight: FontWeight.normal);
  static TextStyle style13BlackW400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: Colors.black,
      fontWeight: FontWeight.w400);
  static TextStyle style13WhiteNormal = TextStyle(
      fontSize: AppTextSizes.size13,
      color: Colors.white,
      fontWeight: FontWeight.normal);
  static TextStyle style13Grey20W500 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.grey20,
      fontWeight: FontWeight.w500);
  static TextStyle style13GreyTextW400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.greyTextField,
      fontWeight: FontWeight.w400);
      static TextStyle style15GreyTextW400 = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.greyTextField,
      fontWeight: FontWeight.w400);
  static TextStyle style13GreyW400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.grey15,
      fontWeight: FontWeight.w400);
  static TextStyle style13Grey25W400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.grey25,
      fontWeight: FontWeight.w400);
  static TextStyle style13RedW400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.redError,
      fontWeight: FontWeight.w400);
  static TextStyle style13BlueW400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.blueText,
      fontWeight: FontWeight.w400);
  static TextStyle style13GreyW700 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.greyTextField,
      fontWeight: FontWeight.w700);
  static TextStyle style13GreenW400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.greenText,
      fontWeight: FontWeight.w400);
  static TextStyle style13Grey25W600 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.grey25,
      fontWeight: FontWeight.w600);
  ///style14
  static TextStyle style14WhiteBold = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.bold);
  static TextStyle style14PrimaryBold = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold);
  static TextStyle style14BlackBold = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.blackColor,
      fontWeight: FontWeight.bold);
  static TextStyle style14BlackNormal = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.blackColor,
      fontWeight: FontWeight.normal);
  static TextStyle style14WhiteNormal = TextStyle(
      fontSize: AppTextSizes.size14,
      color: Colors.white,
      fontWeight: FontWeight.normal);
  static TextStyle style14RedW400 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: Colors.red,
      fontWeight: FontWeight.w400);
  static TextStyle style14WhiteW500 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: Colors.white,
      fontWeight: FontWeight.w500);
  static TextStyle style14WhiteW700 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: Colors.white,
      fontWeight: FontWeight.w700);
  static TextStyle style14Grey25W400 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.grey25,
      fontWeight: FontWeight.w400);
  static TextStyle style14BlackLightW600 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.blackLight,
      fontWeight: FontWeight.w600);
  static TextStyle style14BlackW400 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.blackLight,
      fontWeight: FontWeight.w400);
  static TextStyle style14BlackW600 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.blackLight,
      fontWeight: FontWeight.w600);
  static TextStyle style14GreyW400 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.greyTextField,
      fontWeight: FontWeight.w400);
  ///style15
  static TextStyle style15BlackBold = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.blackColor,
      fontWeight: FontWeight.bold);
  static TextStyle style15WhiteBold = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.bold);
  static TextStyle style15PrimaryBold = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold);
  static TextStyle style15PrimaryNormal = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.normal);
  static TextStyle style15WhiteNormal = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.normal);
  static TextStyle style15BlackNormal = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.blackColor,
      fontWeight: FontWeight.normal);
  static TextStyle style15BlackW500 = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w500);
  ///style16
   static TextStyle style16BlackWeight700 = TextStyle(
        fontSize: AppTextSizes.size16,
        color: AppColors.blackColor,
        fontWeight: FontWeight.w700);
  static TextStyle style16PrimaryW700 = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w700);
  static TextStyle style16PrimaryBold = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold);
  static TextStyle style16PrimaryW400 = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w400);
  static TextStyle style16PrimaryW500 = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w500);
  static TextStyle style16WhiteW500 = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.w500);
  static TextStyle style16WhiteNormal = TextStyle(
      fontSize: AppTextSizes.size16,
      color: Colors.white,
      fontWeight: FontWeight.normal);
  static TextStyle style16WhiteBold = TextStyle(
      fontSize: AppTextSizes.size16,
      color: Colors.white,
      fontWeight: FontWeight.bold);
  static TextStyle style16BlackBold = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.blackColor,
      fontWeight: FontWeight.bold);
  static TextStyle style16BlackW500 = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w500);
  static TextStyle style16BlackNormal = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.blackColor,
      fontWeight: FontWeight.normal);
  static TextStyle style16Black600 = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.blackLight,
      fontWeight: FontWeight.w600);
  static TextStyle style16GreyText600 = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.greyTextField,
      fontWeight: FontWeight.w600);
  static TextStyle style16GreyTextW500 = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.greyTextField,
      fontWeight: FontWeight.w500);
  static TextStyle style16Grey25Normal = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.grey25,
      fontWeight: FontWeight.normal);
  ///style17
  static TextStyle style17BlackBold = TextStyle(
      fontSize: AppTextSizes.size17,
      color: Colors.black,
      fontWeight: FontWeight.bold);
  static TextStyle style17PrimaryBold = TextStyle(
      fontSize: AppTextSizes.size17,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold);
  static TextStyle style17WhiteNormal = TextStyle(
      fontSize: AppTextSizes.size17,
      color: Colors.white,
      fontWeight: FontWeight.normal);
  ///style18
  static TextStyle style18PrimaryBold = TextStyle(
      fontSize: AppTextSizes.size18,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold);
  static TextStyle style18BlackBold = TextStyle(
      fontSize: AppTextSizes.size18,
      color: AppColors.blackColor,
      fontWeight: FontWeight.bold);
  static TextStyle style18WhiteBold = TextStyle(
      fontSize: AppTextSizes.size18,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.bold);
  ///style20
  static TextStyle style20BlackBold = TextStyle(
      fontSize: AppTextSizes.size20,
      color: Colors.black,
      fontWeight: FontWeight.bold);
  static TextStyle style20WhiteBold = TextStyle(
      fontSize: AppTextSizes.size20,
      color: Colors.white,
      fontWeight: FontWeight.bold);
  static TextStyle style20BlackW500 = TextStyle(
      fontSize: AppTextSizes.size20,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w500);
  ///style24
  static TextStyle style24Primary600Bold = TextStyle(
      fontSize: AppTextSizes.size24,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w600);
  static TextStyle style24Black600Bold = TextStyle(
      fontSize: AppTextSizes.size24,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w600);
  ///style_orther
  static TextStyle style10WhiteBold = TextStyle(
      fontSize: AppTextSizes.size10,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.bold);
  static TextStyle style10BlackNormal = TextStyle(
      fontSize: AppTextSizes.size10,
      color: AppColors.blackColor,
      fontWeight: FontWeight.normal);
  static TextStyle style10GreyW500= TextStyle(
      fontSize: AppTextSizes.size10,
      color: AppColors.grey15,
      fontWeight: FontWeight.w500);
  static TextStyle style11OrangeGreyW400 = TextStyle(
      fontSize: AppTextSizes.size10,
      color: AppColors.orangeText,
      fontWeight: FontWeight.w400);
  static TextStyle style11GreyW400 = TextStyle(
      fontSize: AppTextSizes.size10,
      color: AppColors.grey15,
      fontWeight: FontWeight.w400);
  static TextStyle style22BlackW500 = TextStyle(
      fontSize: AppTextSizes.size22,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w500);

}

class AppFormat {
  static DateFormat formatDate = DateFormat("dd/MM/yyyy");
  static DateFormat formatTime = DateFormat("HH:mm");
  static DateFormat formatFullTime = DateFormat("HH:mm:ss");
  static DateFormat formatDateTime = DateFormat("dd/MM/yyyy HH:mm");
  static DateFormat formatDateCreate = DateFormat("yyyy-MM-dd");
  static DateFormat formatDateTimeCreate = DateFormat("yyyy-MM-dd HH:mm");
  static DateFormat formatDateResponse = DateFormat("yyyy-MM-dd HH:mm:ss");
  static DateFormat formatDateRequest = DateFormat("yyyy/MM/dd");
  static DateFormat formatRemind = DateFormat("HH:mm dd/MM");
  static DateFormat formatTimeDate = DateFormat("HH:mm dd/MM/yyyy");
  static DateFormat formatDateMonth = DateFormat("dd/MM");
  static DateFormat formatDayOfWeek = DateFormat("E");
  static NumberFormat moneyFormat = NumberFormat("#,###");
  static NumberFormat moneyFormat2 = NumberFormat("#.###");
}

class AppBoxShadow {
  static List<BoxShadow> boxShadow = [
    BoxShadow(
        color: AppColors.blackColor.withOpacity(0.1),
        offset: Offset(0.0, 2.0),
        blurRadius: 4.0)
  ];
  static List<BoxShadow> appBarShadow = [
    BoxShadow(
        offset: Offset(0.0, -1.0),
        color: AppColors.whiteColor.withOpacity(0.05),
        blurRadius: 10.0)
  ];
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: AppColors.grey15.withOpacity(0.3),
      offset: Offset(0.0, 1),
      blurRadius: 6.0,
    ),
  ];
  static List<BoxShadow> bottomShadow = [
    BoxShadow(
        color: AppColors.grey15.withOpacity(0.35),
        offset: Offset(
          0.0,
          3,
        ),
        blurRadius: 3.0,
        spreadRadius: 6.0),
  ];
}

extension MoneyFormat on double {
  String getMoneyFormat() {
    return AppFormat.moneyFormat.format(this) + " VND";
    }

  String getMoneyFormatWithoutVND() {
    return AppFormat.moneyFormat.format(this);
    }

  String getNumberFormat() {
    return AppFormat.moneyFormat.format(this) + "";
    }
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.centerRight,
          radius: 0.85,
          colors: <Color>[
            AppColors.primaryColor,
          ],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

class AppAnimation {
  static Duration duration = Duration(milliseconds: 500);
  static Curve curve = Curves.fastOutSlowIn;
}

 