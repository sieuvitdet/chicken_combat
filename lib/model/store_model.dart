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
