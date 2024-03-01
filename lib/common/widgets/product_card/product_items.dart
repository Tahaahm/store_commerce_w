import 'package:flutter/material.dart';
import 'package:store_commerce_shop/common/widgets/product_card/product_cart_vertical.dart';
import 'package:store_commerce_shop/common/widgets/shimmer/t_shimmer_effect.dart';
import 'package:store_commerce_shop/models/products/product_model.dart';
import 'package:store_commerce_shop/pages/cart/controller/cart_controller.dart';

import 'package:store_commerce_shop/pages/home/controller/supcategory_controller.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class TProductItemsDetail extends StatelessWidget {
  const TProductItemsDetail({
    Key? key,
    required this.supcategoryId,
    required this.categoryId,
    required this.brandId,
  }) : super(key: key);

  final String supcategoryId;
  final String categoryId;
  final String brandId;

  @override
  Widget build(BuildContext context) {
    final controller = FetchController.instance;
    return FutureBuilder<List<ProductModel>>(
      future: controller.fetchProductsForBrand(
        supcategoryId,
        categoryId,
        brandId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: double.maxFinite,
            height: Dimentions.pageView316 * 2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.all(Dimentions.height40),
                child: TShimmerEffect(
                    width: Dimentions.pageView316,
                    height: Dimentions.pageView316 * 1.5),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final List<ProductModel> products = snapshot.data!;
          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(TImage.emptyBoxImage,
                      height: Dimentions.pageView200,
                      width: Dimentions.pageView200),
                  SizedBox(
                    height: Dimentions.height20,
                  ),
                  Text(
                    "Empty Box Please try to add product in this Brand",
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          } else {
            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                      onLongPress: () {
                        CartController.instance.addToFavorite(product);
                      },
                      child: TProductCardVertical(product: product));
                });
          }
        } else {
          // Handle other cases
          return Container();
        }
      },
    );
  }
}
