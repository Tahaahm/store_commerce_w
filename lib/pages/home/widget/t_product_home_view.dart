// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/common/widgets/texts/section_heading.dart';
import 'package:store_commerce_shop/common/widgets/texts/t_product_title_text.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/models/category/category_model.dart';
import 'package:store_commerce_shop/pages/brands/brand_page.dart';
import 'package:store_commerce_shop/pages/home/controller/supcategory_controller.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';

class TProductHomeView extends StatelessWidget {
  const TProductHomeView({
    Key? key,
    required this.supcategoryId,
    required this.supcategoryName,
  }) : super(key: key);

  final String supcategoryId;
  final String supcategoryName;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.find<FetchController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          height: Dimentions.height60,
          decoration: BoxDecoration(
              color: dark ? TColors.dark : TColors.light,
              borderRadius: BorderRadius.circular(Dimentions.height10)),
          child: Padding(
            padding: EdgeInsets.all(Dimentions.height16),
            child: TSectionHeading(
              title: supcategoryName,
            ),
          ),
        ),
        FutureBuilder<List<CategoryModel>>(
          future: controller.fetchCategoriesForSupcategory(supcategoryId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: TColors.primaryColor,
              ));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final categories = snapshot.data ?? [];

            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (categories[index].title.isEmpty) {
                    return Center(
                      child: Text("Empty"),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () => Get.to(() => BrandPage(
                            supcategoryId: supcategoryId,
                            categoryId: categories[index].id,
                            categoryName: categories[index].title,
                          )),
                      child: Container(
                        width: Dimentions.pageView316,
                        height: Dimentions.pageView316,
                        padding: EdgeInsets.all(1),
                        margin: EdgeInsets.all(Dimentions.height15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimentions.height5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: Dimentions.pageView350,
                              height: Dimentions.pageView280 - 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Dimentions.height15,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: categories[index].imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => SpinKitCircle(
                                    color: Colors
                                        .grey, // Placeholder spinner color
                                    size: 50.0, // Placeholder spinner size
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Dimentions.height5,
                            ),
                            Padding(
                              padding: EdgeInsets.all(Dimentions.width10),
                              child: TProductTitleText(
                                title: categories[index].title,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
