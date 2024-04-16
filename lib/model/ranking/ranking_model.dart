import 'package:cloud_firestore/cloud_firestore.dart';

class RankingModel {
  String id;
  int PK11;
  int PK22;
  String username;

  RankingModel({required this.id, required this.PK11, required this.PK22, required this.username});

  factory RankingModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return RankingModel(
      id: snapshot.id,
      PK11: data?['PK11'] ?? '',
      PK22: data?['PK22'] ?? '',
      username: data?['username'] ?? '',
    );
  }
}