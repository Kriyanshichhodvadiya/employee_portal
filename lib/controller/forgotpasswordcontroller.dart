// controllers/forgot_password_controller.dart
import 'dart:async';

import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/view/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> newPasswordController = TextEditingController().obs;
  Rx<TextEditingController> pinController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController =
      TextEditingController().obs;
  RxString pass = "".obs;
  RxString confirmPass = "".obs;
  RxBool showNewPassword = true.obs;
  RxBool showConfirmPassword = true.obs;
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  var secondsRemaining = 59.obs;
  Timer? timer;
  void startTimer() {
    secondsRemaining.value = 59;
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void resendCode() {
    startTimer();
  }

  void onOTPCompleted() {
    final otp = otpControllers.map((e) => e.text).join();
    if (otp.length == 4) {
      // primaryToast(msg: "OTP Entered: $otp");
      // primaryToast(msg: "Verify Successfully");
    }
  }

  void resetPassword() {
    final newPassword = newPasswordController.value.text;
    final confirmPassword = confirmPasswordController.value.text;

    primaryToast(
      msg: "Password updated successfully",
    );
    otpControllers.forEach((c) => c.clear());
    newPasswordController.value.clear();
    confirmPasswordController.value.clear();
    Get.offAll(() => Login());
  }

  @override
  void onClose() {
    timer?.cancel();
    emailController.value.dispose();
    newPasswordController.value.dispose();
    confirmPasswordController.value.dispose();
    super.onClose();
  }
}
