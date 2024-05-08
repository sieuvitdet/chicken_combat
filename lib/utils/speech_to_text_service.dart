import 'package:chicken_combat/data/open_api/chat_gpt_service.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  stt.SpeechToText _speech = stt.SpeechToText();
  String lastWords = '';
  bool isListening = false;
  List<RecognizedWord> recognizedWordsList = [];

  ChatGPTService _chatService = ChatGPTService();

  Future<void> init() async {
    bool hasSpeech = await _speech.initialize();
    if (!hasSpeech) {
      throw Exception('Speech recognition unavailable.');
    }
  }
  String recognizedWordsToString(List<RecognizedWord> recognizedWordsList) {
    return recognizedWordsList.map((word) => word.words).join(' ');
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
       Globals.alternates == "";
        if (result.alternates.length > 0) {
          result.alternates.forEach((element) {
             if (Globals.alternates == "") {
            Globals.alternates = element.recognizedWords;
          } else {
            Globals.alternates += "/${element.recognizedWords}";
          }
           });
        }
        lastWords = Globals.alternates;

        // print(result.alternates);
        // if (result.alternates.isNotEmpty) {
        //   recognizedWordsList = result.alternates.map((word) => RecognizedWord.fromJson(word.toJson())).toList();
        // }
        // lastWords = recognizedWordsToString(recognizedWordsList);
        // if (result.recognizedWords.isNotEmpty) {
        //   lastWords = result.recognizedWords;
        // }
      }, localeId: 'en_US'
      );
      isListening = true;
    }
  }
}

class RecognizedWord {
  String words;
  double confidence;

  RecognizedWord({required this.words, required this.confidence});

  factory RecognizedWord.fromJson(Map<String, dynamic> json) {
    return RecognizedWord(
      words: json['words'],
      confidence: json['confidence'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'words': words,
      'confidence': confidence,
    };
  }
}
