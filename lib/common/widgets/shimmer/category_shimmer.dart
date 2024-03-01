// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:store_commerce_shop/common/widgets/shimmer/t_shimmer_effect.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class TCategoryShimmer extends StatelessWidget {
  const TCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: [
              TShimmerEffect(
                width: 55,
                height: 55,
                radius: 55,
              ),
              SizedBox(
                height: Dimentions.height16,
              ),
              TShimmerEffect(width: 55, height: 8),
            ],
          );
        },
        separatorBuilder: (context, index) => SizedBox(
          width: Dimentions.width16,
        ),
        itemCount: 6,
      ),
    );
  }
}
