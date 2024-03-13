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
  String? userId;
  int discount;
  String? buyName; // Added buyName field

  CartModel({
    this.id,
    this.name,
    this.price,
    this.img,
    this.quantity,
    this.time,
    this.isExist,
    this.product,
    this.userId,
    this.discount = 0,
    this.buyName, // Initialized buyName field in the constructor
  });

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
      'userId': userId,
      'discount': discount,
      'buyName': buyName, // Included buyName in the toMap method
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
      userId: doc['userId'],
      discount: doc['discount'] ?? 0,
      buyName: doc['buyName'], // Get buyName from Firestore
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
      userId: json['userId'],
      discount: json['discount'] ?? 0,
      buyName: json['buyName'], // Get buyName from JSON
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
      'userId': userId,
      'discount': discount,
      'buyName': buyName, // Include buyName in the toJson method
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
