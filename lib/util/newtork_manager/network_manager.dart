// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_field, unused_local_variable

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/util/popups/loaders.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _streamSubscription;
  final Rx<ConnectivityResult> _connectivityResult =
      ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectivityResult.value = result;
    if (_connectivityResult.value == ConnectivityResult.none) {
      TLoaders.warningSnackBar(
          title: "No Inernet Connection",
          message: "Please first connect to the Wifi and then try to loading");
    }
  }

  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        return false;
      } else {
        return true;
      }
    } on PlatformException catch (_) {
      return false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    _streamSubscription.cancel();
  }
}
