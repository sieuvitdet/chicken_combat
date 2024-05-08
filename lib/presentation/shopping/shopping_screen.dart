import 'dart:math';

import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/model/finance_model.dart';
import 'package:chicken_combat/model/store_model.dart';
import 'package:chicken_combat/model/user_model.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/utils/notification_manager.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/custom_dialog_with_title_button_widget.dart';
import 'package:chicken_combat/widgets/dialog_comfirm_widget.dart';
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
  FinanceModel? _financeModel;
  List<StoreModel> _listItemSkinShop = [];
  List<StoreModel> _listItemColorShop = [];
  List<StoreModel> _listItemPremiumShop = [];
  int tab = 0;
  String type = "";

  @override
  void initState() {
    super.initState();
    _initData();
    _getUser(Globals.currentUser!.id);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getFinance(Globals.currentUser?.financeId ?? "");
    });
  }

  _initData() {
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
        cast: 5,
        type: "0",
        key: StoreModelEnum.diamond));
  }

  Future<void> _getFinance(String _id) async {
    CollectionReference finance =
        FirebaseFirestore.instance.collection(FirebaseEnum.finance);
    finance.doc(_id).snapshots().listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        setState(() {
          _financeModel = FinanceModel.fromSnapshot(documentSnapshot);
          Globals.financeUser = _financeModel;
        });
      }
    });
  }

  Future<void> _updateStore(String _idUser, List<String> bags) async {
    CollectionReference _user =
        FirebaseFirestore.instance.collection(FirebaseEnum.userdata);

    return _user
        .doc(_idUser)
        .update({'bag': bags})
        .then((value) => NotificationManager.showNotification('Store', 'You have buy success, Thanks!'))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> _updateUseSkinColor(String _idUser, String type) async {
    CollectionReference _user =
        FirebaseFirestore.instance.collection(FirebaseEnum.userdata);

    return _user
        .doc(_idUser)
        .update({type:type == 'useColor' ? Globals.currentUser?.useColor ?? "" : Globals.currentUser?.useSkin ?? ""})
        .then((value) => NotificationManager.showNotification('Store', 'You update skin success, Thanks!'))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> _getUser(String _idUser) async {
    CollectionReference _user =
        FirebaseFirestore.instance.collection(FirebaseEnum.userdata);
    _user.doc(_idUser).snapshots().listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          UserModel user = UserModel.fromSnapshot(documentSnapshot);
          Globals.currentUser = user;
        });
      }
    });
  }

  _buyItem(StoreModel model) {
    if (tab == 2) {
      if (Globals.financeUser!.diamond >= model.cast) {
        AudioManager.playSoundEffect(AudioFile.sound_buy);
        if (model.asset == Assets.img_gift_gacha) {
          final random = Random();
          int i = random.nextInt(100);
          if (i >= 50 && i <= 100) {
            type = "chicken";
            int j = random.nextInt(100);
            if (j >= 50 && j <= 100) {
              type = "chicken_premium";
            }
          } else {
            type = "gold";
          }
          Globals.financeUser!.diamond -= model.cast;
          _updateFinance(Globals.currentUser?.financeId ?? "",
              Globals.financeUser?.diamond ?? 0, "diamond");

          GlobalSetting.shared.showPopupWithContext(
              context,
              DialogRandomGiftWidget(
                type: type,
                ontap: () {
                  AudioManager.playSoundEffect(AudioFile.sound_tap);
                  Navigator.of(context).pop();
                },
              ));
        } else {
          Globals.financeUser!.diamond -= model.cast;
          _updateFinance(Globals.currentUser?.financeId ?? "",
              Globals.financeUser?.diamond ?? 0, "diamond");

          Globals.currentUser!.bags.add(model.id);

          _updateStore(Globals.currentUser!.id, Globals.currentUser!.bags);
        }
      } else {
        GlobalSetting.shared.showPopupWithContext(
            context,
            CustomDialogWithTitleButtonWidget(
              title: "Please find more diamonds to purchase this item!",
              ontap: () {
                Navigator.of(context).pop();
              },
            ));
      }
    } else {
      if ((Globals.financeUser!.gold >= model.cast)) {
        AudioManager.playSoundEffect(AudioFile.sound_buy);
        Globals.financeUser!.gold -= model.cast;
        _updateFinance(Globals.currentUser?.financeId ?? "",
            Globals.financeUser?.gold ?? 0, "gold");
        Globals.currentUser!.bags.add(model.id);
        _updateStore(Globals.currentUser!.id, Globals.currentUser!.bags);
      } else {
        GlobalSetting.shared.showPopupWithContext(
            context,
            CustomDialogWithTitleButtonWidget(
              title: "Please find more gold to purchase this item!",
              ontap: () {
                Navigator.of(context).pop();
              },
            ));
      }
    }
  }

  Future<void> _updateFinance(String _id, int diamond, String type) async {
    CollectionReference _finance =
        FirebaseFirestore.instance.collection(FirebaseEnum.finance);

    return _finance
        .doc(_id)
        .update({type: diamond})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Widget _listTabUnSelect() {
    return Positioned(
        top: AppSizes.maxHeight * 0.12,
        right: 0,
        left: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (tab != 0)
                ? ScalableButton(
                    onTap: () {
                      AudioManager.playSoundEffect(AudioFile.sound_tap);
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
                          fit: BoxFit.fill,
                        ),
                        StrokeTextWidget(
                          text: "Skin",
                          size: 13,
                        )
                      ],
                    ),
                  )
                : Container(width: (AppSizes.maxWidth * 0.7) / 3),
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
                          fit: BoxFit.cover,
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
                          fit: BoxFit.cover,
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
        top: AppSizes.maxHeight > 850
            ? -AppSizes.maxHeight * 0.07
            : -AppSizes.maxHeight * 0.075,
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
                          width: (AppSizes.maxWidth * 0.65) / 3,
                          fit: BoxFit.fill,
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
                : Container(width: (AppSizes.maxWidth * 0.5) / 3),
            (tab == 1)
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      ScalableButton(
                        child: Image.asset(
                          Assets.img_tab_button_selected_shop,
                          height: AppSizes.maxHeight * 0.065,
                          width: (AppSizes.maxWidth * 0.65) / 3,
                          fit: BoxFit.fill,
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
                : Container(width: (AppSizes.maxWidth * 0.75) / 3),
            (tab == 2)
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      ScalableButton(
                        child: Image.asset(
                          Assets.img_tab_button_selected_shop,
                          height: AppSizes.maxHeight * 0.065,
                          width: (AppSizes.maxWidth * 0.6) / 3,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: StrokeTextWidget(
                          text: "Diamond",
                          size: AppSizes.maxWidth < 400 ? 12 : 16,
                        ),
                      )
                    ],
                  )
                : Container(width: (AppSizes.maxWidth * 0.52) / 3)
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
                    flex: 5,
                    child: ScalableButton(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return CustomDialogWithTitleButtonWidget(
                                    title: model.desc == "" ? "I'm chicken" : model.desc!,
                                    ontap: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              );
                            });
                      },
                      child: Center(
                          child: Image.asset(
                        model.asset!,
                        fit: BoxFit.contain,
                        height: AppSizes.maxHeight * 0.07,
                        width: (AppSizes.maxWidth * 0.6) / 3,
                      )),
                    )),
                Expanded(
                    flex: 4,
                    child: (Globals.currentUser?.bags.contains(model.id)) ??
                            false
                        ? ScalableButton(
                            onTap: () {
                              String type = "";
                              if (tab == 0) {
                                type = "useSkin";
                                Globals.currentUser?.useSkin = model.id;
                                Globals.currentUser?.useColor = "";
                              } else {
                                type = "useColor";
                                Globals.currentUser?.useColor = model.id;
                                Globals.currentUser?.useSkin = "";
                              }
                              _updateUseSkinColor(
                                  Globals.currentUser!.id, type);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                    child: Image.asset(
                                  (Globals.currentUser?.useColor == model.id ||
                                          Globals.currentUser?.useSkin ==
                                              model.id)
                                      ? Assets.img_bg_item_used
                                      : Assets.img_bg_money_shop,
                                  height: AppSizes.maxHeight * 0.03,
                                  width: (Globals.currentUser?.useColor ==
                                              model.id ||
                                          Globals.currentUser?.useSkin ==
                                              model.id)
                                      ? (AppSizes.maxWidth * 0.7) / 3
                                      : (AppSizes.maxWidth * 0.55) / 3,
                                  fit: BoxFit.contain,
                                )),
                                Center(
                                  child: StrokeTextWidget(
                                    text: tab == 1 || tab == 2
                                        ? Globals.currentUser?.useColor ==
                                                model.id
                                            ? AppLocalizations.text(
                                                LangKey.used)
                                            : AppLocalizations.text(LangKey.use)
                                        : Globals.currentUser?.useSkin ==
                                                model.id
                                            ? AppLocalizations.text(
                                                LangKey.used)
                                            : AppLocalizations.text(
                                                LangKey.use),
                                    size: 12,
                                    colorStroke: tab == 1 || tab == 2
                                        ? Globals.currentUser?.useColor ==
                                                model.id
                                            ? Colors.grey
                                            : Colors.green
                                        : Globals.currentUser?.useSkin ==
                                                model.id
                                            ? Colors.grey
                                            : Colors.green,
                                  ),
                                )
                              ],
                            ),
                          )
                        : ScalableButton(
                            onTap: () {

                              GlobalSetting.shared.showPopupWithContext(
                          context,
                          DialogConfirmWidget(
                            title: "Are you sure you want to buy this item?",
                            agree: () async {
                               Navigator.of(context).pop();
                              _buyItem(model);
                            },
                            cancel: () {
                              Navigator.of(context).pop();
                            },
                          ));
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
                                          text: "${model.cast}",
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
                left: 0,
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
      height: AppSizes.maxHeight * 0.045,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(child: _number("${Globals.financeUser?.gold ?? 0}")),
          _coinNow(),
        ],
      ),
    );
  }

  Widget _diamond() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: AppSizes.maxHeight * 0.045,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(child: _number("${Globals.financeUser?.diamond ?? 0}")),
          _diamondNow(),
        ],
      ),
    );
  }

  Widget _number(String number) {
    return Container(
      height: AppSizes.maxHeight * 0.03,
      width: AppSizes.maxWidth * 0.17,
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
          color: Color(0xFFD13F06), borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        margin: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            color: Color(0xFFB94416), borderRadius: BorderRadius.circular(8.0)),
        alignment: Alignment.center,
        child: Text("$number",
            style: TextStyle(fontSize: 10, color: Colors.white)),
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
      width: AppSizes.maxWidth * 0.077,
      height: AppSizes.maxWidth * 0.077,
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
      width: AppSizes.maxWidth * 0.077,
      height: AppSizes.maxWidth * 0.077,
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
        height: AppSizes.maxHeight > 850
            ? AppSizes.maxHeight * 0.65
            : AppSizes.maxHeight * 0.7,
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
                    height: AppSizes.maxHeight * 0.05,
                    width: AppSizes.maxWidth * 0.116,
                    fit: BoxFit.contain,
                  ),
                )),
            Positioned(
                bottom: AppSizes.maxHeight * 0.65,
                child: StrokeTextWidget(
                  text: AppLocalizations.text(LangKey.shop),
                  size: 32,
                )),
            Positioned(
                bottom: AppSizes.maxHeight > 850 ? 0 : 8,
                child: Row(
                  children: [_coin(), _diamond()],
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
