class AskModel {
  String question;
  String correct;
  String A;
  String B;
  String C;
  String D;

  AskModel({
    required this.question,
    required this.correct,
    required this.A,
    required this.B,
    required this.C,
    required this.D,
  });

  factory AskModel.fromJson(Map<dynamic, dynamic>? json) {
    return AskModel(
      question: json?['question'] ?? '',
      correct: json?['correct'] ?? '',
      A: json?['A'] ?? '',
      B: json?['B'] ?? '',
      C: json?['C'] ?? '',
      D: json?['D'] ?? '',
    );
  }
}