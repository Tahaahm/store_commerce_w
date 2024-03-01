// ignore_for_file: deprecated_member_use, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class RowCustomWidget extends StatelessWidget {
  const RowCustomWidget({
    super.key,
    required this.title,
    required this.child,
  });
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "•",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(
          width: Dimentions.width10,
        ),
        Text(title, style: Theme.of(context).textTheme.headline6),
        SizedBox(
          width: Dimentions.width10,
        ),
        Container(width: Dimentions.pageView280, child: child),
      ],
    );
  }
}
