import 'package:cloud_firestore/cloud_firestore.dart';

class FinanceModel {
  String id;
  String gold;
  String diamond;
  String uuid;

  FinanceModel({
    required this.id,
    required this.gold,
    required this.diamond,
    required this.uuid,
  });
  factory FinanceModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return FinanceModel(
      id: snapshot.id,
      gold: data?['gold'] ?? '',
      diamond: data?['diamond'] ?? '',
      uuid: data?['userId'] ?? '',
    );
  }
}
