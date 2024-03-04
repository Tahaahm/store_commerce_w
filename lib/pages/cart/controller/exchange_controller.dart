// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/pages/cart/controller/cart_controller.dart';

class ExchangeRateController extends GetxController {
  static ExchangeRateController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxDouble iqdAmount = RxDouble(0.0);
  RxBool isLoading = RxBool(false); // Add isLoading state
  late Timer _timer; // Declare timer
  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchIqdAmount(false);
    });
  }

  @override
  void onClose() {
    super.onClose();
    // Cancel the timer when the controller is closed to prevent memory leaks
    _timer.cancel();
  }

  Future<void> fetchIqdAmount(bool isFetchng) async {
    try {
      isFetchng
          ? isLoading.value = true
          : null; // Set isLoading to true when fetching
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('exchange').doc('exchange_rates').get();
      if (snapshot.exists) {
        double amount = snapshot.data()?['iqd_amount'] ?? 0.0;
        iqdAmount.value = amount;
        // Update total amount after fetching IQD amount
        CartController.instance.updateTotalAmount();
        print(iqdAmount);
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching iqd_amount: $e');
    } finally {
      isFetchng
          ? isLoading.value = false
          : null; // Set isLoading to false after fetching
    }
  }
}
