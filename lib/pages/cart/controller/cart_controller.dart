// ignore_for_file: prefer_const_constructors, prefer_is_empty, avoid_function_literals_in_foreach_calls, unused_element, avoid_print, prefer_interpolation_to_compose_strings, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/models/cart_model/cart_model.dart';
import 'package:store_commerce_shop/models/products/product_model.dart';
import 'package:store_commerce_shop/pages/cart/controller/exchange_controller.dart';
import 'package:store_commerce_shop/pages/cart/repo/cart_repo.dart';
import 'package:store_commerce_shop/pages/recipe/generate_pdf.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/constants/sizes.dart';
import 'package:store_commerce_shop/util/popups/full_screen_loaders.dart';
import 'package:store_commerce_shop/util/popups/loaders.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();
  final CartRepo _cartRepo = CartRepo();
  List<CartModel> _items = [];
  List<CartModel> get items => _items;
  List<ProductModel> favoriteProducts = [];
  int _selectedDiscount = 0;
  int get selectedDiscount => _selectedDiscount;
  List<CartModel> cartHistory = []; // Add cart history list
  RxList<List<CartModel>> cartHistoryGrouped = <List<CartModel>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ExchangeRateController exchangeRateController =
      ExchangeRateController.instance;
  // Method to set the favorite products

  @override
  void onInit() {
    super.onInit();
    _initializeCart();
    getFavoriteProducts();

    // Listen to changes in IQD amount
    ever(exchangeRateController.iqdAmount, (_) {
      print('IQD amount changed. Updating total amount...');
      updateTotalAmount();
    });
  }

  Future<void> _initializeCart() async {
    _items = await _cartRepo.getCartList();
    update();
  }

  void addItem(
      ProductModel product, int quantity, bool isTrue, String title) async {
    String? userId = getCurrentUserId();
    if (userId != null) {
      int currentStock = product.stock;
      int existingQuantity = 0;

      // Check if the stock is 0
      if (currentStock == 0) {
        TLoaders.errorSnackBar(
          title: "Out of Stock",
          message: "${product.title} is currently out of stock.",
        );
        return;
      }

      // Check if the item already exists in the cart
      if (_items.any(
          (item) => item.product!.id == product.id && item.userId == userId)) {
        // Get the existing quantity of the item in the cart
        existingQuantity = _items
            .where((item) =>
                item.product!.id == product.id && item.userId == userId)
            .map((item) => item.quantity!)
            .reduce((value, element) => value + element);

        // If adding the new quantity exceeds the stock, show a warning
        if (existingQuantity + quantity > currentStock) {
          TLoaders.warningSnackBar(
            title: "Stock Limit Exceeded",
            message:
                "You cannot add more than $currentStock items of ${product.title}.",
          );
          return;
        }

        // Update the quantity of the existing item in the cart
        _items.forEach((item) {
          if (item.product!.id == product.id && item.userId == userId) {
            item.quantity = (item.quantity ?? 0) + quantity;
            if (item.quantity! <= 0) {
              removeItem(item);
            } else {
              _updateCart();
            }
            return;
          }
        });
      } else {
        // If the item doesn't exist in the cart, add it
        if (quantity <= currentStock) {
          _items.add(
            CartModel(
              id: product.id,
              name: product.title,
              price: product.price,
              img: product.imageUrl,
              isExist: true,
              quantity: quantity,
              userId: userId,
              time: DateTime.now().toString(),
              product: product,
            ),
          );
          _updateCart();
          isTrue
              ? TLoaders.successSnackBar(
                  title: "Adding Product",
                  message:
                      "Successfully add ${product.title} from $title to the Cart")
              : null;
        } else {
          // If adding the new quantity exceeds the stock, show a warning
          TLoaders.warningSnackBar(
            title: "Stock Limit Exceeded",
            message:
                "You cannot add more than $currentStock items of ${product.title}.",
          );
        }
      }
    }
  }

  String? getCurrentUserId() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  void removeItem(CartModel item) {
    _items.remove(item);
    _updateCart();
  }

  void increaseQuantity(CartModel item) {
    item.quantity = (item.quantity ?? 0) + 1;
    _updateCart();
  }

  void decreaseQuantity(CartModel item) {
    item.quantity = (item.quantity ?? 0) - 1;
    if (item.quantity! <= 0) {
      removeItem(item);
    } else {
      _updateCart();
    }
  }

  void clearCart() {
    _items.clear();
    _updateCart();
  }

  void _updateCart() {
    _cartRepo.addToCartList(_items);
    update();
  }

  void updateTotalAmount() {
    // Recalculate total amount based on new IQD amount
    double totalAmount = getTotalAmount();

    // You can use the total amount as needed
  }

  double getTotalAmount() {
    double total = 0.0;
    double iqdAmount =
        exchangeRateController.iqdAmount.value; // Get the fetched iqd_amount
    for (var item in _items) {
      double itemPrice;
      if (item.product!.currency == 'IQD') {
        // Convert IQD to USD using the fetched iqd_amount
        itemPrice = (item.price! / iqdAmount) * 100; // Convert to dollar
        print("object");
        itemPrice = double.parse(
            itemPrice.toStringAsFixed(2)); // Round to 2 decimal places
      } else {
        itemPrice = item.price!;
      }
      total += itemPrice * (item.quantity ?? 1);
    }

    return total.roundToDouble(); // Round the total to the nearest double value
  }

  Future<void> incrementProductStock(ProductModel product, int quantity) async {
    await _firestore
        .collection('Supcategories')
        .doc(product.supcategoryId)
        .collection('categories')
        .doc(product.categoryId)
        .collection('brands')
        .doc(product.brandId)
        .collection('products')
        .doc(product.id)
        .update({'stock': FieldValue.increment(quantity)});
  }

  Future<void> decrementProductStock(ProductModel product, int quantity) async {
    await _firestore
        .collection('Supcategories')
        .doc(product.supcategoryId)
        .collection('categories')
        .doc(product.categoryId)
        .collection('brands')
        .doc(product.brandId)
        .collection('products')
        .doc(product.id)
        .update({'stock': FieldValue.increment(-quantity)});
  }

  void checkOut(int selectedDiscount) async {
    _selectedDiscount = selectedDiscount; // Set the selected discount
    List<String> outOfStockProducts = [];

    for (var item in _items) {
      if (item.quantity! > item.product!.stock) {
        outOfStockProducts.add(item.product!.title);
      }
    }

    if (outOfStockProducts.isEmpty) {
      if (_items.isNotEmpty) {
        TFullScreenLoader.openLoadingDialog("Loading...", TImage.processing);

        // Proceed with checkout
        Get.to(() => GeneratePdfPage(
              items: _items,
              totalPrice: getTotalAmount(),
              discount: selectedDiscount,
            ));
      } else {
        TLoaders.warningSnackBar(
          title: "Cart is Empty",
          message: "The cart is empty. Please add products to checkout.",
        );
      }
    } else {
      String outOfStockProductsMessage = outOfStockProducts.join(", ");
      TLoaders.warningSnackBar(
        title: "Insufficient Stock",
        message:
            "The following products are out of stock: $outOfStockProductsMessage",
      );
    }
  }

  void addToFavorite(ProductModel product) {
    if (!isFavorite(product)) {
      _cartRepo.addToFavoriteList(product);
      favoriteProducts.add(product);
      TLoaders.successSnackBar(
          title: "Favorite",
          message: "Added the ${product.title} to the Favorite");
      update();
    } else {
      TLoaders.warningSnackBar(
          title: "Favorite", message: "Product is already in favorites.");
    }
  }

  void removeFromFavorite(ProductModel product) {
    if (isFavorite(product)) {
      _cartRepo.removeFromFavoriteList(product);
      favoriteProducts.remove(product);
      print(favoriteProducts);
      getFavoriteProducts();
      TLoaders.warningSnackBar(
          title: "Favorite",
          message: "Remove the ${product.title} in the Favorite ");
      update();
    } else {
      print('Product is not in favorites.');
    }
  }

  bool isFavorite(ProductModel product) {
    return favoriteProducts.any((favProduct) => favProduct.id == product.id);
  }

  Future<List<ProductModel>> getFavoriteProducts() async {
    favoriteProducts = await _cartRepo.getFavoriteList();
    return favoriteProducts;
  }

  void deleteAccountWarningPopup(int selectDiscount) {
    Get.defaultDialog(
      contentPadding: EdgeInsets.all(TSize.md),
      title: "Delete Account",
      middleText:
          "Are you sure you want to delete your account permanetly? this action is not reversible and all of your data will be removed permanently.",
      confirm: ElevatedButton(
        onPressed: () {
          checkOut(selectDiscount);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: BorderSide(
            color: Colors.red,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: TSize.lg),
          child: Text("Invoice"),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.context!).pop(),
        child: Text("Close"),
      ),
    );
  }

  Future<List<List<CartModel>>> getCartHistoryList() {
    return _cartRepo.fetchCartHistory();
  }
}
