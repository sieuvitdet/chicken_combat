import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:flutter/material.dart';

class GroupMountainSea extends StatelessWidget {
  final bool isLeft;
  final double horizontal;
  final int count;
  final Function? onTap;
  final double heightMountain;

  GroupMountainSea(
      {this.isLeft = false,
      this.horizontal = 16.0,
      this.count = 0,
      this.onTap,
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
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage(Assets.img_mountain_sea),
                      width: AppSizes.maxWidth * 0.5,
                      height: heightMountain ,
                    ),
                  ),
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


  Widget _start() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.015,
        right: AppSizes.maxWidth * 0.34,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_start),
            width: AppSizes.maxWidth * 0.15,
            height: AppSizes.maxHeight * 0.06,
          ),
        ));
  }



  Widget _storehouse() {
    return Positioned(
        bottom:heightMountain - AppSizes.maxHeight * 0.035,
        right: AppSizes.maxWidth * 0.3,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_storehouse),
            width: AppSizes.maxWidth * 0.16,
            height: AppSizes.maxHeight * 0.12,
          ),
        ));
  }

  Widget _truck() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.01,
        left: AppSizes.maxWidth * 0.21,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_truck),
            width: AppSizes.maxWidth * 0.12,
            height: AppSizes.maxHeight * 0.03,
          ),
        ));
  }

  Widget _smallTruck() {
    return Positioned(
        bottom:heightMountain - AppSizes.maxHeight * 0.012,
        right: AppSizes.maxWidth * 0.18,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_truck_small),
            width: AppSizes.maxWidth * 0.2,
            height: AppSizes.maxHeight * 0.06,
          ),
        ));
  }

  Widget _treeRight() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.018,
        left: AppSizes.maxWidth * 0.25,
        child: Container(
          child: Image(
            fit: BoxFit.cover,
            image: AssetImage(Assets.img_tree),
            width: AppSizes.maxWidth * 0.2,
            height: AppSizes.maxHeight * 0.12,
          ),
        ));
  }

  Widget _treeLeft() {
    return Positioned(
        bottom: heightMountain - AppSizes.maxHeight * 0.015,
        right: AppSizes.maxWidth * 0.3,
        child: Container(
          child: Image(
            fit: BoxFit.cover,
            image: AssetImage(Assets.img_tree),
            width: AppSizes.maxWidth * 0.2,
            height: AppSizes.maxHeight * 0.12,
          ),
        ));
  }

  Widget _bush() {
    return Positioned(
        bottom: heightMountain- AppSizes.maxHeight * 0.026,
        left: AppSizes.maxWidth * 0.35,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_bush),
            width: AppSizes.maxWidth * 0.08,
            height: AppSizes.maxHeight * 0.05,
          ),
        ));
  }

  Widget _cloud() {
    return Positioned(
        bottom: heightMountain*1.5,
        right: AppSizes.maxWidth * 0.3,
        child: Container(
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(Assets.img_cloud_big),
            width: AppSizes.maxWidth * 0.12,
            height: AppSizes.maxHeight * 0.04,
          ),
        ));
  }

  Widget _farmerWaterTheTree() {
    return Positioned(
        bottom: heightMountain- AppSizes.maxHeight * 0.018,
        right: AppSizes.maxWidth * 0.2,
        child: Container(
          child: Image(
            fit: BoxFit.cover,
            image: AssetImage(Assets.img_farmer_water_the_tree),
            width: AppSizes.maxWidth * 0.1,
            height: AppSizes.maxHeight * 0.08,
          ),
        ));
  }
  
}
