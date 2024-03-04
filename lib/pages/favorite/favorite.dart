// ignore_for_file: prefer_const_constructors, deprecated_member_use, unnecessary_string_interpolations, await_only_futures

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:store_commerce_shop/common/widgets/images/t_rounded_image.dart';
import 'package:store_commerce_shop/common/widgets/layouts/grid_layout.dart';
import 'package:store_commerce_shop/common/widgets/shimmer/t_list_shimmer.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/constant/widgets/app_bar/custom_appbar.dart';
import 'package:store_commerce_shop/models/products/product_model.dart';
import 'package:store_commerce_shop/pages/cart/controller/cart_controller.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';
import 'package:store_commerce_shop/util/popups/loaders.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<ProductModel>> _favoriteProductsFuture;

  @override
  void initState() {
    super.initState();
    _refreshFavoriteProducts();
  }

  Future<void> _refreshFavoriteProducts() async {
    setState(() {
      _favoriteProductsFuture = CartController.instance.getFavoriteProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Column(
        children: [
          TAppBar(
            title: Text("Favorites"),
          ),
          SizedBox(height: Dimentions.height12),
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: _favoriteProductsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return TListShimmer();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final favoriteProducts = snapshot.data!;
                  if (favoriteProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            TImage.emptyBoxImage,
                            height: Dimentions.pageView200,
                          ),
                          SizedBox(height: Dimentions.height20),
                          Text("No favorite products"),
                        ],
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      child:
                          _buildFavoriteList(favoriteProducts, context, dark),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteList(
      List<ProductModel> favoriteProducts, BuildContext context, dark) {
    return TGirdLayout(
      crossAxisCount: MediaQuery.of(context).size.width > 450 ? 3 : 1,
      itemCount: favoriteProducts.length,
      mainAxisExtent: Dimentions.pageView400,
      itemBuilder: (context, index) {
        final ProductModel product = favoriteProducts[index];
        return _buildFavoriteProductCard(product, context, dark);
      },
    );
  }

  Widget _buildFavoriteProductCard(
      ProductModel product, BuildContext context, dark) {
    return Padding(
      padding: MediaQuery.of(context).size.width > 450
          ? const EdgeInsets.all(8.0)
          : EdgeInsets.all(16),
      child: GestureDetector(
        onLongPress: () {
          CartController.instance.removeFromFavorite(product);
          _refreshFavoriteProducts();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: dark ? TColors.black : TColors.light,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                width: double.maxFinite,
                child: Stack(
                  children: [
                    TRoundedImage(
                      imageUrl: product.imageUrl,
                      borderRadius: 12,
                      width: double.maxFinite,
                      fit: BoxFit.contain,
                      backgroundColor: TColors.white,
                    ),
                    Positioned(
                      right: 10,
                      top: 5,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: TColors.light,
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: TColors.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .apply(color: dark ? Colors.white : Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Iconsax.verify5,
                          color: TColors.primaryColor,
                          size: 18,
                        ),
                        Text(
                          "${product.brand}",
                          style: TextStyle(
                              color: dark ? Colors.white : Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Dimension: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .apply(
                                      color:
                                          dark ? Colors.white : Colors.black),
                            ),
                            Text(
                              "${product.height} X ${product.width} X ${product.depth}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .apply(
                                    color: dark ? Colors.white : Colors.black,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "Power: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .apply(
                                      color:
                                          dark ? Colors.white : Colors.black),
                            ),
                            Text(
                              "${product.power} KW",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .apply(
                                    color: dark ? Colors.white : Colors.black,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimentions.height15,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          TLoaders.warningSnackBar(
                              title: "Oh Snap!",
                              message:
                                  "Cant add product from Favorite to cart");
                        },
                        child: SizedBox(
                          width: Dimentions.height60 * 3,
                          height: Dimentions.height50,
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.primaryColor,
                              borderRadius: BorderRadius.circular(
                                Dimentions.height15,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimentions.height10,
                                vertical: Dimentions.height5,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    product.currency == "USD" ? "\$ " : "IQD ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .apply(color: TColors.white),
                                  ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
