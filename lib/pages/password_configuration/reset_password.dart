// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:store_commerce_shop/authentication/pages/login/login.dart';
import 'package:store_commerce_shop/pages/password_configuration/controller/forget_password_controller.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/constants/text_strings.dart';

import '../../../../util/constants/sizes.dart';
import '../../../../util/helpers/helper_functions.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              CupertinoIcons.clear,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSize.defaultSpace),
        child: Column(
          children: [
            Lottie.asset(TImage.processing,
                width: THelperFunctions.screenWidth() * 0.6),
            SizedBox(
              height: TSize.spaceBtwSections,
            ),
            Text(
              TText.changeYourPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: TSize.spaceBtwItems,
            ),
            SizedBox(
              height: TSize.spaceBtwItems,
            ),
            Text(
              TText.changeYourPasswordSubTitle,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: TSize.spaceBtwSections,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.offAll(() => LoginPage()),
                child: Text(TText.done),
              ),
            ),
            SizedBox(
              height: TSize.spaceBtwItems,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => FogetPasswordController.instance
                    .resendPasswordResetEmail(email),
                child: Text(TText.resendEmail),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
