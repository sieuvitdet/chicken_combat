import 'package:chicken_combat/model/course/ask_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/utils/utils.dart';
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
      status: data?['status'] as String? ?? '',
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

  Future<void> updateUsersRemove(List<UserInfoRoom> list) async {
    try {
      List<UserInfoRoom> updatedUsers = list.where((element) => element.userId != Globals.currentUser?.id).toList();
      await FirebaseFirestore.instance.collection(FirebaseEnum.room).doc(id).update({
        'user': updatedUsers.map((user) => user.toJson()).toList(),
      });
    } catch (e) {
      print('Error updating users: $e');
    }
  }

    Future<void> updateUsersReady(List<UserInfoRoom> list) async {
      try {
        List<UserInfoRoom> updatedUsers = list.map((element) {
          if (element.userId == Globals.currentUser?.id) {
            return UserInfoRoom(
              userId: element.userId,
              username: element.username,
              usecolor: element.usecolor,
              ready: true,
            );
          } else {
            return element;
          }
        }).toList();
        await FirebaseFirestore.instance.collection(FirebaseEnum.room).doc(id).update({
          'user': updatedUsers.map((user) => user.toJson()).toList(),
        });
      } catch (e) {
        print('Error updating users: $e');
      }
    }

  // Future<void> updateRoomStatus(StatusBattle newStatus) async {
  //   try {
  //     await FirebaseFirestore.instance.collection(FirebaseEnum.room).doc(id).update({
  //       'status': newStatus.toJson(),
  //     });
  //     print("Status updated successfully in room ID: $id");
  //   } catch (e) {
  //     print("Error updating status: $e");
  //     throw Exception("Failed to update status in Firestore");
  //   }
  // }
}

class UserInfoRoom {
  String userId;
  String username;
  String usecolor;
  bool ready;

  UserInfoRoom({required this.userId, required this.username, required this.usecolor, required this.ready});

  static UserInfoRoom fromMap(Map<String, dynamic> map) {
    return UserInfoRoom(
      userId: map['userid'] as String,
      username: map['username'] as String,
      usecolor: map['usecolor'] as String,
      ready: map['ready'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userId,
      'username': username,
      'usecolor': usecolor,
      'ready': ready,
    };
  }
}

class RoomCheckResult {
  final RoomModel room;
  final bool isNew;

  RoomCheckResult({required this.room, required this.isNew});
}

class StatusBattle {
  String id;
  int askPosition;
  String userid;
  bool correct;

  StatusBattle({required this.id,required this.askPosition,required this.userid, required this.correct});

  factory StatusBattle.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return StatusBattle(
      id: snapshot.id,
      askPosition: data?['askPosition'] as int? ?? -1,
      userid: data?['userid'] as String? ?? '',
      correct: data?['correct'] as bool? ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'askPosition': askPosition,
      'userid': userid,
      'correct': correct,
    };
  }
}