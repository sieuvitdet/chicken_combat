import 'dart:math';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/model/finance_model.dart';
import 'package:chicken_combat/model/store_model.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/custom_dialog_with_title_button_widget.dart';
import 'package:chicken_combat/widgets/dialog_random_gift_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShoppingScreen extends StatefulWidget {
  final FinanceModel financeModel;

  ShoppingScreen({required this.financeModel});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<StoreModel> _listItemSkinShop = [];
  List<StoreModel> _listItemColorShop = [];
  List<StoreModel> _listItemPremiumShop = [];
  int tab = 0;
  String type = "";

  @override
  void initState() {
    super.initState();
    //Skin
    for (var store in Globals.listStore) {
      if (store.key == StoreModelEnum.color) {
        _listItemColorShop.add(store);
      } else if (store.key == StoreModelEnum.skin) {
        _listItemSkinShop.add(store);
      } else if (store.key == StoreModelEnum.diamond) {
        _listItemPremiumShop.add(store);
      }
    }

    _listItemPremiumShop.add(StoreModel(
        id: "",
        asset: Assets.img_gift_gacha,
        isHotSale: true,
        cast: "10",
        type: "0",
        key: StoreModelEnum.diamond));

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  Widget _listTabUnSelect() {
    return Positioned(
        top: AppSizes.maxHeight * 0.128,
        right: 0,
        left: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            (tab != 0)
                ? ScalableButton(
                    onTap: () {
                      setState(() {
                        tab = 0;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          Assets.img_tab_button_unselected_shop,
                          height: AppSizes.maxHeight * 0.054,
                          width: (AppSizes.maxWidth * 0.65) / 3,
                          fit: BoxFit.fitWidth,
                        ),
                        StrokeTextWidget(
                          text: "Skin",
                          size: 13,
                        )
                      ],
                    ),
                  )
                : Container(width: (AppSizes.maxWidth * 0.65) / 3),
            (tab != 1)
                ? ScalableButton(
                    onTap: () {
                      setState(() {
                        tab = 1;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          Assets.img_tab_button_unselected_shop,
                          height: AppSizes.maxHeight * 0.054,
                          width: (AppSizes.maxWidth * 0.65) / 3,
                          fit: BoxFit.fitWidth,
                        ),
                        StrokeTextWidget(
                          text: "Color",
                          size: 13,
                        )
                      ],
                    ),
                  )
                : Container(width: (AppSizes.maxWidth * 0.65) / 3),
            (tab != 2)
                ? ScalableButton(
                    onTap: () {
                      setState(() {
                        tab = 2;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          Assets.img_tab_button_unselected_shop,
                          height: AppSizes.maxHeight * 0.054,
                          width: (AppSizes.maxWidth * 0.65) / 3,
                          fit: BoxFit.fitWidth,
                        ),
                        StrokeTextWidget(
                          text: "Diamond",
                          size: 13,
                        )
                      ],
                    ),
                  )
                : Container(width: (AppSizes.maxWidth * 0.66) / 3)
          ],
        ));
  }

  Widget _listTabSelected() {
    return Positioned(
        top: -AppSizes.maxHeight * 0.07,
        right: 0,
        left: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            (tab == 0)
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      ScalableButton(
                        child: Image.asset(
                          Assets.img_tab_button_selected_shop,
                          height: AppSizes.maxHeight * 0.065,
                          width: (AppSizes.maxWidth * 0.6) / 3,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: StrokeTextWidget(
                          text: "Skin",
                          size: AppSizes.maxWidth < 350 ? 12 : 16,
                        ),
                      )
                    ],
                  )
                : Container(width: (AppSizes.maxWidth * 0.6) / 3),
            (tab == 1)
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      ScalableButton(
                        child: Image.asset(
                          Assets.img_tab_button_selected_shop,
                          height: AppSizes.maxHeight * 0.065,
                          width: (AppSizes.maxWidth * 0.6) / 3,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: StrokeTextWidget(
                          text: "Color",
                          size: AppSizes.maxWidth < 350 ? 12 : 16,
                        ),
                      )
                    ],
                  )
                : Container(width: (AppSizes.maxWidth * 0.6) / 3),
            (tab == 2)
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      ScalableButton(
                        child: Image.asset(
                          Assets.img_tab_button_selected_shop,
                          height: AppSizes.maxHeight * 0.065,
                          width: (AppSizes.maxWidth * 0.6) / 3,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: StrokeTextWidget(
                          text: "Diamond",
                          size: AppSizes.maxWidth < 350 ? 12 : 16,
                        ),
                      )
                    ],
                  )
                : Container(width: (AppSizes.maxWidth * 0.6) / 3)
          ],
        ));
  }

  Widget _item(int tab, StoreModel model) {
    return Container(
      width: (AppSizes.maxWidth * 0.775) / 3,
      height: AppSizes.maxHeight * 0.14,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image(
            image: AssetImage(Assets.img_background_item_shop),
            height: AppSizes.maxHeight * 0.14,
            width: (AppSizes.maxWidth * 0.775) / 3,
            fit: BoxFit.fill,
          ),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    flex: 4,
                    child: Center(
                        child: Image.asset(
                      model.asset!,
                      fit: BoxFit.fill,
                      height: AppSizes.maxHeight * 0.07,
                    ))),
                Expanded(
                    flex: 3,
                    child: (Globals.currentUser?.bags.contains(model.id)) ??
                            false
                        ? ScalableButton(
                            onTap: () {},
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                    child: Image.asset(
                                  Assets.img_bg_money_shop,
                                  height: AppSizes.maxHeight * 0.038,
                                  width: (AppSizes.maxWidth * 0.7) / 3,
                                  fit: BoxFit.fill,
                                )),
                                Center(
                                  child: StrokeTextWidget(
                                    text: tab == 1
                                        ? Globals.currentUser?.useColor ==
                                                model.id
                                            ? "Đã dùng"
                                            : "Sử dụng"
                                        : Globals.currentUser?.useSkin ==
                                                model.id
                                            ? "Đã dùng"
                                            : "Sử dụng",
                                    size: 12,
                                    colorStroke: Colors.green,
                                  ),
                                )
                              ],
                            ),
                          )
                        : ScalableButton(
                            onTap: () {
                              if (tab == 2 &&
                                  model.asset == Assets.img_gift_gacha &&
                                  (Globals.financeUser!.diamond >= 10)) {
                                final random = Random();
                                int i = random.nextInt(100);
                                if (i >= 90 && i <= 100) {
                                  type = "chicken";

                                  int j = random.nextInt(100);
                                  if (j >= 95 && j <= 100) {
                                    type = "chicken_premium";
                                    print("Nhận gà hiếm");
                                  }
                                } else {
                                  type = "gold";
                                }
                                Globals.financeUser!.diamond -= 10;
                                _updateFinance(
                                    Globals.currentUser?.financeId ?? "",
                                    Globals.financeUser?.diamond ?? 0);

                                GlobalSetting.shared.showPopupWithContext(
                                    context,
                                    DialogRandomGiftWidget(
                                      type: type,
                                      ontap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ));
                              } else {
                                GlobalSetting.shared.showPopupWithContext(
                                    context,
                                    CustomDialogWithTitleButtonWidget(
                                      title: "Vui lòng tiềm kiếm thêm kim cương để mua vật phẩm này!",
                                      ontap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ));
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                    child: Image.asset(
                                  Assets.img_button_coin_shop,
                                  width: AppSizes.maxWidth * 0.16,
                                  fit: BoxFit.fill,
                                )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      model.type == "0"
                                          ? Assets.ic_diamond
                                          : Assets.ic_coin,
                                      width: 16,
                                      height: 16,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: StrokeTextWidget(
                                          text: model.cast,
                                          size: 16,
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ))
              ],
            ),
          ),
          if (model.isHotSale)
            Positioned(
                top: -AppSizes.maxWidth * 0.01,
                left: -AppSizes.maxWidth * 0.008,
                child: Image.asset(
                  Assets.img_hot_item,
                  fit: BoxFit.fill,
                  width: AppSizes.maxWidth * 0.1,
                ))
        ],
      ),
    );
  }

  Widget _listViewSkin() {
    return ListView(
      children: [
        Center(
          child: Container(
            child: Wrap(
              runSpacing: 8,
              children: List.generate(
                _listItemSkinShop.length,
                (index) {
                  return _item(0, _listItemSkinShop[index]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _listViewColor() {
    return ListView(
      children: [
        Center(
          child: Container(
            child: Wrap(
              runSpacing: 8,
              children: List.generate(
                _listItemColorShop.length,
                (index) {
                  return _item(1, _listItemColorShop[index]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _listViewDiamond() {
    return ListView(
      children: [
        Center(
          child: Container(
            child: Wrap(
              runSpacing: 8,
              children: List.generate(
                _listItemPremiumShop.length,
                (index) {
                  return _item(2, _listItemPremiumShop[index]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _coin() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(child: _number("${widget.financeModel.gold}")),
          _coinNow(),
        ],
      ),
    );
  }

  Widget _dimond() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(child: _number("${widget.financeModel.diamond}")),
          _diamondNow(),
        ],
      ),
    );
  }

  Widget _number(String number) {
    return Container(
      height: 24,
      width: 70,
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
          color: Color(0xFFD13F06), borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        margin: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            color: Color(0xFFB94416), borderRadius: BorderRadius.circular(8.0)),
        alignment: Alignment.center,
        child: Text("$number",
            style: TextStyle(fontSize: 12, color: Colors.white)),
      ),
    );
  }

  Widget _coinNow() {
    return Positioned(
      top: 4,
      left: -10,
      child: Image.asset(
        Assets.img_coin_border_white,
        fit: BoxFit.fill,
      ),
      width: 32,
      height: 32,
    );
  }

  Widget _diamondNow() {
    return Positioned(
      top: 4,
      left: -10,
      child: Image.asset(
        Assets.img_diamond_border_white,
        fit: BoxFit.fill,
      ),
      width: 32,
      height: 32,
    );
  }

  Future<void> _updateFinance(String _id, int diamond) async {
    CollectionReference _finance =
        FirebaseFirestore.instance.collection(FirebaseEnum.finance);

    return _finance
        .doc(_id)
        .update({'diamond': diamond})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Widget _buildContent() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFF55BBEB),
                Color(0xFF56C4F5),
              ],
            )),
        width: AppSizes.maxWidth * 0.9,
        height: AppSizes.maxHeight * 0.7,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            _listTabUnSelect(),
            Container(
              width: AppSizes.maxWidth * 0.8,
              margin:
                  EdgeInsets.only(top: AppSizes.maxHeight * 0.167, bottom: 40),
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xFF157BAC),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (tab == 0) _listViewSkin(),
                  if (tab == 1) _listViewColor(),
                  if (tab == 2) _listViewDiamond(),
                  _listTabSelected()
                ],
              ),
            ),
            Positioned(
                top: 0,
                child: Image.asset(
                  Assets.img_roof_shop,
                  // height: 72,
                  width: AppSizes.maxWidth,
                  fit: BoxFit.contain,
                )),
            Positioned(
                top: -16,
                right: -16,
                child: ScalableButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    Assets.ic_close_popup,
                    height: 48,
                    width: 48,
                    fit: BoxFit.fill,
                  ),
                )),
            Positioned(
                top: -40,
                child: StrokeTextWidget(
                  text: "Cửa hàng",
                  size: 32,
                )),
            Positioned(
                bottom: 0,
                child: Row(
                  children: [_coin(), _dimond()],
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.transparent, body: _buildContent());
  }
}

class ItemShopModel {
  String? asset;
  bool? isHot;
  bool? bought;
  bool? isUsed;
  bool? isDiamond;
  int? price;
  ItemShopModel(
      {this.asset,
      this.isHot,
      this.bought,
      this.isUsed,
      this.isDiamond,
      this.price});
}
