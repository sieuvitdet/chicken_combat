import 'package:chicken_combat/common/assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModelEnum {
  static String color = "CO";
  static String skin = "SK";
  static String diamond = "DI";
}

class StoreModel {
  bool isHotSale;
  int cast;
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
        asset: ExtendedAssets.getAssetByCode(snapshot.id));
  }
}

class ExtendedAssets extends Assets {
  static String getAssetByCode(String code) {
  Map<String, String> codeToAssetMap = {
    "CO01": Assets.img_chicken,
    "CO02": Assets.img_chicken_green,
    "CO03": Assets.img_chicken_black,
    "CO04": Assets.img_chicken_blue,
    "CO05": Assets.img_chicken_red,
    "CO06": Assets.img_chicken_white_0,
    "CO08": Assets.img_chicken_brown,
    "SK01": Assets.img_hat_scholar,
    "SK02": Assets.img_breath_machine,
    "SK03": Assets.img_mask,
    "DI01": Assets.gif_chicken_brown,
    "DI02": Assets.img_chicken_bear_white_premium,
    "DI03": Assets.img_chicken_lovely,
    "DI04": Assets.img_chicken_brown_circleface_premium,
  };

  return codeToAssetMap[code] ?? Assets.img_chicken; // Trả về tên asset tương ứng hoặc asset mặc định nếu không tìm thấy
}

  static String getCodeByAsset(String asset) {
    Map<String, String> assetToCodeMap = {
      Assets.img_chicken: "CO01",
      Assets.img_chicken_green: "CO02",
      Assets.img_chicken_black: "CO03",
      Assets.img_chicken_blue: "CO04",
      Assets.img_chicken_red: "CO05",
      Assets.img_chicken_white_0: "CO06",
      Assets.img_chicken_brown: "CO08",
      Assets.img_hat_scholar: "SK01",
      Assets.img_breath_machine: "SK02",
      Assets.img_mask: "SK03",
      Assets.gif_chicken_brown: "DI01",
      Assets.img_chicken_bear_white_premium: "DI02",
      Assets.img_chicken_lovely: "DI03",
      Assets.img_chicken_brown_circleface_premium: "DI04",
    };
    return assetToCodeMap[asset] ?? "CO01";
  }
}
