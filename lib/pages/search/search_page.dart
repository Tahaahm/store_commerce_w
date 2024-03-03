// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:store_commerce_shop/common/widgets/images/t_rounded_image.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/constant/widgets/app_bar/custom_appbar.dart';
import 'package:store_commerce_shop/models/products/product_model.dart';
import 'package:store_commerce_shop/pages/cart/controller/cart_controller.dart';
import 'package:store_commerce_shop/pages/search/controller/product_search_controller.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/constants/text_strings.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final ProductSearchController productSearchController =
        Get.put(ProductSearchController());

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TAppBar(
            title: Text("Search"),
            showBackArrow: true,
            action: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Icon(
                  Iconsax.search_normal_1,
                  color: dark ? TColors.white : TColors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimentions.height25),
          Container(
            padding: EdgeInsets.all(Dimentions.height20),
            width: double.maxFinite,
            child: TextFormField(
              onChanged: (query) {
                // Capitalize the first letter of the query
                String capitalizedQuery = query.isNotEmpty
                    ? query[0].toUpperCase() + query.substring(1)
                    : '';

                productSearchController.searchProducts(capitalizedQuery);
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.search_normal_1),
                labelText: TText.search,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final bool isLoading = productSearchController.isLoading.value;

              if (isLoading) {
                return Center(
                  child: Lottie.asset(TImage.processing),
                );
              } else {
                final List<ProductModel> searchResults =
                    productSearchController.searchResults;

                if (searchResults.isEmpty) {
                  // Show empty image if search results are empty
                  return SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            TImage
                                .emptyBoxImage, // Replace with your empty image asset path
                            height: 280,
                            width: 280,
                          ),
                          Text(
                            "Empty Searching",
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final ProductModel product = searchResults[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: Dimentions.pageView200,
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin:
                                  EdgeInsets.only(bottom: Dimentions.height10),
                              width: Dimentions.pageView200 - 40,
                              height: Dimentions.pageView200 - 40,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimentions.height45),
                              ),
                              child: TRoundedImage(
                                height: Dimentions.pageView200 - 40,
                                width: Dimentions.pageView200 - 40,
                                imageUrl: product.imageUrl,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product.title,
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
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          product.height.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(" X "),
                                        Text(
                                          product.width.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(" X "),
                                        Text(
                                          product.depth.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                            width: Dimentions.width10 / 10),
                                        Text(
                                          "cm",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Iconsax.verify5,
                                        color: TColors.primaryColor,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        product.brand.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Stock: ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge),
                                          Text(
                                              product.stock.toString() +
                                                  " Stock",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .apply(
                                                      color: product.stock <= 2
                                                          ? TColors.error
                                                          : product.stock <= 5
                                                              ? TColors.warning
                                                              : Colors.green)),
                                        ],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: GestureDetector(
                                            onTap: () {
                                              CartController.instance.addItem(
                                                  product, 1, true, "Search");
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimentions.height20),
                                                color: dark
                                                    ? Colors.black
                                                    : TColors.white,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    width: 125,
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: TColors
                                                            .primaryColor),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            product.currency
                                                                        .toString() ==
                                                                    "USD"
                                                                ? "\$ "
                                                                : "IQD ",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleLarge!
                                                                .apply(
                                                                    color: TColors
                                                                        .white)),
                                                        SizedBox(
                                                          width: Dimentions
                                                              .height60,
                                                          child: Wrap(
                                                            children: [
                                                              Text(
                                                                product.price
                                                                    .toString(),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleLarge!
                                                                    .apply(
                                                                        color: TColors
                                                                            .white),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Dimentions.height10),
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
            }),
          ),
        ],
      ),
    );
  }
}
