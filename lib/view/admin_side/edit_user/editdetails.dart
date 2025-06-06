import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/config/images.dart';
import 'package:employeeform/model/eprofilemodel.dart';
import 'package:employeeform/view/admin_side/employee_details.dart';
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
import '../../../controller/employeeformContro.dart';
import '../bottom_nav_admin.dart';
import '../company_profile/co_profile_form.dart';
import 'employeeform.dart';

class Editdetails extends StatefulWidget {
  final UserProfile? employee;
  final int? index;
  const Editdetails({
    super.key,
    this.employee,
    this.index,
  });

  @override
  State<Editdetails> createState() => EditdetailsState();
}

class EditdetailsState extends State<Editdetails> {
  EmployeeFormController employeeFormController =
      Get.put(EmployeeFormController());
  // employeeFormController employeeFormController = Get.put(employeeFormController());
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  File? aadharFile;
  File? bankPassbookFile;
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

  void removeDocuments(String proofType) {
    if (proofType == commonString.aadhar) {
      aadharFile = null;
    } else if (proofType == commonString.passbook) {
      bankPassbookFile = null;
    }
    setState(() {});
    // uploadedDocuments.remove(proofType);
  }

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

  TextEditingController zipCodeController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassWordController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  var uploadedDocs;

  void initState() {
    super.initState();

    if (widget.employee!.birthDate.isNotEmpty) {
      try {
        selectedDate = date(widget.employee!.birthDate);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
    if (widget.employee!.dateFrom.isNotEmpty) {
      try {
        selectedDatefrom = date(widget.employee!.dateFrom);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    if (widget.employee != null) {
      firstnamecontroller.text = widget.employee!.firstName;
      middlenamecontroller.text = widget.employee!.middleName;
      lastnamecontroller.text = widget.employee!.lastName;
      // emailcontroller.text = widget.employee!.email ;
      addresscontroller.text = widget.employee!.address;
      aadharcontroller.text = widget.employee!.aadhar;
      // selectedImages = widget.employee!.image ;
      group = widget.employee!.gender;
      emailcontroller.text = widget.employee!.email;
      selectedDate = DateFormat('dd-MM-yyyy').parse(widget.employee!.birthDate);
      selectedDatefrom =
          DateFormat('dd-MM-yyyy').parse(widget.employee!.dateFrom);

      mobilenucontroller.text = widget.employee!.mobilenoone;
      mobilenutwocontroller.text = widget.employee!.mobilentwo;
      mobilenuthreecontroller.text = widget.employee!.email;
      dropdownvaluebank = widget.employee!.bankName;
      branchaddresscontroller.text = widget.employee!.branchAddress;
      acnocontroller.text = widget.employee!.accountNumber;
      ifsccontroller.text = widget.employee!.ifscCode;
      referancecontroller.text = widget.employee!.reference;
      officegroup = widget.employee!.employmentType;
      srnocontroller.text = widget.employee!.srNo;

      selectedProofs = widget.employee!.attachProof;
      zipCodeController.text = widget.employee!.zipCode ?? '';
      countryController.text = widget.employee!.country ?? '';
      stateController.text = widget.employee!.state ?? '';
      cityController.text = widget.employee!.city ?? '';
      passController.text = widget.employee!.password ?? '';
      confirmPassWordController.text = widget.employee!.confirmPass ?? '';
      // aadharFile = widget.employee!.attachedFiles!.aadharFile;
      employeeFormController.frontAadharFilePath.value =
          widget.employee!.attachedFiles!.aadharCard!.frontSidePath;
      employeeFormController.backAadharFilePath.value =
          widget.employee!.attachedFiles!.aadharCard!.backSidePath;
      bankPassbookFile = widget.employee!.attachedFiles!.bankPassbookFile;
      updateSelectedProofs(selectedProofs: selectedProofs);
      selectedImages = File(widget.employee!.image);
      final otherFiles = widget.employee?.attachedFiles?.otherFiles;
      isOtherSelected = false;
      if (otherFiles != null && otherFiles.isNotEmpty) {
        // Populate the otherDocuments list
        employeeFormController.otherDocuments.assignAll(otherFiles);

        // Fill selectedDocs with initial checkbox values
        for (int i = 0; i < otherFiles.length; i++) {
          employeeFormController.selectedDocs[i] =
              otherFiles[i].check == true; // FIXED
        }

        // Assign known types (e.g. Aadhar, Passbook)
        for (var doc in otherFiles) {
          if (doc.name?.toLowerCase().contains('aadhar') == true &&
              doc.otherFile != null) {
            employeeFormController.aadharFile.value = doc.otherFile;
          } else if (doc.name?.toLowerCase().contains('passbook') == true &&
              doc.otherFile != null) {
            employeeFormController.bankPassbookFile.value = doc.otherFile;
          }
        }
      }
      employeeFormController.editCountryValue(
        country: widget.employee?.country,
        state: widget.employee?.state,
        city: widget.employee?.city,
      );

      log('employee!.country==>>${widget.employee!.country}');
      log('employee!.state==>>${widget.employee!.state}');
      log('employee!.city==>>${widget.employee!.city}');
      // log('aadharFile==>>${widget.employee!.attachedFiles!.aadharFile}');
      log('bankPassbookFile==>>${widget.employee!.attachedFiles!.bankPassbookFile}');
      log('otherFiles==>>${widget.employee!.attachedFiles!.otherFiles}');
      log('attachedFiles==>>${widget.employee!.attachedFiles}');
      // log('aadharFile==>>${widget.employee!.attachedFiles!.aadharFile}');
      log('bankPassbookFile==>>${widget.employee!.attachedFiles!.bankPassbookFile}');
      log('otherFiles==>>${widget.employee!.attachedFiles!.otherFiles}');
      for (var doc in widget.employee!.attachedFiles!.otherFiles) {
        log("doc.name==>>${doc.name}");
        log("doc.file==>>${doc.otherFile}");
        log("doc.check==>>${doc.check}");
      }
      // log('Aadhar File: ${widget.employee!.attachedFiles!.aadharFile?.path}');
      log('Bank Passbook File: ${widget.employee!.attachedFiles!.bankPassbookFile?.path}');
      log('Other Files: ${widget.employee!.attachedFiles!.otherFiles.map((file) => file).toList()}');

      log('employeeuploadedDocuments==>>${widget.employee!.uploadedDocuments}');
      log('employee_attachProof==>>${widget.employee!.attachProof}');
      log('officegroup==>>${officegroup}');
      log('passController==>>${passController.text}');
      log('confirmPassWordController==>>${confirmPassWordController.text}');
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
  String? zipCode;
  String? country;
  String? state;
  String? city;
  String? pass;
  String? confirmPass;
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
            employeeFormController.frontAadharFilePath.value.isEmpty &&
            employeeFormController.backAadharFilePath.value.isEmpty) ||
        (isBankPassbookSelected && bankPassbookFile == null)) {
      primaryToast(msg: "Please upload documents.");
      return false;
    }
    for (var i = 0; i < employeeFormController.otherDocuments.length; i++) {
      log('otherDocuments[i].check=>${employeeFormController.otherDocuments[i].check == true && employeeFormController.otherDocuments[i].otherFile == null}');
      if (employeeFormController.otherDocuments[i].check == true &&
          employeeFormController.otherDocuments[i].otherFile == null) {
        primaryToast(
            msg:
                "Please upload the ${employeeFormController.otherDocuments[i].name} document.");
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
        employeeFormController.resetValue();
        Get.offAll(
          () => BottomNavAdmin(),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: appBar(
            onTap: () {
              // Get.back();
              employeeFormController.resetCountryValue();
              employeeFormController.resetValue();
              Get.offAll(
                () => BottomNavAdmin(),
              );
            },
            title: 'Edit Details',
            actions: [
              commonSaveButton(onPressed: () async {
                // if (_formkey.currentState!.validate()) {
                fname = firstnamecontroller.text.trim();
                middlename = middlenamecontroller.text.trim();
                lname = lastnamecontroller.text.trim();
                address = addresscontroller.text.trim();
                aadhar = aadharcontroller.text.trim();
                mobileNumber = mobilenucontroller.text.trim();
                mobileNumbertwo = mobilenutwocontroller.text.trim();
                mobileNumberthree = mobilenuthreecontroller.text.trim();
                email = emailcontroller.text.trim();
                acno = acnocontroller.text.trim();
                ifsc = ifsccontroller.text.trim();
                referance = referancecontroller.text.trim();
                srno = srnocontroller.text.trim();
                branchaddres = branchaddresscontroller.text.trim();
                pass = passController.text.trim();
                confirmPass = confirmPassWordController.text.trim();

                if (!validateAllFields()) return;
                // Image validation
                String imagePath;
                if (selectedImages != null) {
                  imagePath = selectedImages!.path;
                } else if (widget.employee?.image != null) {
                  imagePath = widget.employee!.image;
                } else {
                  primaryToast(
                    msg: 'Please select an image or keep the existing one.',
                  );
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
                log('otherDocuments.length==>>${employeeFormController.otherDocuments.length}');
                log('otherDocuments.length==>>${employeeFormController.selectedDocs.length}');
                List<OtherDocumentsModel> otherDocumentsList = [];
                for (var doc in employeeFormController.otherDocuments) {
                  otherDocumentsList.add(OtherDocumentsModel(
                    name: doc.name,
                    check: doc.check,
                    otherFile: doc.otherFile,
                  ));
                }
                AadharCardModel aadharCard = AadharCardModel(
                  frontSidePath:
                      employeeFormController.frontAadharFilePath.value,
                  backSidePath: employeeFormController.backAadharFilePath.value,
                );
                UploadedDocumentsModel attachedFiles = UploadedDocumentsModel(
                  aadharCard: aadharCard,
                  bankPassbookFile: bankPassbookFile,
                  otherFiles: otherDocumentsList,
                );

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
                    dateFrom:
                        "${selectedDatefrom!.day}-${selectedDatefrom!.month}-${selectedDatefrom!.year}",
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
                    uploadedDocuments: uploadedDocuments,
                    attachedFiles: attachedFiles);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if (widget.index != null) {
                  userprofilelist[widget.index!] = newProfile;

                  List<Map<String, dynamic>> updatedEmployeeList =
                      userprofilelist.map((item) => item.toMap()).toList();
                  await prefs.setString(
                      'employeeData', jsonEncode(updatedEmployeeList));
                }

                primaryToast(
                  msg: "Update submitted successfully!",
                );

                String? employeeData = prefs.getString('employeeData');

                if (employeeData != null) {
                  List<dynamic> dataList = jsonDecode(employeeData);

                  // Convert the list of maps into a list of UserProfile objects
                  List<UserProfile> employees = dataList.map((data) {
                    return UserProfile.fromMap(data);
                  }).toList();

                  // Log the employee data
                  for (var employee in employees) {
                    // log('aadharFile: ${employee.attachedFiles!.aadharFile}');
                    log('bankPassbookFile: ${employee.attachedFiles!.bankPassbookFile}');
                    log('otherFiles: ${employee.attachedFiles!.otherFiles}');
                  }
                } else {
                  log('No employee data found in SharedPreferences.');
                }
                employeeFormController.resetValue();
                employeeFormController.resetCountryValue();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavAdmin(),
                  ),
                );
                // employeeFormController.resetValue();
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
                                                        source:
                                                            ImageSource.camera);
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
                                                } else {}
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
                                                        source:
                                                            ImageSource.gallery,
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(12),
                                ],
                                keyboardType: TextInputType.number,
                                controller: aadharcontroller,
                                onChanged: (value) {
                                  aadhar = value;
                                },
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
                                                          child: searchLottie())
                                                      : Expanded(
                                                          child:
                                                              ListView.builder(
                                                            padding:
                                                                EdgeInsets.only(
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
                                                  .selectedCountryIndex.value];

                                          // Log selected country information
                                          log('Selected Country: ${selectedCountry.title}');
                                          log('States in selected Country: ${selectedCountry.states.map((state) => state.name).join(", ")}');

                                          // Clear existing state list and set the new filtered states
                                          employeeFormController
                                              .filteredStateList
                                              .value = selectedCountry.states;
                                          log('Filtered States: ${employeeFormController.filteredStateList.map((state) => state.name).join(", ")}');

                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return searchDialog(
                                                searchField: commontextfield(
                                                  text: "Search State...",
                                                  prefixIcon:
                                                      countrySearchBtn(),
                                                  onChanged: (value) {
                                                    final query =
                                                        value.toLowerCase();
                                                    employeeFormController
                                                        .stateSearch
                                                        .value = query;
                                                    print(
                                                        'Searching for state: $query');

                                                    employeeFormController
                                                            .filteredStateList
                                                            .value =
                                                        selectedCountry.states
                                                            .where((s) => s.name
                                                                .toLowerCase()
                                                                .contains(
                                                                    query))
                                                            .toList();

                                                    // Log filtered state search result
                                                    log('Filtered States after search: ${employeeFormController.filteredStateList.value.map((state) => state.name).join(", ")}');
                                                  },
                                                ),
                                                title: "Select State",
                                                listView: Obx(() {
                                                  final filteredStates =
                                                      employeeFormController
                                                          .filteredStateList;

                                                  if (filteredStates.isEmpty) {
                                                    log('No states found for the given query');
                                                  }

                                                  return filteredStates.isEmpty
                                                      ? Expanded(
                                                          child: searchLottie())
                                                      : Expanded(
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                filteredStates
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              final state =
                                                                  filteredStates[
                                                                      index];

                                                              print(
                                                                  'State in list: ${state.name}'); // Log each state being shown

                                                              return searchDialogItem(
                                                                title:
                                                                    state.name,
                                                                onTap: () {
                                                                  print(
                                                                      'Selected State: ${state.name}'); // Log selected state
                                                                  employeeFormController
                                                                      .selectStateOnTap(
                                                                    selectedCountry:
                                                                        selectedCountry,
                                                                    selectedState:
                                                                        state,
                                                                  );
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
                                                .stateSearch.value = '';
                                            log('Search completed and cleared');
                                          });
                                        },
                                      )),

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
                                                            .citySearch.value =
                                                        value.toLowerCase();
                                                    employeeFormController
                                                        .filteredCityList
                                                        .value = countries[
                                                            employeeFormController
                                                                .selectedCountryIndex
                                                                .value]
                                                        .states[
                                                            employeeFormController
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
                                                          child: searchLottie())
                                                      : Expanded(
                                                          child:
                                                              ListView.builder(
                                                            padding:
                                                                EdgeInsets.only(
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
                                                                  employeeFormController
                                                                      .selectCityOnTap(
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
                                  // commontextfield(
                                  //   readOnly: true,
                                  //   controller: countryController,
                                  //   text: "Select Country",
                                  //   validator: (value) {
                                  //     // if (value == null || value.isEmpty) {
                                  //     //   return 'Please select a country';
                                  //     // }
                                  //     // return null;
                                  //   },
                                  //   suffixIcon: fieldSuffixIcon(),
                                  //   onTap: () {
                                  //     employeeFormController.filteredCountryList
                                  //         .value = countries;
                                  //     showDialog(
                                  //       context: context,
                                  //       builder: (context) {
                                  //         return searchDialog(
                                  //           searchField: commontextfield(
                                  //             text: "Search Country...",
                                  //             prefixIcon: Icon(Icons.search),
                                  //             onChanged: (value) {
                                  //               employeeFormController
                                  //                       .countrySearch.value =
                                  //                   value.toLowerCase();
                                  //               employeeFormController
                                  //                       .filteredCountryList
                                  //                       .value =
                                  //                   countries
                                  //                       .where((country) => country
                                  //                           .title
                                  //                           .toLowerCase()
                                  //                           .contains(value
                                  //                               .toLowerCase()))
                                  //                       .toList();
                                  //             },
                                  //           ),
                                  //           title: "Select Country",
                                  //           listView: Obx(() {
                                  //             return employeeFormController
                                  //                     .filteredCountryList
                                  //                     .isEmpty
                                  //                 ? Expanded(
                                  //                     child: searchLottie())
                                  //                 : Expanded(
                                  //                     child: ListView.builder(
                                  //                       padding:
                                  //                           EdgeInsets.only(
                                  //                               left: 5),
                                  //                       itemCount:
                                  //                           employeeFormController
                                  //                               .filteredCountryList
                                  //                               .length,
                                  //                       itemBuilder:
                                  //                           (context, index) {
                                  //                         final country =
                                  //                             employeeFormController
                                  //                                     .filteredCountryList[
                                  //                                 index];
                                  //                         final originalIndex =
                                  //                             countries.indexWhere(
                                  //                                 (c) =>
                                  //                                     c.title ==
                                  //                                     country
                                  //                                         .title);
                                  //                         return searchDialogItem(
                                  //                           title:
                                  //                               country.title,
                                  //                           onTap: () {
                                  //                             employeeFormController
                                  //                                 .selectCountryOnTap(
                                  //                                     country:
                                  //                                         country,
                                  //                                     originalIndex:
                                  //                                         originalIndex);
                                  //                             // employeeFormController
                                  //                             //     .filteredStateList
                                  //                             //     .value = [];
                                  //                             // employeeFormController
                                  //                             //     .selectedCountryIndex
                                  //                             //     .value = index;
                                  //                             // countryController
                                  //                             //         .text =
                                  //                             //     country.title;
                                  //                             //
                                  //                             // if (country.states
                                  //                             //     .isNotEmpty) {
                                  //                             //   // Set the first state by default
                                  //                             //   employeeFormController
                                  //                             //       .selectedStateIndex
                                  //                             //       .value = 0;
                                  //                             //   stateController
                                  //                             //           .text =
                                  //                             //       country
                                  //                             //           .states[
                                  //                             //               0]
                                  //                             //           .name;
                                  //                             //   employeeFormController
                                  //                             //       .filteredStateList
                                  //                             //       .assignAll(
                                  //                             //           country
                                  //                             //               .states);
                                  //                             //
                                  //                             //   // Check if the first state has cities
                                  //                             //   if (country
                                  //                             //       .states[0]
                                  //                             //       .cities
                                  //                             //       .isNotEmpty) {
                                  //                             //     // Set the first city by default
                                  //                             //     employeeFormController
                                  //                             //         .selectedCity
                                  //                             //         .value = 0;
                                  //                             //     cityController
                                  //                             //             .text =
                                  //                             //         country
                                  //                             //             .states[
                                  //                             //                 0]
                                  //                             //             .cities[0];
                                  //                             //     employeeFormController
                                  //                             //         .filteredCityList
                                  //                             //         .assignAll(country
                                  //                             //             .states[
                                  //                             //                 0]
                                  //                             //             .cities);
                                  //                             //   }
                                  //                             // }
                                  //                             //
                                  //                             // Get.back();
                                  //                           },
                                  //                         );
                                  //                       },
                                  //                     ),
                                  //                   );
                                  //           }),
                                  //         );
                                  //       },
                                  //     ).whenComplete(() {
                                  //       employeeFormController
                                  //           .countrySearch.value = '';
                                  //     });
                                  //   },
                                  // ),
                                  // labelHeight(),
                                  // commontext(text: "Select State"),
                                  // fieldBottomHeight(),
                                  // commontextfield(
                                  //   readOnly: true,
                                  //   controller: stateController,
                                  //   text: "Select State",
                                  //   suffixIcon: fieldSuffixIcon(),
                                  //   onTap: () {
                                  //     final selectedCountry = countries[
                                  //         employeeFormController
                                  //             .selectedCountryIndex.value];
                                  //     employeeFormController.filteredStateList
                                  //         .value = selectedCountry.states;
                                  //
                                  //     // employeeFormController
                                  //     //     .filteredStateList.value = countries[
                                  //     //         employeeFormController
                                  //     //             .selectedCountryIndex.value]
                                  //     //     .states;
                                  //     showDialog(
                                  //       context: context,
                                  //       builder: (context) {
                                  //         return searchDialog(
                                  //           searchField: commontextfield(
                                  //             text: "Search State...",
                                  //             prefixIcon: Icon(Icons.search),
                                  //             onChanged: (value) {
                                  //               employeeFormController
                                  //                       .stateSearch.value =
                                  //                   value.toLowerCase();
                                  //               employeeFormController
                                  //                       .filteredStateList
                                  //                       .value =
                                  //                   selectedCountry.states
                                  //                       .where((state) => state
                                  //                           .name
                                  //                           .toLowerCase()
                                  //                           .contains(value
                                  //                               .toLowerCase()))
                                  //                       .toList();
                                  //               // employeeFormController
                                  //               //         .stateSearch.value =
                                  //               //     value.toLowerCase();
                                  //               // employeeFormController
                                  //               //     .filteredStateList
                                  //               //     .value = countries[
                                  //               //         employeeFormController
                                  //               //             .selectedCountryIndex
                                  //               //             .value]
                                  //               //     .states
                                  //               //     .where((state) => state.name
                                  //               //         .toLowerCase()
                                  //               //         .contains(value
                                  //               //             .toLowerCase()))
                                  //               //     .toList();
                                  //             },
                                  //           ),
                                  //           title: "Select State",
                                  //           listView: Obx(() {
                                  //             return employeeFormController
                                  //                     .filteredStateList.isEmpty
                                  //                 ? Expanded(
                                  //                     child: searchLottie())
                                  //                 : Expanded(
                                  //                     child: ListView.builder(
                                  //                       padding:
                                  //                           EdgeInsets.only(
                                  //                               left: 5),
                                  //                       itemCount:
                                  //                           employeeFormController
                                  //                               .filteredStateList
                                  //                               .length,
                                  //                       itemBuilder:
                                  //                           (context, index) {
                                  //                         final selectedState =
                                  //                             employeeFormController
                                  //                                     .filteredStateList[
                                  //                                 index];
                                  //                         return searchDialogItem(
                                  //                           title: selectedState
                                  //                               .name,
                                  //                           onTap: () {
                                  //                             employeeFormController
                                  //                                 .selectStateOnTap(
                                  //                               selectedCountry:
                                  //                                   selectedCountry,
                                  //                               selectedState:
                                  //                                   selectedState,
                                  //                             );
                                  //                           },
                                  //                         );
                                  //                         // final state =
                                  //                         //     employeeFormController
                                  //                         //             .filteredStateList[
                                  //                         //         index];
                                  //                         // return searchDialogItem(
                                  //                         //   title: state.name,
                                  //                         //   onTap: () {
                                  //                         //     employeeFormController
                                  //                         //         .filteredCityList
                                  //                         //         .value = [];
                                  //                         //     employeeFormController
                                  //                         //         .selectedStateIndex
                                  //                         //         .value = index;
                                  //                         //     stateController
                                  //                         //             .text =
                                  //                         //         state.name;
                                  //                         //     log('state.name${state.name}');
                                  //                         //     log('state.name${state.cities}');
                                  //                         //     if (state.cities
                                  //                         //         .isNotEmpty) {
                                  //                         //       // Set the first city by default
                                  //                         //       employeeFormController
                                  //                         //           .selectedCity
                                  //                         //           .value = 0;
                                  //                         //       cityController
                                  //                         //               .text =
                                  //                         //           state.cities[
                                  //                         //               0];
                                  //                         //       employeeFormController
                                  //                         //           .filteredCityList
                                  //                         //           .assignAll(state
                                  //                         //               .cities);
                                  //                         //     }
                                  //                         //
                                  //                         //     Get.back();
                                  //                         //   },
                                  //                         // );
                                  //                       },
                                  //                     ),
                                  //                   );
                                  //           }),
                                  //         );
                                  //       },
                                  //     ).whenComplete(() {
                                  //       employeeFormController
                                  //           .stateSearch.value = '';
                                  //     });
                                  //   },
                                  // ),
                                  // labelHeight(),
                                  // commontext(text: "Select City"),
                                  // fieldBottomHeight(),
                                  // Obx(() => commontextfield(
                                  //       readOnly: true,
                                  //       controller: cityController,
                                  //       text: "Select City",
                                  //       suffixIcon: fieldSuffixIcon(),
                                  //       onTap: () {
                                  //         employeeFormController
                                  //             .filteredCityList
                                  //             .value = countries[
                                  //                 employeeFormController
                                  //                     .selectedCountryIndex
                                  //                     .value]
                                  //             .states[employeeFormController
                                  //                 .selectedStateIndex.value]
                                  //             .cities;
                                  //
                                  //         showDialog(
                                  //           context: context,
                                  //           builder: (context) {
                                  //             return searchDialog(
                                  //               searchField: commontextfield(
                                  //                 text: "Search City...",
                                  //                 prefixIcon:
                                  //                     countrySearchBtn(),
                                  //                 onChanged: (value) {
                                  //                   employeeFormController
                                  //                           .citySearch.value =
                                  //                       value.toLowerCase();
                                  //                   employeeFormController
                                  //                       .filteredCityList
                                  //                       .value = countries[
                                  //                           employeeFormController
                                  //                               .selectedCountryIndex
                                  //                               .value]
                                  //                       .states[
                                  //                           employeeFormController
                                  //                               .selectedStateIndex
                                  //                               .value]
                                  //                       .cities
                                  //                       .where((city) => city
                                  //                           .toLowerCase()
                                  //                           .contains(value
                                  //                               .toLowerCase()))
                                  //                       .toList();
                                  //                 },
                                  //               ),
                                  //               title: "Select City",
                                  //               listView: Obx(() {
                                  //                 return employeeFormController
                                  //                         .filteredCityList
                                  //                         .isEmpty
                                  //                     ? Expanded(
                                  //                         child: searchLottie())
                                  //                     : Expanded(
                                  //                         child:
                                  //                             ListView.builder(
                                  //                           padding:
                                  //                               EdgeInsets.only(
                                  //                                   left: 5),
                                  //                           itemCount:
                                  //                               employeeFormController
                                  //                                   .filteredCityList
                                  //                                   .length,
                                  //                           itemBuilder:
                                  //                               (context,
                                  //                                   index) {
                                  //                             final city =
                                  //                                 employeeFormController
                                  //                                         .filteredCityList[
                                  //                                     index];
                                  //                             return searchDialogItem(
                                  //                               title: city,
                                  //                               onTap: () {
                                  //                                 employeeFormController
                                  //                                     .selectCityOnTap(
                                  //                                         city:
                                  //                                             city,
                                  //                                         index:
                                  //                                             index);
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
                                  //               .citySearch.value = '';
                                  //         });
                                  //       },
                                  //     )),
                                  // commontextfield(
                                  //   readOnly: true,
                                  //   controller: cityController,
                                  //   text: "Select City",
                                  //   suffixIcon: fieldSuffixIcon(),
                                  //   onTap: () {
                                  //     employeeFormController
                                  //         .filteredCityList.value = countries[
                                  //             employeeFormController
                                  //                 .selectedCountryIndex.value]
                                  //         .states[employeeFormController
                                  //             .selectedStateIndex.value]
                                  //         .cities;
                                  //     showDialog(
                                  //       context: context,
                                  //       builder: (context) {
                                  //         return searchDialog(
                                  //           searchField: commontextfield(
                                  //             text: "Search City...",
                                  //             prefixIcon: Icon(Icons.search),
                                  //             onChanged: (value) {
                                  //               employeeFormController
                                  //                   .filteredCityList
                                  //                   .value = countries[
                                  //                       employeeFormController
                                  //                           .selectedCountryIndex
                                  //                           .value]
                                  //                   .states[
                                  //                       employeeFormController
                                  //                           .selectedStateIndex
                                  //                           .value]
                                  //                   .cities
                                  //                   .where((city) => city
                                  //                       .toLowerCase()
                                  //                       .contains(value
                                  //                           .toLowerCase()))
                                  //                   .toList();
                                  //             },
                                  //           ),
                                  //           title: "Select City",
                                  //           listView: Obx(() {
                                  //             log("==>>${employeeFormController.filteredCityList.isEmpty}");
                                  //             return employeeFormController
                                  //                     .filteredCityList.isEmpty
                                  //                 ? Expanded(
                                  //                     child: searchLottie())
                                  //                 : Expanded(
                                  //                     child: ListView.builder(
                                  //                       padding:
                                  //                           EdgeInsets.only(
                                  //                               left: 5),
                                  //                       itemCount:
                                  //                           employeeFormController
                                  //                               .filteredCityList
                                  //                               .length,
                                  //                       itemBuilder:
                                  //                           (context, index) {
                                  //                         final city =
                                  //                             employeeFormController
                                  //                                     .filteredCityList[
                                  //                                 index];
                                  //                         return searchDialogItem(
                                  //                           title: city,
                                  //                           onTap: () {
                                  //                             employeeFormController
                                  //                                 .selectedCity
                                  //                                 .value = index;
                                  //                             cityController
                                  //                                 .text = city;
                                  //                             Get.back();
                                  //                           },
                                  //                         );
                                  //                       },
                                  //                     ),
                                  //                   );
                                  //           }),
                                  //         );
                                  //       },
                                  //     ).whenComplete(() {
                                  //       employeeFormController
                                  //           .citySearch.value = '';
                                  //     });
                                  //   },
                                  // ),
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
                                    text: "Enter Password",
                                    obscureText: passwordVisible,
                                    suffixIcon: GestureDetector(
                                        //iconSize: 15,
                                        onTap: () {
                                          passwordVisible = !passwordVisible;
                                          setState(() {});
                                        },
                                        child: visibilityIcon(
                                          icon: passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        )),
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
                                    obscureText: confirmPasswordVisible,
                                    onChanged: (value) {
                                      confirmPass = value;
                                    },
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
                                    suffixIcon: GestureDetector(
                                        //iconSize: 15,
                                        onTap: () {
                                          confirmPasswordVisible =
                                              !confirmPasswordVisible;
                                          setState(() {});
                                        },
                                        child: visibilityIcon(
                                          icon: confirmPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        )),
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
                                  setState(() {
                                    dropdownvaluebank = val!;
                                  });
                                },
                              ),
                              labelHeight(),
                              commontext(text: "Ac No"),
                              fieldBottomHeight(),
                              commontextfield(
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
                                            employeeFormController
                                                .removeAadharCard();
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
                                                  title: "Select Document Side",
                                                  FrontOnTap: () {
                                                    Navigator.pop(
                                                        context); // Close the dialog
                                                    // Open file picker for front side
                                                    employeeFormController
                                                        .pickAadharDoc(
                                                            commonString.aadhar,
                                                            "front");
                                                  },
                                                  backOnTap: () {
                                                    Navigator.pop(
                                                        context); // Close the dialog
                                                    // Open file picker for back side
                                                    employeeFormController
                                                        .pickAadharDoc(
                                                            commonString.aadhar,
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
                                        if (employeeFormController
                                            .frontAadharFilePath.isNotEmpty)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              aadharLabelText(
                                                  side: 'Front Side'),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: ListTile(
                                                  onTap: () async {
                                                    final file = File(
                                                        employeeFormController
                                                            .frontAadharFilePath
                                                            .value);
                                                    openFile(
                                                        file); // Using the common method for opening file
                                                  },
                                                  leading: const Icon(
                                                      Icons.file_present),
                                                  title: selectedDocTitle(
                                                    label:
                                                        employeeFormController
                                                            .frontAadharFilePath
                                                            .value
                                                            .split('/')
                                                            .last,
                                                  ),
                                                  subtitle: selectedDocSubTitle(
                                                    subTitle:
                                                        "File Type: ${employeeFormController.frontAadharFilePath.value.split('.').last.toUpperCase()}",
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
                                                            confirmText:
                                                                'Delete',
                                                            cancelText:
                                                                'Cancel',
                                                            icon: Icons
                                                                .warning_amber_rounded,
                                                            cancelOnPressed:
                                                                () =>
                                                                    Get.back(),
                                                            logOutOnPressed:
                                                                () {
                                                              print(
                                                                  "DELETE CONFIRMED ✅");
                                                              employeeFormController
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
                                        if (employeeFormController
                                            .backAadharFilePath.isNotEmpty)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              aadharLabelText(
                                                  side: 'Back Side'),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: ListTile(
                                                  onTap: () async {
                                                    final file = File(
                                                        employeeFormController
                                                            .backAadharFilePath
                                                            .value);
                                                    openFile(
                                                        file); // Using the common method for opening file
                                                  },
                                                  leading: const Icon(
                                                      Icons.file_present),
                                                  title: selectedDocTitle(
                                                    label:
                                                        employeeFormController
                                                            .backAadharFilePath
                                                            .value
                                                            .split('/')
                                                            .last,
                                                  ),
                                                  subtitle: selectedDocSubTitle(
                                                    subTitle:
                                                        "File Type: ${employeeFormController.backAadharFilePath.value.split('.').last.toUpperCase()}",
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
                                                            confirmText:
                                                                'Delete',
                                                            cancelText:
                                                                'Cancel',
                                                            icon: Icons
                                                                .warning_amber_rounded,
                                                            cancelOnPressed:
                                                                () =>
                                                                    Get.back(),
                                                            logOutOnPressed:
                                                                () {
                                                              print(
                                                                  "DELETE CONFIRMED ✅");
                                                              employeeFormController
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
                                                await openFilex.OpenFilex.open(
                                                    file.path);
                                            if (result.type !=
                                                openFilex.ResultType.done) {
                                              primaryToast(
                                                  msg:
                                                      "Failed to open file: ${result.message}");
                                            }
                                          } catch (e) {
                                            primaryToast(
                                                msg: "Error opening file: $e");
                                          }
                                        },
                                        leading: const Icon(Icons.file_present),
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
                                                    print("DELETE CONFIRMED ✅");
                                                    log(" employeeFormController1${employeeFormController.bankPassbookFile.value}");
                                                    employeeFormController
                                                        .bankPassbookFile
                                                        .value = null;
                                                    bankPassbookFile = null;
                                                    log(" employeeFormController2${employeeFormController.bankPassbookFile.value}");

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
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: employeeFormController
                                      .otherDocuments.length,
                                  itemBuilder: (context, index) {
                                    final doc = employeeFormController
                                        .otherDocuments[index];
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
                                                value: employeeFormController
                                                        .selectedDocs[index] ??
                                                    false,
                                                onChanged: (bool? value) {
                                                  employeeFormController
                                                      .toggleDocSelection(
                                                    index,
                                                    doc.name.toString(),
                                                    value ?? false,
                                                  );
                                                  if (value == false) {
                                                    employeeFormController
                                                        .removeNewFiles(index);
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
                                                        if (editDocController
                                                            .text.isNotEmpty) {
                                                          employeeFormController
                                                                  .otherDocuments[
                                                                      index]
                                                                  .name =
                                                              editDocController
                                                                  .text;
                                                          employeeFormController
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
                                              final isChecked =
                                                  employeeFormController
                                                              .selectedDocs[
                                                          index] ??
                                                      false;
                                              return isChecked
                                                  ? addBtn(
                                                      onTap: () {
                                                        employeeFormController
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
                                                      iconColor: AppColors.red,
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
                                                        if (index >= 0 &&
                                                            index <
                                                                employeeFormController
                                                                    .otherDocuments
                                                                    .length) {
                                                          employeeFormController
                                                              .otherDocuments
                                                              .removeAt(
                                                                  index); // Remove the document itself

                                                          employeeFormController
                                                              .selectedDocs
                                                              .remove(
                                                                  index); // Remove checkbox selection

                                                          employeeFormController
                                                              .otherDocuments
                                                              .refresh(); // Notify UI to rebuild

                                                          employeeFormController
                                                              .selectedDocs
                                                              .refresh();
                                                        }
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: ListTile(
                                              onTap: () async {
                                                final file = doc.otherFile;

                                                if (file != null &&
                                                    await file.exists()) {
                                                  try {
                                                    openFilex.OpenResult
                                                        result = await openFilex
                                                                .OpenFilex
                                                            .open(file.path);
                                                    if (result.type !=
                                                        openFilex
                                                            .ResultType.done) {
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
                                                          employeeFormController
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

                              Obx(() => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            activeColor: AppColors.primarycolor,
                                            value: isOtherSelected,
                                            onChanged: (value) {
                                              isOtherSelected = value!;

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
                                        child: commontextfield(
                                          controller: employeeFormController
                                              .customDocNameController.value,
                                          onChanged: (value) {
                                            setState(() {});
                                            employeeFormController
                                                .documentName.value = value;
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
                                              employeeFormController
                                                  .addDocumentName();
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: 10.vertical,
                    child:
                        commonDivider(color: AppColors.grey.withOpacity(0.5)),
                  ),
                  Padding(
                    padding: 15.horizontal,
                    child: Container(
                      // height: 380,
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(10),
                      decoration: commonDecoration(),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: commonProfileLabel(
                              label: "Office Use Only",
                            ),
                          ),
                          commonDivider(),
                          commontext(text: "Employee Type"),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 20.0,
                              left: 4,
                            ),
                            child: Row(
                              children: [
                                radioBtn(
                                    value: commonString.office,
                                    groupValue: officegroup,
                                    onChanged: (val) {
                                      setState(() {
                                        officegroup = val;
                                      });
                                    }),

                                Text(
                                  "OFFICE",
                                  style: poppinsStyle(),
                                ),
                                30.width,
                                radioBtn(
                                    value: commonString.mfgdept,
                                    groupValue: officegroup,
                                    onChanged: (val) {
                                      setState(() {
                                        officegroup = val;
                                      });
                                    }),

                                Text(
                                  "MFGDEPT",
                                  style: poppinsStyle(),
                                ),
                                // const Spacer(),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelHeight(),
                              commontext(text: "Joining Date"),
                              fieldBottomHeight(),
                              commonDateCon(
                                label: selectedDatefrom != null
                                    ? DateFormat('dd-MM-yyyy')
                                        .format(selectedDatefrom!)
                                    : 'No date selected',
                                onTap: () {
                                  selectDateFrom(context);
                                },
                              ),
                              labelHeight(),
                              commontext(text: "Employee ID"),
                              fieldBottomHeight(),
                              commontextfield(
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                controller: srnocontroller,
                                onChanged: (value) {
                                  srno = value;
                                },
                                text: "Employee ID",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter employee ID';
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
                  20.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
