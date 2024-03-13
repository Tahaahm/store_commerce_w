// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unused_field, avoid_returning_null_for_void, unused_local_variable, body_might_complete_normally_nullable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:store_commerce_shop/authentication/pages/login/login.dart';
import 'package:store_commerce_shop/authentication/pages/signup/verfiy_email.dart';
import 'package:store_commerce_shop/pages/main_page/naviagte_menu.dart';
import 'package:store_commerce_shop/pages/onBoarding/onBoarding.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/ecpectation/firebase_auth_exception.dart';
import 'package:store_commerce_shop/util/ecpectation/firebase_exception.dart';
import 'package:store_commerce_shop/util/ecpectation/format_exception.dart';
import 'package:store_commerce_shop/util/ecpectation/platform_exception.dart';
import 'package:store_commerce_shop/util/popups/full_screen_loaders.dart';
import 'package:store_commerce_shop/util/popups/loaders.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //check from where it comes

  final previousRoute = Get.previousRoute;
  final currentRoute = Get.currentRoute;

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    // FlutterNativeSplash.remove();
    checkPermissionsAndNavigate();
  }

  Future<void> checkPermissionsAndNavigate() async {
    // Check if the necessary permissions are granted
    final permissionStatus = await Permission.storage.status;
    if (permissionStatus.isGranted) {
      // Permissions granted, proceed with redirection
      ScreenRedirct();
    } else {
      // Permissions not granted, request them
      requestPermissions();
    }
  }

  Future<void> requestPermissions() async {
    // Request permissions
    final permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {
      // Permissions granted, proceed with redirection
      ScreenRedirct();
    } else {
      // Permissions denied, handle accordingly

      TLoaders.errorSnackBar(title: "Permission denied");
    }
  }

  //Screen for show relevant Screen
  ScreenRedirct() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        // Check if the user exists in Firestore
        final userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          // User exists in Firestore, navigate to NavigationMenu
          Get.offAll(() => NavigationMenu());
        } else {
          // User does not exist in Firestore, navigate to LoginPage
          Get.offAll(() => LoginPage());
        }
      } else {
        // User's email is not verified, navigate to LoginPage
        Get.offAll(() => VerfiyEmailScreen(
              email: user.email.toString(),
            ));
      }
    } else {
      // User is not logged in, navigate to OnBoardingScreen
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => LoginPage())
          : Get.offAll(() => OnBoardingScreen());
    }
  }

  // [Authentication Email] - SignIn
  Future<UserCredential?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      // Attempt to authenticate the user with email and password
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user exists in Firestore
      final userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userSnapshot.exists) {
        TLoaders.errorSnackBar(title: "The Account has been Deleted ");
        Navigator.of(Get.context!).pop();
        return null;
      }

      // User exists in Firestore, return the UserCredential
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      // Handle FirebaseException
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      // Handle FormatException
      throw TFormatException();
    } on PlatformException catch (e) {
      // Handle PlatformException
      throw TPlatformException(e.code).message;
    } catch (e) {
      // Handle other exceptions
      throw "Something went wrong, please try again";
    }
  }

  // [Authentication Email] - Register
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, please try again";
    }
  }

  // [Authentication Email] - Reautheticate User

  // [Authentication Email] - Mail Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) {
        print("Something went wrong, please try again $e");
        return null;
      }
    }
  }

  // [Authentication Email] - FORGOT PASSWORD
  Future<void> sendPasswordRestEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) {
        print("Something went wrong, please try again $e");
        return null;
      }
    }
  }

  // [Authentication Email] - FACEBOOK

  // LOGOUT --
  Future<void> logout() async {
    try {
      TFullScreenLoader.openLoadingDialog("LogOut...", TImage.processing);
      await FirebaseAuth.instance.signOut();
      TFullScreenLoader.stopLoading();
      Get.offAll(() => LoginPage());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) {
        print("Something went wrong, please try again $e");
        return null;
      }
    }
  }

  Future<void> reAuthenticationWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);

      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) {
        print("Something went wrong, please try again $e");
        return null;
      }
    }
  }

  // DELETE USER
  // Future<void> deleteAccount() async {
  //   try {
  //     await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
  //     await _auth.currentUser!.delete();
  //   } on FirebaseAuthException catch (e) {
  //     throw TFirebaseAuthException(e.code).message;
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw TFormatException();
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Something went wrong, please try again $e");
  //       return null;
  //     }
  //   }
  // }
}
