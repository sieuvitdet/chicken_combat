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

  Future<String> callChatGPT(String topic, String answer) async {
    if (!_isApiKeyReady) {
      throw Exception("API Key is not loaded yet");
    }
    final url = Uri.parse(_baseUrl);
    final prompt = "Topic: $topic\nAnswer: $answer\nHere are the topics and children's answers. Give a score, only answer in numbers and rate on a 10-point scale. The answer syntax is \"Score: xxx\" where xxx is your score.";
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey'
      },
      body: jsonEncode({
        'model': 'gpt-4',
        'messages': [
          {'role': 'user', 'content': prompt}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to load data with status code: ${response.statusCode}');
    }
  }
}
