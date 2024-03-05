// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:store_commerce_shop/pages/password_configuration/controller/forget_password_controller.dart';
import 'package:store_commerce_shop/util/constants/text_strings.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/validators/validation.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FogetPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(Dimentions.height12),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  TText.forgetPasswordTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(
                  height: Dimentions.height16,
                ),
                Text(
                  TText.forgetPasswordSubTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(height: Dimentions.height60),
                SizedBox(
                  width: Dimentions.pageView400,
                  child: Form(
                    key: controller.forgetPasswordFormKey,
                    child: TextFormField(
                      controller: controller.email,
                      validator: TValidator.validateEmail,
                      decoration: InputDecoration(
                          labelText: TText.email,
                          prefixIcon: Icon(Iconsax.direct_right)),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimentions.height32,
                ),
                SizedBox(
                  width: Dimentions.pageView500 - 50,
                  child: ElevatedButton(
                      onPressed: () => controller.sendPasswordResetEmail(),
                      child: Text(TText.submit)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
