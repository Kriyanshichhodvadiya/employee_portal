import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  PageController onBoardingController = PageController(initialPage: 0);
  RxInt selectedIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void changeScreen(int index) {
    selectedIndex.value = index;
    update();
  }
}
