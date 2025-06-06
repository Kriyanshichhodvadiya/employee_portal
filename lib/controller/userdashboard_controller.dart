import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:employeeform/view/login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/eprofilemodel.dart';

class UserDashBoardController extends GetxController {
  RxMap<String, dynamic> employeeData = <String, dynamic>{}.obs;
  RxBool isLoading = false.obs;
  var lastAdminImage = ''.obs;
  var lastAdminName = ''.obs;
  var lastAdminLastName = ''.obs;
  var lastAdminEmail = ''.obs;
  var lastAdminAddress = ''.obs;
  var lastAdminAadhar = ''.obs;
  var lastAdminGender = ''.obs;
  var lastAdminBirthDate = ''.obs;
  var lastAdminMobileOne = ''.obs;
  var lastAdminMobileTwo = ''.obs;
  var lastAdminBankName = ''.obs;
  var lastAdminAccountNumber = ''.obs;
  var lastAdminBranchAddress = ''.obs;
  var lastAdminIfscCode = ''.obs;
  var lastAdminEmploymentType = ''.obs;
  var lastAdminDateFrom = ''.obs;
  var lastAdminSrNo = ''.obs;
  RxString frontAadharFilePath = "".obs;
  RxString backAadharFilePath = "".obs;
  var lastAdminBranchName = ''.obs;
  var confirmPass = ''.obs;
  var password = ''.obs;
  var country = ''.obs;
  var state = ''.obs;
  var city = ''.obs;
  var zipcode = ''.obs;
  var otherDocuments = <OtherDocumentsModel>[].obs;
  Rx<TextEditingController> customDocNameController =
      TextEditingController().obs;
  var uploadedMultipleDocuments = <String, List<File>>{}.obs;
  var selectedDocs = <int, bool>{}.obs;
  var lastAdminreference = ''.obs;
  final Rxn<File> aadharFile = Rxn<File>();
  final Rxn<File> bankPassbookFile = Rxn<File>();
  List<String> selectedProofs = [];
  RxList<File> selectedDocuments = <File>[].obs;
  var selectedDate = DateTime.now().obs;
  Rx<DateTime> selectedDateFrom = DateTime.now().obs;

  List<File> uploadedDoc(Map<String, dynamic> employeeData) {
    List<File> uploadedDocslist = [];
    if (employeeData['proof'] != null) {
      for (String path in employeeData['proof']) {
        uploadedDocslist.add(File(path));
      }
    }
    return uploadedDocslist;
  }

  Future<void> fetchEmployeeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');
    // String? loggedInUserSrNo =
    //     await SharedPreferencesHelper.sharedPreferencesHelper.getCurrentUser();
    //
    String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

    if (employeeListString != null) {
      try {
        List<Map<String, dynamic>> employeeList =
            List<Map<String, dynamic>>.from(
                jsonDecode(employeeListString) as List);

        employeeData.value = employeeList.firstWhere(
          (employee) => employee['srNo'] == loggedInUserSrNo,
          orElse: () =>
              <String, dynamic>{}, // Return an empty Map<String, dynamic>
        );

        log('employeeData==>>${employeeData}');
      } catch (e) {
        log("Error decoding employee data: $e");
        employeeData.value = {}; // Set an empty map to avoid crashes
      }
    }

