class UserMapModel {
  String collectionMap;
  int level;
  String isCourse;
  bool isComplete;

  UserMapModel({
    required this.collectionMap,
    required this.level,
    required this.isCourse,
    required this.isComplete,
  });

  static List<UserMapModel> convertDynamicListToUserMapModelList(List<dynamic> dynamicList) {
    return dynamicList.map((dynamic item) {
      Map<String, dynamic> map = item as Map<String, dynamic>;
      return UserMapModel(
        collectionMap: map['collectionMap'] ?? '',
        level: map['level'] ?? '',
        isCourse: map['isCourse'] ?? '',
        isComplete: map['isComplete'] ?? false,
      );
    }).toList();
  }
}



