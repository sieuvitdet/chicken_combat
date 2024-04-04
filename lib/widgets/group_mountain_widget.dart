import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:flutter/material.dart';

class Group_Mountain extends StatelessWidget {
  final bool isLeft;
  final double horizontal;
  final int count;
  final Function? onTap;
  final bool isChicken;
  final bool isCactus;
  final bool isStart;
  final bool isMoreWood;
  final bool isChickenLovely;
  final bool isMoreCactus;
  final bool isWood;
  final bool isWoodBlack;
  final bool isFarmer;
  final bool isStorehouse;
  final bool isTruck;
  final double heightMountain;

  Group_Mountain(
      {this.isLeft = false,
      this.horizontal = 16.0,
      this.count = 0,
      this.onTap,
      this.isChicken = false,
      this.isCactus = false,
      this.isStart = false,
      this.isMoreWood = false,
      this.isChickenLovely = false,
      this.isMoreCactus = false,
      this.isWood = false,
      this.isWoodBlack = false,
      this.isFarmer = false,
      this.isStorehouse = false,
      this.isTruck = false,
      this.heightMountain = 0.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      width: AppSizes.maxWidth,
      child: Row(
        mainAxisAlignment:
            isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: onTap as void Function()?,
                    child: Container(
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage(Assets.img_mountain_map),
                        width: AppSizes.maxWidth * 0.42,
                        height: AppSizes.maxHeight * 0.132,
                        // width: AppSizes.maxHeight > 800 ? 174 : 158,
                        // height: heightMountain,
                      ),
                    ),
                  ),
                  if (isCactus) _cactus(),
                  if (isStart) _start(),
                  if (isChickenLovely) _chickenLovely(),
                  if (isMoreWood) _moreWood(),
                  if (isMoreCactus) _moreCactus(),
                  if (isWood) _wood(),
                  if (isChicken) _chicken(),
                  if (isFarmer) _farmer(),
                  if (isWoodBlack) _woodBlack(),
                  if (isStorehouse) _storehouse(),
                  if (isTruck) _truck(),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 4),
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2.0, color: Colors.white)),
                alignment: Alignment.center,
                child: Text(
                  "$count",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              )
            ],
          ),
          Container()
        ],
      ),
    );
  }

  Widget _chicken() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.012,
        left: 0,
        right: 0,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_chicken),
            width: AppSizes.maxWidth * 0.1,
            height: AppSizes.maxHeight * 0.08,
          ),
        ));
  }

  Widget _cactus() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.012,
        left: AppSizes.maxWidth * 0.4 / 3,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_cactus),
            width: AppSizes.maxWidth * 0.4,
            height: AppSizes.maxHeight * 0.08,
          ),
        ));
  }

  Widget _start() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.015,
        right: AppSizes.maxWidth * 0.15 * 1.8,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_start),
            width: AppSizes.maxWidth * 0.15,
            height: AppSizes.maxHeight * 0.06,
          ),
        ));
  }

  Widget _chickenLovely() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.012,
        left: 0,
        right: 0,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_chicken_lovely),
            width: AppSizes.maxWidth * 0.1,
            height: AppSizes.maxHeight * 0.08,
          ),
        ));
  }

  Widget _moreWood() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.025,
        left: 20,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_more_wood),
            width: AppSizes.maxWidth * 0.2,
            height: AppSizes.maxHeight * 0.1,
          ),
        ));
  }

  Widget _moreCactus() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.012,
        right: AppSizes.maxWidth * 0.15 * 1.6,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_more_cactus),
            width: AppSizes.maxWidth * 0.15,
            height: AppSizes.maxHeight * 0.1,
          ),
        ));
  }

  Widget _wood() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.015,
        left: AppSizes.maxWidth * 0.25,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_wood),
            width: AppSizes.maxWidth * 0.12,
            height: AppSizes.maxHeight * 0.05,
          ),
        ));
  }

  Widget _woodBlack() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.012,
        left: AppSizes.maxWidth * 0.255,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_wood_black),
            width: AppSizes.maxWidth * 0.12,
            height: AppSizes.maxHeight * 0.04,
          ),
        ));
  }

  Widget _farmer() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.022,
        left: AppSizes.maxWidth * 0.15,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_farmer),
            width: AppSizes.maxWidth * 0.2,
            height: AppSizes.maxHeight * 0.1,
          ),
        ));
  }

  Widget _storehouse() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.012,
        right: AppSizes.maxWidth * 0.18,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_storehouse),
            width: AppSizes.maxWidth * 0.2,
            height: AppSizes.maxHeight * 0.1,
          ),
        ));
  }

  Widget _truck() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.012,
        left: AppSizes.maxWidth * 0.25,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_truck),
            width: AppSizes.maxWidth * 0.12,
            height: AppSizes.maxHeight * 0.04,
          ),
        ));
  }

}
