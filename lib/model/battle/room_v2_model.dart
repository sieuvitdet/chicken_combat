import 'package:chicken_combat/model/course/ask_examination_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomV2Model {
  String id;
  Timestamp timestamp;
  int type;
  String status;
  List<UserInfoRoomV2> users;
  List<AskExaminationModel> asks;

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
    List<AskExaminationModel> asks = (data?['asks'] as List<dynamic>? ?? []).map((askMap) {
      return AskExaminationModel.fromMap(askMap as Map<String, dynamic>);
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

  void assignTeams() {
    int teamSize = users.length;
    for (int i = 0; i < teamSize; i++) {
      users[i].team = (i == 0 || i == 1) ? 1 : 2;
    }
    if (teamSize == 1) {
      users[0].team = 1;
    }
  }

  Future<void> updateUserTeams() async {
    try {
      assignTeams();
      await FirebaseFirestore.instance.collection(FirebaseEnum.roomV2).doc(id).update({
        'user': users.map((user) => user.toJson()).toList(),
      });
    } catch (e) {
      print('Error updating user teams: $e');
    }
  }

  Future<void> removeUser(String userId) async {
    try {
      users = users.where((user) => user.userId != userId).toList();
      assignTeams();
      await FirebaseFirestore.instance.collection(FirebaseEnum.roomV2).doc(id).update({
        'user': users.map((user) => user.toJson()).toList(),
      });
    } catch (e) {
      print('Error removing user: $e');
    }
  }

  Future<void> updateUsers() async {
    await FirebaseFirestore.instance.collection(FirebaseEnum.roomV2).doc(id).update({
      'user': users.map((user) => user.toJson()).toList(),
    }).catchError((error) {
      print("Failed to update users: $error");
    });
  }

  Future<void> updateUsersRemove(List<UserInfoRoomV2> list) async {
    try {
      List<UserInfoRoomV2> updatedUsers = list.where((element) => element.userId != Globals.currentUser?.id).toList();
      await FirebaseFirestore.instance.collection(FirebaseEnum.roomV2).doc(id).update({
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
      await FirebaseFirestore.instance.collection(FirebaseEnum.roomV2).doc(id).update({
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

class RoomV2CheckResult {
  final RoomV2Model room;
  final bool isNew;

  RoomV2CheckResult({required this.room, required this.isNew});
}