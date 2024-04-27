class AskExaminationModel {
  String Question;
  String Answer;
  String Script;
  String A;
  String B;
  String C;
  String D;

  AskExaminationModel({
    required this.Question,
    required this.Answer,
    required this.Script,
    required this.A,
    required this.B,
    required this.C,
    required this.D,
  });

  factory AskExaminationModel.fromJson(Map<dynamic, dynamic>? json) {
    return AskExaminationModel(
      Question: json?['Question'] ?? '',
      Answer: json?['Answer'] ?? '',
      Script: json?['Script'] ?? '',
      A: json?['A'] ?? '',
      B: json?['B'] ?? '',
      C: json?['C'] ?? '',
      D: json?['D'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Question': Question,
      'Answer': Answer,
      'Script': Script,
      'A': A,
      'B': B,
      'C': C,
      'D': D,
    };
  }

  static AskExaminationModel fromMap(Map<String, dynamic> map) {
    return AskExaminationModel(
      Question: map['Question'] as String,
      Answer: map['Answer'] as String,
      Script: map['Script'] as String,
      A: map['A'] as String,
      B: map['B'] as String,
      C: map['C'] as String,
      D: map['D'] as String,
    );
  }


  static int answerToIndex(String answer) {
    const Map<String, int> answerMap = {
      "A": 0,
      "B": 1,
      "C": 2,
      "D": 3
    };
    if (!answerMap.containsKey(answer)) {
      throw ArgumentError("Invalid answer: $answer");
    }
    return answerMap[answer]!;
  }
}