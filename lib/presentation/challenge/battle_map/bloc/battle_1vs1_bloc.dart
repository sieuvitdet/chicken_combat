import 'package:chicken_combat/model/battle/room_model.dart';
import 'package:chicken_combat/model/course/ask_model.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/presentation/interface/base_bloc.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class Battle1vs1Bloc extends BaseBloc {
  Battle1vs1Bloc(BuildContext context, RoomModel modelRoom){
    this.modelRoom = modelRoom;
    setContext(context);
    getQuestion();
  }

  @override
  void dispose() {
    _streamSelected.close();
    _streamAsk.close();
    _streamAnswer.close();
    super.dispose();
  }

  late AskModel modelAsk;
  late RoomModel modelRoom;
  int currentQuestionPosition = 0; // Track question position

  final _streamSelected = BehaviorSubject<int>();
  ValueStream<int> get outputSelected => _streamSelected.stream;
  setSelected(int event) => set(_streamSelected, event);

  final _streamAsk = BehaviorSubject<AskModel>();
  ValueStream<AskModel> get outputAsk => _streamAsk.stream;
  setAsk(AskModel event) => set(_streamAsk, event);

  final _streamAnswer = BehaviorSubject<List<String>>();
  ValueStream<List<String>> get outputAnswer => _streamAnswer.stream;
  setAnswer(List<String> event) => set(_streamAnswer, event);

  void getQuestion() {
    if (currentQuestionPosition < modelRoom.asks.length) {
      modelAsk = modelRoom.asks[currentQuestionPosition];
      setAsk(modelAsk);
      setAnswer([modelAsk.A, modelAsk.B, modelAsk.C, modelAsk.D]);
      setSelected(-1);
    } else {
      print("Position $currentQuestionPosition is out of range.");
      // Optionally, handle the end of questions (e.g., show results or reset the quiz)
    }
  }

  onCheckAsk(int position, StatusBattle battle) async {
    if (AskModel.answerToIndex(modelAsk.Answer) == position) {
      await onCheck(currentQuestionPosition, true, battle);
      if (currentQuestionPosition < modelRoom.asks.length - 1) {
          currentQuestionPosition++; // Move to next question
          getQuestion(); // Load next question
      }
    } else {
      await onCheck(currentQuestionPosition, false, battle);
        currentQuestionPosition++; // Move to next question
        getQuestion();
    }
  }

  Future<void> onCheck(int stt, bool correct, StatusBattle battle) async {
    try {
      await FirebaseFirestore.instance.collection(FirebaseEnum.battlestatus).doc(battle.id).update({
        'id': battle.id,
        'askPosition': stt,
        'correct': correct,
        'userid': Globals.currentUser!.id
      });
    } catch (e) {
      print("Error updating status: $e");
      throw Exception("Failed to update status in Firestore");
    }
  }
}
