// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/common/widgets/layouts/grid_layout.dart';
import 'package:store_commerce_shop/common/widgets/shimmer/t_list_shimmer.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/pages/home/controller/supcategory_controller.dart';
import 'package:store_commerce_shop/pages/home/widget/t_product_home_view.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class TGirdViewWithListView extends StatelessWidget {
  const TGirdViewWithListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FetchController());

    return Obx(() {
      final isLoading = controller.isLoading.value;
      final supcategories = controller.supcategories;

      return RefreshIndicator(
        color: TColors.primaryColor,
        onRefresh: () async {
          await controller.fetchSupcategories();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              if (isLoading)
                TGirdLayout(
                  itemCount: 3,
                  itemBuilder: (context, index) =>
                      TListShimmer(isVertical: false),
                  mainAxisExtent: Dimentions.pageView316,
                ),
              if (!isLoading && supcategories.isEmpty)
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No supcategories found.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              if (!isLoading && supcategories.isNotEmpty)
                TGirdLayout(
                  itemCount: supcategories.length,
                  itemBuilder: (context, index) {
                    final supcategory = supcategories[index];
                    return TProductHomeView(
                      supcategoryId: supcategory.id,
                      supcategoryName: supcategory.title,
                    );
                  },
                  mainAxisExtent: Dimentions.pageView400,
                ),
              SizedBox(height: Dimentions.height60 * 3),
            ],
          ),
        ),
      );
    });
  }
}
