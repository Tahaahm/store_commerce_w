// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_local_variable

import 'package:flutter/material.dart';

import 'package:store_commerce_shop/common/widgets/custom/home_app_bar.dart';
import 'package:store_commerce_shop/pages/home/widget/gridview_and_listview_home.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimentions.width10),
        child: Column(
          children: [
            SHomeAppBar(),
            SizedBox(
              height: Dimentions.height10,
            ),
            //ListView && GridView
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      Dimentions.height50, // Adjust height as needed
                  child: TGirdViewWithListView(),
                ),
              ),
            ),
            SizedBox(
              height: Dimentions.height10,
            )
          ],
        ),
      ),
    );
  }
}
