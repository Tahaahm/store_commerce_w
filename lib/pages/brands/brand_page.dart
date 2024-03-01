// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:store_commerce_shop/common/widgets/layouts/grid_layout.dart';
import 'package:store_commerce_shop/common/widgets/shimmer/t_list_shimmer.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/constant/widgets/app_bar/custom_appbar.dart';
import 'package:store_commerce_shop/models/brand/brand.dart';
import 'package:store_commerce_shop/pages/detail/detail.dart';
import 'package:store_commerce_shop/pages/home/controller/supcategory_controller.dart';
import 'package:store_commerce_shop/pages/settings/setting_menu_title.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class BrandPage extends StatelessWidget {
  const BrandPage({
    Key? key,
    required this.supcategoryId,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  final String supcategoryId;
  final String categoryId;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    final controller = FetchController.instance;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimentions.height12),
        child: Column(
          children: [
            TAppBar(
              title: Text("Brands",
                  style: Theme.of(context).textTheme.headlineMedium!),
              showBackArrow: true,
            ),
            Expanded(
              child: FutureBuilder<List<BrandModel>>(
                future: controller.fetchBrandsForCategory(
                    supcategoryId, categoryId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return TListShimmer();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final brands = snapshot.data ?? [];
                    if (brands.isEmpty) {
                      return Center(
                        child: Text("There is no Brand"),
                      );
                    } else {
                      return RefreshIndicator(
                        color: TColors.primaryColor,
                        onRefresh: () async {
                          await controller.fetchBrandsForCategory(
                              supcategoryId, categoryId);
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: TGirdLayout(
                            crossAxisCount: 1,
                            itemCount: brands.length,
                            itemBuilder: (p0, index) {
                              final BrandModel brand = brands[index];
                              return GestureDetector(
                                onTap: () => Get.to(() => DetailPage(
                                      supcategoryId: supcategoryId,
                                      categoryId: categoryId,
                                      brandId: brand.id,
                                      categoryName: categoryName,
                                    )),
                                child: Padding(
                                  padding: EdgeInsets.all(Dimentions.height15),
                                  child: TSettingsMenuTitle(
                                    icon: Iconsax.language_square,
                                    title: brand.title,
                                    subTitle:
                                        "View the ${brand.title} brand and check what is in there",
                                  ),
                                ),
                              );
                            },
                            mainAxisExtent: 100,
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
