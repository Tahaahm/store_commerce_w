// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:store_commerce_shop/common/widgets/product_card/product_items.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/constant/widgets/app_bar/custom_appbar.dart';
import 'package:store_commerce_shop/pages/cart/controller/cart_controller.dart';
import 'package:store_commerce_shop/pages/cart/shopping/shopping_cart.dart';
import 'package:store_commerce_shop/pages/home/controller/supcategory_controller.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';
import 'package:store_commerce_shop/util/popups/loaders.dart';

class DetailPage extends StatelessWidget {
  const DetailPage(
      {super.key,
      required this.supcategoryId,
      required this.categoryId,
      required this.brandId,
      required this.categoryName});
  final String supcategoryId;
  final String categoryId;
  final String brandId;
  final String categoryName;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    Future<void> checkLowStockProducts() async {
      // Fetch products for the current brand
      final products = await FetchController.instance.fetchProductsForBrand(
        supcategoryId,
        categoryId,
        brandId,
      );

      // Check if any product has 3 or less stock
      final lowStockProducts =
          products.where((product) => product.stock <= 5).toList();

      if (lowStockProducts.isNotEmpty) {
        // Get the names of the low stock products
        final lowStockProductNames =
            lowStockProducts.map((product) => product.title).toList();

        // Display a warning snackbar with the names of the low stock products
        TLoaders.infoSnackBar(
          title: "Low Stock Products",
          message:
              "The following products have low stock: \n ${lowStockProductNames.join(", ")}",
        );
      }
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimentions.width10),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: TAppBar(
                action: [
                  GestureDetector(
                      onTap: () => Get.to(() => ShoppingCartPage()),
                      child: Container(
                          height: Dimentions.height60 * 1.6,
                          width: Dimentions.height60,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height60)),
                          child: GetBuilder<CartController>(
                            builder: (cartController) {
                              return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        Get.to(() => ShoppingCartPage()),
                                    child: Container(
                                        height: Dimentions.height60 * 1.6,
                                        width: Dimentions.height60,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Dimentions.height60)),
                                        child: Stack(children: [
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            top: 0,
                                            bottom: 0,
                                            child: Icon(Iconsax.shopping_cart,
                                                color: dark
                                                    ? TColors.white
                                                    : TColors.black),
                                          ),
                                          cartController.items.length <= 0
                                              ? SizedBox()
                                              : Positioned(
                                                  right: 6,
                                                  top: 6,
                                                  child: Container(
                                                    height: Dimentions.height12,
                                                    width: Dimentions.height12,
                                                    decoration: BoxDecoration(
                                                        color: TColors.error,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                Dimentions
                                                                    .height15)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      cartController
                                                          .items.length
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                        ])),
                                  ),
                                ],
                              );
                            },
                          ))),
                ],
                showBackArrow: true,
                title: Text(categoryName,
                    style: Theme.of(context).textTheme.headlineMedium!),
              ),
            ),
            SizedBox(
              height: Dimentions.height10,
            ),
            Expanded(
              flex: 13,
              child: FutureBuilder(
                future: checkLowStockProducts(),
                builder: (context, snapshot) {
                  return TProductItemsDetail(
                    supcategoryId: supcategoryId,
                    categoryId: categoryId,
                    brandId: brandId,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
