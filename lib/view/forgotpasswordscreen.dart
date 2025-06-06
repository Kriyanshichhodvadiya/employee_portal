import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/controller/forgotpasswordcontroller.dart';
import 'package:employeeform/view/otpscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/logincommon.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final ForgotPasswordController controller =
      Get.put(ForgotPasswordController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Add this
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: appBar(
        title: "",
        onTap: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                5.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Reset Your Password",
                        style: poppinsStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primarycolor,
                        ),
                      ),
                    ),
                    10.height,
                    Center(
                      child: Text(
                        "Please enter your registered email address. We'll send you an OTP to reset your password.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    30.height,
                    Text(
                      "Email Address",
                      style:
                          poppinsStyle(color: AppColors.hinttext, fontSize: 12),
                    ),
                    5.height,
                    logintextfiled(
                      controller: controller.emailController.value,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.email,
                        size: 18,
                      ),
                      text: "Enter Email",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        RegExp emailRegExp = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$');
                        if (!emailRegExp.hasMatch(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                      /* decoration: InputDecoration(
                        labelText: "Email Address",
                        hintText: "example@email.com",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),*/
                    ),
                    30.height,
                    primarybutton(
                      text: "Continue",
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          String email =
                              controller.emailController.value.text.trim();
                          Get.to(() => OTPScreen(),
                              arguments: {'email': email});
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
