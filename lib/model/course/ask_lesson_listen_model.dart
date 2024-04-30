class AskLessonListenModel {
  String script;
  List<ContentModel> content;
  List<QuizModel> quiz;

  AskLessonListenModel({
    required this.script,
    required this.content,
    required this.quiz,
  });

  factory AskLessonListenModel.fromJson(List<dynamic>? json) {
    if (json == null || json.isEmpty) {
      return AskLessonListenModel(
        script: '',
        content: [],
        quiz: [],
      );
    }

    var contentList = json[0]['content'] as List<dynamic>?;
    var contents = <ContentModel>[];
    if (contentList != null) {
      contents = contentList.map((contentJson) => ContentModel.fromJson(contentJson)).toList();
    }

    var quizList = json[0]['quiz'] as List<dynamic>?;
    var quizzes = <QuizModel>[];
    if (quizList != null) {
      quizzes = quizList.map((quizJson) => QuizModel.fromJson(quizJson)).toList();
    }

    return AskLessonListenModel(
      script: json[0]['script'] ?? '',
      content: contents,
      quiz: quizzes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'script': script,
      'content': content,
      'quiz': quiz,
    };
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

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      idImage: json['id_image'] ?? '',
      pronounce: json['pronounce'] ?? '',
      transcription: json['transcription'] ?? '',
      translate: json['translate'] ?? '',
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

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      idImage: List<String>.from(json['id_image']),
      listen: Map<String, String>.from(json['listen']),
      answer: json['answer'] ?? '',
    );
  }
}