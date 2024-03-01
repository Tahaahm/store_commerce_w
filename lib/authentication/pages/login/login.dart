// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:store_commerce_shop/common/style/spacing_style.dart';
import 'package:store_commerce_shop/common/widgets/login_signup/login_header.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpecaingStyle.paddingWithAppBarHeight,
          child: Center(
            child: Column(
              children: [
                TLoginHeader(),
                SizedBox(
                  height: Dimentions.height32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
