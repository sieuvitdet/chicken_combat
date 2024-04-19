import 'package:chicken_combat/model/course/ask_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  String id;
  Timestamp timestamp;
  int type;
  String status;
  List<UserInfoRoom> users;
  List<AskModel> asks;

  RoomModel({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.status,
    required this.users,
    required this.asks,
  });

  factory RoomModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    List<UserInfoRoom> users = (data?['user'] as List<dynamic>? ?? []).map((userMap) {
      return UserInfoRoom.fromMap(userMap as Map<String, dynamic>);
    }).toList();
    List<AskModel> asks = (data?['asks'] as List<dynamic>? ?? []).map((askMap) {
      return AskModel.fromMap(askMap as Map<String, dynamic>); // Assuming AskModel has a similar structure
    }).toList();

    return RoomModel(
      id: snapshot.id,
      timestamp: data?['timestamp'] as Timestamp,
      type: data?['type'] as int? ?? 0,
      status: data?['status'] ?? '',
      users: users,
      asks: asks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp,
      'type': type,
      'status': status,
      'user': users.map((user) => user.toJson()).toList(),
      'asks': asks.map((ask) => ask.toJson()).toList(),
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
      'usecolor': usecolor,
    };
  }
}

class RoomCheckResult {
  final RoomModel room;
  final bool isNew;

  RoomCheckResult({required this.room, required this.isNew});
}