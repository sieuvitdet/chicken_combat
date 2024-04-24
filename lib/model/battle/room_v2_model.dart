import 'package:chicken_combat/model/course/ask_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomV2Model {
  String id;
  Timestamp timestamp;
  int type;
  String status;
  List<UserInfoRoomV2> users;
  List<AskModel> asks;

  RoomV2Model({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.status,
    required this.users,
    required this.asks,
  });

  factory RoomV2Model.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    List<UserInfoRoomV2> users = (data?['user'] as List<dynamic>? ?? []).map((userMap) {
      return UserInfoRoomV2.fromMap(userMap as Map<String, dynamic>);
    }).toList();
    List<AskModel> asks = (data?['asks'] as List<dynamic>? ?? []).map((askMap) {
      return AskModel.fromMap(askMap as Map<String, dynamic>); // Assuming AskModel has a similar structure
    }).toList();

    return RoomV2Model(
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

  Future<void> updateUsersRemove(List<UserInfoRoomV2> list) async {
    try {
      List<UserInfoRoomV2> updatedUsers = list.where((element) => element.userId != Globals.currentUser?.id).toList();
      await FirebaseFirestore.instance.collection(FirebaseEnum.room).doc(id).update({
        'user': updatedUsers.map((user) => user.toJson()).toList(),
      });
    } catch (e) {
      print('Error updating users: $e');
    }
  }

  Future<void> updateUsersReady(List<UserInfoRoomV2> list) async {
    try {
      List<UserInfoRoomV2> updatedUsers = list.map((element) {
        if (element.userId == Globals.currentUser?.id) {
          return UserInfoRoomV2(
            userId: element.userId,
            username: element.username,
            usecolor: element.usecolor,
            team: element.team,
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

}

class UserInfoRoomV2 {
  String userId;
  String username;
  String usecolor;
  int team;
  bool ready;

  UserInfoRoomV2({required this.userId, required this.username, required this.usecolor, required this.team, required this.ready});

  static UserInfoRoomV2 fromMap(Map<String, dynamic> map) {
    return UserInfoRoomV2(
      userId: map['userid'] as String,
      username: map['username'] as String,
      usecolor: map['usecolor'] as String,
      team: map['team'] as int,
      ready: map['ready'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userId,
      'username': username,
      'usecolor': usecolor,
      'team': team,
      'ready': ready,
    };
  }
}

class RoomCheckResult {
  final RoomV2Model room;
  final bool isNew;

  RoomCheckResult({required this.room, required this.isNew});
}

class StatusBattleV2 {
  String id;
  int askPosition;
  String userid;
  int team;
  bool correct;

  StatusBattleV2({required this.id,required this.askPosition,required this.userid,required this.team, required this.correct});

  factory StatusBattleV2.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return StatusBattleV2(
        id: snapshot.id,
        askPosition: data?['askPosition'] as int? ?? -1,
        userid: data?['userid'] as String? ?? '',
        team: data?['team'] as int? ?? 0,
        correct: data?['correct'] as bool? ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'askPosition': askPosition,
      'userid': userid,
      'team': team,
      'correct': correct,
    };
  }
}