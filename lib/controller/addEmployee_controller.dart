import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:employeeform/model/eprofilemodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/comman_widget.dart';

class AddEmployeeController extends GetxController {
  Rx<TextEditingController> firstnamecontroller = TextEditingController().obs;
  Rx<TextEditingController> middlenamecontroller = TextEditingController().obs;
  Rx<TextEditingController> lastnamecontroller = TextEditingController().obs;
  Rx<TextEditingController> addresscontroller = TextEditingController().obs;

  Rx<TextEditingController> aadharcontroller = TextEditingController().obs;
  Rx<TextEditingController> banknamercontroller = TextEditingController().obs;
  Rx<TextEditingController> branchaddresscontroller =
      TextEditingController().obs;

  Rx<TextEditingController> acnocontroller = TextEditingController().obs;
  Rx<TextEditingController> ifsccontroller = TextEditingController().obs;
  Rx<TextEditingController> referancecontroller = TextEditingController().obs;
  Rx<TextEditingController> srnocontroller = TextEditingController().obs;

  Rx<TextEditingController> mobilenucontroller = TextEditingController().obs;
  Rx<TextEditingController> mobilenutwocontroller = TextEditingController().obs;
  Rx<TextEditingController> emailcontroller = TextEditingController().obs;
  Rx<TextEditingController> otherTextController = TextEditingController().obs;

  RxString fname = ''.obs;
  RxString middlename = ''.obs;
  RxString lname = ''.obs;
  RxString address = ''.obs;
  RxString aadhar = ''.obs;
  RxString group = ''.obs;
  RxString mobileNumber = ''.obs;
  RxString mobileNumbertwo = ''.obs;
  RxString email = ''.obs;
  RxString dropdownvalue = 'Indian'.obs;
  RxString dropdownvaluebank = 'SBI'.obs;
  RxString branchaddres = ''.obs;
  RxString acno = ''.obs;
  RxString ifsc = ''.obs;
  RxString referance = ''.obs;
  RxString officegroup = ''.obs;
  RxString seletedproof = ''.obs;
  RxString bankname = ''.obs;
  RxString ortherdoc = ''.obs;
  RxString poofgroup = ''.obs;

  // Observables for DateTime
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<DateTime> selectedDatefrom = DateTime.now().obs;

  // Boolean Observables
  RxBool isAadharSelected = false.obs;
  RxBool isBankPassbookSelected = false.obs;
  RxBool isOtherSelected = false.obs;

  Rx<File?> selectedImages = Rx<File?>(null);

  final ImagePicker picker = ImagePicker();

  RxList<String> selectedProofs = <String>[].obs;
  RxList<Map<String, dynamic>> item = <Map<String, dynamic>>[].obs;

  RxList<File>? selectedDocuments = <File>[].obs;

  // Dropdown Items

  Future<void> pickDocuments() async {
    // Request storage permission
    var status = await Permission.storage.request();

    // If permission is granted
    if (status.isGranted) {
      // Open file picker to select multiple files
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
      );

      // If files are selected
      if (result != null) {
        // Update the selectedDocuments observable list with the selected files
        selectedDocuments!.value =
            result.paths.map((path) => File(path!)).toList();
      } else {
        print('User canceled the picker');
      }
    } else {
      print('Storage permission denied');
    }
  }

  // Method to select a date
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) => commonThemeBuilder(context, child),
    );

    if (picked != null && picked != selectedDate.value) {
      // Update the selectedDate observable
      selectedDate.value = picked;
    }
  }

  // Method to select a date (from)
  Future<void> selectDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) => commonThemeBuilder(context, child),
    );

    if (picked != null && picked != selectedDatefrom.value) {
      // Update the selectedDatefrom observable
      selectedDatefrom.value = picked;
    }
  }

  Future<bool> employeeIdExists(String? employeeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmployeeData = prefs.getString('employeeData');
    if (storedEmployeeData != null) {
      List<dynamic> employeeList = jsonDecode(storedEmployeeData);
      for (var employee in employeeList) {
        if (employee['srNo'] == employeeId) {
          return true;
        }
      }
    }
    return false;
  }

  void addEmployee({required formkey}) async {
    if (formkey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Fetch existing employee data from SharedPreferences as a string
      String? storedEmployeeData = prefs.getString('employeeData');
      List<UserProfile> existingProfiles = [];

      if (storedEmployeeData != null && storedEmployeeData.isNotEmpty) {
        // If data exists, decode it into a list of UserProfile objects
        List<Map<String, dynamic>> decodedData =
            List<Map<String, dynamic>>.from(jsonDecode(storedEmployeeData));
        existingProfiles =
            decodedData.map((item) => UserProfile.fromMap(item)).toList();
      }

      // Get the next available srNo (auto-increment)
      int srno = existingProfiles.isNotEmpty
          ? int.parse(existingProfiles.last.srNo) + 1
          : 1; // Start from 1 if no employees exist

      // Check if the srNo already exists (you could use this method or avoid it based on your logic)
      if (await employeeIdExists(srno.toString())) {
        Fluttertoast.showToast(msg: "Employee ID already registered.");
      } else {
        // Create new employee data
        Map<String, dynamic> employeeData = {
          'image': selectedImages.value!.path,
          'firstName': fname.value,
          'middleName': middlename.value,
          'lastName': lname.value,
          'address': address.value,
          'aadhar': aadhar.value,
          'gender': group.value,
          'birthdate':
              "${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year}",
          'mobileNumber': mobileNumber.value,
          'mobileNumberTwo': mobileNumbertwo.value,
          'email': email.value,
          'bankname': dropdownvaluebank.value,
          'accountNumber': acno.value,
          'ifscCode': ifsc.value,
          'reference': referance.value,
          'proof': selectedDocuments?.map((file) => file.path).toList(),
          'employeetype': officegroup.value,
          'joindate':
              "${selectedDatefrom.value.day}/${selectedDatefrom.value.month}/${selectedDatefrom.value.year}",
          'srNo': srno.toString(),
          'branchAddress': branchaddres.value,
          'attendance': false,
        };

        // Create new UserProfile object
        UserProfile newProfile = UserProfile.fromMap(employeeData);
        existingProfiles.add(newProfile);

        // Save updated list to SharedPreferences as a JSON string
        try {
          await prefs.setString(
              'employeeData',
              jsonEncode(
                  existingProfiles.map((item) => item.toMap()).toList()));
          log("Updated employee list: ${prefs.getString('employeeData')}");
        } catch (e) {
          log("Error updating SharedPreferences: $e");
        }

        // Optionally show a confirmation toast or snackbar
        Fluttertoast.showToast(msg: "Employee added successfully!");
        Get.back();
        /*Get.to(() => EmployeeDetails(),
            transition: Transition.noTransition,
            duration: Duration(milliseconds: 300));*/
        // Navigator.
        // push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ViewEmployeeDetails(),
        //     ));
      }
    }
  }
}
