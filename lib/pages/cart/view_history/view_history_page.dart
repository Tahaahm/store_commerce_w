// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, duplicate_ignore, deprecated_member_use

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

    int totalDiscount = 0;
    for (final item in cartItems) {
      totalDiscount = item.discount;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TAppBar(
              title: Text("View History"),
              showBackArrow: true,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(
                      width: 8), // Add some space between date and buyer name
                  Text(
                    cartItems.isNotEmpty
                        ? cartItems.first.buyName ?? ''
                        : '', // Display the buyer name from the first item
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
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
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height15),
                              border: Border.all(color: TColors.primaryColor),
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
                                        color:
                                            dark ? TColors.white : Colors.black,
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
                                        color:
                                            dark ? TColors.white : Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      // ignore: unnecessary_string_interpolations
                                      "Quantity:${product.quantity}",
                                      style: TextStyle(
                                        color:
                                            dark ? TColors.white : Colors.black,
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
                                          ),
                                    ),
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
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          height: Dimentions.height20 * 3.5,
          decoration: BoxDecoration(
            color: dark ? TColors.dark : TColors.light,
            borderRadius: BorderRadius.circular(Dimentions.height12),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Dimentions.width10,
            vertical: Dimentions.height10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      totalDiscount.toString() + " %OFF",
                      style: TextStyle(color: TColors.primaryColor),
                    ),
                    SizedBox(
                      width: Dimentions.height10 / 2,
                    ),
                    Container(
                      padding: EdgeInsets.all(Dimentions.height10),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimentions.height20),
                        color: TColors.primaryColor,
                      ),
                      child: Text(
                        // Display total quantity in the checkout button
                        "${calculateFinalAmount(cartItems)}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(color: TColors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String calculateFinalAmount(List<CartModel> cartItems) {
    double totalAmount = 0;
    int totalDiscount = 0;

    // Calculate total amount and total discount
    for (final item in cartItems) {
      totalAmount += (item.quantity ?? 0) * (item.product!.price);
      totalDiscount = item.discount;
    }

    // Subtract total discount from total amount to get final payable amount
    double finalAmount = totalAmount - (totalAmount * totalDiscount / 100);

    // Round the final amount to two decimal places
    finalAmount = double.parse(finalAmount.round().toString());

    // Return formatted string with total amount and discount
    return "\$$finalAmount";
  }
}
