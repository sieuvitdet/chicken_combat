import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/langkey.dart';
import 'package:chicken_combat/common/localization/app_localization.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/shopping/shopping_screen.dart';
import 'package:chicken_combat/utils/audio_manager.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/dialog_rules_reward_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';

class DialogRewardWidget extends StatefulWidget {
  const DialogRewardWidget({super.key});

  @override
  State<DialogRewardWidget> createState() => _DialogRewardWidgetState();
}

class _DialogRewardWidgetState extends State<DialogRewardWidget> {
  List<ItemShopModel> _listItemRewardRoutine = [];
  List<ItemShopModel> _listItemRewardMonthly = [];
  int tab = 0;

  @override
  void initState() {
    super.initState();
    //Routine
    _listItemRewardRoutine.add(ItemShopModel(asset: Assets.img_chicken));
    _listItemRewardRoutine.add(ItemShopModel(asset: Assets.img_chicken_green));
    _listItemRewardRoutine.add(ItemShopModel(
      asset: Assets.img_chicken_black,
    ));
    _listItemRewardRoutine.add(ItemShopModel(
      asset: Assets.img_chicken_blue,
    ));
    _listItemRewardRoutine.add(ItemShopModel(
      asset: Assets.img_chicken_red,
    ));
    _listItemRewardRoutine.add(ItemShopModel(
      asset: Assets.img_chicken_white_0,
    ));
    _listItemRewardRoutine.add(ItemShopModel(asset: Assets.img_chicken_green));
    _listItemRewardRoutine.add(ItemShopModel(asset: Assets.img_chicken_brown));
//Monthly
    _listItemRewardMonthly.add(ItemShopModel(asset: Assets.img_hat_scholar));
    _listItemRewardMonthly.add(ItemShopModel(asset: Assets.img_breath_machine));
    _listItemRewardMonthly.add(ItemShopModel(asset: Assets.img_mask));

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  Widget _item({String? asset}) {
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
                    child: ScalableButton(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                              child: Image.asset(
                            Assets.img_button_coin_shop,
                            width: 66,
                            fit: BoxFit.fill,
                          )),
                          StrokeTextWidget(
                            text: "Nhận",
                            size: AppSizes.maxWidth < 350 ? 10.0 : 13.0,
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listReward() {
    return ListView(
      children: [
        Center(
          child: Container(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0, left: 8.0),
                      child: StrokeTextWidget(
                          text: AppLocalizations.text(LangKey.daily_gift),
                          size: AppSizes.maxWidth < 350 ? 13 : 16),
                    ),
                    Wrap(
                      runSpacing: 8,
                      children: List.generate(
                        _listItemRewardRoutine.length,
                        (index) {
                          return _item(
                            asset: _listItemRewardRoutine[index].asset,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0, left: 8.0),
                      child: StrokeTextWidget(
                          text: AppLocalizations.text(LangKey.monthly_gift),
                          size: AppSizes.maxWidth < 350 ? 13 : 16),
                    ),
                    Wrap(
                      runSpacing: 8,
                      children: List.generate(
                        _listItemRewardMonthly.length,
                        (index) {
                          return _item(
                            asset: _listItemRewardMonthly[index].asset,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizes.maxHeight * 0.02,
                )
              ],
            ),
          ),
        ),
      ],
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
            Container(
              width: AppSizes.maxWidth * 0.8,
              margin: EdgeInsets.symmetric(vertical: AppSizes.maxHeight * 0.03),
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xFF157BAC),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: _listReward(),
            ),
            Positioned(
                top: -AppSizes.maxHeight * 0.054,
                child: Image.asset(
                  Assets.img_banner_reward,
                  height: AppSizes.maxHeight * 0.054,
                  width: AppSizes.maxWidth / 1.2,
                  fit: BoxFit.fitWidth,
                )),
            Positioned(
                top: -16,
                right: -16,
                child: ScalableButton(
                  onTap: () {
                    AudioManager.playSoundEffect(AudioFile.sound_tap);
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
                bottom: AppSizes.maxWidth * 0.07,
                right: AppSizes.maxWidth * 0.07,
                child: ScalableButton(
                  onTap: () {
                    _showDialogRule();
                  },
                  child: Container(
                    height: AppSizes.maxWidth * 0.1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(Assets.img_redblur_circle),
                        StrokeTextWidget(
                          text: "?",
                           size: AppSizes.maxWidth < 350 ? 12 : 16,
                          colorStroke: Color(0xFFD18A5A),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void _showDialogRule() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return DialogRulesRewardWidget();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.transparent, body: _buildContent());
  }
}
