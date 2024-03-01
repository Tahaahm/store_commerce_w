// ignore_for_file: empty_catches, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/controllers/repository/authentication_repository.dart';
import 'package:store_commerce_shop/pages/password_configuration/reset_password.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/newtork_manager/network_manager.dart';
import 'package:store_commerce_shop/util/popups/full_screen_loaders.dart';
import 'package:store_commerce_shop/util/popups/loaders.dart';

class FogetPasswordController extends GetxController {
  static FogetPasswordController get instance => Get.find();

  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Processing your request...", TImage.processing);

      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        TLoaders.errorSnackBar(
            title: "No Ineternet Connection",
            message: "Please try to connect internet and try again");
        TFullScreenLoader.stopLoadingNavigate();
        return;
      }

      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .sendPasswordRestEmail(email.text.trim());

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(
          title: "Email sent",
          message: "Email Link Sent to Reset your Password".tr);

      Get.to(() => ResetPasswordScreen(email: email.text));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Processing your request...", TImage.processing);

      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        TLoaders.errorSnackBar(
            title: "No Ineternet Connection",
            message: "Please try to connect internet and try again");
        TFullScreenLoader.stopLoadingNavigate();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordRestEmail(email);

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(
          title: "Email sent",
          message: "Email Link Sent to Reset your Password".tr);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }
}
