import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/controller/admin_reg_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../common/global_widget.dart';
import '../config/color.dart';
import '../config/images.dart';
import 'admin_side/bottom_nav_admin.dart';
import 'admin_side/edit_user/employeeform.dart';

class AdminReg extends StatelessWidget {
  AdminReg({super.key});
  AdminRegController controller = Get.put(AdminRegController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      /*  appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        shadowColor: AppColors.black.withOpacity(0.2),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Admin Register",
          style: style(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
      ),*/
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: 15.horizontal,
              child: Column(
                children: [
                  30.height,
                  Text(
                    "REGISTER ADMIN",
                    style: poppinsStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primarycolor),
                  ),
                  90.height,
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        // height: 950,
                        width: double.maxFinite,
                        // margin: const EdgeInsets.symmetric(
                        //     vertical: 10, horizontal: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                spreadRadius: 5,
                                offset: Offset(0, 5)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            90.height,
                            // Center(
                            //   child: Text(
                            //     "Personal Information",
                            //     style: style(
                            //       fontWeight: FontWeight.w600,
                            //       fontSize: 16,
                            //     ),
                            //   ),
                            // ),
                            // Divider(
                            //   color: AppColors.black.withOpacity(0.4),
                            //   height: 30,
                            // ),
                            commontext(text: "Company Name"),
                            fieldBottomHeight(),

                            commontextfield(
                              controller: controller.companyController.value,
                              onChanged: (value) {
                                controller.company.value = value;
                              },
                              text: "Enter Company name",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your company name';
                                }

                                return null;
                              },
                            ),
                            labelHeight(),
                            commontext(text: "Admin Name"),
                            fieldBottomHeight(),
                            commontextfield(
                              controller: controller.adminNameController.value,
                              onChanged: (value) {
                                controller.adminName.value = value;
                              },
                              text: "Enter Admin Name",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter admin name';
                                }

                                return null;
                              },
                            ),
                            labelHeight(),
                            commontext(text: "Address"),
                            fieldBottomHeight(),
                            commontextfield(
                              controller: controller.addressController.value,
                              onChanged: (value) {
                                controller.address.value = value;
                              },
                              text: "Enter Address",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Address';
                                }

                                return null;
                              },
                            ),
                            labelHeight(),
                            commontext(text: "Mobile Number"),
                            fieldBottomHeight(),
                            commontextfield(
                              // maxLines: 2,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              controller: controller.numberController.value,
                              onChanged: (value) {
                                controller.number.value = value;
                              },
                              text: "Enter Mobile Number",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Number';
                                }

                                return null;
                              },
                            ),
                            labelHeight(),
                            commontext(text: "Email ID"),
                            fieldBottomHeight(),
                            commontextfield(
                              controller: controller.emailController.value,
                              onChanged: (value) {
                                controller.email.value = value;
                              },
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
                            ),
                            labelHeight(),
                            commontext(text: "Password"),
                            fieldBottomHeight(),
                            Obx(
                              () => commontextfield(
                                controller: controller.passController.value,
                                onChanged: (value) {
                                  controller.pass.value = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 7) {
                                    return 'Password must be at least 7 characters long';
                                  }

                                  return null;
                                },
                                obscureText: controller.passwordVisible.value,
                                suffixIcon: GestureDetector(
                                    //iconSize: 15,
                                    onTap: () {
                                      controller.passwordVisible.value =
                                          !controller.passwordVisible.value;
                                    },
                                    child: visibilityIcon(
                                      icon: controller.passwordVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    )),
                                text: 'Enter Password',
                              ),
                            ),
                            labelHeight(),
                            commontext(text: "Confirm Password"),
                            fieldBottomHeight(),
                            Obx(
                              () => commontextfield(
                                controller:
                                    controller.confirmPassController.value,
                                onChanged: (value) {
                                  controller.confirmPass.value = value;
                                },
                                obscureText:
                                    controller.confirmPasswordVisible.value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != controller.pass.value) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    controller.confirmPasswordVisible.value =
                                        !controller
                                            .confirmPasswordVisible.value;
                                  },
                                  child: visibilityIcon(
                                    icon:
                                        controller.confirmPasswordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                  ),
                                ),
                                text: 'Enter Confirm Password',
                              ),
                            ),
                            labelHeight(),
                            30.height,
                            Padding(
                              padding: 15.horizontal,
                              child: primarybutton(
                                  text: "SIGN UP",
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      // await  adminRegController.registerAdmin();
                                      Get.off(() => BottomNavAdmin(),
                                          transition: Transition.noTransition,
                                          duration:
                                              Duration(milliseconds: 300));
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -65,
                        child: Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Container(
                                            // width: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: AppColors.white),
                                            child: Padding(
                                              padding: 10.vertical,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      controller
                                                          .pickImageFromCamera(
                                                              source:
                                                                  ImageSource
                                                                      .camera);
                                                    },
                                                    child: cameraBtn(
                                                      text: "Camera",
                                                      image: AppSvg.takephoto,
                                                    ),
                                                  ),
                                                  20.width,
                                                  GestureDetector(
                                                    onTap: () async {
                                                      controller
                                                          .pickImageFromCamera(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                    },
                                                    child: cameraBtn(
                                                      text: "Gallery",
                                                      image: AppSvg.gallery,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: AppColors.greylight,
                                      shape: BoxShape.circle,
                                      image: controller.selectedImages.value !=
                                              null
                                          ? DecorationImage(
                                              image: FileImage(controller
                                                  .selectedImages.value!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child:
                                        controller.selectedImages.value == null
                                            ? Center(
                                                child: Text(
                                                  "+ Add Logo",
                                                  style: poppinsStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.height
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
