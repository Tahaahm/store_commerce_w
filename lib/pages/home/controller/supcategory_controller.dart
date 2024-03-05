// ignore_for_file: avoid_print, unused_field, prefer_const_constructors, unused_local_variable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/authentication/pages/login/login.dart';
import 'package:store_commerce_shop/models/brand/brand.dart';
import 'package:store_commerce_shop/models/category/category_model.dart';
import 'package:store_commerce_shop/models/products/product_model.dart';
import 'package:store_commerce_shop/models/sup_category/sup_category.dart';
import 'package:store_commerce_shop/repository/fetch_repository/fetch_repository.dart';
import 'package:store_commerce_shop/util/popups/loaders.dart';

class FetchController extends GetxController {
  Timer? _timer;

  @override
  void onInit() {
    fetchSupcategories();
    startUserCheckTimer(); // Start the timer for user check
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel(); // Cancel the timer when the controller is closed
    super.onClose();
  }

  void startUserCheckTimer() async {
    const duration = Duration(seconds: 300);
    _timer = Timer.periodic(duration, (timer) async {
      final user = FirebaseAuth.instance.currentUser;

      // Check if the user is logged in
      if (user != null) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();
        if (userSnapshot.exists) {
          print("Good");
        } else {
          Get.offAll(() => LoginPage());
        }
      } else {
        // User is not logged in, navigate to LoginPage
        Get.offAll(() => LoginPage());
      }
    });
  }

  static FetchController get instance => Get.find();
  final RxList<BrandModel> brands = <BrandModel>[].obs;

  final fetchRepository = FetchRepository(); // Instantiate FetchRepository
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  RxList<SupCategoryModel> supcategories =
      <SupCategoryModel>[].obs; // Update to RxList

  final isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SupCategoryModel>> fetchSupcategories() async {
    try {
      isLoading.value = true;
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;

      // Check if the user is logged in
      if (user != null) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          supcategories.assignAll(await fetchRepository.fetchSupcategories());
          print(supcategories.toJson());
          return supcategories;
        } else {
          // User does not exist in Firestore, navigate to LoginPage
          Get.offAll(() => LoginPage());
          return [];
        }
      } else {
        // User is not logged in, navigate to LoginPage
        Get.offAll(() => LoginPage());
        return [];
      }
    } catch (e) {
      // Handle errors
      TLoaders.errorSnackBar(
        title: "Error fetching supcategories",
        message: e.toString(),
      );
      // Optionally, you can rethrow the error to handle it in the UI layer
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<CategoryModel>> fetchCategoriesForSupcategory(
      String supcategoryId) async {
    try {
      return await fetchRepository.fetchCategoriesForSupcategory(supcategoryId);
    } catch (e) {
      print('Error fetching categories for supcategory: $e');
      return [];
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
      return []; // Return an empty list in case of an error
    }
  }

  Future<List<ProductModel>> fetchProductsForBrand(
      String supCategoryId, String categoryId, String brandId) async {
    try {
      QuerySnapshot productsSnapshot = await _firestore
          .collection('Supcategories')
          .doc(supCategoryId)
          .collection('categories')
          .doc(categoryId)
          .collection('brands')
          .doc(brandId)
          .collection('products')
          .get();
      List<ProductModel> products = productsSnapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc);
      }).toList();
      return products;
    } catch (e) {
      print('Error fetching products for brand: $e');
      return []; // Return an empty list in case of an error
    }
  }
}
