import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/controller/userviewtask_controller.dart';
import 'package:employeeform/model/eprofilemodel.dart';
import 'package:employeeform/view/user/edituserprofileform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart' as openFilex;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/global_widget.dart';
import '../../../controller/employeeformContro.dart';
import '../../login.dart';
import '../../user/bottom_nav_emp.dart';
import 'adminEditForm.dart';

class ProfileDetail extends StatefulWidget {
  UserProfile userprofile;
  final bool adminProfile;
  final bool editMode;
  final bool backBtn;
  final bool adminEdit;

  ProfileDetail(
      {super.key,
      required this.userprofile,
      required this.adminProfile,
      required this.editMode,
      required this.adminEdit,
      required this.backBtn});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  // UserDashBoardController controller = Get.put(UserDashBoardController());
  UserViewTaskController userViewTaskController =
      Get.put(UserViewTaskController());

  EmployeeFormController employeeFormController =
      Get.put(EmployeeFormController());
  Future<void> opendoc(String filePath) async {
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

  @override
  void initState() {
    // controller.fetchEmployeeData();
    userViewTaskController.fetchEmployeeData();
    log("backBtn==>>${widget.backBtn}");
    log(widget.userprofile.mobilenoone);
    log(widget.userprofile.birthDate);
    log(widget.userprofile.bankName);
    // final otherFiles = widget.userprofile.attachedFiles?.otherFiles;
    //
    //
    log(widget.userprofile.bankName);
    log("attachedFiles==>>${jsonEncode(widget.userprofile.attachedFiles?.toJson())}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // controller.fetchEmployeeData();
    var userProfile = widget.userprofile;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBar(
          // showBack: widget.adminProfile == true ? true : false,
          showBack: widget.backBtn == true ? true : false,
          onTap: () {
            if (widget.editMode == true) {
              Get.offAll(() => BottomNavEmployee());
            } else {
              Get.back();
            }
          },
          title: 'Profile',
          actions: [
            Visibility(
              visible: widget.editMode == true,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  employeeFormController.firstnamecontroller.value.text =
                      userProfile.firstName;
                  employeeFormController.lastnamecontroller.value.text =
                      userProfile.lastName;
                  employeeFormController.mobilenucontroller.value.text =
                      userProfile.mobilenoone;
                  employeeFormController.mobilenutwocontroller.value.text =
                      userProfile.mobilentwo;
                  employeeFormController.emailcontroller.value.text =
                      userProfile.email;
                  employeeFormController.addresscontroller.value.text =
                      userProfile.address;
                  employeeFormController.selectedImage.value =
                      File(userProfile.image);
                  employeeFormController.middlenamecontroller.value.text =
                      userProfile.middleName;
                  employeeFormController.aadharcontroller.value.text =
                      userProfile.aadhar;
                  employeeFormController.banknamercontroller.value.text =
                      userProfile.bankName;
                  employeeFormController.branchaddresscontroller.value.text =
                      userProfile.branchAddress;
                  employeeFormController.acnocontroller.value.text =
                      userProfile.accountNumber;
                  employeeFormController.ifsccontroller.value.text =
                      userProfile.ifscCode;
                  employeeFormController.referancecontroller.value.text =
                      userProfile.reference;
                  employeeFormController.group.value = userProfile.gender;
                  employeeFormController.zipCodeController.value.text =
                      userProfile.zipCode!;
                  // employeeFormController.countryController.value.text =
                  //     userProfile.country!;
                  // employeeFormController.stateController.value.text =
                  //     userProfile.state!;
                  // employeeFormController.cityController.value.text =
                  //     userProfile.city!;
                  employeeFormController.passwordController.value.text =
                      userProfile.password!;
                  employeeFormController.confirmPasswordController.value.text =
                      userProfile.confirmPass!;
                  employeeFormController.frontAadharFilePath.value =
                      userProfile.attachedFiles!.aadharCard!.frontSidePath;
                  employeeFormController.backAadharFilePath.value =
                      userProfile.attachedFiles!.aadharCard!.backSidePath;
                  employeeFormController.bankPassbookFile.value =
                      userProfile.attachedFiles!.bankPassbookFile;
                  final otherFiles = userProfile.attachedFiles?.otherFiles;

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
                      } else if (doc.name?.toLowerCase().contains('passbook') ==
                              true &&
                          doc.otherFile != null) {
                        employeeFormController.bankPassbookFile.value =
                            doc.otherFile;
                      }
                    }
                  }
                  employeeFormController.officegroup.value =
                      userProfile.employmentType;
                  if (userProfile.attachProof.isNotEmpty) {
                    employeeFormController.selectedProofs.clear();
                    employeeFormController.selectedProofs
                        .addAll(List<String>.from(userProfile.attachProof));
                  }

                  if (userProfile.documents.isNotEmpty) {
                    employeeFormController.selectedDocuments.clear();
                    employeeFormController.selectedDocuments.addAll(
                      userProfile.documents.map((path) => File(path)).toList(),
                    );
                  }
                  employeeFormController.selectedDate.value =
                      DateFormat('dd-MM-yy').parse(userProfile.birthDate);
                  employeeFormController.selectedDateFrom.value =
                      DateFormat('dd-MM-yy').parse(userProfile.dateFrom);
                  employeeFormController.editCountryValue(
                    country: userProfile.country,
                    state: userProfile.state,
                    city: userProfile.city,
                  );
                  log('selectedImage==>>${employeeFormController.selectedImage.value}');
                  log('image==>>${File(userProfile.image)}');
                  log('gender==>>${userProfile.gender}');
                  log('birthDate==>>${userProfile.birthDate}');
                  log('employeeFormController.selectedDate.value==>>${employeeFormController.selectedDate.value}');
                  log('employmentType==>>${userProfile.employmentType}');
                  log('dateFrom==>>${userProfile.dateFrom}');
                  log('documents==>>${userProfile.documents}');
                  log('documents==>>${employeeFormController.selectedProofs}');
                  log('selectedDate==>>${employeeFormController.selectedDate.value}');
                  log('selectedDateFrom==>>${employeeFormController.selectedDateFrom.value}');
                  log('documents==>>${employeeFormController.selectedProofs}');
                  log('attachProof==>>${userProfile.attachProof}');
                  // Get.to(() => EditUserProfileScreen());
                  // setState(() {});

                  Get.to(() => EditUserProfileScreen())?.then((result) {
                    /*    if (result == true) {
                      controller.fetchEmployeeData();
                      setState(() {});
                    }*/
                  });
                },
              ),
            ),
            Visibility(
              visible: widget.adminEdit == true,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  log('selectedImage==>>${employeeFormController.selectedImage.value}');
                  log('image==>>${File(userProfile.image)}');
                  log('lastName==>>${userProfile.lastName}');
                  log('gender==>>${userProfile.gender}');
                  log('birthDate==>>${userProfile.birthDate}');
                  log('employeeFormController.selectedDate.value==>>${employeeFormController.selectedDate.value}');
                  log('employmentType==>>${userProfile.employmentType}');
                  log('dateFrom==>>${userProfile.dateFrom}');
                  log('documents==>>${userProfile.documents}');
                  log('documents==>>${employeeFormController.selectedProofs}');
                  log('selectedDate==>>${employeeFormController.selectedDate.value}');
                  log('selectedDateFrom==>>${employeeFormController.selectedDateFrom.value}');
                  log('documents==>>${employeeFormController.selectedProofs}');
                  log('attachProof==>>${userProfile.attachProof}');
                  log('otherFiles==>>${userProfile.attachedFiles!.otherFiles.length}');
                  // Get.to(() => EditUserProfileScreen());
                  // setState(() {});
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => adminEditScreen(
                        employee: userProfile,
                      ),
                    ),
                  );
                  // Get.to(() => EditUserProfileScreen())?.then((result) {
                  //   /*    if (result == true) {
                  //     controller.fetchEmployeeData();
                  //     setState(() {});
                  //   }*/
                  // });
                },
              ),
            ),
            Visibility(
              visible: widget.adminProfile == true,
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return commonLogOutDialog(
                        title: "Logout?",
                        subTitle: "Are you sure you want to logout?",
                        icon: Icons.exit_to_app,
                        cancelText: "Cancel",
                        deleteButtonColor: AppColors.primarycolor,
                        confirmText: "Logout",
                        iconColor: AppColors.primarycolor,
                        cancelOnPressed: () {
                          Navigator.pop(context);
                        },
                        logOutOnPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove('isLoggedIn');
                          await prefs.remove('role');

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                20.height,
                Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primarycolor, width: 3),
                    shape: BoxShape.circle,
                    color: AppColors.primarycolor,
                    image: DecorationImage(
                      image: widget.adminProfile
                          ? (widget.userprofile.image.contains('assets/')
                              ? AssetImage(widget.userprofile.image)
                                  as ImageProvider
                              : FileImage(File(widget.userprofile.image)))
                          : FileImage(File(widget.userprofile.image)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                5.height,
              ],
            ),
            profileDetailConHeight(),
            Padding(
              padding: 15.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonProfileLabel(
                    label: "Personal information",
                  ),
                  profileDetailLabelHeight(),
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(12),
                    decoration: commonDecoration(),
                    child: Column(
                      children: [
                        commonrowprofile(
                          labeltext: "Name",
                          fetchname:
                              "${widget.userprofile.firstName} ${widget.userprofile.lastName}",
                        ),
                        profileDetailHeight(),
                        commonrowprofile(
                          labeltext: "Aadhar",
                          fetchname: widget.userprofile.aadhar ?? "",
                        ),
                        profileDetailHeight(),
                        commonrowprofile(
                            labeltext: "Gender",
                            fetchname: widget.userprofile.gender ?? ""),
                        profileDetailHeight(),
                        commonrowprofile(
                            labeltext: "Birth Date",
                            fetchname: widget.userprofile.birthDate),
                        profileDetailHeight(),
                        commonrowprofile(
                            labeltext: "User Password",
                            fetchname: widget.userprofile.password),
                      ],
                    ),
                  ),
                  profileDetailConHeight(),
                  commonProfileLabel(
                    label: "Contact Details",
                  ),
                  profileDetailLabelHeight(),
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(8),
                    decoration: commonDecoration(),
                    child: Column(
                      children: [
                        commonrowprofile(
                            labeltext: "Mobile Number 1",
                            fetchname: widget.userprofile.mobilenoone),
                        profileDetailHeight(),
                        commonrowprofile(
                            labeltext: "Mobile Number 2",
                            fetchname: widget.userprofile.mobilentwo),
                        profileDetailHeight(),
                        commonrowprofile(
                            labeltext: "Email",
                            fetchname: widget.userprofile.email),
                        profileDetailHeight(),
                        commonrowprofile(
                          labeltext: "Address",
                          fetchname:
                              "${widget.userprofile.address},${widget.userprofile.city},${widget.userprofile.state},${widget.userprofile.country}",
                        ),
                        profileDetailHeight(),
                        commonrowprofile(
                          labeltext: "ZipCode",
                          fetchname: "${widget.userprofile.zipCode}",
                        ),
                      ],
                    ),
                  ),
                  profileDetailConHeight(),
                  commonProfileLabel(
                    label: "Bank Details",
                  ),
                  profileDetailLabelHeight(),
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(10),
                    decoration: commonDecoration(),
                    child: Column(
                      children: [
                        commonrowprofile(
                            labeltext: "Bank Name",
                            fetchname: widget.userprofile.bankName),
                        profileDetailHeight(),
                        commonrowprofile(
                            labeltext: "Branch Address",
                            fetchname: widget.userprofile.branchAddress),
                        profileDetailHeight(),
                        commonrowprofile(
                            labeltext: "Ac No",
                            fetchname: widget.userprofile.accountNumber),
                        profileDetailHeight(),
                        commonrowprofile(
                            labeltext: "IFSC",
                            fetchname: widget.userprofile.ifscCode),
                        profileDetailHeight(),
                        commonrowprofile(
                            labeltext: "Referance",
                            fetchname: widget.userprofile.reference),
                        profileDetailHeight(),
                        Column(
                          children: [
                            // Aadhar Card Row
                            if (widget.userprofile.attachedFiles!.aadharCard!
                                    .frontSidePath.isNotEmpty ||
                                widget.userprofile.attachedFiles!.aadharCard!
                                    .backSidePath.isNotEmpty)
                              Column(
                                children: [
                                  // Front side of Aadhar card

                                  commonAadharFile(
                                      checkFront: widget
                                          .userprofile
                                          .attachedFiles!
                                          .aadharCard!
                                          .frontSidePath
                                          .isNotEmpty,
                                      checkBack: widget
                                          .userprofile
                                          .attachedFiles!
                                          .aadharCard!
                                          .backSidePath
                                          .isNotEmpty,
                                      label: "Aadhar Card",
                                      frontfile: widget
                                          .userprofile
                                          .attachedFiles!
                                          .aadharCard!
                                          .frontSidePath
                                          .split('/')
                                          .last,
                                      backFile: widget
                                          .userprofile
                                          .attachedFiles!
                                          .aadharCard!
                                          .backSidePath
                                          .split('/')
                                          .last,
                                      backView: "Back View",
                                      FrontView: "Front View",
                                      backonTap: () {
                                        opendoc(widget
                                            .userprofile
                                            .attachedFiles!
                                            .aadharCard!
                                            .backSidePath);
                                      },
                                      frontonTap: () {
                                        opendoc(widget
                                            .userprofile
                                            .attachedFiles!
                                            .aadharCard!
                                            .frontSidePath);
                                      }),
                                  profileDetailHeight(),
                                ],
                              ),

                            // Bank Passbook Row
                            if (widget.userprofile.attachedFiles
                                    ?.bankPassbookFile !=
                                null)
                              commonOpenFile(
                                  label: "Bank Passbook",
                                  file: widget.userprofile.attachedFiles!
                                      .bankPassbookFile!.path
                                      .split('/')
                                      .last,
                                  onTap: () {
                                    opendoc(widget.userprofile.attachedFiles!
                                        .bankPassbookFile!.path);
                                  }),
                            profileDetailHeight(),
                            if (widget.userprofile.attachedFiles?.otherFiles
                                    .isNotEmpty ??
                                false)
                              ListView.separated(
                                separatorBuilder: (context, index) =>
                                    profileDetailHeight(),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget
                                        .userprofile.attachedFiles?.otherFiles
                                        .where((file) =>
                                            file.otherFile !=
                                            null) // Filter out null files
                                        .length ??
                                    0,
                                itemBuilder: (context, index) {
                                  // Get only the files where otherFile is not null
                                  var file = widget
                                      .userprofile.attachedFiles!.otherFiles
                                      .where((file) =>
                                          file.otherFile !=
                                          null) // Filter out null files
                                      .toList()[index]; // Access the valid file

                                  return commonOpenFile(
                                    label: file.name ??
                                        "Other Files", // Use the name from the model
                                    file: file.otherFile?.path
                                            .split('/')
                                            .last ??
                                        "No File", // Fallback if no file exists
                                    onTap: () {
                                      if (file.otherFile != null) {
                                        opendoc(file.otherFile!
                                            .path); // Open file when tapped
                                      } else {
                                        primaryToast(
                                            msg: "File not available.");
                                      }
                                    },
                                  );
                                },
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                  profileDetailConHeight(),
                  if (widget.adminEdit == false)
                    commonProfileLabel(
                      label: "Office Details",
                    ),
                  if (widget.adminEdit == false) profileDetailLabelHeight(),
                  if (widget.adminEdit == false)
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(10),
                      decoration: commonDecoration(),
                      child: Column(
                        children: [
                          Visibility(
                            visible:
                                widget.userprofile.employmentType.isNotEmpty,
                            child: commonrowprofile(
                                labeltext: "Employee Type",
                                fetchname: widget.userprofile.employmentType),
                          ),
                          profileDetailHeight(),
                          commonrowprofile(
                              labeltext: "Joining Date",
                              fetchname: widget.userprofile.dateFrom),
                          profileDetailHeight(),
                          if (widget.editMode != true)
                            commonrowprofile(
                                labeltext: "Employee ID",
                                fetchname: widget.userprofile.srNo),
                        ],
                      ),
                    ),
                  10.height,
                ],
              ),
            ),

            // commontext(text: "text"),
          ],
        ),
      ),
    );
  }
}

