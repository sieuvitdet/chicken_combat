import 'package:cloud_firestore/cloud_firestore.dart';

class MapModel {
  String id;
  String imageId;
  String namemap;

  MapModel({
    required this.id,
    required this.imageId,
    required this.namemap,
  });

  factory MapModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return MapModel(
      id: snapshot.id,
      imageId: data?['imageId'] ?? '',
      namemap: data?['namemap'] ?? '',
    );
  }
}