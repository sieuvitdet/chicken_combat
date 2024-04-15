import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:flutter/material.dart';

class GroupMountainSnow extends StatelessWidget {
  final bool isLeft;
  final double horizontal;
  final int count;
  final Function? onTap;
  final double heightMountain;
  final bool snowMan;
  final bool isStart;

  GroupMountainSnow(
      {this.isLeft = false,
      this.horizontal = 16.0,
      this.count = 0,
      this.onTap,
      this.heightMountain = 0.0,
      this.snowMan = false,
      this.isStart = false});

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
                  if (isStart) _start(),
                  if (snowMan) _snowMan(),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: onTap as void Function()?,
                    child: Image(
                      fit: BoxFit.fill,
                      image: AssetImage(Assets.img_mountain_snow),
                      width: AppSizes.maxWidth * 0.5,
                    ),
                  ),
                ],
              ),
              Container(
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

  Widget _snowMan() {
    return Positioned(
        bottom: heightMountain + (AppSizes.maxHeight > 850 ? AppSizes.maxHeight * 0.018 : AppSizes.maxHeight * 0.04),
        right: AppSizes.maxWidth * 0.02,
        child: Container(
          child: Image(
            fit: BoxFit.fill,
            image: AssetImage(Assets.img_snowman),
            width: AppSizes.maxWidth * 0.13,
          ),
        ));
  }

  Widget _start() {
    return Positioned(
        bottom: heightMountain + (AppSizes.maxHeight > 850 ?AppSizes.maxHeight * 0.022 : AppSizes.maxHeight * 0.06),
        right: AppSizes.maxWidth * 0.34,
        child: Container(
          child: Image(
            fit: BoxFit.fill,
            image: AssetImage(Assets.img_start),
            width: AppSizes.maxWidth * 0.15,
            // height: AppSizes.maxHeight * 0.06,
          ),
        ));
  }
}
