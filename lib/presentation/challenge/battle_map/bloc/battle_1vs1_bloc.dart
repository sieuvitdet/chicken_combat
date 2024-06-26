import 'package:chicken_combat/model/battle/room_model.dart';
import 'package:chicken_combat/model/course/ask_examination_model.dart';
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
    _streamOutRoom.close();
    _streamAsk.close();
    _streamAnswer.close();
    super.dispose();
  }

  late AskExaminationModel modelAsk;
  late RoomModel modelRoom;
  int currentQuestionPosition = 0; // Track question position

  final _streamSelected = BehaviorSubject<int>();
  ValueStream<int> get outputSelected => _streamSelected.stream;
  setSelected(int event) => set(_streamSelected, event);

  final _streamOutRoom = BehaviorSubject<bool>();
  ValueStream<bool> get outputOutRoom => _streamOutRoom.stream;
  setRemoveRoom(bool event) => set(_streamOutRoom, event);

  final _streamAsk = BehaviorSubject<AskExaminationModel>();
  ValueStream<AskExaminationModel> get outputAsk => _streamAsk.stream;
  setAsk(AskExaminationModel event) => set(_streamAsk, event);

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
    }
  }

  onCheckAsk(int position, StatusBattle battle) async {
    if (AskExaminationModel.answerToIndex(modelAsk.Answer) == position) {
      await onCheck(currentQuestionPosition, true, battle);
      if (currentQuestionPosition < modelRoom.asks.length - 1) {
        getQuestion();
      }
    } else {
      await onCheck(currentQuestionPosition, false, battle);
      if (currentQuestionPosition < modelRoom.asks.length - 1) {
        getQuestion();
      }
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
