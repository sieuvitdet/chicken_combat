import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String id;
  late String username;
  late String password;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return UserModel(
      id: snapshot.id,
      username: data?['username'] ?? '',
      password: data?['password'] ?? '',
    );
  }
}