// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:store_commerce_shop/authentication/controllers/signup/singup_controller.dart';
import 'package:store_commerce_shop/common/widgets/login_signup/term_condtion_checkbox.dart';
import 'package:store_commerce_shop/util/constants/sizes.dart';
import 'package:store_commerce_shop/util/constants/text_strings.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';
import 'package:store_commerce_shop/util/validators/validation.dart';

class TSignUpForm extends StatelessWidget {
  const TSignUpForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    final dark = THelperFunctions.isDarkMode(context);
    return Form(
        key: controller.signUpFromKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: (value) =>
                        TValidator.validateEmptyText("First Name", value),
                    controller: controller.firstName,
                    expands: false,
                    decoration: InputDecoration(
                      label: Text(TText.firstName),
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                ),
                SizedBox(
                  width: Dimentions.height16,
                ),
                Expanded(
                  child: TextFormField(
                    controller: controller.lastName,
                    validator: (value) =>
                        TValidator.validateEmptyText("Last Name", value),
                    expands: false,
                    decoration: InputDecoration(
                      label: Text(TText.lastName),
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dimentions.height16,
            ),
            TextFormField(
              controller: controller.userName,
              validator: (value) =>
                  TValidator.validateEmptyText("Username", value),
              expands: false,
              decoration: InputDecoration(
                label: Text(TText.username),
                prefixIcon: Icon(Iconsax.user_edit),
              ),
            ),
            SizedBox(
              height: Dimentions.height16,
            ),
            TextFormField(
              controller: controller.email,
              validator: (value) => TValidator.validateEmail(value),
              expands: false,
              decoration: InputDecoration(
                label: Text(TText.email),
                prefixIcon: Icon(Iconsax.direct),
              ),
            ),
            SizedBox(
              height: Dimentions.height16,
            ),
            Obx(
              () => TextFormField(
                obscureText: controller.hidePassword.value,
                validator: (value) => TValidator.validatePassword(value),
                controller: controller.password,
                expands: false,
                decoration: InputDecoration(
                  label: Text(TText.password),
                  prefixIcon: Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value =
                          !controller.hidePassword.value,
                      icon: Icon(controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye)),
                ),
              ),
            ),
            SizedBox(
              height: TSize.spaceBtwSections,
            ),
            TTermAndCondtionCheckbox(),
            SizedBox(
              height: TSize.spaceBtwSections,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.signUp(),
                child: Text(TText.createAccount),
              ),
            )
          ],
        ));
  }
}
