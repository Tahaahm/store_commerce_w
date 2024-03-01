// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/constant/widgets/loader/animation_loader.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class TFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: Dimentions.pageView316,
            width: Dimentions.pageView316,
            child: Column(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TAnimationLoaderWidget(
                        text: text,
                        animaton: animation,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static stopLoading() {
    Get.back();
  }

  static stopLoadingNavigate() {
    Navigator.of(Get.context!).pop();
  }
}
