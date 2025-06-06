import 'dart:math';

import 'package:employeeform/config/color.dart';
import 'package:employeeform/config/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/splashcontroller.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SplashController splashController = Get.put(SplashController());

    final Size screenSize = MediaQuery.of(context).size;
    final double maxDiameter = sqrt(
      screenSize.width * screenSize.width +
          screenSize.height * screenSize.height,
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: AnimatedBuilder(
        animation: splashController.dotController,
        builder: (context, child) {
          final value = splashController.dotAnimation.value;
          final size = value.clamp(0.0, maxDiameter);
          final opacity = (value / 100).clamp(0.0, 1.0);

          return Center(
            child: Opacity(
              opacity: opacity,
              child: SizedBox(
                height: size,
                width: size,
                child: Image.asset(
                  AppImages.appLogoTrans,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
