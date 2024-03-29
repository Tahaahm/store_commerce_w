// ignore_for_file: avoid_print, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/constant/general_bindings.dart';
import 'package:store_commerce_shop/controllers/repository/authentication_repository.dart';
import 'package:store_commerce_shop/firebase_options.dart';
import 'package:store_commerce_shop/util/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';

//store-commerce-shop   this is the name of firebase database from the cloud for both admin and the store
//store called admin_store_commerce_shop  this is the project flutter we are linked together

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));
  // Storage
  await GetStorage.init();
  // Check

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      home: Scaffold(
        backgroundColor: TColors.primaryColor,
        body: Center(
          child: CircularProgressIndicator(
            color: TColors.white,
          ),
        ),
      ),
    );
  }
}
