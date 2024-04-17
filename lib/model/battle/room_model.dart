import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  String id;
  Timestamp timestamp;
  int type;
  List<UserInfoRoom> users;

  RoomModel({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.users,
  });

  factory RoomModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    List<UserInfoRoom> users = (data?['user'] as List<dynamic>? ?? []).map((userMap) {
      return UserInfoRoom.fromMap(userMap as Map<String, dynamic>);
    }).toList();

    return RoomModel(
      id: snapshot.id,
      timestamp: data?['timestamp'] as Timestamp,
      type: data?['type'] as int? ?? 0,
      users: users,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp,
      'type': type,
      'user': users.map((user) => user.toJson()).toList(),
    };
  }

  Future<void> updateUsers() async {
    await FirebaseFirestore.instance.collection(FirebaseEnum.room).doc(id).update({
      'user': users.map((user) => user.toJson()).toList(),
    });
  }
}

class UserInfoRoom {
  String userId;
  String username;
  String usecolor;

  UserInfoRoom({required this.userId, required this.username, required this.usecolor});

  static UserInfoRoom fromMap(Map<String, dynamic> map) {
    return UserInfoRoom(
      userId: map['userid'] as String,
      username: map['username'] as String,
      usecolor: map['usecolor'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userId,
      'username': username,
    };
  }
}

class RoomCheckResult {
  final RoomModel room;
  final bool isNew;

  RoomCheckResult({required this.room, required this.isNew});
}