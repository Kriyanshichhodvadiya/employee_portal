import 'dart:developer';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/admin_side/bottom_nav_admin.dart';
import '../view/login.dart';
import '../view/onboarding.dart';
import '../view/user/bottom_nav_emp.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController dotController;
  late Animation<double> dotAnimation;

  late AnimationController blinkController;
  late Animation<double> blinkAnimation;

  RxBool showBlink = false.obs;

  @override
  void onInit() {
    super.onInit();

    dotController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    dotAnimation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(parent: dotController, curve: Curves.easeOut),
    );

    blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    blinkAnimation =
        Tween<double>(begin: 0.3, end: 1.0).animate(blinkController);

    dotController.forward();

    dotController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), checkLoginAndNavigate);
      }
    });
  }

  Future<void> checkLoginAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? role = prefs.getString('role');
    bool openFirst = prefs.getBool('openFirst') ?? false;
    String? employeeListString = prefs.getString('employeeData');
    String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

    log("isLoggedIn: $isLoggedIn");
    log("openFirst: $openFirst");
    log("role: $role");
    log("employeeListString: $employeeListString");
    log("loggedInUserSrNo: $loggedInUserSrNo");
    if (openFirst == false) {
      Get.offAll(() => OnBoarding());
    } else {
      if (isLoggedIn == true) {
        if (role == 'admin') {
          Get.offAll(() => BottomNavAdmin());
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const BottomNavAdmin(),
          //   ),
          // );
        } else if (role == 'user') {
          Get.offAll(() => BottomNavEmployee());
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => BottomNavEmployee(),
          //   ),
          // );
        } else {
          Get.offAll(() => Login());
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const Login(),
          //   ),
          // );
        }
      } else {
        Get.offAll(() => Login());
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const Login(),
        //   ),
        // );
      }
    }
  }

  @override
  void onClose() {
    dotController.dispose();
    blinkController.dispose();
    super.onClose();
  }
}
/*
Future.delayed(
  Duration(seconds: 3),
  () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? role = prefs.getString('role');
    bool openFirst = prefs.getBool('openFirst') ?? false;
    String? employeeListString = prefs.getString('employeeData');
    String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

    log("isLoggedIn: $isLoggedIn");
    log("openFirst: $openFirst");
    log("role: $role");
    log("employeeListString: $employeeListString");
    log("loggedInUserSrNo: $loggedInUserSrNo");
    if (openFirst == false) {
      Get.offAll(() => OnBoarding());
    } else {
      if (isLoggedIn == true) {
        if (role == 'admin') {
          Get.offAll(() => BottomNavAdmin());
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const BottomNavAdmin(),
          //   ),
          // );
        } else if (role == 'user') {
          Get.offAll(() => BottomNavEmployee());
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => BottomNavEmployee(),
          //   ),
          // );
        } else {
          Get.offAll(() => Login());
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const Login(),
          //   ),
          // );
        }
      } else {
        Get.offAll(() => Login());
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const Login(),
        //   ),
        // );
      }
    }
  },
);*/
