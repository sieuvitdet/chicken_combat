import 'package:chicken_combat/model/maps/user_map_model.dart';

class CourseMapsModel {
  List<UserMapModel> listeningCourses;
  List<UserMapModel> readingCourses;
  List<UserMapModel> speakingCourses;

  CourseMapsModel({
    required this.listeningCourses,
    required this.readingCourses,
    required this.speakingCourses,
  });

  static CourseMapsModel fromUserMapModelList(List<UserMapModel> userMapModels) {
    List<UserMapModel> listeningCourses = [];
    List<UserMapModel> readingCourses = [];
    List<UserMapModel> writingCourses = [];
    List<UserMapModel> speakingCourses = [];

    for (var userMapModel in userMapModels) {
      if (userMapModel.isCourse == 'listening') {
        listeningCourses.add(userMapModel);
      } else if (userMapModel.isCourse == 'reading') {
        readingCourses.add(userMapModel);
      } else if (userMapModel.isCourse == 'speaking') {
        speakingCourses.add(userMapModel);
      }
    }

    return CourseMapsModel(
      listeningCourses: listeningCourses,
      readingCourses: readingCourses,
      speakingCourses: speakingCourses,
    );
  }
}