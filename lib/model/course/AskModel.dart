class AskModel {
  String Question;
  String Answer;
  String Script;
  String A;
  String B;
  String C;
  String D;

  AskModel({
    required this.Question,
    required this.Answer,
    required this.Script,
    required this.A,
    required this.B,
    required this.C,
    required this.D,
  });

  factory AskModel.fromJson(Map<dynamic, dynamic>? json) {
    return AskModel(
      Question: json?['Question'] ?? '',
      Answer: json?['Answer'] ?? '',
      Script: json?['Script'] ?? '',
      A: json?['A'] ?? '',
      B: json?['B'] ?? '',
      C: json?['C'] ?? '',
      D: json?['D'] ?? '',
    );
  }
}