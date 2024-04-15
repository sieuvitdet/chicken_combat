import 'package:chicken_combat/utils/string_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'maps/course_map_model.dart';
import 'maps/user_map_model.dart';

class UserModel {
   String id;
   String username;
   String password;
   String level;
   String financeId;
   String avatar;
   String useColor;
   String useSkin;
   List<dynamic> bag;
   List<dynamic> courseMaps;
   List<String> bags;
   CourseMapsModel courseMapModel;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.level,
    required this.financeId,
    required this.avatar,
    required this.useColor,
    required this.useSkin,
    required this.bag,
    required this.courseMaps,
  }) :  bags = StringUtils.convertDynamicListToStringList(bag),
        courseMapModel = CourseMapsModel.fromUserMapModelList(UserMapModel.convertDynamicListToUserMapModelList(courseMaps));

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return UserModel(
      id: snapshot.id,
      username: data?['username'] ?? '',
      password: data?['password'] ?? '',
      level: data?['level'] ?? '',
      financeId: data?['financeId'] ?? '',
      avatar: data?['avatar'] ?? '',
      useColor: data?['useColor'] ?? '',
      useSkin: data?['useSkin'] ?? '',
      bag: data?['bag'] ?? [],
      courseMaps: data?['courseMaps'] ?? [],
    );
  }
}