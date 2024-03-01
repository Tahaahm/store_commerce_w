// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:store_commerce_shop/controllers/controller/onBoarding/controller_onboarding.dart';
import 'package:store_commerce_shop/util/device/device_utilites.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      right: Dimentions.height12,
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: dark ? Colors.white : Colors.black,
        ),
        child: Icon(
          Iconsax.arrow_right_3,
          color: dark ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
