// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:store_commerce_shop/authentication/controllers/login_controller.dart';
import 'package:store_commerce_shop/authentication/pages/signup/signup.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/pages/password_configuration/forget_password.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/constants/sizes.dart';
import 'package:store_commerce_shop/util/constants/text_strings.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';
import 'package:store_commerce_shop/util/validators/validation.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(LoginController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          dark ? TImage.logoLogingDark : TImage.logoLogingLight,
          height: 150,
        ),
        Text(
          TText.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(
          height: Dimentions.height8,
        ),
        Text(
          TText.loginSubTitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(
          width: Dimentions.pageView500,
          child: Form(
              key: controller.loginFromKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: TSize.spaceBtwSections),
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.email,
                      validator: (value) => TValidator.validateEmail(value),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          label: Text(TText.email)),
                    ),
                    SizedBox(
                      height: TSize.spaceBtwInputField,
                    ),
                    Obx(
                      () => TextFormField(
                        obscureText: controller.hidePassword.value,
                        controller: controller.password,
                        validator: (value) =>
                            TValidator.validateEmptyText("Password", value),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.password_check),
                            label: Text(TText.password),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  controller.hidePassword.value =
                                      !controller.hidePassword.value;
                                },
                                icon: Icon(controller.hidePassword.value
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye))),
                      ),
                    ),
                    SizedBox(
                      height: TSize.spaceBtwInputField / 2,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Get.to(
                                  () => ForgetPassword(),
                                ),
                                child: Text(
                                  TText.forgetPassword,
                                  style: TextStyle(color: TColors.primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ]),
                    SizedBox(
                      height: TSize.spaceBtwSections,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () => controller.emailAndPasswordSignIn(),
                        child: Text(TText.signIn),
                      ),
                    ),
                    SizedBox(
                      height: TSize.spaceBtwItems,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: OutlinedButton(
                          onPressed: () => Get.to(
                                () => SignUpPage(),
                              ),
                          child: Text(TText.createAccount)),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
