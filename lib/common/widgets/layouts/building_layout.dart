// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:store_commerce_shop/authentication/pages/login/login.dart';
import 'package:store_commerce_shop/pages/home/home_page.dart';

class BuildingLayoutWidget extends StatelessWidget {
  const BuildingLayoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 450) {
          return LoginPage();
        } else if (constraints.maxWidth >= 500) {
          return Scaffold();
        }

        return HomePage();
      },
    );
  }
}
