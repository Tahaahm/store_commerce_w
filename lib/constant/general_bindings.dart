import 'package:get/get.dart';
import 'package:store_commerce_shop/pages/cart/controller/cart_controller.dart';
import 'package:store_commerce_shop/pages/cart/controller/exchange_controller.dart';
import 'package:store_commerce_shop/pages/cart/controller/product_controller.dart';
import 'package:store_commerce_shop/pages/settings/controller/theme_controller.dart';
import 'package:store_commerce_shop/repository/fetch_repository/fetch_repository.dart';
import 'package:store_commerce_shop/repository/user_repository/user.dart';
import 'package:store_commerce_shop/util/newtork_manager/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() async {
    Get.put(NetworkManager());
    Get.put(ExchangeRateController());
    Get.put(UserRepository());
    Get.put(ThemeController());
    Get.put(CartController());
    Get.put(ProductController());
    Get.put(FetchRepository());
  }
}
