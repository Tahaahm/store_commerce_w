// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:store_commerce_shop/constant/colors.dart';

class TOutlineButtonTheme {
  TOutlineButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.black,
          side: BorderSide(
            color: TColors.primaryColor,
          ),
          textStyle: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
  static final darkOutlineButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          side: BorderSide(
            color: TColors.primaryColor,
          ),
          textStyle: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))));
}
