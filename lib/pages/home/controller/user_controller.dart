// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/models/user_model.dart';
import 'package:store_commerce_shop/repository/user_repository/user.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecrod();
  }

  Rx<UserModel> user = UserModel.empty().obs;
  final profileLoading = false.obs;

  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  Future<void> fetchUserRecrod() async {
    try {
      profileLoading.value = true;
      final user = await UserRepository.instance.fetchUserDetails();
      this.user(user);
      print(user.toJson());
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }
}
