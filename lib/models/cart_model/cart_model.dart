import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_commerce_shop/models/products/product_model.dart';

class CartModel {
  String? id;
  String? name;
  double? price;
  String? img;
  int? quantity;
  String? time;
  bool? isExist;
  ProductModel? product;
  String? userId; // Add userId field

  CartModel({
    this.id,
    this.name,
    this.price,
    this.img,
    this.quantity,
    this.time,
    this.isExist,
    this.product,
    this.userId, // Initialize userId field in the constructor
  });

  get volume => null;

  get power => null;

  get brand => null;

  get height => null;

  get width => null;

  get depth => null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'img': img,
      'quantity': quantity,
      'time': time,
      'isExist': isExist,
      'product': product!.toJson(),
      'userId': userId, // Include userId in the toMap method
    };
  }

  factory CartModel.fromFirestore(DocumentSnapshot doc) {
    return CartModel(
      id: doc.id,
      name: doc['name'],
      price: doc['price'],
      img: doc['img'],
      quantity: doc['quantity'],
      time: doc['time'],
      isExist: doc['isExist'],
      product: ProductModel.fromFirestore(doc['product']),
      userId: doc['userId'], // Get userId from Firestore
    );
  }
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      img: json['img'],
      quantity: json['quantity'],
      time: json['time'],
      isExist: json['isExist'],
      product: ProductModel.fromJson(json['product']),
      userId: json['userId'], // Get userId from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'img': img,
      'quantity': quantity,
      'time': time,
      'isExist': isExist,
      'product': product!.toJson(),
      'userId': userId, // Include userId in the toJson method
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  static CartModel fromJsonString(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return CartModel.fromJson(json);
  }
}
