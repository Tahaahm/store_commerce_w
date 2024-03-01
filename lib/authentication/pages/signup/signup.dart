// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, unnecessary_string_interpolations
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/common/widgets/login_signup/signup_form.dart';
import 'package:store_commerce_shop/util/constants/text_strings.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';

import '../../../util/constants/sizes.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: dark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(TSize.defaultSpace),
            child: SizedBox(
              width: Dimentions.pageView500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    TText.signupTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(
                    height: TSize.spaceBtwSections,
                  ),
                  TSignUpForm(),
                  SizedBox(
                    height: TSize.spaceBtwSections,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
