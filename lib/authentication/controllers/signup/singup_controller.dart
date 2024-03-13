// ignore_for_file: non_constant_identifier_names, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/authentication/pages/signup/verfiy_email.dart';
import 'package:store_commerce_shop/models/user_model.dart';
import 'package:store_commerce_shop/controllers/repository/authentication_repository.dart';
import 'package:store_commerce_shop/pages/cart/controller/cart_controller.dart';
import 'package:store_commerce_shop/repository/user_repository/user.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/newtork_manager/network_manager.dart';
import 'package:store_commerce_shop/util/popups/full_screen_loaders.dart';
import 'package:store_commerce_shop/util/popups/loaders.dart';

class SignUpController extends GetxController {
  @override
  void onClose() {
    userName.dispose();
    firstName.dispose();
    lastName.dispose();
    password.dispose();
    email.dispose();

    super.onClose();
  }

  static SignUpController get instance => Get.find();
  final hidePassword = true.obs;
  final privacyPolice = true.obs;
  final userName = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();

  GlobalKey<FormState> signUpFromKey = GlobalKey<FormState>();

  void signUp() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
        "We are loading your information...",
        TImage.processing,
      );

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: "No Internet Connection",
            message: "Please check your internet connection.");
        return;
      }

      // Form Validation
      if (!signUpFromKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!privacyPolice.value) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: "Accept Privacy Policy",
            message: "Please accept the privacy policy.");
        return;
      }

      // Register User in Firebase Authentication
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      // Save Authentication user data in Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: userName.text.trim(),
        email: email.text.trim(),
        role: 'User',
      );

      final userRepository = Get.put(UserRepository());
      userRepository.saveUserRecord(newUser);

      // Show Success Message
      TLoaders.successSnackBar(
          title: "Congratulations",
          message:
              "Your account has been created! Please verify your email to continue.");

      // Move to verify email screen
      Get.off(() => VerfiyEmailScreen(
            email: email.text.trim(),
          ));
      CartController.instance.clearCart();
    } catch (e) {
      // Show Error Message
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: "Oh Snap!", message: "An error occurred during sign up: $e");
    }
  }
}
