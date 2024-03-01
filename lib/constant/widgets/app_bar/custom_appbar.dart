// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/util/device/device_utilites.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';

class TAppBar extends StatelessWidget implements PreferredSize {
  final Widget? title;
  final bool showBackArrow;
  final IconData? leadIcon;
  final List<Widget>? action;
  final VoidCallback? leadingOnPressed;
  final Color? backgroundColor;

  const TAppBar(
      {super.key,
      this.title,
      this.showBackArrow = false,
      this.leadIcon,
      this.action,
      this.leadingOnPressed,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimentions.width10 / 5),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color:
                      backgroundColor ?? (dark ? TColors.white : TColors.black),
                ))
            : leadIcon != null
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Iconsax.arrow_left,
                      color: dark ? TColors.white : TColors.black,
                    ))
                : null,
        title: title,
        actions: action,
      ),
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => Size.fromHeight(
        TDeviceUtils.getAppBarHeight(),
      );
}
