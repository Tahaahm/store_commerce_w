// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:store_commerce_shop/common/widgets/container/primary_header_container.dart';
import 'package:store_commerce_shop/common/widgets/list_title/user_profile_title.dart';
import 'package:store_commerce_shop/common/widgets/texts/section_heading.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/constant/widgets/app_bar/custom_appbar.dart';
import 'package:store_commerce_shop/controllers/repository/authentication_repository.dart';
import 'package:store_commerce_shop/pages/account_privacy/account_privacy.dart';
import 'package:store_commerce_shop/pages/cart/shopping/shopping_cart.dart';
import 'package:store_commerce_shop/pages/settings/controller/theme_controller.dart';
import 'package:store_commerce_shop/pages/settings/setting_menu_title.dart';
import 'package:store_commerce_shop/util/constants/sizes.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController = ThemeController.instance;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    backgroundColor: Colors.white,
                    showBackArrow: true,
                    title: Text(
                      "Account",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.white),
                    ),
                  ),
                  SizedBox(
                    height: TSize.spaceBtwSections,
                  ),
                  TUserProfieTitle(),
                  SizedBox(
                    height: TSize.spaceBtwSections,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(TSize.defaultSpace),
              child: Column(
                children: [
                  TSectionHeading(title: "Account Settings"),
                  TSettingsMenuTitle(
                    icon: Iconsax.security_card,
                    title: "Account Privacy",
                    subTitle: "Manage data usage and connected accounts",
                    onTap: () => Get.to(() => AccountPrivacy()),
                  ),
                  SizedBox(
                    height: TSize.spaceBtwSections,
                  ),
                  TSectionHeading(
                    title: "App Settings",
                  ),
                  SizedBox(
                    height: TSize.spaceBtwItems,
                  ),
                  TSettingsMenuTitle(
                    icon: Iconsax.shopping_cart,
                    title: "My Cart",
                    subTitle: "add, remove products and move to checkout",
                    onTap: () => Get.to(() => ShoppingCartPage()),
                  ),
                  TSettingsMenuTitle(
                    icon: Get.isDarkMode ? Iconsax.moon : Iconsax.sun_15,
                    title: Get.isDarkMode ? 'Dark Theme' : 'Light Theme',
                    subTitle: "Manage Theme of Settings",
                    trailing: Switch(
                      activeColor: TColors.primaryColor,
                      value: Get.isDarkMode,
                      onChanged: (value) {
                        _themeController.changeThemeMode(value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: TSize.spaceBtwItems,
                  ),
                  TSettingsMenuTitle(
                    icon: Iconsax.monitor_mobbile,
                    title: "Version App",
                    subTitle: "1.0.0",
                  ),
                  SizedBox(
                    height: TSize.spaceBtwSections,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () =>
                          AuthenticationRepository.instance.logout(),
                      child: Text("Logout"),
                    ),
                  ),
                  SizedBox(
                    height: Dimentions.height60,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
