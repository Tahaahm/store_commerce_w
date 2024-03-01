// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:store_commerce_shop/common/widgets/shimmer/t_list_shimmer.dart';
import 'package:store_commerce_shop/common/widgets/shimmer/t_shimmer_effect.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/models/cart_model/cart_model.dart';
import 'package:store_commerce_shop/models/user_model.dart';
import 'package:store_commerce_shop/pages/cart/repo/cart_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_commerce_shop/pages/cart/view_history/view_history_page.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';

class CartHistoryPage extends StatelessWidget {
  const CartHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart History'),
      ),
      body: FutureBuilder<List<List<CartModel>>>(
        future: CartRepo().fetchCartHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return TListShimmer();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final cartHistoryGroups = snapshot.data!;
            cartHistoryGroups.reversed; // Reverse the list
            if (cartHistoryGroups.isEmpty) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    TImage.emptyBoxImage,
                    height: 250,
                    width: 250,
                  ),
                  Text(
                    "History is empty please to create Invoice it will Authomaticlly added by it self!!",
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ],
              )); // Show empty image
            }
            return _buildCartHistory(cartHistoryGroups);
          }
        },
      ),
    );
  }

  Widget _buildCartHistory(List<List<CartModel>> cartHistoryGroups) {
    return ListView.builder(
      itemCount: cartHistoryGroups.length,
      itemBuilder: (context, index) {
        final cartItems = cartHistoryGroups[index];
        final orderTime = cartItems.first.time ?? '';
        final formattedOrderTime =
            DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.parse(orderTime));

        // Fetch the user associated with this group of cart items
        final userFuture = _fetchUserDetails(cartItems.first.userId ?? '');

        // Check if all cart items in this group have the same time
        final sameTime =
            cartItems.every((cartItem) => cartItem.time == orderTime);
        final dark = THelperFunctions.isDarkMode(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<UserModel>(
                future: userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return TShimmerEffect(
                      width: 150,
                      height: 15,
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final user = snapshot.data!;
                    final userName = user.fullName;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$formattedOrderTime',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: dark ? TColors.white : TColors.black),
                        ),
                        Text(
                          '$userName',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            sameTime
                ? _buildCartItemsRow(cartItems, formattedOrderTime)
                : Column(
                    children: cartItems
                        .map((cartItem) => _buildCartItem(cartItem))
                        .toList(),
                  ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _buildCartItemsRow(
      List<CartModel> cartItems, String formattedOrderTime) {
    final itemCount = cartItems.length;
    final itemsToShow = itemCount > 3 ? cartItems.sublist(0, 3) : cartItems;
    final dark = THelperFunctions.isDarkMode(Get.context!);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: itemsToShow
                        .map((cartItem) => _buildCartItem(cartItem))
                        .toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Total",
                      style: Theme.of(Get.context!).textTheme.titleSmall,
                    ),
                    SizedBox(height: 2),
                    Text("${itemCount.toString()} Items",
                        style: TextStyle(
                            color: dark ? TColors.white : TColors.black,
                            fontSize: 16)),
                    SizedBox(height: 2),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ViewHistoryPage(
                              cartItems: cartItems,
                              date: formattedOrderTime,
                            ));
                      },
                      child: Container(
                        height: 30,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: TColors.primaryColor)),
                        alignment: Alignment.center,
                        child: Text(
                          itemCount.toString() + " More",
                          style: TextStyle(color: TColors.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(CartModel cartItem) {
    return Container(
      width: Dimentions.realWidth150,
      height: Dimentions.realWidth150, // Adjust as needed
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: TColors.primaryColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: cartItem.img!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
              color: TColors.primaryColor,
            ),
          ),
          errorWidget: (context, url, error) => Center(
            child: Text(
              'Image not available',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Future<UserModel> _fetchUserDetails(String userId) async {
    try {
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        if (userData != null) {
          return UserModel.fromJson(userData as Map<String, dynamic>);
        } else {
          throw Exception('User data is null for ID $userId');
        }
      } else {
        // Return a default UserModel with name set to "Unknown"
        return UserModel(
            id: '',
            firstName: 'UnKnow',
            lastName: '',
            username: '',
            email: '',
            role: '');
      }
    } catch (e) {
      throw Exception('Error fetching user details: $e');
    }
  }
}
