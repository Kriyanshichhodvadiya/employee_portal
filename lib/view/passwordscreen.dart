import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/controller/forgotpasswordcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/logincommon.dart';
import '../config/color.dart';
import 'admin_side/edit_user/employeeform.dart';

class NewPasswordScreen extends StatelessWidget {
  NewPasswordScreen({super.key});

  ForgotPasswordController controller = Get.find();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: appBar(
        title: '',
        onTap: () => Get.back(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              5.height,
              Center(
                child: Text(
                  "Create a new password",
                  style: poppinsStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primarycolor),
                ),
              ),
              10.height,
              Center(
                child: Text(
                  "Your new password must be different from the previous password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500),
                ),
              ),
              30.height,
              Obx(
                () => logintextfiled(
                  obscureText: controller.showNewPassword.value,
                  suffixIcon: Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.showNewPassword.value =
                            !controller.showNewPassword.value;
                      },
                      child: visibilityIcon(
                        icon: controller.showNewPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  controller: controller.newPasswordController.value,
                  onChanged: (value) {
                    controller.pass.value = value;
                  },
                  text: "Enter Password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Password must have at least one uppercase letter';
                    }
                    if (!RegExp(r'[!@#\$&*~_]').hasMatch(value)) {
                      return 'Password must have at least one special character';
                    }
                    return null;
                  },
                ),
              ),
              10.height,
              // New Password
              Obx(
                () => logintextfiled(
                  obscureText: controller.showConfirmPassword.value,
                  suffixIcon: Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.showConfirmPassword.value =
                            !controller.showConfirmPassword.value;
                      },
                      child: visibilityIcon(
                        icon: controller.showConfirmPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  controller: controller.confirmPasswordController.value,
                  onChanged: (value) {
                    controller.confirmPass.value = value;
                  },
                  text: "Enter Confirm PassWord",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Confirm Password';
                    }
                    if (value != controller.pass.value) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              30.height,

              // Submit Button
              primarybutton(
                text: "Reset Password",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.resetPassword();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
