// ignore_for_file: prefer_const_constructors, deprecated_member_use, sized_box_for_whitespace, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:store_commerce_shop/common/widgets/images/t_rounded_image.dart';
import 'package:store_commerce_shop/common/widgets/layouts/grid_layout.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/constant/widgets/app_bar/custom_appbar.dart';
import 'package:store_commerce_shop/models/cart_model/cart_model.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';

class ViewHistoryPage extends StatelessWidget {
  const ViewHistoryPage({
    super.key,
    required this.cartItems,
    required this.date,
  });
  final List<CartModel> cartItems;
  final String date;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TAppBar(
            title: Text("View Hstory"),
            showBackArrow: true,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              date,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TGirdLayout(
              crossAxisCount: MediaQuery.of(context).size.width > 450 ? 3 : 2,
              mainAxisExtent: Dimentions.pageView316,
              itemCount: cartItems.length,
              itemBuilder: (p0, index) {
                final product = cartItems[index];
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: dark ? TColors.dark : TColors.light,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 50,
                              spreadRadius: 10,
                            )
                          ],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 200,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimentions.height15),
                                  border:
                                      Border.all(color: TColors.primaryColor),
                                ),
                                child: TRoundedImage(
                                  imageUrl: product.product!.imageUrl,
                                  width: double.maxFinite,
                                  fit: BoxFit.contain,
                                  backgroundColor: TColors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.product!.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .apply(
                                            color: dark
                                                ? TColors.white
                                                : Colors.black,
                                          ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          // ignore: unnecessary_string_interpolations
                                          "${product.product!.brand}",
                                          style: TextStyle(
                                            color: dark
                                                ? TColors.white
                                                : Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          // ignore: unnecessary_string_interpolations
                                          "Quantity:${product.quantity}",
                                          style: TextStyle(
                                            color: dark
                                                ? TColors.white
                                                : Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        Text(
                                            product.product!.currency == "USD"
                                                ? "\$"
                                                : "IQD",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .apply(
                                                  color: TColors.primaryColor,
                                                )),
                                        Text(
                                          product.product!.price.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .apply(
                                                color: TColors.primaryColor,
                                              ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ])));
              },
            ),
          ),
        ],
      ),
    ));
  }
}
