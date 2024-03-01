// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, file_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/controllers/controller/onBoarding/controller_onboarding.dart';
import 'package:store_commerce_shop/pages/onBoarding/widgets/onboarding_dot_navigation.dart';
import 'package:store_commerce_shop/pages/onBoarding/widgets/onboarding_next-button.dart';
import 'package:store_commerce_shop/pages/onBoarding/widgets/onboarding_page.dart';
import 'package:store_commerce_shop/pages/onBoarding/widgets/onboarding_skip.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/constants/text_strings.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              onBoardingPage(
                image: TImage.onBoarding1,
                title: TText.onBoardingTitle1,
                subTitle: TText.onBoardingSubTitle1,
              ),
              onBoardingPage(
                image: TImage.onBoarding2,
                title: TText.onBoardingTitle2,
                subTitle: TText.onBoardingSubTitle2,
              ),
              onBoardingPage(
                image: TImage.onBoarding3,
                title: TText.onBoardingTitle3,
                subTitle: TText.onBoardingSubTitle3,
              ),
            ],
          ),
          OnBoardingSkip(),
          OnBoardingDotNavigation(),
          OnBoardingNextButton()
        ],
      ),
    );
  }
}
