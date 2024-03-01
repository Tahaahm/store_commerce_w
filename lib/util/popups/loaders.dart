// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:store_commerce_shop/constant/colors.dart';

class TLoaders {
  static successSnackBar(
      {required title,
      message = "",
      duration = 3,
      bacgroundColor = TColors.primaryColor}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: bacgroundColor,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: EdgeInsets.all(10),
        icon: Icon(
          Iconsax.check,
          color: TColors.white,
        ));
  }

  static warningSnackBar({required title, message = "", duration = 3}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: EdgeInsets.all(20),
        icon: Icon(
          Iconsax.warning_2,
          color: TColors.white,
        ));
  }

  static errorSnackBar({required title, message = "", duration = 3}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Colors.red.shade600,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: EdgeInsets.all(20),
        icon: Icon(
          Iconsax.warning_2,
          color: TColors.white,
        ));
  }
}