Widget commonOpenFile(
    {required label, required file, required void Function()? onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 4,
        child: textprofilelist(label: label),
      ),
      const Expanded(
        child: Text(":"),
      ),
      Expanded(
        flex: 5,
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            file,
            style: poppinsStyle(
              fontSize: 14,
              color: AppColors.primarycolor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget commonAadharFile({
  required label,
  required frontfile,
  required backFile,
  required checkBack,
  required checkFront,
  required void Function()? frontonTap,
  required void Function()? backonTap,
  required FrontView,
  required backView,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 4,
        child: textprofilelist(label: label),
      ),
      const Expanded(
        child: Text(":"),
      ),
      Expanded(
        flex: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (checkFront)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FrontView,
                    style: poppinsStyle(
                        fontSize: 12,
                        color: AppColors.hinttext,
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: frontonTap,
                    child: Text(
                      frontfile,
                      style: poppinsStyle(
                        fontSize: 14,
                        color: AppColors.primarycolor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            if (checkFront) 10.height,
            if (checkBack)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    backView,
                    style: poppinsStyle(
                        fontSize: 12,
                        color: AppColors.hinttext,
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: backonTap,
                    child: Text(
                      backFile,
                      style: poppinsStyle(
                        fontSize: 14,
                        color: AppColors.primarycolor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    ],
  );
}
