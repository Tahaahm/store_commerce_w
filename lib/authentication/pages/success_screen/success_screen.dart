// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:store_commerce_shop/common/style/spacing_style.dart';
import 'package:store_commerce_shop/util/constants/sizes.dart';
import 'package:store_commerce_shop/util/constants/text_strings.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(
      {super.key,
      required this.title,
      required this.image,
      required this.subTtitle,
      required this.onPressed,
      this.isAssets = false});
  final String title, image, subTtitle;
  final void Function()? onPressed;
  final bool isAssets;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpecaingStyle.paddingWithAppBarHeight * 2,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //we are putting condtion if the image is lottie or assets
                isAssets
                    ? Image(
                        image: AssetImage(
                          image,
                        ),
                        width: Dimentions.pageView316,
                      )
                    : Lottie.asset(image, width: Dimentions.pageView316),
                SizedBox(
                  height: TSize.spaceBtwSections,
                ),
                Text(
                  title,
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
                  subTtitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: TSize.spaceBtwSections,
                ),
                SizedBox(
                    width: Dimentions.pageView316,
                    child: ElevatedButton(
                        onPressed: onPressed, child: Text(TText.tContinue))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
