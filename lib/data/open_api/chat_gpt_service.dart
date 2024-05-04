import 'dart:convert';
import 'package:chicken_combat/model/enum/chat_gpt_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ChatGPTService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  String _apiKey = '';
  bool _isApiKeyReady = false;

  ChatGPTService() {
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(ChatGPTEnum.openapi_collection)
          .doc(ChatGPTEnum.openapi_document)
          .get();
      if (snapshot.exists) {
        _apiKey = snapshot.get('apikey');
        _isApiKeyReady = true;
      } else {
        throw Exception("API Key does not exist in the document or is not properly set.");
      }
    } catch (e) {
      throw Exception("Failed to load API Key: $e");
    }
  }

  Future<String> callChatGPT(String topic, String answer, bool isLesson) async {
    if (!_isApiKeyReady) {
      throw Exception("API Key is not loaded yet");
    }
    final url = Uri.parse(_baseUrl);
    ///Ý 1 là chấm bằng điểm ý 2 là chấm bằng pass hoặc fail
    final prompt = """magine you are an elementary school teacher, rate the following topic and answer. Answers must fit the context of the topic question, do not give high marks for wrong answers. Because the answer may have a few words wrong because the text recognition and reading may not be correct. So please grade openly if there are spelling mistakes.\nBelow are the topics and children's responses. For scoring, answer only in numbers and rate on a 10-point scale. The answer syntax is "x" where x is your score. Please answer x.\nTopic: $topic\nAnswer: $answer""";
    final promptLesson = "Imagine you are an elementary school teacher, rate the following topic and answer. Question: $topic\nAnswer: $answer\nHere is the question and the child's answer."
    "For grading, answers are only pass or fail. The answer syntax is \"x\" where x is the result. Please answer x";
    print(prompt);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey'
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': isLesson ? promptLesson : prompt}
        ]
      }),
    );
    print(response);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to load data with status code: ${response.statusCode}');
    }
  }
}
