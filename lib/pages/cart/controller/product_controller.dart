import 'package:get/get.dart';
import 'package:store_commerce_shop/models/products/product_model.dart';
import 'package:store_commerce_shop/pages/cart/controller/cart_controller.dart';

class ProductController extends GetxController {
  final CartController cartController = Get.find();

  void addToCart(ProductModel product, int quantity) {
    cartController.addItem(product, quantity, false, "Product");
  }
}
