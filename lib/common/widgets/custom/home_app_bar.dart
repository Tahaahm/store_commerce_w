// ignore_for_file: prefer_const_constructors, avoid_print, prefer_is_empty, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:store_commerce_shop/common/widgets/shimmer/t_shimmer_effect.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/constant/widgets/app_bar/custom_appbar.dart';
import 'package:store_commerce_shop/pages/cart/controller/cart_controller.dart';
import 'package:store_commerce_shop/pages/cart/shopping/shopping_cart.dart';
import 'package:store_commerce_shop/pages/home/controller/user_controller.dart';
import 'package:store_commerce_shop/pages/search/search_page.dart';
import 'package:store_commerce_shop/pages/settings/setting_page.dart';
import 'package:store_commerce_shop/util/constants/text_strings.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';

class SHomeAppBar extends StatelessWidget {
  const SHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(UserController());
    final cartController = Get.put(CartController());
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TText.homeAppBarTitle,
              style: Theme.of(context).textTheme.labelMedium),
          SizedBox(
            height: Dimentions.height5,
          ),
          Obx(() {
            if (controller.profileLoading.value) {
              return TShimmerEffect(
                width: 80,
                height: 15,
              );
            } else {
              return Text(controller.user.value.username,
                  style: Theme.of(context).textTheme.headlineSmall!);
            }
          }),
        ],
      ),
      action: [
        GestureDetector(
            onTap: () => Get.to(() => ShoppingCartPage()),
            child: GetBuilder<CartController>(
              builder: (cartController) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() => ShoppingCartPage()),
                      child: Container(
                          height: Dimentions.height60 * 1.6,
                          width: Dimentions.height60,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height60)),
                          child: Stack(children: [
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Icon(Iconsax.shopping_cart,
                                  color: dark ? TColors.white : TColors.black),
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
                                          borderRadius: BorderRadius.circular(
                                              Dimentions.height15)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        cartController.items.length.toString(),
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.white),
                                      ),
                                    ),
                                  )
                          ])),
                    ),
                  ],
                );
              },
            )),
        IconButton(
          onPressed: () {
            print(Dimentions.screenHeight);
            print(Dimentions.screenWidth);
            Get.to(() => SettingsPage());
          },
          icon: Icon(
            Iconsax.setting,
            color: dark ? TColors.white : TColors.black,
          ),
        ),
        IconButton(
          onPressed: () {
            Get.to(() => SearchPage());
          },
          icon: Icon(
            Iconsax.search_normal_1,
            color: dark ? TColors.white : TColors.black,
          ),
        ),
      ],
    );
  }
}
