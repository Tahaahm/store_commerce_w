// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_commerce_shop/common/widgets/shimmer/t_shimmer_effect.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.fit = BoxFit.cover,
    required this.image,
    this.isNetworkImage = false,
    this.overlayColor,
    this.backgroundColor,
    this.width = 56,
    this.height = 56,
    required this.padding,
  });
  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      height: width,
      width: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? (dark ? TColors.black : TColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: isNetworkImage
              ? CachedNetworkImage(
                  imageUrl: image,
                  color: overlayColor,
                  fit: fit,
                  progressIndicatorBuilder: (context, url, progress) =>
                      TShimmerEffect(width: 55, height: 55),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
              : Image(
                  image: AssetImage(image),
                  fit: fit,
                  color: overlayColor,
                ),
        ),
      ),
    );
  }
}
