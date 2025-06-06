import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/config/images.dart';
import 'package:employeeform/controller/userdashboard_controller.dart';
import 'package:employeeform/model/eprofilemodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart' as openFilex;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/dashboardcommon.dart';
import '../../../common/global_widget.dart';
import '../../../config/imageHelper.dart';
import '../../../config/list.dart';
import '../../../controller/admineditcontroller.dart';
import '../../../controller/employeeformContro.dart';
import '../../../controller/userviewtask_controller.dart';
import '../bottom_nav_admin.dart';
import '../company_profile/co_profile_form.dart';
import 'employeeform.dart';

class adminEditScreen extends StatefulWidget {
  final UserProfile? employee;
  final int? index;
  const adminEditScreen({
    super.key,
    this.employee,
    this.index,
  });

  @override
  State<adminEditScreen> createState() => adminEditScreenState();
}

class adminEditScreenState extends State<adminEditScreen> {
  EmployeeFormController employeeFormController =
      Get.put(EmployeeFormController());
  UserDashBoardController userDashBoardController = Get.find();
  UserViewTaskController userViewTaskController = Get.find();
  AdminEditController editController = Get.put(AdminEditController());
  Future<void> pdf(filePath) async {
    try {
      openFilex.OpenResult result = await openFilex.OpenFilex.open(filePath);

      if (result.type != openFilex.ResultType.done) {
        primaryToast(
          msg: "Failed to open file: ${result.message}",
        );
      }
    } catch (e) {
      primaryToast(
        msg: "Error opening file: $e",
      );
    }
  }

  String getSelectedProofs() {
    if (isAadharSelected == true) {
      if (!selectedProofs.contains("Aadhar Card")) {
        selectedProofs.add("Aadhar Card");
      }
    } else {
      selectedProofs.remove("Aadhar Card");
    }
    if (isBankPassbookSelected == true) {
      if (!selectedProofs.contains("Bank Passbook")) {
        selectedProofs.add("Bank Passbook");
      }
    } else {
      selectedProofs.remove("Bank Passbook");
    }
    if (isOtherSelected == true) {
      if (!selectedProofs.contains("Other")) {
        selectedProofs.add("Other");
      }
    } else {
      selectedProofs.remove("Other");
    }

    return selectedProofs.isNotEmpty
        ? selectedProofs.join(', ')
        : "No proof selected";
  }

  void pickDocumentFor(String proofType) async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        File pickedFile = File(result.files.single.path!);

        // Set specific file variables based on proofType
        if (proofType == "Aadhar") {
          aadharFile = pickedFile;
        } else if (proofType == "Bank Passbook") {
          bankPassbookFile = pickedFile;
        }
        setState(() {});
        // Also update the general map
        // uploadedDocuments[proofType] = pickedFile;
      } else {
        print('User canceled the picker');
      }
    } else {
      print('Storage permission denied');
    }
  }

  Future<void> openFile(File? file) async {
    if (file != null && await file.exists()) {
      try {
        openFilex.OpenResult result = await openFilex.OpenFilex.open(file.path);
        if (result.type != openFilex.ResultType.done) {
          primaryToast(msg: "Failed to open file: ${result.message}");
        }
      } catch (e) {
        primaryToast(msg: "Error opening file: $e");
      }
    } else {
      primaryToast(msg: "No file found to open.");
    }
  }

  String? zipCode;
  String? country;
  String? state;
  String? city;
  String? pass;
  String? confirmPass;
  DateTime _parseDate(String date) {
    final parts = date.split('/');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
    throw const FormatException('Invalid date format');
  }

  File? aadharFile;
  File? bankPassbookFile;
  void removeDocuments(String proofType) {
    if (proofType == commonString.aadhar) {
      aadharFile = null;
    } else if (proofType == commonString.passbook) {
      bankPassbookFile = null;
    }
    setState(() {});
    // uploadedDocuments.remove(proofType);
  }

  DateTime date(String date) {
    if (widget.employee?.image != null) {
      selectedImages = File(widget.employee!.image);
    }

    final parts = date.split('/');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } else {
      throw const FormatException('Invalid date format');
    }
  }

  void initState() {
    super.initState();
    log('isOtherSelected${isOtherSelected}');
    log('isOtherSelected${isOtherSelected}');
    if (widget.employee != null) {
      final employee = widget.employee!;
      employeeFormController.editCountryValue(
        country: employee.country,
        state: employee.state,
        city: employee.city,
      );
      log('employee!.country==>>${widget.employee!.country}');
      log('employee!.state==>>${widget.employee!.state}');
      log('employee!.city==>>${widget.employee!.city}');
      firstnamecontroller.text = employee.firstName;
      middlenamecontroller.text = employee.middleName;
      lastnamecontroller.text = employee.lastName;
      selectedDate = DateFormat('dd-MM-yyyy').parse(employee.birthDate);
      emailcontroller.text = employee.email;
      addresscontroller.text = employee.address;
      aadharcontroller.text = employee.aadhar;
      mobilenucontroller.text = employee.mobilenoone;
      mobilenutwocontroller.text = employee.mobilentwo;
      mobilenuthreecontroller.text = employee.email;
      dropdownvaluebank = employee.bankName;
      branchaddresscontroller.text = employee.branchAddress;
      acnocontroller.text = employee.accountNumber;
      ifsccontroller.text = employee.ifscCode;
      referancecontroller.text = employee.reference;
      officegroup = employee.employmentType;
      srnocontroller.text = employee.srNo;
      zipCodeController.text = employee.zipCode ?? '';
      countryController.text = employee.country ?? '';
      stateController.text = employee.state ?? '';
      cityController.text = employee.city ?? '';
      passController.text = employee.password ?? '';
      confirmPassWordController.text = employee.confirmPass ?? '';
      group = employee.gender;
      editController.frontAadharFilePath.value =
          employee.attachedFiles!.aadharCard!.frontSidePath;

      editController.backAadharFilePath.value =
          employee.attachedFiles!.aadharCard!.backSidePath;
      bankPassbookFile = employee.attachedFiles!.bankPassbookFile;

      selectedImages = File(employee.image);
      // final otherFiles = employee.attachedFiles?.otherFiles;
      final otherFiles = userDashBoardController.otherDocuments;
      log('otherFiles${otherFiles}');
      if (otherFiles.isNotEmpty) {
        // Populate the otherDocuments list
        log('userDashBoardController.otherDocuments==>>${userDashBoardController.otherDocuments.length}');
        userDashBoardController.otherDocuments.assignAll(otherFiles);

        // Fill selectedDocs with initial checkbox values
        for (int i = 0; i < otherFiles.length; i++) {
          userDashBoardController.selectedDocs[i] =
              otherFiles[i].check == true; // FIXED
        }

        // Assign known types (e.g. Aadhar, Passbook)
        for (var doc in otherFiles) {
          if (doc.name?.toLowerCase().contains('aadhar') == true &&
              doc.otherFile != null) {
            editController.aadharFile.value = doc.otherFile;
          } else if (doc.name?.toLowerCase().contains('passbook') == true &&
              doc.otherFile != null) {
            editController.bankPassbookFile.value = doc.otherFile;
          }
        }
      }
      if (employee.birthDate.isNotEmpty) {
        try {
          selectedDate = _parseDate(employee.birthDate);
        } catch (e) {
          print('Error parsing birth date: $e');
        }
      }

      if (employee.dateFrom.isNotEmpty) {
        try {
          selectedDatefrom = _parseDate(employee.dateFrom);
        } catch (e) {
          print('Error parsing dateFrom: $e');
        }
      }

      selectedProofs = employee.attachProof;
      updateSelectedProofs(selectedProofs: selectedProofs);
      isOtherSelected = false;
    }
  }

  String? fname;
  String? middlename;
  String? lname;
  String? address;
  String? email;
  String? aadhar;
  String? group;
  String? mobileNumber;
  String? mobileNumbertwo;
  String? mobileNumberthree;
  String dropdownvalue = 'Indian';
  String dropdownvaluebank = 'SBI';
  String? branchaddres;
  String? acno;
  String? ifsc;
  String? referance;
  String? srno;
  String? officegroup;
