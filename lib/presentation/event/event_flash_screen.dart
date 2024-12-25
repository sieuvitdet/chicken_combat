import 'package:chicken_combat/common/assets.dart';
import 'package:chicken_combat/model/enum/firebase_data.dart';
import 'package:chicken_combat/model/user_model.dart';
import 'package:chicken_combat/presentation/flash/flash_screen.dart';
import 'package:chicken_combat/utils/shared_pref_key.dart';
import 'package:chicken_combat/utils/utils.dart';
import 'package:chicken_combat/widgets/animation/loading_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'event_information_screen.dart';

class EventFlashScreen extends StatefulWidget {
  const EventFlashScreen({super.key});

  @override
  State<EventFlashScreen> createState() => _EventFlashScreenState();
}

class _EventFlashScreenState extends State<EventFlashScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserInfo();
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EventInformationScreen()));
    });
  }

  Future<void> getUserInfo() async {
    CollectionReference users = firestore.collection(FirebaseEnum.userdata);
    users
        .doc(Globals.prefs!.getString(SharedPrefsKey.id_user))
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        UserModel user = UserModel.fromSnapshot(documentSnapshot);
        Globals.currentUser = user;
        var data = documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('countEvent')) {
          var countEvent = data['countEvent'];
          print('countEvent: $countEvent');
        } else {
          await users
              .doc(Globals.prefs!.getString(SharedPrefsKey.id_user))
              .update({'countEvent': 1});
          print('Field countEvent được tạo và set giá trị ban đầu là 0');
        }

        setState(() {});
      } else {
        print('Document không tồn tại.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child:  Image.asset(Assets.img_background_event_tet,width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,),
          ),

          Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 100,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  LoadingAnimation(
                    offsetSpeed: Offset(1, 0),
                    width: 180,
                    height: 16,
                  ),
                ],
              ),)
        ],
      ),
    );
  }
}
