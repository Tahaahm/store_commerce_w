// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/models/user_model.dart';
import 'package:store_commerce_shop/repository/user_repository/user.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    // Fetch user record initially
    fetchUserRecord();
    // Start periodic fetch every 30 seconds
  }

  Rx<UserModel> user = UserModel.empty().obs;
  final profileLoading = false.obs;

  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final fetchedUser = await UserRepository.instance.fetchUserDetails();
      user(fetchedUser);
      print(fetchedUser.toJson());
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }
}
