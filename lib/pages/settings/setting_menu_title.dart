// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:store_commerce_shop/util/constants/colors.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class TSettingsMenuTitle extends StatelessWidget {
  const TSettingsMenuTitle(
      {super.key,
      required this.icon,
      required this.title,
      required this.subTitle,
      this.trailing,
      this.onTap});
  final IconData icon;
  final String title, subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: Dimentions.height30 - 2,
        color: TColors.primaryColor,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        subTitle,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
