// ignore_for_file: prefer_const_constructors, unused_local_variable, unused_element, await_only_futures

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/authentication/pages/success_screen/success_screen.dart';
import 'package:store_commerce_shop/controllers/repository/authentication_repository.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/constants/text_strings.dart';
import 'package:store_commerce_shop/util/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  //Send Verification
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      TLoaders.successSnackBar(
          title: "Email Sent",
          message: "Please check your inbox and verify your email");
    } catch (e) {
      TLoaders.errorSnackBar(title: "Oh Snap!!", message: e.toString());
    }
  }

  //Set Timer
  setTimerForAutoRedirect() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      //create veriabe for the UserFirebase
      final user = FirebaseAuth.instance.currentUser;
      //check if user is null
      if (user?.emailVerified ?? false) {
        timer.cancel();

        Get.off(
          () => SuccessScreen(
            title: TText.yourAccountCreatedTitle,
            subTtitle: TText.youAccountCreatedSubTitle,
            image: TImage.success,
            onPressed: () {
              Get.put(AuthenticationRepository.instance.ScreenRedirct());
            },
          ),
        );
      }
    });
  }

  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
          title: TText.yourAccountCreatedTitle,
          subTtitle: TText.youAccountCreatedSubTitle,
          image: TImage.processing,
          onPressed: () {
            Get.to(() => AuthenticationRepository.instance.ScreenRedirct());
          },
        ),
      );
    }
  }
}
