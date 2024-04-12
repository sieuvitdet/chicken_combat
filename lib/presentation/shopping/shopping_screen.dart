import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<ItemShopModel> _listItemSkinShop = [];
  List<ItemShopModel> _listItemColorShop = [];
  List<ItemShopModel> _listItemPremiumShop = [];
  int tab = 0;

  @override
  void initState() {
    super.initState();
    //Skin
    _listItemColorShop.add(ItemShopModel(
        asset: Assets.img_chicken,
        isHot: true,
        bought: true,
        isUsed: true,
        isDiamond: false));
    _listItemColorShop.add(ItemShopModel(
        asset: Assets.img_chicken_green,
        isHot: true,
        bought: true,
        isUsed: false,
        isDiamond: false));
    _listItemColorShop.add(ItemShopModel(
        asset: Assets.img_chicken_black,
        isHot: false,
        bought: false,
        isUsed: false,
        isDiamond: false));
    _listItemColorShop.add(ItemShopModel(
        asset: Assets.img_chicken_blue,
        isHot: false,
        bought: false,
        isUsed: false,
        isDiamond: false));
    _listItemColorShop.add(ItemShopModel(
        asset: Assets.img_chicken_red,
        isHot: false,
        bought: false,
        isUsed: false,
        isDiamond: false));
    _listItemColorShop.add(ItemShopModel(
        asset: Assets.img_chicken_white_0,
        isHot: false,
        bought: false,
        isUsed: false,
        isDiamond: false));
    _listItemColorShop.add(ItemShopModel(
        asset: Assets.img_chicken_green,
        isHot: false,
        bought: false,
        isUsed: false,
        isDiamond: false));
    _listItemColorShop.add(ItemShopModel(
        asset: Assets.img_chicken_brown,
        isHot: false,
        bought: false,
        isUsed: false,
        isDiamond: false));
//Hat
    _listItemSkinShop.add(ItemShopModel(
        asset: Assets.img_hat_scholar,
        isHot: false,
        bought: false,
        isUsed: false,
        isDiamond: false));
    _listItemSkinShop.add(ItemShopModel(
        asset: Assets.img_breath_machine,
        isHot: false,
        bought: false,
        isUsed: false,
        isDiamond: false));
    _listItemSkinShop.add(ItemShopModel(
        asset: Assets.img_mask,
        isHot: false,
        bought: false,
        isUsed: false,
        isDiamond: false));
//Premium
    _listItemPremiumShop.add(ItemShopModel(
        asset: Assets.gif_chicken_brown,
        isHot: false,
        bought: false,
        isUsed: false,
        isDiamond: true));
    _listItemPremiumShop.add(ItemShopModel(
        asset: Assets.img_chicken_bear_white_premium,
        isHot: false,
        bought: false,
        isUsed: false,
        isDiamond: true));
    _listItemPremiumShop.add(ItemShopModel(
        asset: Assets.img_chicken_lovely,
        isHot: false,
        bought: false,
        isUsed: false,
        isDiamond: true));

    _listItemPremiumShop.add(ItemShopModel(
        asset: Assets.img_chicken_brown_circleface_premium,
        isHot: false,
        bought: false,
        isUsed: false,
        isDiamond: true));
        _listItemPremiumShop.add(ItemShopModel(
        asset: Assets.img_gift_gacha,
        isHot: true,
        bought: false,
        isUsed: false,
        isDiamond: true));

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  Widget _listTabUnSelect() {
    return Positioned(
        top: AppSizes.maxHeight*0.128,
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
                          height: AppSizes.maxHeight*0.054,
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
                          height: AppSizes.maxHeight*0.054,
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
                          height: AppSizes.maxHeight*0.054,
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

  Widget _item(int tab,
      {bool? isDiamond,
      bool? isHot,
      bool? bought,
      bool? isUsed,
      String? asset}) {
    return Container(
      width: (AppSizes.maxWidth * 0.775) / 3,
      height: AppSizes.maxHeight * 0.14,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image(
            image: AssetImage(Assets.img_background_item_shop),
            height: 124,
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
                      asset!,
                      // width: AppSizes.maxWidth * 0.1,
                      height: AppSizes.maxHeight * 0.07,
                    ))),
                Expanded(
                    flex: 3,
                    child: (bought ?? false)
                        ? ScalableButton(
                            onTap: () {},
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                    child: Image.asset(
                                  Assets.img_bg_money_shop,
                                  height: AppSizes.maxHeight*0.038,
                                  width: (AppSizes.maxWidth * 0.7) / 3,
                                  fit: BoxFit.fill,
                                )),
                                Center(
                                  child: StrokeTextWidget(
                                    text:
                                        isUsed ?? false ? "Đã dùng" : "Sử dụng",
                                    size: 12,
                                    colorStroke: Colors.green,
                                  ),
                                )
                              ],
                            ),
                          )
                        : ScalableButton(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                    child: Image.asset(
                                  Assets.img_button_coin_shop,
                                  width: 66,
                                  fit: BoxFit.fill,
                                )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      isDiamond ?? false
                                          ? Assets.ic_diamond
                                          : Assets.ic_coin,
                                      width: 16,
                                      height: 16,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: StrokeTextWidget(
                                          text: "200",
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
          if (isHot ?? false)
            Positioned(
                top: -5,
                left: -2,
                child: Image.asset(
                  Assets.img_hot_item,
                  width: ((AppSizes.maxWidth * 0.7 - 24) / 3) / 1.8,
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
                  return _item(0,
                      asset: _listItemSkinShop[index].asset,
                      isDiamond: _listItemSkinShop[index].isDiamond,
                      isHot: _listItemSkinShop[index].isHot,
                      isUsed: _listItemSkinShop[index].isUsed,
                      bought: _listItemSkinShop[index].bought);
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
                  return _item(1,
                      asset: _listItemColorShop[index].asset,
                      isDiamond: _listItemColorShop[index].isDiamond,
                      isHot: _listItemColorShop[index].isHot,
                      isUsed: _listItemColorShop[index].isUsed,
                      bought: _listItemColorShop[index].bought);
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
                  return _item(2,
                      asset: _listItemPremiumShop[index].asset,
                      isDiamond: _listItemPremiumShop[index].isDiamond,
                      isHot: _listItemPremiumShop[index].isHot,
                      isUsed: _listItemPremiumShop[index].isUsed,
                      bought: _listItemPremiumShop[index].bought);
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
          Center(child: _number(200)),
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
          Center(child: _number(100)),
          _diamondNow(),
        ],
      ),
    );
  }

  Widget _number(int number) {
    return Container(
      height: 24,
      width: 70,
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
          color: Colors.pink, borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        margin: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(8.0)),
        alignment: Alignment.center,
        child: Text("$number",style: TextStyle(fontSize: 12,color: Colors.white)),
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
              margin: EdgeInsets.only(top: AppSizes.maxHeight*0.167, bottom: 40),
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
