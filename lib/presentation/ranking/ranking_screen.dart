import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/widgets/custom_button_image_color_widget.dart';
import 'package:chicken_combat/widgets/dialog_reward_widget.dart';
import 'package:chicken_combat/widgets/stroke_text_widget.dart';
import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  int tab = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  Widget _listTabUnSelect() {
    return Positioned(
        top: AppSizes.maxHeight * 0.1,
        right: 0,
        left: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
                          width: (AppSizes.maxWidth * 0.5) / 2,
                          fit: BoxFit.contain,
                        ),
                        StrokeTextWidget(
                          text: "1 vs 1",
                          size: 13,
                        )
                      ],
                    ),
                  )
                : Container(width: (AppSizes.maxWidth * 0.5) / 2),
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
                          width: (AppSizes.maxWidth * 0.5) / 2,
                          fit: BoxFit.contain,
                        ),
                        StrokeTextWidget(
                          text: "2 vs 2",
                          size: 13,
                        )
                      ],
                    ),
                  )
                : Container(width: (AppSizes.maxWidth * 0.5) / 2),
          ],
        ));
  }

  Widget _listTabSelected() {
    return Positioned(
        top: -AppSizes.maxHeight * 0.082,
        right: 0,
        left: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (tab == 0)
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      ScalableButton(
                        child: Image.asset(
                          Assets.img_tab_button_selected_shop,
                          width: (AppSizes.maxWidth * 0.5) / 2,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: StrokeTextWidget(
                          text: "1 vs 1",
                          size: AppSizes.maxWidth < 350 ? 12 : 16,
                        ),
                      )
                    ],
                  )
                : Container(width: (AppSizes.maxWidth * 0.46) / 2),
            (tab == 1)
                ? Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ScalableButton(
                          child: Image.asset(
                            Assets.img_tab_button_selected_shop,
                            width: (AppSizes.maxWidth * 0.5) / 2,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: StrokeTextWidget(
                            text: "2 vs 2",
                            size: AppSizes.maxWidth < 350 ? 12 : 16,
                          ),
                        )
                      ],
                    ),
                  )
                : Container(width: (AppSizes.maxWidth * 0.42) / 2),
          ],
        ));
  }

  Widget _item(int stt, {int score = 0, int tab = 0}) {
    return Container(
      width: AppSizes.maxWidth * 0.85,
      height: AppSizes.maxHeight * 0.07,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image(
            image: AssetImage(Assets.img_item_ranking),
            fit: BoxFit.fill,
            width: AppSizes.maxWidth * 0.835,
            height: AppSizes.maxHeight * 0.08,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (stt == 0)
                              Image(
                                image: AssetImage(Assets.ic_rank_gold),
                                width: AppSizes.maxHeight * 0.035,
                                height: AppSizes.maxHeight * 0.06,
                                fit: BoxFit.contain,
                              ),
                            if (stt == 1)
                              Image(
                                image: AssetImage(Assets.ic_rank_silver),
                                width: AppSizes.maxHeight * 0.035,
                                height: AppSizes.maxHeight * 0.06,
                                fit: BoxFit.contain,
                              ),
                            if (stt == 2)
                              Image(
                                image: AssetImage(Assets.ic_rank_bronze),
                                width: AppSizes.maxHeight * 0.035,
                                height: AppSizes.maxHeight * 0.06,
                                fit: BoxFit.contain,
                              ),
                            if (stt > 2)
                              Container(
                                width: AppSizes.maxHeight * 0.035,
                                child: Center(
                                  child: StrokeTextWidget(
                                      text: "${stt + 1}",
                                      size: 16,
                                      colorStroke: Color(0xFF157BAC)),
                                ),
                              ),
                            SizedBox(height: AppSizes.maxHeight * 0.01)
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StrokeTextWidget(
                                  text: "LocDy",
                                  size: 12,
                                  colorStroke: Color(0xFF8F1E23)),
                              StrokeTextWidget(
                                  text: "level 10",
                                  size: 11,
                                  colorStroke: Color(0xFF7F613E)),
                              SizedBox(height: AppSizes.maxHeight * 0.01)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Score",
                        style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        // width: AppSizes.maxWidth * 0.186,
                        height: AppSizes.maxHeight * 0.028,
                        decoration: BoxDecoration(
                            color: Color(0xFF195EC8),
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 1,
                                offset: Offset(0, 1), // Shadow position
                              ),
                              BoxShadow(
                                color: Colors.blue,
                                blurRadius: 4,
                                offset: Offset(2, 0), // Shadow position
                              )
                            ]),
                        child: Center(
                          child: StrokeTextWidget(
                              text: "50.135",
                              size: 12,
                              colorStroke: Color(0xFF157BAC)),
                        ),
                      ),
                      Container(height: AppSizes.maxHeight * 0.01)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _info() {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(Assets.img_avatar),
                  width: AppSizes.maxHeight * 0.0558,
                  height: AppSizes.maxHeight * 0.0558,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StrokeTextWidget(
                          text: "LocDy",
                          size: AppSizes.maxWidth < 350 ? 10 : 13,
                          colorStroke: Color(0xFF8F1E23)),
                      StrokeTextWidget(
                          text: "level 1000",
                          size: AppSizes.maxWidth < 350 ? 10 : 13,
                          colorStroke: Color(0xFF7F613E)),
                      StrokeTextWidget(
                          text: "111",
                          size: AppSizes.maxWidth < 350 ? 10 : 13,
                          colorStroke: Color(0xFF157BAC))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Score",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              // width: AppSizes.maxWidth * 0.186,
              height: AppSizes.maxHeight * 0.028,
              decoration: BoxDecoration(
                  color: Color(0xFF195EC8),
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 1,
                      offset: Offset(0, 1), // Shadow position
                    ),
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 4,
                      offset: Offset(2, 0), // Shadow position
                    )
                  ]),
              child: Center(
                child: StrokeTextWidget(
                    text: "50.135",
                    size: AppSizes.maxWidth < 350 ? 13 : 16,
                    colorStroke: Color(0xFF157BAC)),
              ),
            ),
          ],
        )
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
        width: AppSizes.maxWidth * 0.92,
        height: AppSizes.maxHeight * 0.7,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            _listTabUnSelect(),
            Container(
              width: AppSizes.maxWidth * 0.85,
              margin: EdgeInsets.only(
                  top: AppSizes.maxHeight * 0.15,
                  bottom: AppSizes.maxHeight * 0.045),
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xFF157BAC),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _listTabSelected(),
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: 15,
                          itemBuilder: (BuildContext context, int index) {
                            return _item(index);
                          },
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.maxHeight * 0.032,
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                top: -5,
                child: Image.asset(
                  Assets.img_banner_ranking,
                  // height: 72,
                  width: AppSizes.maxWidth * 0.6,
                  fit: BoxFit.contain,
                )),
            Positioned(
                top: -AppSizes.maxWidth * 0.038,
                right: -AppSizes.maxWidth * 0.03,
                child: ScalableButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    Assets.ic_close_popup,
                    height: AppSizes.maxWidth * 0.116,
                    width: AppSizes.maxWidth * 0.116,
                    fit: BoxFit.fill,
                  ),
                )),
            Positioned(
                bottom: AppSizes.maxHeight * 0.016,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: AppSizes.maxHeight * 0.0825,
                  width: AppSizes.maxWidth * 0.88,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(34.0),
                          bottomRight: Radius.circular(34.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 6), // Shadow position
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xFF1594DA),
                          Color(0xFF78D7E9),
                        ],
                      )),
                  child: _info(),
                )),

            Positioned(
                top: AppSizes.maxHeight * 0.11,
                right: AppSizes.maxWidth * 0.038,
                child: ScalableButton(
                  onTap: () {
                    //  Navigator.of(context).pop();
                    _showDialogReward();
                  },
                  child: Image.asset(
                    Assets.img_treasure,
                    width: AppSizes.maxWidth * 0.08,
                    fit: BoxFit.fill,
                  ),
                )),

            // Positioned(
            // top: AppSizes.maxHeight * 0.085,
            // right: AppSizes.maxWidth * 0.01,
            // child: ScalableButton(
            //   onTap: () {

            //   },
            //   child: Image.asset(
            //     Assets.img_reward,
            //     height: AppSizes.maxWidth * 0.18,
            //     width: AppSizes.maxWidth * 0.18,
            //     fit: BoxFit.fill,
            //   ),
            // ))
          ],
        ),
      ),
    );
  }

  void _showDialogReward() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return DialogRewardWidget();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.transparent, body: _buildContent());
  }
}
