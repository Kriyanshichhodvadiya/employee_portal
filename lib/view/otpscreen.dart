import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/controller/forgotpasswordcontroller.dart';
import 'package:employeeform/view/passwordscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../config/color.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  ForgotPasswordController controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    controller.startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var email = Get.arguments != null ? Get.arguments['email'] ?? '' : '';
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: TextStyle(fontSize: 24, color: Colors.black),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBar(
        title: '',
        onTap: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.height,
              Center(
                child: Text(
                  "OTP Verification",
                  style: poppinsStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primarycolor,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: 20.horizontal,
                child: Center(
                  child: Text(
                    "we have sent the OTP verification code to your email address. Check your email and enter the code below.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Code sent to:",
                style: poppinsStyle(fontSize: 14, color: Colors.black54),
              ),

              Text(
                email,
                style: poppinsStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black),
              ),
              25.height,
              Center(
                child: Pinput(
                  controller: controller.pinController.value,
                  separatorBuilder: (index) => const SizedBox(width: 8),
                  validator: (value) {
                    // return value == '2222' ? null : 'Pin is incorrect';
                  },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) {
                    debugPrint('onCompleted: $pin');
                  },
                  onChanged: (value) {
                    debugPrint('onChanged: $value');
                  },
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        width: 22,
                        height: 1,
                        color: AppColors.primarycolor, // Cursor color
                      ),
                    ],
                  ),
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primarycolor),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primarycolor),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
              Obx(
                () => Visibility(
                  visible: controller.secondsRemaining.value == 0,
                  child: Center(
                    child: Text(
                      "If you didn't receive a code",
                      style: poppinsStyle(
                        fontSize: 15,
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),

              Center(
                child: Obx(() {
                  return controller.secondsRemaining.value == 0
                      ? GestureDetector(
                          onTap: () {
                            controller.resendCode();
                          },
                          child: Padding(
                            padding: 5.vertical,
                            child: Text(
                              "Resend OTP",
                              style: poppinsStyle(
                                color: AppColors.primarycolor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            style: poppinsStyle(
                                fontSize: 15, color: AppColors.hinttext),
                            children: [
                              TextSpan(text: "You can resend code in "),
                              TextSpan(
                                text: controller.secondsRemaining.value
                                    .toString(),
                                style:
                                    poppinsStyle(color: AppColors.primarycolor),
                              ),
                              TextSpan(text: " s"),
                            ],
                          ),
                        );
                }),
              ),
              SizedBox(height: 12),
              // Center(
              //   child: Obx(() {
              //     return RichText(
              //       text: TextSpan(
              //         style:
              //             poppinsStyle(fontSize: 15, color: AppColors.hinttext),
              //         children: [
              //           TextSpan(text: "You can resend code in "),
              //           TextSpan(
              //             text: controller.secondsRemaining.value.toString(),
              //             style: poppinsStyle(color: AppColors.primarycolor),
              //           ),
              //           TextSpan(text: " s"),
              //         ],
              //       ),
              //     );
              //   }),
              // ),
              30.height,
              primarybutton(
                onPressed: () {
                  final otp = controller.pinController.value.text.trim();

                  if (controller.secondsRemaining.value == 0) {
                    primaryToast(msg: "OTP expired. Please resend the code.");
                  } else if (otp.isEmpty) {
                    primaryToast(msg: "Please enter the OTP.");
                  } else if (otp.length < 4) {
                    primaryToast(msg: "Please enter all 4 digits of the OTP.");
                  } else {
                    // Add your own OTP check here if needed, e.g., match a fixed code
                    // if (otp != '1234') {
                    //   primaryToast(msg: "Invalid OTP.");
                    //   return;
                    // }

                    primaryToast(msg: "Verified successfully");
                    Get.to(() => NewPasswordScreen());
                  }
                },

                // onPressed: () {
                //   final otp = controller.otpControllers
                //       .map((c) => c.text.trim())
                //       .join();
                //
                //   if (otp.length == 4) {
                //     if (controller.secondsRemaining.value > 0) {
                //       primaryToast(msg: "Verify Successfully");
                //       Get.to(() => NewPasswordScreen());
                //     } else {
                //       primaryToast(msg: "OTP expired. Please resend the code.");
                //     }
                //   } else {
                //     primaryToast(msg: "Please enter all 4 digits of the OTP.");
                //   }
                // },
                text: "Verify",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
