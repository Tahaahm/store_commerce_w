// ignore_for_file: unused_local_variable, unnecessary_overrides
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_commerce_shop/controllers/repository/authentication_repository.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/newtork_manager/network_manager.dart';
import 'package:store_commerce_shop/util/popups/full_screen_loaders.dart';
import 'package:store_commerce_shop/util/popups/loaders.dart';

class LoginController extends GetxController {
  LoginController get instance => Get.find();
  @override
  void onInit() {
    super.onInit();
  }

  final email = TextEditingController();
  final password = TextEditingController();
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  GlobalKey<FormState> loginFromKey = GlobalKey<FormState>();
  final localStorage = GetStorage();

  Future<void> emailAndPasswordSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Logging you in....", TImage.processing);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      if (!loginFromKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final userCredential = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      TFullScreenLoader.stopLoading();

      AuthenticationRepository.instance.ScreenRedirct();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Oh Snap!!", message: e.toString());
    }
  }
}
