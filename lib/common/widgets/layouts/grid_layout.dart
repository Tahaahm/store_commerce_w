// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class TGirdLayout extends StatelessWidget {
  const TGirdLayout({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    required this.mainAxisExtent,
    this.childAspectRatio = 1.0,
    this.crossAxisCount = 1,
  }) : super(key: key);

  final int itemCount;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuilder;
  final double childAspectRatio;
  final int crossAxisCount;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisExtent: mainAxisExtent,
          mainAxisSpacing: Dimentions.height16,
          crossAxisSpacing: Dimentions.height16,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: itemCount,
        itemBuilder: itemBuilder);
  }
}
