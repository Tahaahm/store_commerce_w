// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:store_commerce_shop/common/widgets/shimmer/t_shimmer_effect.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class TListShimmer extends StatelessWidget {
  const TListShimmer({
    super.key,
    this.isVertical = true,
  });
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
      shrinkWrap: true,
      itemCount: 7,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(Dimentions.height12),
          child: TShimmerEffect(
              width: Dimentions.width40 * 8, height: Dimentions.height60),
        );
      },
    );
  }
}
