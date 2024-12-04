import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireStoreManager {

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  BuildContext context;

  FireStoreManager(this.context);

  Future<DocumentSnapshot?> get(CollectionReference collections, {required String key, required VoidCallback onCallBack}) async {
    await collections.doc(key).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
          return documentSnapshot;
      } else {
         return null;
      }
    }).catchError((error) {
      return null;
    });;
    return null;
  }
}
