import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String id;
  late String phoneNumber;
  late String password;
  late String fullName;

  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.password,
    required this.fullName,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return UserModel(
      id: snapshot.id,
      phoneNumber: data?['phoneNumber'] ?? '',
      password: data?['password'] ?? '',
      fullName: data?['fullName'] ?? '',
    );
  }
}