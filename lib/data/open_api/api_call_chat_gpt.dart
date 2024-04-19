import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> callChatGPT(String prompt) async {
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer your_api_key_here'
    },
    body: jsonEncode({
      'model': 'gpt-4', // Hoặc model khác tùy thuộc vào nhu cầu
      'messages': [
        {'role': 'user', 'content': prompt}
      ]
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['choices'][0]['message']['content'];
  } else {
    throw Exception('Failed to load data');
  }
}