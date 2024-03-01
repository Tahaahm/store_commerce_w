// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:store_commerce_shop/pages/settings/setting_menu_title.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

import '../../constant/widgets/app_bar/custom_appbar.dart';

class AccountPrivacy extends StatelessWidget {
  const AccountPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TAppBar(
              showBackArrow: true,
              title: Text("Account Privacy"),
            ),
            SizedBox(
              height: Dimentions.height32,
            ),
            Padding(
              padding: EdgeInsets.all(Dimentions.width16),
              child: Column(
                children: [
                  TSettingsMenuTitle(
                    icon: Iconsax.personalcard,
                    title: "Customer Support",
                    subTitle: "Assistance whenever you need it",
                  ),
                  SizedBox(height: Dimentions.height16),
                  TSettingsMenuTitle(
                    icon: Iconsax.security_safe,
                    title: "Data Protection",
                    subTitle: "Your privacy is our priority",
                  ),
                  SizedBox(height: Dimentions.height16),
                  TSettingsMenuTitle(
                    icon: Iconsax.safe_home,
                    title: "Secure Access",
                    subTitle: "Keep your account safe",
                  ),
                  SizedBox(height: Dimentions.height16),
                  TSettingsMenuTitle(
                    icon: Iconsax.security_time,
                    title: "Privacy Assurance",
                    subTitle: "We never share your data",
                  ),
                  SizedBox(height: Dimentions.height16),
                  TSettingsMenuTitle(
                    icon: Iconsax.security_user,
                    title: "User Control",
                    subTitle: "Manage your information",
                  ),
                  SizedBox(height: Dimentions.height16),
                  TSettingsMenuTitle(
                    icon: Iconsax.note,
                    title: "Policy Updates",
                    subTitle: "Stay informed about changes",
                  ),
                  SizedBox(height: Dimentions.height16),
                  TSettingsMenuTitle(
                    icon: Iconsax.trend_up,
                    title: "Trusted Partners",
                    subTitle: "Confidentiality with our associates",
                  ),
                  SizedBox(height: Dimentions.height16),
                  TSettingsMenuTitle(
                    icon: Iconsax.transaction_minus,
                    title: "Transparency",
                    subTitle: "Clear practices, clear policies",
                  ),
                  SizedBox(height: Dimentions.height16),
                  TSettingsMenuTitle(
                    icon: Iconsax.language_circle,
                    title: "Legal Compliance",
                    subTitle: "Committed to following regulations",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
