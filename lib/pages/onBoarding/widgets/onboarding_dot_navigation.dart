// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store_commerce_shop/controllers/controller/onBoarding/controller_onboarding.dart';

import '../../../../util/constants/colors.dart';
import '../../../../util/constants/sizes.dart';
import '../../../../util/device/device_utilites.dart';
import '../../../../util/helpers/helper_functions.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = OnBoardingController.instance;
    return Positioned(
      left: TSize.defaultSpace,
      bottom: TDeviceUtils.getBottomNavigationBarHeight() + 25,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.doNavigationClick,
        count: 3,
        effect: ExpandingDotsEffect(
          activeDotColor: dark ? TColors.light : TColors.black,
          dotHeight: 6,
        ),
      ),
    );
  }
}