    isLoading.value = false;
    update();
  }

  Future<void> pickMultiFile(int index) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      // Assign the file to the 'otherFile' field instead of 'file'
      otherDocuments[index].otherFile = File(result.files.single.path!);
      otherDocuments.refresh(); // Important to refresh the list
    }
  }

  Future<void> fetchAdminData() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminListString = prefs.getString('adminData');
    String? currentAdminSrNo =
        // await SharedPreferencesHelper.sharedPreferencesHelper.getCurrentAdmin();
        prefs.getString('currentAdmin');

    if (adminListString != null && currentAdminSrNo != null) {
      try {
        List<Map<String, dynamic>> adminList = List<Map<String, dynamic>>.from(
          jsonDecode(adminListString) as List,
        );

        Map<String, dynamic> adminData = adminList.firstWhere(
          (admin) => admin['srNo'] == currentAdminSrNo,
          orElse: () => <String, dynamic>{},
        );

        if (adminData.isNotEmpty) {
          UserProfile adminProfile = UserProfile.fromMap(adminData);
          populateAdminFields(adminProfile); // ✅ Load into fields
          log('Admin Profile Populated');
          log('adminProfile==>>${adminProfile.firstName}');
        }
      } catch (e) {
        log("Error fetching admin data: $e");
      }
    }
    isLoading.value = false;
  }

  void populateAdminFields(UserProfile admin) {
    lastAdminImage.value = admin.image;
    log(" lastAdminImage: ${lastAdminImage.value}");

    lastAdminName.value = admin.firstName;
    log(" lastAdminName: ${lastAdminName.value}");

    lastAdminLastName.value = admin.lastName;
    log(" lastAdminLastName: ${lastAdminLastName.value}");

    lastAdminEmail.value = admin.email;
    log(" lastAdminEmail: ${lastAdminEmail.value}");

    lastAdminAddress.value = admin.address;
    log(" lastAdminAddress: ${lastAdminAddress.value}");

    lastAdminAadhar.value = admin.aadhar;
    log(" lastAdminAadhar: ${lastAdminAadhar.value}");

    lastAdminGender.value = admin.gender;
    log(" lastAdminGender: ${lastAdminGender.value}");

    lastAdminBirthDate.value = admin.birthDate;
    log(" lastAdminBirthDate: ${lastAdminBirthDate.value}");

    lastAdminMobileOne.value = admin.mobilenoone;
    log(" lastAdminMobileOne: ${lastAdminMobileOne.value}");

    lastAdminMobileTwo.value = admin.mobilentwo;
    log(" lastAdminMobileTwo: ${lastAdminMobileTwo.value}");

    lastAdminBankName.value = admin.bankName;
    log(" lastAdminBankName: ${lastAdminBankName.value}");

    lastAdminBranchAddress.value = admin.branchAddress;
    log(" lastAdminBranchAddress: ${lastAdminBranchAddress.value}");

    lastAdminAccountNumber.value = admin.accountNumber;
    log(" lastAdminAccountNumber: ${lastAdminAccountNumber.value}");

    lastAdminIfscCode.value = admin.ifscCode;
    log(" lastAdminIfscCode: ${lastAdminIfscCode.value}");

    lastAdminEmploymentType.value = admin.employmentType;
    log(" lastAdminEmploymentType: ${lastAdminEmploymentType.value}");

    city.value = admin.city!;
    log(" city: ${city.value}");

    state.value = admin.state!;
    log(" state: ${state.value}");

    country.value = admin.country!;
    log(" country: ${country.value}");

    frontAadharFilePath.value = admin.attachedFiles!.aadharCard!.frontSidePath;
    log(" frontAadharFilePath: ${frontAadharFilePath.value}");

    backAadharFilePath.value = admin.attachedFiles!.aadharCard!.backSidePath;
    log(" backAadharFilePath: ${backAadharFilePath.value}");

    bankPassbookFile.value = admin.attachedFiles!.bankPassbookFile;
    log(" bankPassbookFile: ${bankPassbookFile.value}");

    final otherFiles = admin.attachedFiles!.otherFiles;
    log(" Other Files Count: ${otherFiles.length}");

    if (otherFiles.isNotEmpty) {
      otherDocuments.assignAll(otherFiles);
      log(" otherDocuments assigned with ${otherDocuments.length} items");

      for (int i = 0; i < otherFiles.length; i++) {
        selectedDocs[i] = otherFiles[i].check == true;
        log(" selectedDocs[$i]: ${selectedDocs[i]} (${otherFiles[i].name})");
      }

      for (var doc in otherFiles) {
        if (doc.name?.toLowerCase().contains('aadhar') == true &&
            doc.otherFile != null) {
          aadharFile.value = doc.otherFile;
          log("📎 Aadhar file assigned: ${aadharFile.value}");
        } else if (doc.name?.toLowerCase().contains('passbook') == true &&
            doc.otherFile != null) {
          bankPassbookFile.value = doc.otherFile;
          log("📎 Bank Passbook file assigned from otherFiles: ${bankPassbookFile.value}");
        }
      }
    }

    country.value = admin.country!;
    log(" country (reassigned): ${country.value}");

    zipcode.value = admin.zipCode!;
    log(" zipcode: ${zipcode.value}");

    lastAdminreference.value = admin.reference;
    log(" lastAdminreference: ${lastAdminreference.value}");

    password.value = admin.password!;
    log(" password: ${password.value}");

    confirmPass.value = admin.confirmPass!;
    log(" confirmPass: ${confirmPass.value}");

    lastAdminSrNo.value = admin.srNo;
    log(" lastAdminSrNo: ${lastAdminSrNo.value}");

    adminSrNo = admin.srNo;
    log(" adminSrNo: $adminSrNo");

    selectedDocuments.value =
        admin.documents.map((path) => File(path)).toList();
    log(" selectedDocuments (${selectedDocuments.length}): ${admin.documents}");

    selectedProofs = List<String>.from(admin.attachProof);
    log(" selectedProofs: $selectedProofs");
  }
}
