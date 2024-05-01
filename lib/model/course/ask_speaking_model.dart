class AskSpeakingModel {
  List<QuizSpeakingModel> quiz;
  String script
;

  AskSpeakingModel({
    required this.quiz,
    required this.script
,
  });

  factory AskSpeakingModel.fromJson(Map<dynamic, dynamic>? json) {
    var quizList = json?['quiz'] as List<dynamic>?;
    var quizzes = <QuizSpeakingModel>[];
      quizzes = quizList!.map((quizJson) => QuizSpeakingModel.fromJson(quizJson)).toList();

    return AskSpeakingModel(
      quiz: quizzes,
      script: json?['script'] ?? '',
    );
  }
}


class QuizSpeakingModel {
  String question;


  QuizSpeakingModel({
    required this.question,
  });

  factory QuizSpeakingModel.fromJson(Map<dynamic, dynamic>? json) {
    return QuizSpeakingModel(
      question: json?['question'] ?? '',
    );
  }
}
