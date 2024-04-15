import 'package:cloud_firestore/cloud_firestore.dart';

class RankingModel {
  int PK11;
  int PK22;

  RankingModel({required this.PK11, required this.PK22});

  factory RankingModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return RankingModel(
      PK11: data?['PK11'] ?? '',
      PK22: data?['PK22'] ?? '',
    );
  }
}