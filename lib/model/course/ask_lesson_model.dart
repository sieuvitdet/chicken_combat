class AskLessonModel {
  String Script;
  String Content;
  List<QuizModel> Quiz;

  AskLessonModel({
    required this.Script,
    required this.Content,
    required this.Quiz,
  });

  factory AskLessonModel.fromJson(Map<dynamic, dynamic>? json) {
    if (json == null) {
      return AskLessonModel(
        Script: '',
        Content: '',
        Quiz: [],
      );
    }
    var quizList = json['quiz'] as List<dynamic>?;
    var quizzes = <QuizModel>[];
    if (quizList != null) {
      quizzes = quizList.map((quizJson) => QuizModel.fromJson(quizJson)).toList();
    }
    return AskLessonModel(
      Script: json['script'] ?? '',
      Content: json['content'] ?? '',
      Quiz: quizzes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'script': Script,
      'content': Content,
      'quiz': Quiz,
    };
  }

  static AskLessonModel fromMap(Map<String, dynamic> map) {
    var quizList = map['quiz'] as List<dynamic>?;
    var quizzes = <QuizModel>[];
    if (quizList != null) {
      quizzes = quizList.map((quizJson) => QuizModel.fromMap(quizJson)).toList();
    }
    return AskLessonModel(
      Script: map['script'] as String,
      Content: map['content'] as String,
      Quiz: quizzes,
    );
  }

  static int answerToIndex(String answer) {
    const Map<String, int> answerMap = {"A": 0, "B": 1, "C": 2, "D": 3};
    if (!answerMap.containsKey(answer)) {
      throw ArgumentError("Invalid answer: $answer");
    }
    return answerMap[answer]!;
  }
}

class QuizModel {
  String Question;
  String Answer;
  OptionQuizModel Options;

  QuizModel({
    required this.Question,
    required this.Answer,
    required this.Options,
  });

  factory QuizModel.fromJson(Map<dynamic, dynamic>? json) {
    return QuizModel(
      Question: json?['question'] ?? '',
      Answer: json?['answer'] ?? '',
      Options: json?['options'] != null ? OptionQuizModel.fromJson(json?['options']) : OptionQuizModel(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': Question,
      'answer': Answer,
      'options': Options,
    };
  }

  static QuizModel fromMap(Map<String, dynamic> map) {
    return QuizModel(
      Question: map['question'] as String,
      Answer: map['answer'] as String,
      Options: OptionQuizModel(
        A: map['options']['A'] as String,
        B: map['options']['B'] as String,
        C: map['options']['C'] as String,
        D: map['options']['D'] as String,
      ),
    );
  }
}

class OptionQuizModel {
  String? A;
  String? B;
  String? C;
  String? D;

  OptionQuizModel({
    this.A,
    this.B,
    this.C,
    this.D,
  });

  factory OptionQuizModel.fromJson(Map<String, dynamic>? json) {
    return OptionQuizModel(
      A: json?['A'] ?? '',
      B: json?['B'] ?? '',
      C: json?['C'] ?? '',
      D: json?['D'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'A': A,
      'B': B,
      'C': C,
      'D': D,
    };
  }
}