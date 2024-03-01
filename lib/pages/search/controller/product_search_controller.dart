// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/models/products/product_model.dart';

class ProductSearchController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<ProductModel> searchResults = <ProductModel>[].obs;
  RxBool isLoading = false.obs; // Define isLoading as a RxBool

  Future<void> searchProducts(String query) async {
    try {
      isLoading.value = true; // Set isLoading to true when starting the search

      // Clear the previous search results
      searchResults.clear();

      // Query Firestore for products that match the search query
      QuerySnapshot productSnapshot = await _firestore
          .collectionGroup('products')
          .where('title', isEqualTo: query)
          .get();

      // Add matching products to search results
      searchResults.addAll(
          productSnapshot.docs.map((doc) => ProductModel.fromFirestore(doc)));

      print("Dude you fetch one" + searchResults.toString());
    } catch (e) {
      print('Error searching for products: $e');
    } finally {
      isLoading.value = false; // Set isLoading to false when search is complete
    }
  }
}
