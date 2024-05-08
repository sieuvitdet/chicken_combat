import 'dart:async';
import 'dart:math';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DialogRandomGiftWidget extends StatefulWidget {

    final Function? ontap;
  final String type;

  DialogRandomGiftWidget({this.ontap, required this.type});

  @override
  State<DialogRandomGiftWidget> createState() => _DialogRandomGiftWidgetState();
}

class _DialogRandomGiftWidgetState extends State<DialogRandomGiftWidget> {


@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
   Widget build(BuildContext context) {
    String content = "";
    int gold = 0;
    String chicken = Assets.getRandomImage();
    String chickenPremium = Assets.getRandomImagePremium();
    final random = Random();
    switch (widget.type) {
      case "gold":
        gold = random.nextInt(10) + 20;
        Globals.financeUser?.gold += gold;
        _updateFinance(Globals.currentUser?.financeId ?? "",Globals.financeUser?.gold ?? 0);
        content = "${AppLocalizations.text(LangKey.congratulation_reward)} ${gold} ${AppLocalizations.text(LangKey.gold)}";
        break;
      case "chicken":
        if (_validateItemExist(chicken)) {
          content = AppLocalizations.text(LangKey.the_purchased_item_150_gold);
          Globals.financeUser?.gold += 150;
          _updateFinance(Globals.currentUser?.financeId ?? "",Globals.financeUser?.gold ?? 0);
        } else {
          Globals.currentUser!.bags.add(ExtendedAssets.getCodeByAsset(chicken));
          _updateStore(Globals.currentUser!.id, Globals.currentUser!.bags);
          content = AppLocalizations.text(LangKey.congratulation_receive_item);
        }
        break;
      case "chicken_premium":
      if (_validateItemExist(chickenPremium)) {
          content =  AppLocalizations.text(LangKey.the_purchased_item_500_gold);
          Globals.financeUser?.gold += 500;
          _updateFinance(Globals.currentUser?.financeId ?? "",Globals.financeUser?.gold ?? 0);
        } else {
          Globals.currentUser!.bags.add(ExtendedAssets.getCodeByAsset(chickenPremium));
          _updateStore(Globals.currentUser!.id, Globals.currentUser!.bags);
          content = AppLocalizations.text(LangKey.congratulation_receive_rare_item);
        }
        break;
      default:
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: AppSizes.maxWidth * 0.838,
          height: widget.type == "gold" ?AppSizes.maxHeight * 0.44 : AppSizes.maxHeight * 0.48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.img_background_popup,
                fit: BoxFit.fill,
                width: AppSizes.maxWidth * 0.8,
                height: widget.type == "gold" ?AppSizes.maxHeight * 0.44 :AppSizes.maxHeight * 0.48,
              ),
              Column(
                children: [
                  Container(
                    height: AppSizes.maxHeight * 0.09,
                    child: Center(
                      child: StrokeTextWidget(
                          text: AppLocalizations.text(LangKey.notification),
                          size: AppSizes.maxWidth < 350 ? 30 : 40,
                          colorStroke: Colors.red[900]),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    width: AppSizes.maxWidth * 0.8,
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
                        if (widget.type == "gold") _buildGold(gold),
                        if (widget.type == "chicken") _buildChickenReward(chicken),
                        if (widget.type == "chicken_premium")
                          _buildChickenPremiumReward(chickenPremium),
                        SizedBox(height: 8.0),
                        StrokeTextWidget(
                            text: content,
                            size: AppSizes.maxWidth < 350 ? 16 : 20,
                            colorStroke: Colors.red[900]),
                        SizedBox(height: AppSizes.maxHeight * 0.02),
                        _buildButton()
                      ],
                    ),
                  )),
                  SizedBox(
                    height: AppSizes.maxHeight * 0.025,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateStore(String _idUser, List<String> bags) async {
    CollectionReference _user =
        FirebaseFirestore.instance.collection(FirebaseEnum.userdata);

    return _user
        .doc(_idUser)
        .update({'bag': bags})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  bool _validateItemExist(String assest) {
    return (Globals.currentUser?.bag ?? []).contains(ExtendedAssets.getCodeByAsset(assest));
  }

  _buildChickenReward(String assest) {
    return Image.asset(assest,
        height: AppSizes.maxHeight * 0.1, fit: BoxFit.fill);
  }

  _buildChickenPremiumReward(String assest) {
    return Image.asset(assest,
        height: AppSizes.maxHeight * 0.1, fit: BoxFit.fill);
  }

  _buildGold(int gold) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
              Assets.img_coin_border_white,
              fit: BoxFit.fill,
              width: 24,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("${gold}",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
            )
        ],
      ),
    );
  }

  Widget _buildButton() {
    return CustomButtomImageColorWidget(
      onTap: widget.ontap,
      orangeColor: true,
      child: Center(
        child: StrokeTextWidget(
          text: AppLocalizations.text(LangKey.agree),
          size: AppSizes.maxWidth < 350 ? 14 : 20,
          colorStroke: Color(0xFFD18A5A),
        ),
      ),
    );
  }

  Future<void> _updateFinance(String _id, int gold) async {
    CollectionReference _finance = FirebaseFirestore.instance.collection(FirebaseEnum.finance);

  return _finance
    .doc(_id)
    .update({'gold': gold})
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));

  }
}