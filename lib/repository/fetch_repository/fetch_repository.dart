// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/models/brand/brand.dart';
import 'package:store_commerce_shop/models/category/category_model.dart';
import 'package:store_commerce_shop/models/products/product_model.dart';
import 'package:store_commerce_shop/models/sup_category/sup_category.dart';

class FetchRepository extends GetxController {
  static FetchRepository get instance => Get.find();
  //
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //fetch SupCategory
  Future<List<SupCategoryModel>> fetchSupcategories() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('Supcategories').get();
      List<SupCategoryModel> supcategories = snapshot.docs
          .map((doc) => SupCategoryModel.fromFirestore(doc))
          .toList();
      return supcategories;
    } catch (e) {
      throw Exception('Failed to fetch supcategories: $e');
    }
  }

  Future<List<CategoryModel>> fetchCategoriesForSupcategory(
      String supcategoryId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Supcategories')
          .doc(supcategoryId)
          .collection('categories')
          .get();
      List<CategoryModel> categories = snapshot.docs
          .map((doc) => CategoryModel.fromDocumentSnapshot(doc))
          .toList();
      return categories;
    } catch (e) {
      throw Exception('Failed to fetch categories for supcategory: $e');
    }
  }

  Future<List<BrandModel>> fetchBrandsForCategory(
      String supCategoryId, String categoryId) async {
    try {
      QuerySnapshot brandsSnapshot = await _firestore
          .collection('Supcategories')
          .doc(supCategoryId)
          .collection('categories')
          .doc(categoryId)
          .collection('brands')
          .get();
      List<BrandModel> brands = brandsSnapshot.docs.map((doc) {
        return BrandModel.fromFirestore(doc);
      }).toList();
      return brands;
    } catch (e) {
      print('Error fetching brands for category: $e');
      return [];
    }
  }

  Future<List<ProductModel>> fetchProductsFormBrand(
      String supCategoryId, String categoryId, String brandId) async {
    try {
      QuerySnapshot productSnapshot = await _firestore
          .collection('Supcategories')
          .doc(supCategoryId)
          .collection('categories')
          .doc(categoryId)
          .collection('brands')
          .doc(brandId)
          .collection('products')
          .get();
      List<ProductModel> products = productSnapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc);
      }).toList();

      return products;
    } catch (e) {
      print('Error fetching products for brand: $e');
      return [];
    }
  }

  Future<List<ProductModel>> fetchProductsBySupCategory(
      String supCategoryId) async {
    try {
      // Implement your logic to fetch products by SupCategory from Firestore
      // For example:
      QuerySnapshot productSnapshot = await _firestore
          .collection('products')
          .where('supcategoryId', isEqualTo: supCategoryId)
          .get();

      List<ProductModel> products = productSnapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc);
      }).toList();

      return products;
    } catch (e) {
      print('Error fetching products by SupCategory: $e');
      return [];
    }
  }
}
