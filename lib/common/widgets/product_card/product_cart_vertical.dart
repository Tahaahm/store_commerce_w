// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, unrelated_type_equality_checks, sized_box_for_whitespace, deprecated_member_use, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:store_commerce_shop/common/widgets/container/rounded_container.dart';
import 'package:store_commerce_shop/common/widgets/images/t_rounded_image.dart';
import 'package:store_commerce_shop/common/widgets/texts/t_product_title_text.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/models/products/product_model.dart';
import 'package:store_commerce_shop/pages/cart/controller/product_controller.dart';
import 'package:store_commerce_shop/util/constants/sizes.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({
    super.key,
    required this.product,
  });
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(ProductController());
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Dimentions.pageView400,
        padding: EdgeInsets.all(1),
        margin: EdgeInsets.all(Dimentions.height8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSize.productImageRaduis),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      TRoundedContainer(
                        width: Dimentions.pageView350,
                        height: Dimentions.pageView280,
                        backgroundColor: Colors.white,
                        borderColor: TColors.darkGrey.withOpacity(0.2),
                        showBorder: true,
                        radius: Dimentions.height16,
                        child: Stack(
                          children: [
                            Center(
                              child: TRoundedImage(
                                height: double.maxFinite,
                                width: double.maxFinite,
                                imageUrl: product.imageUrl,
                                applyImageRadius: true,
                                fit: BoxFit.cover,
                              ),
                            ),

                            //
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimentions.height5,
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: Dimentions.height8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TProductTitleText(
                            title: product.title,
                          ),
                          SizedBox(
                            height: Dimentions.height8,
                          ),
                          Row(
                            children: [
                              Text(
                                product.brand,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              SizedBox(
                                width: TSize.xs,
                              ),
                              Icon(
                                Iconsax.verify5,
                                color: TColors.primaryColor,
                                size: TSize.iconXs,
                              ),
                              SizedBox(
                                height: Dimentions.height5,
                              ),
                            ],
                          ),
                          if (product.depth != 0 ||
                              product.height != 0 ||
                              product.weight != 0)
                            Row(
                              children: [
                                Text(
                                  "- ",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  product.height.toString(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(" X "),
                                Text(
                                  product.width.toString(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(" X "),
                                Text(
                                  product.depth.toString(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SizedBox(
                                  width: Dimentions.width10,
                                ),
                                Text("cm",
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              ],
                            ),
                          SizedBox(
                            height: Dimentions.height10,
                          ),
                          if (product.power != 0 || product.volume != 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (product.power != 0)
                                  Row(
                                    children: [
                                      Text(
                                        "- ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      Text(
                                        "Power ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      Icon(
                                        Iconsax.electricity,
                                      ),
                                      Text(
                                        product.power.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        width: Dimentions.height10 / 5,
                                      ),
                                      Text(
                                        "KW",
                                        style: TextStyle(fontSize: 9),
                                      ),
                                    ],
                                  ),
                                if (product.volume != 0)
                                  Row(
                                    children: [
                                      Text(
                                        "Liter ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      Icon(Iconsax.glass),
                                      Text(
                                        product.volume.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        width: Dimentions.height10 / 5,
                                      ),
                                      Text(
                                        "L",
                                        style: TextStyle(fontSize: 9),
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  width: Dimentions.height10,
                                ),
                              ],
                            ),
                          SizedBox(
                            height: Dimentions.height10,
                          ),
                          if (product.weight != 0 ||
                              product.material.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (product.power != 0)
                                  Row(
                                    children: [
                                      Text(
                                        "- ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      Text(
                                        "Weight ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      Icon(
                                        Iconsax.weight,
                                      ),
                                      Text(
                                        product.weight.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        width: Dimentions.height10 / 5,
                                      ),
                                      Text(
                                        "Kg",
                                        style: TextStyle(fontSize: 9),
                                      ),
                                    ],
                                  ),
                                if (product.material != 0)
                                  Row(
                                    children: [
                                      Text(
                                        "Material ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      Icon(Iconsax.code_1),
                                      SizedBox(
                                        width: Dimentions.height45,
                                        child: Text(
                                          product.material.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Dimentions.height10 / 5,
                                      ),
                                      Text(
                                        "P",
                                        style: TextStyle(fontSize: 9),
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  width: Dimentions.height10,
                                ),
                              ],
                            ),
                          Expanded(
                            flex: 1,
                            child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: product.description.length,
                              itemBuilder: (context, index) {
                                final descriptionLines =
                                    product.description[index].split('\n');
                                return Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var lineIndex = 0;
                                          lineIndex < descriptionLines.length;
                                          lineIndex++)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              lineIndex == 0
                                                  ? "• "
                                                  : "  ", // Add the dot for the first line only
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                            ),
                                            SizedBox(width: Dimentions.width10),
                                            Expanded(
                                              child: Text(
                                                descriptionLines[lineIndex],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      SizedBox(
                                        height: Dimentions.height10 / 2,
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text("Stock: ",
                          style: Theme.of(context).textTheme.headlineSmall),
                      Text(product.stock.toString() + " In the Stock",
                          style: Theme.of(context).textTheme.titleMedium!.apply(
                              color: product.stock <= 2
                                  ? TColors.error
                                  : product.stock <= 5
                                      ? TColors.warning
                                      : Colors.green)),
                      product.stock <= 2
                          ? Text(" (Low)",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .apply(color: TColors.error))
                          : product.stock <= 5
                              ? Text(" (Medium)",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .apply(color: TColors.warning))
                              : Text(" (Very Good)",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .apply(color: TColors.success))
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(Dimentions.height12),
                  child: SizedBox(
                    width: Dimentions.height60 * 3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: product.stock == 0
                              ? TColors.primaryColor.withOpacity(0.5)
                              : TColors.primaryColor),
                      onPressed: () {
                        cartController.addToCart(product, 1);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimentions.height10,
                            vertical: Dimentions.height5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(product.currency == "USD" ? "\$ " : "IQD ",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .apply(color: TColors.white)),
                            Text(
                              product.price.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .apply(color: TColors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
