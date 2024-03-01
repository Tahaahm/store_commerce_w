import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();
  final _storage = GetStorage();
  final _themeModeKey = 'themeMode';

  @override
  void onInit() {
    super.onInit();
    // Retrieve the theme mode stored in get_storage when the app starts
    _retrieveThemeMode();
  }

  // Method to change the theme mode
  void changeThemeMode(bool isDarkMode) {
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    // Save the current theme mode in get_storage
    _storage.write(_themeModeKey, isDarkMode);
  }

  // Method to retrieve the stored theme mode from get_storage
  void _retrieveThemeMode() {
    final isDarkMode = _storage.read(_themeModeKey) ?? false;
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
