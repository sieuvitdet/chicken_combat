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
        var apiKey = snapshot.get('apikey');
        if (apiKey is String && apiKey.isNotEmpty) {
          _apiKey = apiKey;
          _isApiKeyReady = true;
        } else {
          throw Exception("API Key is not properly set or is empty.");
        }
      } else {
        throw Exception("API Key document does not exist.");
      }
    } catch (e) {
      print("Error loading API Key: $e");
      throw Exception("Failed to load API Key: $e");
    }
  }

  Future<String> callChatGPT(String topic, String answer, bool isLesson) async {
    if (!_isApiKeyReady) {
      throw Exception("API Key is not loaded yet");
    }

    final url = Uri.parse(_baseUrl);

    // Prompt cho đánh giá bằng điểm số từ 0 đến 10
    final prompt = """
Imagine you are an elementary school teacher. Evaluate the following topic and multiple children's answers. 
Answers should be appropriate to the context, but spelling mistakes are acceptable due to potential text recognition errors. 
Select the closest answer. For grading, use a 10-point scale. Provide your score as "x", where x is your rating.
Topic: $topic
Answer: $answer
""";

    // Prompt cho đánh giá pass hoặc fail
    final promptLesson = """
Imagine you are an elementary school teacher. Your task is to evaluate the following topic and answer provided by a student. 
Question: $topic
Answer: $answer
Grade the answer with "pass" or "fail" based on its accuracy. Respond with "x", where x is your result.
""";

    // Chọn prompt phù hợp
    final selectedPrompt = isLesson ? promptLesson : prompt;

    print(selectedPrompt);

    // Gửi yêu cầu tới API
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey'
      },
      body: jsonEncode({
        'model': 'gpt-4',
        'messages': [
          {'role': 'user', 'content': selectedPrompt}
        ]
      }),
    );

    print(" ===> Response: $response");

    // Kiểm tra trạng thái phản hồi
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('Failed to load data with status code: ${response.statusCode}');
    }
  }
}
