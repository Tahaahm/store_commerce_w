// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, prefer_is_empty, unused_local_variable, unnecessary_null_comparison, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/common/widgets/images/t_rounded_image.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/constant/widgets/app_bar/custom_appbar.dart';
import 'package:store_commerce_shop/models/cart_model/cart_model.dart';
import 'package:store_commerce_shop/pages/cart/controller/cart_controller.dart';
import 'package:store_commerce_shop/pages/cart/controller/exchange_controller.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  int _selectedDiscount = 0;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: Dimentions.width20,
              right: Dimentions.width20,
              height: Dimentions.height35 * 3,
              child: TAppBar(
                title: Text("Shopping Cart"),
                showBackArrow: true,
                action: [
                  GetBuilder<CartController>(
                    builder: (controller) => Text(
                      controller.items.length.toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  PopupMenuButton<String>(
                    icon: Obx(() {
                      final isLoading =
                          ExchangeRateController.instance.isLoading.value;
                      final iqdAmount =
                          ExchangeRateController.instance.iqdAmount.value;
                      return Row(
                        children: [
                          Text(
                            "IQD: ${isLoading ? 'Loading...' : iqdAmount.toString()}",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: dark ? TColors.white : TColors.black,
                          ),
                        ],
                      );
                    }),
                    onSelected: (String value) {
                      if (value == 'iqd') {
                        // Call a function to refresh the IQD amount here
                        ExchangeRateController.instance.fetchIqdAmount();
                        CartController.instance.updateTotalAmount();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'iqd',
                        child: Text(
                          'Refresh',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //629
            Positioned(
              top: Dimentions.height40 * 2.5,
              left: Dimentions.width20,
              right: Dimentions.width20,
              bottom: 0,
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: Container(
                    margin: EdgeInsets.only(top: Dimentions.height15),
                    child: GetBuilder<CartController>(
                      builder: (cartController) {
                        List<CartModel> cartItems = cartController.items;
                        if (cartItems.length <= 0) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                TImage.emptyBoxImage,
                                height: Dimentions.pageView200,
                                width: Dimentions.pageView200,
                              ),
                              SizedBox(
                                height: Dimentions.height20,
                              ),
                              Text(
                                "The Cart is Empty please add some product in the cart",
                                style: Theme.of(context).textTheme.titleSmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        } else {
                          return ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                height: Dimentions.pageView200,
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: Dimentions.height10),
                                        width: Dimentions.pageView200 - 40,
                                        height: Dimentions.pageView200 - 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimentions.height45),
                                        ),
                                        child: TRoundedImage(
                                          height: Dimentions.pageView200 - 40,
                                          width: Dimentions.pageView200 - 40,
                                          imageUrl: cartItems[index].img!,
                                          applyImageRadius: true,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: Dimentions.width10),
                                    Expanded(
                                      child: Container(
                                        height: Dimentions.pageViewWidth100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              cartItems[index].name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Expanded(
                                              child: Wrap(
                                                children: [
                                                  Text(
                                                    "- ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    cartItems[index]
                                                        .product!
                                                        .height
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(" X "),
                                                  Text(
                                                    cartItems[index]
                                                        .product!
                                                        .width
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(" X "),
                                                  Text(
                                                    cartItems[index]
                                                        .product!
                                                        .depth
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          Dimentions.width10 /
                                                              10),
                                                  Text(
                                                    "cm",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              cartItems[index]
                                                  .product!
                                                  .brand
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        cartItems[index]
                                                                    .product!
                                                                    .currency
                                                                    .toString() ==
                                                                "USD"
                                                            ? "\$ "
                                                            : "IQD ",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .apply(
                                                                color: TColors
                                                                    .error)),
                                                    SizedBox(
                                                      width:
                                                          Dimentions.height60,
                                                      child: Wrap(
                                                        children: [
                                                          Text(
                                                            cartItems[index]
                                                                .price
                                                                .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleLarge!
                                                                .apply(
                                                                    color: TColors
                                                                        .error),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    width:
                                                        Dimentions.pageView200 -
                                                            80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Dimentions
                                                                  .height20),
                                                      color: dark
                                                          ? Colors.black
                                                          : TColors.white,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            cartController
                                                                .decreaseQuantity(
                                                                    cartItems[
                                                                        index]);
                                                          },
                                                          child: Container(
                                                            width: Dimentions
                                                                .height35,
                                                            padding: EdgeInsets
                                                                .all(Dimentions
                                                                        .height10 /
                                                                    2),
                                                            decoration: BoxDecoration(
                                                                color: dark
                                                                    ? TColors
                                                                        .dark
                                                                    : TColors
                                                                        .white,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimentions
                                                                            .height16)),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: dark
                                                                    ? TColors
                                                                        .white
                                                                    : TColors
                                                                        .primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: Dimentions
                                                              .width10,
                                                        ),
                                                        Text(cartItems[index]
                                                            .quantity
                                                            .toString()),
                                                        SizedBox(
                                                          width: Dimentions
                                                              .width10,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            cartController
                                                                .increaseQuantity(
                                                                    cartItems[
                                                                        index]);
                                                          },
                                                          child: Container(
                                                            width: Dimentions
                                                                .height35,
                                                            padding: EdgeInsets
                                                                .all(Dimentions
                                                                        .height10 /
                                                                    2),
                                                            decoration: BoxDecoration(
                                                                color: dark
                                                                    ? Colors
                                                                        .black
                                                                    : TColors
                                                                        .primaryColor,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimentions
                                                                            .height16)),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.add,
                                                                color: dark
                                                                    ? TColors
                                                                        .primaryColor
                                                                    : TColors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: Dimentions.height10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    )),
              ),
            ),
          ],
        ),
        bottomNavigationBar: GetBuilder<CartController>(
          builder: (controller) {
            final finacial = ExchangeRateController.instance;
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: Dimentions.height20 * 6,
                decoration: BoxDecoration(
                  color: dark ? TColors.dark : TColors.light,
                  borderRadius: BorderRadius.circular(Dimentions.height12),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimentions.width10,
                  vertical: Dimentions.height30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      return SizedBox(
                        width: Dimentions.pageView200 - 80,
                        child: Container(
                          padding: EdgeInsets.all(Dimentions.width20),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimentions.height20),
                            color: dark
                                ? TColors.darkGrey.withOpacity(0.4)
                                : Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              "\$" +
                                  "${calculateDiscountedTotal(_selectedDiscount, controller.getTotalAmount())}",
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      width: Dimentions.height5,
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButton<int>(
                            value: _selectedDiscount,
                            onChanged: (int? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedDiscount = newValue;
                                });
                              }
                            },
                            items: List.generate(16, (index) => index)
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(
                                  value.toString() + " %OFF",
                                  style: TextStyle(color: TColors.primaryColor),
                                ),
                              );
                            }).toList(),
                            underline: Container(),
                            icon: Icon(Icons.arrow_drop_down,
                                color: TColors.primaryColor),
                          ),
                          SizedBox(width: Dimentions.height10),
                          GestureDetector(
                            onTap: () async {
                              controller
                                  .deleteAccountWarningPopup(_selectedDiscount);
                            },
                            child: Container(
                              padding: EdgeInsets.all(Dimentions.width20),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimentions.height20),
                                color: TColors.primaryColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Check Out",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .apply(color: TColors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  String calculateDiscountedTotal(int selectedDiscount, double totalNumber) {
    double originalTotal = totalNumber; // Replace this with the actual total
    double discountPercentage = (100 - selectedDiscount) / 100;
    double discountedTotal = originalTotal * discountPercentage;
    return discountedTotal
        .round()
        .toString(); // Round the discounted total to the nearest integer value
  }
}
