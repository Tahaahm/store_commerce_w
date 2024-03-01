// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/pages/cart/cart_page.dart';
import 'package:store_commerce_shop/pages/favorite/favorite.dart';
import 'package:store_commerce_shop/pages/home/home_page.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  NavigationMenu({super.key});
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          backgroundColor: dark ? TColors.black : Colors.white,
          indicatorColor: dark
              ? Colors.white.withOpacity(0.1)
              : TColors.black.withOpacity(0.1),
          height: 80,
          selectedIndex: controller.selectedIndex.value,
          elevation: 0,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: [
            NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
            NavigationDestination(icon: Icon(Iconsax.shop), label: "Cart"),
            NavigationDestination(icon: Icon(Iconsax.heart), label: "Favorite"),
          ],
        ),
      ),
      body: Obx(() => controller.screen[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screen = [
    HomePage(),
    CartHistoryPage(),
    FavoritePage(),
  ];
}
