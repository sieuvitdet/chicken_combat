class AskLessonListenModel {
  String script;
  List<ContentModel> content;
  List<QuizModel> quiz;

  AskLessonListenModel({
    required this.script,
    required this.content,
    required this.quiz,
  });

  factory AskLessonListenModel.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return AskLessonListenModel(
        script: '',
        content: [],
        quiz: [],
      );
    }

    var contentList = json['content'] as List<dynamic>?;
    var contents = <ContentModel>[];
    if (contentList != null) {
      contents = contentList.map((contentJson) => ContentModel.fromJson(contentJson)).toList();
    }

    var quizList = json['quiz'] as List<dynamic>?;
    var quizzes = <QuizModel>[];
      quizzes = quizList!.map((quizJson) => QuizModel.fromJson(quizJson)).toList();

    return AskLessonListenModel(
      script: json['script'] ?? '',
      content: contents,
      quiz: quizzes,
    );
  }
}

class ContentModel {
  String idImage;
  String pronounce;
  String transcription;
  String translate;

  ContentModel({
    required this.idImage,
    required this.pronounce,
    required this.transcription,
    required this.translate,
  });

  factory ContentModel.fromJson(Map<dynamic, dynamic>? json) {
    return ContentModel(
      idImage: json?['id_image'] ?? '',
      pronounce: json?['pronounce'] ?? '',
      transcription: json?['transcription'] ?? '',
      translate: json?['translate'] ?? '',
    );
  }
}

class QuizModel {
  List<String> idImage;
  Map<String, String> listen;
  String answer;

  QuizModel({
    required this.idImage,
    required this.listen,
    required this.answer,
  });

  factory QuizModel.fromJson(Map<dynamic, dynamic>? json) {
    return QuizModel(
      idImage: List<String>.from(json?['id_image']),
      listen: Map<String, String>.from(json?['listen']),
      answer: json?['answer'] ?? '',
    );
  }
}