// File? selectedImages;

  DateTime? selectedDate;
  DateTime? selectedDatefrom;

  bool isImageChanged = false;

  // UserProfile userProfile = UserProfile();
  // void updateProofInProfile() {
  //   setState(() {
  //     userProfile.proof = getSelectedProofs();
  //   });
  // }
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;
  bool isAadharSelected = false;
  bool isBankPassbookSelected = false;
  bool isOtherSelected = false;
  List selectedProofs = [];
  void updateSelectedProofs({required selectedProofs}) {
    isAadharSelected = selectedProofs.contains("Aadhar Card");
    isBankPassbookSelected = selectedProofs.contains("Bank Passbook");
    isOtherSelected = selectedProofs.contains("Other");
    log('isAadharSelected:${isAadharSelected}');
    log('isBankPassbookSelected:${isBankPassbookSelected}');
    log('isOtherSelected:${isOtherSelected}');
  }

  void toggleProofSelection(String proof, bool isSelected) {
    if (isSelected) {
      if (!selectedProofs.contains(proof)) {
        selectedProofs.add(proof);
      }
    } else {
      selectedProofs.remove(proof);
    }
    log("Updated Proofs: $selectedProofs");
  }

//uploadproof
  List<File>? selectedDocuments = [];
  Future<void> pickDocuments() async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
      );

      if (result != null) {
        setState(() {
          widget.employee!.documents.addAll(
            result.paths
                .where((path) => path != null)
                .map((path) => path!)
                .toList(),
          );
        });
      } else {
        print('User canceled the picker');
      }
    } else {
      print('Storage permission denied');
    }
  }

  String? poofgroup;

  DateTime selectedDateto = DateTime.now();
  Future<void> dateSelect(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => commonThemeBuilder(context, child),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return "$day - $month - $year";
  }

  String formatTo(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return "$day - $month - $year";
  }

  Future<void> selectDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) => commonThemeBuilder(context, child),
    );
    if (picked != null && picked != selectedDatefrom) {
      setState(() {
        selectedDatefrom = picked;
      });
    }
  }

  Future<void> selectDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDatefrom?.add(Duration(days: 1)) ?? DateTime.now(),
      firstDate: selectedDatefrom?.add(Duration(days: 1)) ?? DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) => commonThemeBuilder(context, child),
    );
    if (picked != null && picked != selectedDateto) {
      setState(() {
        selectedDateto = picked;
      });
    }
  }

  String formatDateFrom(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return "$day - $month - $year";
  }

  String formatDateTo(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return "$day - $month - $year";
  }

  List<Map<String, dynamic>> item = [];
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // String dropdownvalue = 'Indian';
  List<String> items = ['USA', 'India', 'Canada'];
  List<String> itemsbank = ['SBI', 'Axis Bank', 'ICICI Bank'];

  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController middlenamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController aadharcontroller = TextEditingController();
  TextEditingController banknamercontroller = TextEditingController();
  TextEditingController branchaddresscontroller = TextEditingController();

  TextEditingController acnocontroller = TextEditingController();
  TextEditingController ifsccontroller = TextEditingController();
  TextEditingController referancecontroller = TextEditingController();
  TextEditingController srnocontroller = TextEditingController();

  TextEditingController mobilenucontroller = TextEditingController();
  TextEditingController mobilenutwocontroller = TextEditingController();
  TextEditingController mobilenuthreecontroller = TextEditingController();
  TextEditingController otherTextController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassWordController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  @override
  void dispose() {
    otherTextController.dispose();
    firstnamecontroller.dispose();
    middlenamecontroller.dispose();
    lastnamecontroller.dispose();
    super.dispose();
  }

  String? bankname;

  String? ortherdoc;

  final ImagePicker picker = ImagePicker();
  File? selectedImages;
  bool validateAllFields() {
    if (selectedImages!.path.isEmpty) {
      primaryToast(msg: "Please upload Profile Image.");
      return false;
    }
    if (firstnamecontroller.text.isEmpty) {
      primaryToast(msg: "Please enter First Name");
      return false;
    }
    if (lastnamecontroller.text.trim().isEmpty) {
      primaryToast(msg: "Please enter Last Name");
      return false;
    }
    if (group!.isEmpty) {
      primaryToast(msg: "Please select gender.");
      return false;
    }
    if (addresscontroller.text.isEmpty ||
        aadharcontroller.text.trim().length != 12) {
      primaryToast(msg: "Please enter valid 12-digit Aadhar No.");
      return false;
    }
    if (emailcontroller.text.trim().isEmpty) {
      primaryToast(msg: "Please enter an email.");
      return false;
    }
    RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$');
    if (!emailRegExp.hasMatch(email!.trim())) {
      primaryToast(msg: "Invalid email format.");
      return false;
    }
    if (mobilenucontroller.text.trim().isEmpty) {
      primaryToast(msg: "Please enter Mobile No 1.");
      return false;
    }
    if (mobilenucontroller.text.trim().length != 10) {
      primaryToast(msg: "Mobile No 1 must be exactly 10 digits.");
      return false;
    }

    if (mobilenutwocontroller.text.trim().isEmpty) {
      primaryToast(msg: "Please enter Mobile No 2.");
      return false;
    }
    if (mobilenutwocontroller.text.trim().length != 10) {
      primaryToast(msg: "Mobile No 2 must be exactly 10 digits.");
      return false;
    }
    if (addresscontroller.text.isEmpty) {
      primaryToast(msg: "Please enter your Address.");
      return false;
    }
    if (zipCodeController.text.isEmpty) {
      primaryToast(msg: "Please enter ZipCode");
      return false;
    }
    if (zipCodeController.text.length < 5 ||
        zipCodeController.text.length > 6) {
      primaryToast(msg: "Zip Code must be 5 or 6 digits");
      return false;
    }

    if (passController.text.isEmpty) {
      primaryToast(msg: "Please enter Password");
      return false;
    }
    if (passController.text.length < 8) {
      primaryToast(msg: "Password must be at least 8 characters");
      return false;
    }
    if (!RegExp(r'[A-Z]').hasMatch(passController.text)) {
      primaryToast(msg: "Password must have at least one uppercase letter");
      return false;
    }
    if (!RegExp(r'[!@#\$&*~_]').hasMatch(passController.text)) {
      primaryToast(msg: "Password must have at least one special character");
      return false;
    }
    if (confirmPassWordController.text.isEmpty) {
      primaryToast(msg: "Please enter Confirm Password");
      return false;
    }
    if (confirmPassWordController.text != passController.text) {
      primaryToast(msg: "Passwords do not match");
      return false;
    }

    if (dropdownvaluebank.isEmpty) {
      primaryToast(msg: "Please select Bank Name");
      return false;
    }
    if (acnocontroller.text.trim().isEmpty) {
      primaryToast(msg: "Please enter your Ac No");
      return false;
    }

    final ifscPattern = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (ifsccontroller.text.isEmpty) {
      primaryToast(msg: "Please enter your IFSC");
      return false;
    } else if (!ifscPattern.hasMatch(ifsc!)) {
      primaryToast(msg: "Invalid IFSC code");
      return false;
    }

    if (branchaddresscontroller.text.trim().isEmpty) {
      primaryToast(msg: "Please enter your Branch Address");
      return false;
    }

    if (referancecontroller.text.trim().isEmpty) {
      primaryToast(msg: "Please enter Reference");
      return false;
    }
    if (selectedProofs.isEmpty) {
      primaryToast(msg: "Please attach proofs.");
      return false;
    }
    if ((isAadharSelected &&
            editController.frontAadharFilePath.value.isEmpty &&
            editController.backAadharFilePath.value.isEmpty) ||
        (isBankPassbookSelected && bankPassbookFile == null)) {
      primaryToast(msg: "Please upload documents.");
      return false;
    }
    for (var i = 0; i < editController.otherDocuments.length; i++) {
      log('otherDocuments[i].check=>${editController.otherDocuments[i].check == true && editController.otherDocuments[i].otherFile == null}');
      if (editController.otherDocuments[i].check == true &&
          editController.otherDocuments[i].otherFile == null) {
        primaryToast(
            msg:
                "Please upload the ${editController.otherDocuments[i].name} document.");
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Get.back();
          employeeFormController.resetCountryValue();

          Get.offAll(
            () => BottomNavAdmin(
              initialIndex: 4,
            ),
          );
          return false;
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: appBar(
              onTap: () {
                // Get.back();
                employeeFormController.resetCountryValue();

                Get.offAll(
                  () => BottomNavAdmin(
                    initialIndex: 4,
                  ),
                );
              },
              title: 'Edit Details',
              actions: [
                commonSaveButton(onPressed: () async {
                  // if (_formkey.currentState!.validate()) {
                  // Assign the values from the controllers
                  fname = firstnamecontroller.text;
                  middlename = middlenamecontroller.text;
                  lname = lastnamecontroller.text;
                  address = addresscontroller.text;
                  aadhar = aadharcontroller.text;
                  mobileNumber = mobilenucontroller.text;
                  mobileNumbertwo = mobilenutwocontroller.text;
                  mobileNumberthree = mobilenuthreecontroller.text;
                  email = emailcontroller.text;
                  acno = acnocontroller.text;
                  ifsc = ifsccontroller.text;
                  referance = referancecontroller.text;
                  srno = srnocontroller.text;
                  branchaddres = branchaddresscontroller.text;
                  pass = passController.text;
                  confirmPass = confirmPassWordController.text;
                  if (!validateAllFields()) return;
                  // Validate image
                  String imagePath;
                  if (selectedImages != null) {
                    imagePath = selectedImages!.path;
                  } else if (widget.employee?.image != null) {
                    imagePath = widget.employee!.image;
                  } else {
                    primaryToast(
                        msg:
                            'Please select an image or keep the existing one.');
                    return;
                  }
                  List<String> allDocuments = [];
                  if (widget.employee?.documents != null) {
                    allDocuments.addAll(widget.employee!.documents);
                  }
                  if (selectedDocuments != null) {
                    allDocuments.addAll(
                        selectedDocuments!.map((file) => file.path).toList());
                  }
                  log('isAadharSelected==${isAadharSelected}');
                  log('frontAadharFilePath==${editController.frontAadharFilePath.value}');
                  log('backAadharFilePath==${editController.backAadharFilePath.value}');
                  log('isBankPassbookSelected==${isBankPassbookSelected}');
                  log('bankPassbookFile==${bankPassbookFile}');
                  if (widget.employee?.documents != null) {
                    allDocuments.addAll(widget.employee!.documents);
                  }
                  if (selectedDocuments != null) {
                    allDocuments.addAll(
                        selectedDocuments!.map((file) => file.path).toList());
                  }
                  // Add Aadhar and Bank Passbook file paths to the documents list
                  if (employeeFormController
                          .uploadedDocuments[commonString.aadhar] !=
                      null) {
                    allDocuments.add(employeeFormController
                        .uploadedDocuments[commonString.aadhar]!.path);
                  }
                  if (employeeFormController
                          .uploadedDocuments[commonString.passbook] !=
                      null) {
                    allDocuments.add(employeeFormController
                        .uploadedDocuments[commonString.passbook]!.path);
                  }
                  Map<String, File?> uploadedDocuments = {};
                  log('pass==>>${pass}');
                  log('confirmPass==>>${confirmPass}');
                  log('passController==>>${passController.text}');
                  log('selectedProofs==>>${selectedProofs}');
                  log('confirmPassContro==>>${confirmPassWordController.text}');
                  log('otherDocuments.length==>>${userDashBoardController.otherDocuments.length}');
                  log('selectedDocs.length==>>${userDashBoardController.selectedDocs.length}');
                  List<OtherDocumentsModel> otherDocumentsList = [];
                  for (var doc in editController.otherDocuments) {
                    otherDocumentsList.add(OtherDocumentsModel(
                      name: doc.name,
                      check: doc.check,
                      otherFile: doc.otherFile,
                    ));
                  }
                  log('otherDocumentsList${otherDocumentsList}');

                  AadharCardModel aadharCard = AadharCardModel(
                    frontSidePath: editController.frontAadharFilePath.value,
                    backSidePath: editController.backAadharFilePath.value,
                  );
                  UploadedDocumentsModel attachedFiles = UploadedDocumentsModel(
                    aadharCard: aadharCard,
                    bankPassbookFile: bankPassbookFile,
                    otherFiles: otherDocumentsList,
                  );
                  log('otherDocumentsList${otherDocumentsList}');
                  log('attachedFiles${attachedFiles.otherFiles.length}');
                  // Build user profile
                  UserProfile newProfile = UserProfile(
                      firstName: fname!,
                      middleName: middlename!,
                      lastName: lname!,
                      address: address!,
                      aadhar: aadhar!,
                      gender: group!,
                      birthDate:
                          "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                      mobilenoone: mobileNumber!,
                      mobilentwo: mobileNumbertwo!,
                      email: email!,
                      bankName: dropdownvaluebank,
                      branchAddress: branchaddres!,
                      accountNumber: acno!,
                      ifscCode: ifsc!,
                      reference: referance!,
                      employmentType: officegroup!,
                      srNo: srno!,
                      documents: allDocuments,
                      image: imagePath,
                      attachProof: selectedProofs,
                      password: pass,
                      confirmPass: confirmPass,
                      country:
                          employeeFormController.countryController.value.text,
                      state: employeeFormController.stateController.value.text,
                      city: employeeFormController.cityController.value.text,
                      zipCode: zipCodeController.text,
                      uploadedDocuments: {},
                      attachedFiles: attachedFiles);

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  // Fetch existing admin data from SharedPreferences
                  String? existingAdminDataString =
                      prefs.getString('adminData');
                  List<Map<String, dynamic>> existingAdminList = [];

                  if (existingAdminDataString != null &&
                      existingAdminDataString.isNotEmpty) {
                    existingAdminList = List<Map<String, dynamic>>.from(
                        jsonDecode(existingAdminDataString));
                  }

                  // Update admin data if srNo matches
                  bool isUpdated = false;
                  for (int i = 0; i < existingAdminList.length; i++) {
                    if (existingAdminList[i]['srNo'] == srno) {
                      existingAdminList[i] =
                          newProfile.toMap(); // Update the admin profile
                      isUpdated = true; // Mark that we have updated the admin
                      break; // Exit loop once the admin is found and updated
                    }
                  }

                  if (isUpdated) {
                    // Save the updated admin data back to SharedPreferences
                    await prefs.setString(
                        'adminData', jsonEncode(existingAdminList));

                    // Log the updated admin data to verify the change
                    log("Updated Admin Data: ${jsonEncode(existingAdminList)}");

                    // Fetch updated admin data and update BottomNavAdmin UI
                    userDashBoardController
                        .fetchAdminData(); // Fetch and update data in BottomNavAdmin

                    // Show success toast and navigate to next screen
                    primaryToast(msg: 'Update submitted successfully!');

                    setState(() {
                      isOtherSelected = false;
                    });

                    employeeFormController.resetCountryValue();
                    Get.offAll(
                      () => BottomNavAdmin(
                        initialIndex: 4,
                      ),
                    );
                  } else {
                    log("Admin with srNo $srno not found.");
                  }

                  // employeeFormController.countryController.value.clear();
                  // employeeFormController.stateController.value.clear();
                  // employeeFormController.cityController.value.clear();
                  // Clear form after successful save
                  firstnamecontroller.clear();
                  middlenamecontroller.clear();
                  lastnamecontroller.clear();
                  addresscontroller.clear();
                  aadharcontroller.clear();
                  mobilenucontroller.clear();
                  mobilenutwocontroller.clear();
                  mobilenuthreecontroller.clear();
                  emailcontroller.clear();
                  acnocontroller.clear();
                  ifsccontroller.clear();
                  referancecontroller.clear();
                  srnocontroller.clear();
                  branchaddresscontroller.clear();
                  // employeeFormController.selectCountry();
                  // }
                }),
              ]),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    35.height,
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: selectedImages != null
                                      ? FileImage(selectedImages!)
                                      : FileImage(File(widget.employee!.image)),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: AppColors.white),
                                        child: Padding(
                                          padding: 20.symmetric,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  final XFile? photo =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .camera);
                                                  if (photo != null) {
                                                    File? croppedFile =
                                                        await ImageCropperHelper
                                                            .cropImage(
                                                      File(photo.path),
                                                    );

                                                    setState(() {
                                                      selectedImages =
                                                          croppedFile;
                                                    });

                                                    Navigator.pop(context);
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(''),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: cameraBtn(
                                                  text: "Camera",
                                                  image: AppSvg.takephoto,
                                                ),
                                              ),
                                              20.width,
                                              GestureDetector(
                                                onTap: () async {
                                                  final XFile? pickedFile =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .gallery,
                                                          imageQuality: 100,
                                                          maxHeight: 1000,
                                                          maxWidth: 1000);
                                                  if (pickedFile != null) {
                                                    File? croppedFile =
                                                        await ImageCropperHelper
                                                            .cropImage(
                                                      File(pickedFile.path),
                                                    );

                                                    setState(() {
                                                      selectedImages =
                                                          croppedFile;
                                                    });
                                                  } else {}
                                                  Navigator.pop(context);
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
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: AppColors.black,
                                  size: 19,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    35.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: 15.horizontal,
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.all(10),
                            decoration: commonDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: commonProfileLabel(
                                    label: "Personal information",
                                  ),
                                ),
                                commonDivider(),
                                commontext(text: "First Name"),
                                fieldBottomHeight(),
                                commontextfield(
                                  controller: firstnamecontroller,
                                  onChanged: (value) {
                                    fname = value;
                                  },
                                  text: "Enter First name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your First name';
                                    }

                                    return null;
                                  },
                                ),
                                labelHeight(),
                                commontext(text: "Last Name"),
                                fieldBottomHeight(),
                                commontextfield(
                                  controller: lastnamecontroller,
                                  onChanged: (value) {
                                    lname = value;
                                  },
                                  text: "Enter Last name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Last name';
                                    }

                                    return null;
                                  },
                                ),
                                labelHeight(),
                                commontext(text: "Birth Date"),
                                fieldBottomHeight(),
                                commonDateCon(
                                  label: selectedDate != null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(selectedDate!)
                                      : 'No date selected',
                                  onTap: () {
                                    dateSelect(context);
                                  },
                                ),
                                labelHeight(),
                                commontext(text: "Gender"),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 20.0,
                                    // left: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      radioBtn(
                                          value: commonString.female,
                                          groupValue: group,
                                          onChanged: (val) {
                                            setState(() {
                                              group = val;
                                            });
                                          }),
                                      Text(
                                        "Female",
                                        style: poppinsStyle(),
                                      ),
                                      Spacer(),
                                      radioBtn(
                                          value: commonString.male,
                                          groupValue: group,
                                          onChanged: (val) {
                                            setState(() {
                                              group = val;
                                            });
                                          }),
                                      Text(
                                        "Male",
                                        style: poppinsStyle(),
                                      ),
                                      Spacer(),
                                      radioBtn(
                                          value: commonString.other,
                                          groupValue: group,
                                          onChanged: (val) {
                                            setState(() {
                                              group = val;
                                            });
                                          }),
                                      Text(
                                        "Other",
                                        style: poppinsStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                                labelHeight(),
                                commontext(text: "Aadhar"),
                                fieldBottomHeight(),
                                commontextfield(
                                  keyboardType: TextInputType.number,
                                  controller: aadharcontroller,
                                  onChanged: (value) {
                                    aadhar = value;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(12),
                                  ],
                                  text: "Enter Aadhar",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Aadhar No';
                                    }

                                    return null;
                                  },
                                ),
                                labelHeight(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    commontext(text: "Email ID"),
                                    fieldBottomHeight(),
                                    commontextfield(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: emailcontroller,
                                      onChanged: (value) {
                                        email = value;
                                      },
                                      text: "Email ID",
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
                                    commontext(text: "Mobile no 1"),
                                    fieldBottomHeight(),
                                    commontextfield(
                                      keyboardType: TextInputType.number,
                                      controller: mobilenucontroller,
                                      onChanged: (value) {
                                        mobileNumber = value;
                                      },
                                      text: "Enter Mobile no 1",
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter mobile no 1';
                                        }
                                        if (value.length != 10) {
                                          return 'Mobile number must be exactly 10 digits';
                                        }

                                        return null;
                                      },
                                    ),
                                    labelHeight(),
                                    commontext(text: "Mobile no 2"),
                                    fieldBottomHeight(),
                                    commontextfield(
                                      keyboardType: TextInputType.number,
                                      controller: mobilenutwocontroller,
                                      onChanged: (value) {
                                        mobileNumbertwo = value;
                                      },
                                      text: "Enter Mobile no 2",
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter mobile no 2';
                                        }
                                        if (value.length != 10) {
                                          return 'Mobile number must be exactly 10 digits';
                                        }

                                        return null;
                                      },
                                    ),
                                    labelHeight(),
                                    commontext(text: "Residential Address"),
                                    fieldBottomHeight(),
                                    commontextfield(
                                      maxLines: 3,
                                      controller: addresscontroller,
                                      onChanged: (value) {
                                        address = value;
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
                                    commontext(text: "Select Country"),
                                    fieldBottomHeight(),
                                    Obx(() => commontextfield(
                                          readOnly: true,
                                          controller: employeeFormController
                                              .countryController.value,
                                          text: "Select Country",
                                          validator: (value) {
                                            // if (value == null ||
                                            //     value.isEmpty) {
                                            //   return 'Please select a country';
                                            // }
                                            // return null;
                                          },
                                          suffixIcon: fieldSuffixIcon(),
                                          onTap: () {
                                            employeeFormController
                                                .filteredCountryList
                                                .value = countries;
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return searchDialog(
                                                  searchField: commontextfield(
                                                    text: "Search Country...",
                                                    prefixIcon:
                                                        countrySearchBtn(),
                                                    onChanged: (value) {
                                                      employeeFormController
                                                              .countrySearch
                                                              .value =
                                                          value.toLowerCase();
                                                      employeeFormController
                                                              .filteredCountryList
                                                              .value =
                                                          countries
                                                              .where((country) => country
                                                                  .title
                                                                  .toLowerCase()
                                                                  .contains(value
                                                                      .toLowerCase()))
                                                              .toList();
                                                    },
                                                  ),
                                                  title: "Select Country",
                                                  listView: Obx(() {
                                                    return employeeFormController
                                                            .filteredCountryList
                                                            .isEmpty
                                                        ? Expanded(
                                                            child:
                                                                searchLottie())
                                                        : Expanded(
                                                            child: ListView
                                                                .builder(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              itemCount:
                                                                  employeeFormController
                                                                      .filteredCountryList
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final country =
                                                                    employeeFormController
                                                                            .filteredCountryList[
                                                                        index];
                                                                final originalIndex =
                                                                    countries.indexWhere((c) =>
                                                                        c.title ==
                                                                        country
                                                                            .title);

                                                                return searchDialogItem(
                                                                  title: country
                                                                      .title,
                                                                  onTap: () {
                                                                    employeeFormController.selectCountryOnTap(
                                                                        originalIndex:
                                                                            originalIndex,
                                                                        country:
                                                                            country);
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          );
                                                  }),
                                                );
                                              },
                                            ).whenComplete(() {
                                              employeeFormController
                                                  .countrySearch.value = '';
                                            });
                                          },
                                        )),
                                    labelHeight(),
                                    commontext(text: "Select State"),
                                    fieldBottomHeight(),
                                    Obx(() => commontextfield(
                                          readOnly: true,
                                          controller: employeeFormController
                                              .stateController.value,
                                          text: "Select State",
                                          suffixIcon: fieldSuffixIcon(),
                                          onTap: () {
                                            final selectedCountry = countries[
                                                employeeFormController
                                                    .selectedCountryIndex
                                                    .value];

                                            // Ensure that the selectedCountry has states available
                                            if (selectedCountry
                                                .states.isEmpty) {
                                              print(
                                                  'No states available for the selected country');
                                              return;
                                            }

                                            employeeFormController
                                                .filteredStateList
                                                .value = selectedCountry.states;

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return searchDialog(
                                                  searchField: commontextfield(
                                                    text: "Search State...",
                                                    prefixIcon:
                                                        countrySearchBtn(),
                                                    onChanged: (value) {
                                                      final lowerValue =
                                                          value.toLowerCase();
                                                      employeeFormController
                                                          .stateSearch
                                                          .value = lowerValue;

                                                      employeeFormController
                                                              .filteredStateList
                                                              .value =
                                                          selectedCountry.states
                                                              .where((state) => state
                                                                  .name
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      lowerValue))
                                                              .toList();
                                                    },
                                                  ),
                                                  title: "Select State",
                                                  listView: Obx(() {
                                                    final filteredStates =
                                                        employeeFormController
                                                            .filteredStateList;
                                                    if (filteredStates
                                                        .isEmpty) {
                                                      return Expanded(
                                                          child:
                                                              searchLottie()); // Placeholder for empty state list
                                                    }

                                                    return Expanded(
                                                      child: ListView.builder(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        itemCount:
                                                            filteredStates
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final selectedState =
                                                              filteredStates[
                                                                  index];
                                                          final originalIndex = selectedCountry
                                                              .states
                                                              .indexWhere((s) =>
                                                                  s.name
                                                                      .toLowerCase() ==
                                                                  selectedState
                                                                      .name
                                                                      .toLowerCase());

                                                          // If the state is found, show the item
                                                          if (originalIndex !=
                                                              -1) {
                                                            return searchDialogItem(
                                                              title:
                                                                  selectedState
                                                                      .name,
                                                              onTap: () {
                                                                employeeFormController
                                                                    .selectStateOnTap(
                                                                  selectedCountry:
                                                                      selectedCountry,
                                                                  selectedState:
                                                                      selectedState,
                                                                );
                                                              },
                                                            );
                                                          } else {
                                                            // Handle case where state is not found
                                                            print(
                                                                'Error: selected state not found in the original list');
                                                            return Container();
                                                          }
                                                        },
                                                      ),
                                                    );
                                                  }),
                                                );
                                              },
                                            ).whenComplete(() {
                                              employeeFormController
                                                      .stateSearch.value =
                                                  ''; // Clear search term after dialog is dismissed
                                            });
                                          },
                                        ))

                                    // Obx(() => commontextfield(
                                    //       readOnly: true,
                                    //       controller: employeeFormController
                                    //           .stateController.value,
                                    //       text: "Select State",
                                    //       suffixIcon: fieldSuffixIcon(),
                                    //       onTap: () {
                                    //         final selectedCountry = countries[
                                    //             employeeFormController
                                    //                 .selectedCountryIndex
                                    //                 .value];
                                    //
                                    //         employeeFormController
                                    //             .filteredStateList
                                    //             .value = selectedCountry.states;
                                    //
                                    //         showDialog(
                                    //           context: context,
                                    //           builder: (context) {
                                    //             return searchDialog(
                                    //               searchField: commontextfield(
                                    //                 text: "Search State...",
                                    //                 prefixIcon:
                                    //                     countrySearchBtn(),
                                    //                 onChanged: (value) {
                                    //                   final lowerValue =
                                    //                       value.toLowerCase();
                                    //                   employeeFormController
                                    //                       .stateSearch
                                    //                       .value = lowerValue;
                                    //
                                    //                   employeeFormController
                                    //                           .filteredStateList
                                    //                           .value =
                                    //                       selectedCountry.states
                                    //                           .where((state) => state
                                    //                               .name
                                    //                               .toLowerCase()
                                    //                               .contains(
                                    //                                   lowerValue))
                                    //                           .toList();
                                    //                 },
                                    //               ),
                                    //               title: "Select State",
                                    //               listView: Obx(() {
                                    //                 final filteredStates =
                                    //                     employeeFormController
                                    //                         .filteredStateList;
                                    //
                                    //                 return filteredStates
                                    //                         .isEmpty
                                    //                     ? Expanded(
                                    //                         child:
                                    //                             searchLottie())
                                    //                     : Expanded(
                                    //                         child: ListView
                                    //                             .builder(
                                    //                           padding:
                                    //                               const EdgeInsets
                                    //                                   .only(
                                    //                                   left: 5),
                                    //                           itemCount:
                                    //                               filteredStates
                                    //                                   .length,
                                    //                           itemBuilder:
                                    //                               (context,
                                    //                                   index) {
                                    //                             final selectedState =
                                    //                                 filteredStates[
                                    //                                     index];
                                    //                             final originalIndex = selectedCountry
                                    //                                 .states
                                    //                                 .indexWhere((s) =>
                                    //                                     s.name
                                    //                                         .toLowerCase() ==
                                    //                                     selectedState
                                    //                                         .name
                                    //                                         .toLowerCase());
                                    //
                                    //                             return searchDialogItem(
                                    //                               title:
                                    //                                   selectedState
                                    //                                       .name,
                                    //                               onTap: () {
                                    //                                 if (originalIndex !=
                                    //                                     -1) {
                                    //                                   employeeFormController
                                    //                                       .selectStateOnTap(
                                    //                                     selectedCountry:
                                    //                                         selectedCountry,
                                    //                                     selectedState:
                                    //                                         selectedState,
                                    //                                   );
                                    //                                 } else {
                                    //                                   print(
                                    //                                       'Error: selected state not found');
                                    //                                 }
                                    //                               },
                                    //                             );
                                    //                           },
                                    //                         ),
                                    //                       );
                                    //               }),
                                    //             );
                                    //           },
                                    //         ).whenComplete(() {
                                    //           employeeFormController
                                    //               .stateSearch.value = '';
                                    //         });
                                    //       },
                                    //     )),
                                    ,
                                    labelHeight(),
                                    commontext(text: "Select City"),
                                    fieldBottomHeight(),
                                    Obx(() => commontextfield(
                                          readOnly: true,
                                          controller: employeeFormController
                                              .cityController.value,
                                          text: "Select City",
                                          suffixIcon: fieldSuffixIcon(),
                                          onTap: () {
                                            employeeFormController
                                                .filteredCityList
                                                .value = countries[
                                                    employeeFormController
                                                        .selectedCountryIndex
                                                        .value]
                                                .states[employeeFormController
                                                    .selectedStateIndex.value]
                                                .cities;

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return searchDialog(
                                                  searchField: commontextfield(
                                                    text: "Search City...",
                                                    prefixIcon:
                                                        countrySearchBtn(),
                                                    onChanged: (value) {
                                                      employeeFormController
                                                              .citySearch
                                                              .value =
                                                          value.toLowerCase();
                                                      employeeFormController
                                                          .filteredCityList
                                                          .value = countries[
                                                              employeeFormController
                                                                  .selectedCountryIndex
                                                                  .value]
                                                          .states[employeeFormController
                                                              .selectedStateIndex
                                                              .value]
                                                          .cities
                                                          .where((city) => city
                                                              .toLowerCase()
                                                              .contains(value
                                                                  .toLowerCase()))
                                                          .toList();
                                                    },
                                                  ),
                                                  title: "Select City",
                                                  listView: Obx(() {
                                                    return employeeFormController
                                                            .filteredCityList
                                                            .isEmpty
                                                        ? Expanded(
                                                            child:
                                                                searchLottie())
                                                        : Expanded(
                                                            child: ListView
                                                                .builder(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              itemCount:
                                                                  employeeFormController
                                                                      .filteredCityList
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final city =
                                                                    employeeFormController
                                                                            .filteredCityList[
                                                                        index];
                                                                return searchDialogItem(
                                                                  title: city,
                                                                  onTap: () {
                                                                    employeeFormController.selectCityOnTap(
                                                                        city:
                                                                            city,
                                                                        index:
                                                                            index);
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          );
                                                  }),
                                                );
                                              },
                                            ).whenComplete(() {
                                              employeeFormController
                                                  .citySearch.value = '';
                                            });
                                          },
                                        )),
                                    labelHeight(),
                                    commontext(text: "ZipCode"),
                                    fieldBottomHeight(),
                                    commontextfield(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(6),
                                        FilteringTextInputFormatter.digitsOnly,
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d{0,6}$')),
                                      ],
                                      controller: zipCodeController,
                                      onChanged: (value) {
                                        zipCode = value;
                                      },
                                      text: "Enter Zipcode",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter ZipCode';
                                        }
                                        if (value.length < 5 ||
                                            value.length > 6) {
                                          return 'Zip Code must be 5 or 6 digits';
                                        }
                                        return null;
                                      },
                                    ),
                                    labelHeight(),
                                    commontext(text: "Password"),
                                    fieldBottomHeight(),
                                    commontextfield(
                                      controller: passController,
                                      onChanged: (value) {
                                        pass = value;
                                      },
                                      obscureText: passwordVisible,
                                      suffixIcon: GestureDetector(
                                          //iconSize: 15,
                                          onTap: () {
                                            setState(() {
                                              passwordVisible =
                                                  !passwordVisible;
                                            });
                                          },
                                          child: visibilityIcon(
                                            icon: passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          )),
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
                                        if (!RegExp(r'[!@#\$&*~_]')
                                            .hasMatch(value)) {
                                          return 'Password must have at least one special character';
                                        }
                                        return null;
                                      },
                                    ),
                                    labelHeight(),
                                    commontext(text: "Confirm Password"),
                                    fieldBottomHeight(),
                                    commontextfield(
                                      controller: confirmPassWordController,
                                      onChanged: (value) {
                                        confirmPass = value;
                                      },
                                      obscureText: confirmPasswordVisible,
                                      suffixIcon: GestureDetector(
                                          //iconSize: 15,
                                          onTap: () {
                                            setState(() {
                                              confirmPasswordVisible =
                                                  !confirmPasswordVisible;
                                            });
                                          },
                                          child: visibilityIcon(
                                            icon: confirmPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          )),
                                      text: "Enter Confirm PassWord",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Confirm Password';
                                        }
                                        if (value.trim() !=
                                            passController.text.trim()) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 25.height,
                        Padding(
                          padding: 10.vertical,
                          child: commonDivider(
                              color: AppColors.grey.withOpacity(0.5)),
                        ),

                        Padding(
                          padding: 15.horizontal,
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.all(10),
                            decoration: commonDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: commonProfileLabel(
                                    label: "Bank Details",
                                  ),
                                ),
                                commonDivider(),
                                commontext(text: "Bank Name"),
                                fieldBottomHeight(),
                                DropdownButtonFormField<String>(
                                  hint: Text(
                                    "Bank Name",
                                    style:
                                        poppinsStyle(color: AppColors.hinttext),
                                  ),
                                  value: dropdownvaluebank.isNotEmpty
                                      ? dropdownvaluebank
                                      : null,
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.hinttext,
                                  ),
                                  decoration: commonDropdownDeco(),
                                  dropdownColor: AppColors.white,
                                  items: itemsbank.map((String item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: poppinsStyle(
                                          color: AppColors.hinttext,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? val) {
                                    ((_) {
                                      setState(() {
                                        dropdownvaluebank = val!;
                                      });
                                    });
                                  },
                                ),
                                labelHeight(),
                                commontext(text: "Ac No"),
                                fieldBottomHeight(),
                                commontextfield(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(15),
                                  ],
                                  keyboardType: TextInputType.number,
                                  controller: acnocontroller,
                                  onChanged: (value) {
                                    acno = value;
                                  },
                                  text: "Enter Ac No",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Ac no';
                                    }
                                    return null;
                                  },
                                ),
                                labelHeight(),
                                commontext(text: "IFSC"),
                                fieldBottomHeight(),
                                commontextfield(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'[A-Z0-9]')), // Allow only uppercase letters and digits
                                    LengthLimitingTextInputFormatter(
                                        11), // Limit to 11 characters
                                    UpperCaseTextFormatter(),
                                  ],
                                  // keyboardType: TextInputType.number,
                                  controller: ifsccontroller,
                                  textCapitalization:
                                      TextCapitalization.characters,

                                  onChanged: (value) {
                                    ifsc = value;
                                  },
                                  text: "Enter IFSC",
                                  validator: (value) {
                                    final ifscPattern =
                                        RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your IFSC';
                                    } else if (!ifscPattern.hasMatch(value)) {
                                      return 'Invalid IFSC code';
                                    }

                                    return null;
                                  },
                                ),
                                labelHeight(),
                                commontext(text: "Branch Address"),
                                fieldBottomHeight(),
                                commontextfield(
                                  // keyboardType: TextInputType.number,
                                  controller: branchaddresscontroller,
                                  onChanged: (value) {
                                    branchaddres = value;
                                  },
                                  text: "Enter Branch Address",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Branch Address';
                                    }

                                    return null;
                                  },
                                ),

                                labelHeight(),
                                commontext(text: "Reference"),
                                fieldBottomHeight(),
                                commontextfield(
                                  controller: referancecontroller,
                                  onChanged: (value) {
                                    referance = value;
                                  },
                                  text: "Enter Reference",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Reference';
                                    }

                                    return null;
                                  },
                                ),
                                labelHeight(),
                                Text(
                                  "Attach Proofs",
                                  style: poppinsStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                                // 5.height,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          activeColor: AppColors.primarycolor,
                                          value: isAadharSelected,
                                          onChanged: (bool? value) {
                                            isAadharSelected = value!;

                                            getSelectedProofs();
                                            setState(() {});
                                            if (!value) {
                                              editController.removeAadharCard();
                                            }
                                          },
                                        ),
                                        Text("Aadhar Card",
                                            style:
                                                poppinsStyle()), // Document Name
                                        Spacer(),
                                        if (isAadharSelected)
                                          addBtn(
                                            onTap: () {
                                              // Show dialog to choose front or back side
                                              showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (context) {
                                                  return selectAadharSideDialog(
                                                    title:
                                                        "Select Document Side",
                                                    FrontOnTap: () {
                                                      Navigator.pop(
                                                          context); // Close the dialog
                                                      // Open file picker for front side
                                                      editController
                                                          .pickAadharDoc(
                                                              commonString
                                                                  .aadhar,
                                                              "front");
                                                    },
                                                    backOnTap: () {
                                                      Navigator.pop(
                                                          context); // Close the dialog
                                                      // Open file picker for back side
                                                      editController
                                                          .pickAadharDoc(
                                                              commonString
                                                                  .aadhar,
                                                              "back");
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                      ],
                                    ),
                                    Obx(() {
                                      return Column(
                                        children: [
                                          // Display front side Aadhar image with delete and open functionality
                                          if (editController
                                              .frontAadharFilePath.isNotEmpty)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                aadharLabelText(
                                                    side: 'Front Side'),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12.0),
                                                  child: ListTile(
                                                    onTap: () async {
                                                      final file = File(
                                                          editController
                                                              .frontAadharFilePath
                                                              .value);
                                                      openFile(
                                                          file); // Using the common method for opening file
                                                    },
                                                    leading: const Icon(
                                                        Icons.file_present),
                                                    title: selectedDocTitle(
                                                      label: editController
                                                          .frontAadharFilePath
                                                          .value
                                                          .split('/')
                                                          .last,
                                                    ),
                                                    subtitle:
                                                        selectedDocSubTitle(
                                                      subTitle:
                                                          "File Type: ${editController.frontAadharFilePath.value.split('.').last.toUpperCase()}",
                                                    ),
                                                    trailing: GestureDetector(
                                                      child:
                                                          selectedDocDelete(),
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return commonLogOutDialog(
                                                              title: 'Delete',
                                                              iconColor:
                                                                  AppColors.red,
                                                              deleteButtonColor:
                                                                  AppColors.red,
                                                              subTitle:
                                                                  'Are you sure you want to delete this file?',
                                                              confirmText:
                                                                  'Delete',
                                                              cancelText:
                                                                  'Cancel',
                                                              icon: Icons
                                                                  .warning_amber_rounded,
                                                              cancelOnPressed:
                                                                  () => Get
                                                                      .back(),
                                                              logOutOnPressed:
                                                                  () {
                                                                print(
                                                                    "DELETE CONFIRMED ✅");
                                                                editController
                                                                    .frontAadharFilePath
                                                                    .value = '';
                                                                Get.back();
                                                              },
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                          // Display back side Aadhar image with delete and open functionality
                                          if (editController
                                              .backAadharFilePath.isNotEmpty)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                aadharLabelText(
                                                    side: 'Back Side'),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12.0),
                                                  child: ListTile(
                                                    onTap: () async {
                                                      final file = File(
                                                          editController
                                                              .backAadharFilePath
                                                              .value);
                                                      openFile(
                                                          file); // Using the common method for opening file
                                                    },
                                                    leading: const Icon(
                                                        Icons.file_present),
                                                    title: selectedDocTitle(
                                                      label: editController
                                                          .backAadharFilePath
                                                          .value
                                                          .split('/')
                                                          .last,
                                                    ),
                                                    subtitle:
                                                        selectedDocSubTitle(
                                                      subTitle:
                                                          "File Type: ${editController.backAadharFilePath.value.split('.').last.toUpperCase()}",
                                                    ),
                                                    trailing: GestureDetector(
                                                      child:
                                                          selectedDocDelete(),
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return commonLogOutDialog(
                                                              title: 'Delete',
                                                              iconColor:
                                                                  AppColors.red,
                                                              deleteButtonColor:
                                                                  AppColors.red,
                                                              subTitle:
                                                                  'Are you sure you want to delete this file?',
                                                              confirmText:
                                                                  'Delete',
                                                              cancelText:
                                                                  'Cancel',
                                                              icon: Icons
                                                                  .warning_amber_rounded,
                                                              cancelOnPressed:
                                                                  () => Get
                                                                      .back(),
                                                              logOutOnPressed:
                                                                  () {
                                                                print(
                                                                    "DELETE CONFIRMED ✅");
                                                                editController
                                                                    .backAadharFilePath
                                                                    .value = '';
                                                                Get.back();
                                                              },
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          activeColor: AppColors.primarycolor,
                                          value: isBankPassbookSelected,
                                          onChanged: (bool? value) {
                                            setState(() {});
                                            isBankPassbookSelected = value!;

                                            getSelectedProofs();
                                            if (!value) {
                                              removeDocuments(
                                                  commonString.passbook);
                                            }
                                          },
                                        ),
                                        Text("Bank Passbook",
                                            style: poppinsStyle()),
                                        Spacer(),
                                        if (isBankPassbookSelected)
                                          addBtn(
                                            onTap: () {
                                              pickDocumentFor(
                                                  commonString.passbook);
                                            },
                                          )
                                      ],
                                    ),
                                    if (bankPassbookFile != null &&
                                        isBankPassbookSelected)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: ListTile(
                                          onTap: () async {
                                            final file = bankPassbookFile!;
                                            try {
                                              openFilex.OpenResult result =
                                                  await openFilex.OpenFilex
                                                      .open(file.path);
                                              if (result.type !=
                                                  openFilex.ResultType.done) {
                                                primaryToast(
                                                    msg:
                                                        "Failed to open file: ${result.message}");
                                              }
                                            } catch (e) {
                                              primaryToast(
                                                  msg:
                                                      "Error opening file: $e");
                                            }
                                          },
                                          leading:
                                              const Icon(Icons.file_present),
                                          title: selectedDocTitle(
                                            label: bankPassbookFile!.path
                                                .split('/')
                                                .last,
                                          ),
                                          subtitle: selectedDocSubTitle(
                                            subTitle:
                                                "File Type: ${bankPassbookFile!.path.split('.').last.toUpperCase()}",
                                          ),
                                          trailing: GestureDetector(
                                            child: selectedDocDelete(),
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return commonLogOutDialog(
                                                    title: 'Delete',
                                                    iconColor: AppColors.red,
                                                    deleteButtonColor:
                                                        AppColors.red,
                                                    subTitle:
                                                        'Are you sure you want to delete this file?',
                                                    confirmText: 'Delete',
                                                    cancelText: 'Cancel',
                                                    icon: Icons
                                                        .warning_amber_rounded,
                                                    cancelOnPressed: () =>
                                                        Get.back(),
                                                    logOutOnPressed: () {
                                                      print(
                                                          "DELETE CONFIRMED ✅");
                                                      log(" employeeFormController1${bankPassbookFile}");

                                                      bankPassbookFile = null;
                                                      setState(() {});
                                                      log(" employeeFormController2${bankPassbookFile}");

                                                      Get.back();
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                  ],
                                ),

                                Obx(
                                  () => ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        editController.otherDocuments.length,
                                    itemBuilder: (context, index) {
                                      log('editController.otherDocuments.length==>>${editController.otherDocuments.length}');
                                      final doc =
                                          editController.otherDocuments[index];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Obx(
                                                () => Checkbox(
                                                  activeColor:
                                                      AppColors.primarycolor,
                                                  value: editController
                                                              .selectedDocs[
                                                          index] ??
                                                      false,
                                                  onChanged: (bool? value) {
                                                    editController
                                                        .toggleDocSelection(
                                                            index,
                                                            doc.name.toString(),
                                                            value ?? false,
                                                            getSelectedProofs());
                                                    if (value == false) {
                                                      editController
                                                          .removeNewFiles(
                                                              index);
                                                      setState(() {});
                                                    }
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(doc.name.toString(),
                                                    style: poppinsStyle()),
                                              ),
                                              IconButton(
                                                icon: editIcon(),
                                                onPressed: () {
                                                  // Open a dialog to edit the document name
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) {
                                                      TextEditingController
                                                          editDocController =
                                                          TextEditingController(
                                                              text: doc.name
                                                                  .toString());
                                                      return commonEditDocName(
                                                        onPressed: () {
                                                          // Update the document name
                                                          setState(() {});
                                                          if (editDocController
                                                              .text
                                                              .isNotEmpty) {
                                                            editController
                                                                    .otherDocuments[
                                                                        index]
                                                                    .name =
                                                                editDocController
                                                                    .text;
                                                            editController
                                                                .otherDocuments
                                                                .refresh();
                                                            Get.back(); // Close dialog
                                                          } else {
                                                            primaryToast(
                                                                msg:
                                                                    "Document name cannot be empty.");
                                                          }
                                                        },
                                                        controller:
                                                            editDocController,
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              Obx(() {
                                                final isChecked = editController
                                                        .selectedDocs[index] ??
                                                    false;
                                                return isChecked
                                                    ? addBtn(
                                                        onTap: () {
                                                          editController
                                                              .pickMultiFile(
                                                                  index);
                                                        },
                                                      )
                                                    : const SizedBox(); // Hide button if not selected
                                              }),
                                              5.width,
                                              GestureDetector(
                                                child: selectedDocDelete(),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return commonLogOutDialog(
                                                        title: 'Delete',
                                                        iconColor:
                                                            AppColors.red,
                                                        deleteButtonColor:
                                                            AppColors.red,
                                                        subTitle:
                                                            'Are you sure you want to delete this Document',
                                                        confirmText: 'Delete',
                                                        cancelText: 'Cancel',
                                                        icon: Icons
                                                            .warning_amber_rounded,
                                                        cancelOnPressed: () =>
                                                            Get.back(),
                                                        logOutOnPressed: () {
                                                          log("editController.otherDocuments==>${editController.otherDocuments}");
                                                          if (index >= 0 &&
                                                              index <
                                                                  editController
                                                                      .otherDocuments
                                                                      .length) {
                                                            editController
                                                                .otherDocuments
                                                                .removeAt(
                                                                    index);
                                                            editController
                                                                .selectedDocs
                                                                .remove(index);
                                                            editController
                                                                .otherDocuments
                                                                .refresh();
                                                            editController
                                                                .selectedDocs
                                                                .refresh();
                                                          }
                                                          // if (index >= 0 &&
                                                          //     index <
                                                          //         editController
                                                          //             .otherDocuments
                                                          //             .length) {
                                                          //   editController
                                                          //       .otherDocuments
                                                          //       .removeAt(
                                                          //           index); // Remove the document itself
                                                          //
                                                          //   editController
                                                          //       .selectedDocs
                                                          //       .remove(
                                                          //           index); // Remove checkbox selection
                                                          //
                                                          //   editController
                                                          //       .otherDocuments
                                                          //       .refresh(); // Notify UI to rebuild
                                                          //
                                                          //   editController
                                                          //       .selectedDocs
                                                          //       .refresh();
                                                          // }
                                                          Get.back();
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          if (doc.otherFile != null)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: ListTile(
                                                onTap: () async {
                                                  final file = doc.otherFile;

                                                  if (file != null &&
                                                      await file.exists()) {
                                                    try {
                                                      openFilex.OpenResult
                                                          result =
                                                          await openFilex
                                                                  .OpenFilex
                                                              .open(file.path);
                                                      if (result.type !=
                                                          openFilex.ResultType
                                                              .done) {
                                                        primaryToast(
                                                            msg:
                                                                "Failed to open file: ${result.message}");
                                                      }
                                                    } catch (e) {
                                                      primaryToast(
                                                          msg:
                                                              "Error opening file: $e");
                                                    }
                                                  } else {
                                                    primaryToast(
                                                        msg:
                                                            "No file found to open.");
                                                  }
                                                },
                                                leading: const Icon(
                                                    Icons.file_present),
                                                title: selectedDocTitle(
                                                  label: doc.otherFile != null
                                                      ? doc.otherFile!.path
                                                          .split('/')
                                                          .last
                                                      : 'No file selected',
                                                ),
                                                subtitle: selectedDocSubTitle(
                                                  subTitle:
                                                      "File Type: ${doc.otherFile!.path.split('.').last.toUpperCase()}",
                                                ),
                                                trailing: GestureDetector(
                                                  child: selectedDocDelete(),
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return commonLogOutDialog(
                                                          title: 'Delete',
                                                          iconColor:
                                                              AppColors.red,
                                                          deleteButtonColor:
                                                              AppColors.red,
                                                          subTitle:
                                                              'Are you sure you want to delete this file?',
                                                          confirmText: 'Delete',
                                                          cancelText: 'Cancel',
                                                          icon: Icons
                                                              .warning_amber_rounded,
                                                          cancelOnPressed: () =>
                                                              Get.back(),
                                                          logOutOnPressed: () {
                                                            editController
                                                                .removeNewFiles(
                                                                    index);

                                                            Get.back();
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          activeColor: AppColors.primarycolor,
                                          value: isOtherSelected,
                                          onChanged: (value) {
                                            log('isOtherSelected${isOtherSelected}');
                                            isOtherSelected = value!;
                                            log('isOtherSelected${isOtherSelected}');
                                            getSelectedProofs();
                                            setState(() {});
                                          },
                                        ),
                                        Text("Other Documents",
                                            style:
                                                poppinsStyle()), // Document Name
                                        Spacer(),
                                      ],
                                    ),
                                    Visibility(
                                      visible: isOtherSelected == true,
                                      child: Obx(
                                        () => commontextfield(
                                          controller: editController
                                              .customDocNameController.value,
                                          onChanged: (value) {
                                            setState(() {});
                                            editController.documentName.value =
                                                value;
                                          },
                                          text: "Enter Proof Title",
                                          validator: (value) {
                                            /*   if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter Reference';
                                                }

                                                return null;*/
                                          },
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              Icons.check,
                                              color: AppColors.primarycolor,
                                            ),
                                            onPressed: () {
                                              // setState(() {});
                                              editController.addDocumentName();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        10.height,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
