import 'package:chicken_combat/data/open_api/chat_gpt_service.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  stt.SpeechToText _speech = stt.SpeechToText();
  String lastWords = '';
  bool isListening = false;

  ChatGPTService _chatService = ChatGPTService();

  Future<void> init() async {
    bool hasSpeech = await _speech.initialize();
    if (!hasSpeech) {
      throw Exception('Speech recognition unavailable.');
    }
  }

  void toggleRecording(String answer, bool isLesson,  Function(String) onResult) {
    if (isListening) {
      _speech.stop();
      isListening = false;
      print(lastWords);
      _chatService.callChatGPT(answer, lastWords, isLesson).then(onResult).catchError((e) {
        onResult("Error calling ChatGPT: ${e.toString()}");
      });
    } else {
      _speech.listen(onResult: (result) {
        if (result.recognizedWords.isNotEmpty) {
          lastWords = result.recognizedWords;
        }
      });
      isListening = true;
    }
  }
}