// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, unused_element

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:store_commerce_shop/constant/colors.dart';
import 'package:store_commerce_shop/controllers/repository/authentication_repository.dart';
import 'package:store_commerce_shop/authentication/controllers/signup/verify_email_controller.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/constants/text_strings.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';

class VerfiyEmailScreen extends StatefulWidget {
  const VerfiyEmailScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  _VerfiyEmailScreenState createState() => _VerfiyEmailScreenState();
}

class _VerfiyEmailScreenState extends State<VerfiyEmailScreen> {
  late Timer _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void _restartTimer() {
    setState(() {
      _start = 60;
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => AuthenticationRepository.instance.logout(),
            icon: Icon(
              CupertinoIcons.clear,
              color: dark ? TColors.white : TColors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Dimentions.height12),
          child: Column(
            children: [
              Lottie.asset(TImage.verfiy, width: Dimentions.pageView316),
              SizedBox(
                height: Dimentions.height32,
              ),
              Text(
                TText.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: Dimentions.height12,
              ),
              Text(
                widget.email,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: Dimentions.height16,
              ),
              Text(
                TText.confirmEmailSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: Dimentions.height32,
              ),
              SizedBox(
                width: Dimentions.pageView316,
                child: ElevatedButton(
                  onPressed: () => controller.checkEmailVerificationStatus(),
                  child: Text(TText.tContinue),
                ),
              ),
              SizedBox(
                height: Dimentions.height32,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _start == 0
                      ? () => controller.sendEmailVerification()
                      : null,
                  child: Text(
                    _start == 0
                        ? TText.resendEmail
                        : 'Resend in $_start seconds',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
