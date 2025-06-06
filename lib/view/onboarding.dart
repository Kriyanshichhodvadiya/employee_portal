import 'dart:developer';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/list.dart';
import '../controller/onboarding_controller.dart';
import 'login.dart';

class OnBoarding extends StatelessWidget {
  OnBoarding({super.key});
  OnBoardingController controller = Get.put(OnBoardingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 70.heightBox(),
              child: PageView.builder(
                controller: controller.onBoardingController,
                onPageChanged: (value) {
                  controller.selectedIndex.value = value;
                },
                itemCount: 3,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      50.height,
                      Container(
                        height: 40.heightBox(),
                        color: Colors.transparent,
                        child: Center(
                          child: SvgPicture.asset(
                            onboardingDetail[index]["image"],
                            height: 30.heightBox(),
                            width: 3.widthBox(),
                          ),
                        ),
                      ),
                      20.height,
                      Text(
                        onboardingDetail[index]["title"],
                        textAlign: TextAlign.center,
                        style: poppinsStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primarycolor),
                      ),
                      25.height,
                      Text(
                        onboardingDetail[index]["subtitle"],
                        textAlign: TextAlign.center,
                        style: poppinsStyle(
                          fontSize: 12,
                          color: AppColors.black.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            60.height,
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => AnimatedContainer(
                      height: 5,
                      width: controller.selectedIndex.value == index ? 25 : 8,
                      margin: 2.horizontal,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: controller.selectedIndex.value == index
                              ? AppColors.primarycolor
                              : Colors.grey),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.linear,
                    ),
                  ),
                )),
            15.height,
            Padding(
              padding: 16.horizontal,
              child: primarybutton(
                  onPressed: () async {
                    if (controller.selectedIndex == 2) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('openFirst', true);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    } else {
                      controller.onBoardingController.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeIn);
                      log("curve next index");
                    }
                  },
                  text: "Continue"),
            ),
            20.height,
            RichText(
              text: TextSpan(
                text: 'Skip',
                style: poppinsStyle(
                    color: AppColors.primarycolor,
                    fontSize: 2.3.heightBox(),
                    fontWeight: FontWeight.w500),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('openFirst', true);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
