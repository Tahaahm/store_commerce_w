import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  final String id;
  final String title;

  BrandModel({required this.id, required this.title});

  factory BrandModel.fromFirestore(DocumentSnapshot doc) {
    return BrandModel(
      id: doc.id,
      title: doc['title'],
    );
  }
}
