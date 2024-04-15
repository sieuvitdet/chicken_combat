import 'package:chicken_combat/common/assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModelEnum {
  static String color = "CO";
  static String skin = "SK";
  static String diamond = "DI";
}

class StoreModel {
  bool isHotSale;
  String cast;
  String key;
  String type;
  String id;
  String? asset;

  StoreModel(
      {required this.id,
      required this.isHotSale,
      required this.cast,
      required this.key,
      required this.type,
      this.asset});

  factory StoreModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return StoreModel(
        id: snapshot.id,
        isHotSale: data?['isHotSale'] ?? '',
        cast: data?['cast'] ?? '',
        key: data?['key'] ?? '',
        type: data?['type'] ?? '',
        asset: ExtendedAssets.getImageByCode(snapshot.id));
  }
}

class ExtendedAssets extends Assets {
  static String getImageByCode(String code) {
    switch (code) {
      case "CO01":
        return Assets.img_chicken;
      case "CO02":
        return Assets.img_chicken_green;
      case "CO03":
        return Assets.img_chicken_black;
      case "CO04":
        return Assets.img_chicken_blue;
      case "CO05":
        return Assets.img_chicken_red;
      case "CO06":
        return Assets.img_chicken_white_0;
      case "CO07":
        return Assets.img_chicken_green;
      case "CO08":
        return Assets.img_chicken_brown;
      case "SK01":
        return Assets.img_hat_scholar;
      case "SK02":
        return Assets.img_breath_machine;
      case "SK03":
        return Assets.img_mask;
      case "DI01":
        return Assets.gif_chicken_brown;
      case "DI02":
        return Assets.img_chicken_bear_white_premium;
      case "DI03":
        return Assets.img_chicken_lovely;
      case "DI04":
        return Assets.img_chicken_brown_circleface_premium;
      default:
    }
    return Assets.img_chicken;
  }
}
