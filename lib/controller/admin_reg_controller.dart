import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../common/global_widget.dart';
import '../config/db_helper/shared_prefs_helper.dart';
import '../config/imageHelper.dart';
import '../model/adminmodel.dart';

class AdminRegController extends GetxController {
  Rx<TextEditingController> companyController = TextEditingController().obs;
  Rx<TextEditingController> adminNameController = TextEditingController().obs;

  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> numberController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passController = TextEditingController().obs;
  Rx<TextEditingController> confirmPassController = TextEditingController().obs;

  RxString company = ''.obs;
  RxString adminName = ''.obs;

  RxString address = ''.obs;
  RxString number = ''.obs;
  RxString email = ''.obs;
  RxString pass = ''.obs;
  RxString confirmPass = ''.obs;

  Rx<File?> selectedImages = Rx<File?>(null);
  ImagePicker picker = ImagePicker();

  RxBool passwordVisible = false.obs;
  RxBool confirmPasswordVisible = false.obs;

  Future<void> pickCompanyLogo() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImages.value = File(pickedFile.path);
    }
  }

  Future<void> pickImageFromCamera({required ImageSource source}) async {
    final XFile? photo = await picker.pickImage(source: source);
    if (photo != null) {
      File? croppedFile = await ImageCropperHelper.cropImage(
        File(photo.path),
      );
      if (croppedFile != null) {
        selectedImages.value = croppedFile;
      }
    } else {
      primaryToast(msg: "No image chosen. Select an image to continue.");
    }
    Get.back(); // Close the dialog or screen after picking the image
  }

  Future<void> registerAdmin() async {
    AdminModel admin = AdminModel(
      companyName: company.value,
      adminName: adminName.value,
      address: address.value,
      mobileNumber: number.value,
      email: email.value,
      password: pass.value,
      registrationNumber: 0, // This will be updated in SharedPrefsHelper
      profileImage: selectedImages.value?.path,
    );

    await SharedPreferenceHelper.sharedPreferenceHelper.saveAdminData(admin);
  }

  Future<void> loadAdminData() async {
    AdminModel? admin =
        await SharedPreferenceHelper.sharedPreferenceHelper.fetchAdminData();
    if (admin != null) {
      company.value = admin.companyName;
      adminName.value = admin.adminName;
      address.value = admin.address;
      number.value = admin.mobileNumber;
      email.value = admin.email;
      pass.value = admin.password;
      selectedImages.value =
          admin.profileImage != null ? File(admin.profileImage!) : null;
    }
  }

  Future<void> removeAdminData() async {
    await SharedPreferenceHelper.sharedPreferenceHelper.clearAdminData();
    clearData();
  }

  Future<void> clearData() async {
    company.value = '';
    adminName.value = '';
    address.value = '';
    number.value = '';
    email.value = '';
    pass.value = '';
    confirmPass.value = '';
    selectedImages.value = null;
    companyController.value.clear();
    adminNameController.value.clear();
    addressController.value.clear();
    numberController.value.clear();
    emailController.value.clear();
    passController.value.clear();
    confirmPassController.value.clear();
  }
}
