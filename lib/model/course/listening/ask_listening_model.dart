import 'dart:ffi';

class AskListeningModel {
  String awId;
  String answer;
  int correct;
  String question1;
  String question2;
  String question3;
  String question4;

  AskListeningModel({
    required this.awId,
    required this.answer,
    required this.correct,
    required this.question1,
    required this.question2,
    required this.question3,
    required this.question4,
  });

  factory AskListeningModel.fromJson(Map<dynamic, dynamic>? json) {
    return AskListeningModel(
      awId: json?['awId'] ?? '',
      answer: json?['answer'] ?? '',
      correct: json?['correct'] ?? '',
      question1: json?['question1'] ?? '',
      question2: json?['question2'] ?? '',
      question3: json?['question3'] ?? '',
      question4: json?['question4'] ?? '',
    );
  }
}