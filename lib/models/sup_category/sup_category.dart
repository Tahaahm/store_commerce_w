import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_commerce_shop/models/category/category_model.dart';

class SupCategoryModel {
  final String title;
  final String id; // Add field for document ID
  final List<CategoryModel>? categories;
  SupCategoryModel(this.categories, {required this.title, required this.id});

  factory SupCategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SupCategoryModel(data['categories'],
        title: data['title'], id: doc.id);
  }
}
