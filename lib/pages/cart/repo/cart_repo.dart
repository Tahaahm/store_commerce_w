// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_commerce_shop/models/cart_model/cart_model.dart';
import 'package:store_commerce_shop/models/products/product_model.dart';

class CartRepo {
  static const String _cartKey = 'cartList';
  static const String _favoriteKey = 'listFavorite';
  static const String _cartHistoryKey = 'cartHistory';
  Future<void> addToCartList(List<CartModel> cartList) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> cartJsonList =
          cartList.map((cart) => json.encode(cart.toJson())).toList();
      await prefs.setStringList(_cartKey, cartJsonList);

      // Add items to cart history
    } catch (e) {
      print('Error adding to cart list: $e');
    }
  }

  Future<List<CartModel>> getCartList() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? cartJsonList = prefs.getStringList(_cartKey);
      if (cartJsonList == null) {
        return [];
      }
      final List<CartModel> cartList = cartJsonList
          .map((json) => CartModel.fromJson(jsonDecode(json)))
          .toList();
      return cartList;
    } catch (e) {
      print('Error reading cart list: $e');
      return [];
    }
  }

  Future<void> clearCart() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  Future<void> addToFavoriteList(ProductModel product) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> favoriteList = prefs.getStringList(_favoriteKey) ?? [];
      favoriteList.add(jsonEncode(product.toJson()));
      await prefs.setStringList(_favoriteKey, favoriteList);
    } catch (e) {
      print('Error adding to favorite list: $e');
    }
  }

  Future<List<ProductModel>> getFavoriteList() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? favoriteJsonList = prefs.getStringList(_favoriteKey);
      if (favoriteJsonList == null) {
        return [];
      }
      final List<ProductModel> favoriteList = favoriteJsonList
          .map((json) => ProductModel.fromJson(jsonDecode(json)))
          .toList();
      return favoriteList;
    } catch (e) {
      print('Error reading favorite list: $e');
      return [];
    }
  }

  Future<void> removeFromFavoriteList(ProductModel product) async {
    // Your implementation to remove a product from favorites
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> favoriteList = prefs.getStringList(_favoriteKey) ?? [];
      favoriteList.removeWhere((element) =>
          element ==
          jsonEncode(product.toJson())); // Remove matching JSON string
      await prefs.setStringList(_favoriteKey, favoriteList);
    } catch (e) {
      print('Error removing from favorite list: $e');
    }
  }

  Future<void> updateFavoriteList(List<ProductModel> favoriteProducts) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String favoriteProductsJson = jsonEncode(
        favoriteProducts.map((product) => product.toJson()).toList(),
      );
      await prefs.setString('favorite_products', favoriteProductsJson);
    } catch (e) {
      print("Error updating favorite list: $e");
    }
  }

  Future<void> addToCartHistory(List<CartModel> cartItems, DateTime orderTime,
      int discount, String buyerName) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> cartHistory = prefs.getStringList(_cartHistoryKey) ?? [];

      // Add each cart item to the cart history along with the given discount and buyer name
      for (final item in cartItems) {
        item.time = orderTime.toString(); // Set the time for each cart item

        // Set the discount for the cart item
        item.discount = discount;

        // Set the buyer name for the cart item
        item.buyName = buyerName;

        // Convert the cart item to a Map
        final Map<String, dynamic> itemMap = item.toJson();

        // Encode the cart item Map to JSON and add it to the cart history
        cartHistory.add(jsonEncode(itemMap));
      }

      // Store the updated cart history in SharedPreferences
      await prefs.setStringList(_cartHistoryKey, cartHistory);
    } catch (e) {
      print('Error adding to cart history: $e');
    }
  }

  Future<List<List<CartModel>>> fetchCartHistory() async {
    try {
      final List<List<CartModel>> cartHistoryGroups = [];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> cartHistory =
          prefs.getStringList(_cartHistoryKey) ?? [];

      // Group cart items by order time
      final Map<String, List<CartModel>> groupedCartItems = {};
      for (final json in cartHistory) {
        final cartItem = CartModel.fromJson(jsonDecode(json));
        final orderTime =
            cartItem.time ?? ''; // Assuming time is stored in the cart item
        if (!groupedCartItems.containsKey(orderTime)) {
          groupedCartItems[orderTime] = [];
        }
        groupedCartItems[orderTime]?.add(cartItem);
      }

      // Convert grouped cart items to list of lists
      groupedCartItems.forEach((orderTime, cartItems) {
        cartHistoryGroups.add(cartItems);
      });

      // Sort cartHistoryGroups based on the proximity to the current time
      cartHistoryGroups.sort((a, b) {
        final firstOrderTime = DateTime.parse(a.first.time!);
        final secondOrderTime = DateTime.parse(b.first.time!);
        final currentTime = DateTime.now();
        final firstDifference =
            currentTime.difference(firstOrderTime).inMilliseconds.abs();
        final secondDifference =
            currentTime.difference(secondOrderTime).inMilliseconds.abs();
        return firstDifference.compareTo(secondDifference);
      });

      return cartHistoryGroups;
    } catch (e) {
      print('Error getting cart history: $e');
      return [];
    }
  }
}
