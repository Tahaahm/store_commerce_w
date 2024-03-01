// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:store_commerce_shop/common/widgets/images/t_circular_image.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/pages/home/controller/user_controller.dart';

class TUserProfieTitle extends StatelessWidget {
  const TUserProfieTitle({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return ListTile(
      leading: TCircularImage(
        image:
            "https://cdn3.iconfinder.com/data/icons/men-avatars-2/64/avatar-7-men-user-profile-face-emoji-character-512.png",
        height: 50,
        width: 50,
        isNetworkImage: true,
        padding: 0,
        backgroundColor: TColors.white,
        fit: BoxFit.contain,
      ),
      title: Text(
        controller.user.value.fullName,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .apply(color: TColors.white),
      ),
      subtitle: Text(
        controller.user.value.email,
        style:
            Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),
      ),
      trailing: IconButton(
        onPressed: onPressed,
        icon: Icon(
          Iconsax.edit,
          color: TColors.white,
        ),
      ),
    );
  }
}
