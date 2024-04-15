class UserMapModel {
  String collectionMap;
  String level;
  String isCourse;

  UserMapModel({
    required this.collectionMap,
    required this.level,
    required this.isCourse,
  });

  static List<UserMapModel> convertDynamicListToUserMapModelList(List<dynamic> dynamicList) {
    return dynamicList.map((dynamic item) {
      Map<String, dynamic> map = item as Map<String, dynamic>;
      return UserMapModel(
        collectionMap: map['collectionMap'] ?? '',
        level: map['level'] ?? '',
        isCourse: map['isCourse'] ?? '',
      );
    }).toList();
  }
}
