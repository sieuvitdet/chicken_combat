import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String id;
  late String username;
  late String password;
  late String level;
  late String financeId;
  late String avatar;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.level,
    required this.financeId,
    required this.avatar,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return UserModel(
      id: snapshot.id,
      username: data?['username'] ?? '',
      password: data?['password'] ?? '',
      level: data?['level'] ?? '',
      financeId: data?['financeId'] ?? '',
      avatar: data?['avatar'] ?? '',
    );
  }
}