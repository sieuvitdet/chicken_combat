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


   final _streamSelected = BehaviorSubject<int>();
   ValueStream<int> get outputSelected => _streamSelected.stream;
   setSelected(int event) => set(_streamSelected, event);

   final _streamAsk = BehaviorSubject<AskModel>();
   ValueStream<AskModel> get outputAsk => _streamAsk.stream;
   setAsk(AskModel event) => set(_streamAsk, event);

   final _streamAnswer = BehaviorSubject<List<String>>();
   ValueStream<List<String>> get outputAnswer => _streamAnswer.stream;
   setAnswer(List<String> event) => set(_streamAnswer, event);

   getQuestion(int position, List<AskModel> asks) {
     if (position < asks.length) {
        modelAsk = asks[position];
        setAsk(modelAsk);
        setAnswer([asks[position].A, asks[position].B, asks[position].C, asks[position].D]);
     } else {
       print("Position $position is out of range.");
     }
   }

   onCheckAsk(int stt, int position, StatusBattle battle) async {
     if (AskModel.answerToIndex(modelAsk.Answer) == position) {
       print(position);
       await onCheck(stt, true, battle);
     } else {
       await onCheck(stt, false, battle);
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