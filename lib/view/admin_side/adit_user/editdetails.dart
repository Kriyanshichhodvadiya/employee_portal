// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:employeeform/common/comman_widget.dart';
// import 'package:employeeform/config/color.dart';
// import 'package:employeeform/config/images.dart';
// import 'package:employeeform/model/eprofilemodel.dart';
// import 'package:employeeform/view/admin_side/employee_details.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:open_filex/open_filex.dart' as openFilex;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../common/dashboardcommon.dart';
// import '../../../common/global_widget.dart';
// import '../../../config/imageHelper.dart';
// import '../../../controller/employeeformContro.dart';
// import '../bottom_nav_admin.dart';
//
// class Editdetails extends StatefulWidget {
//   final UserProfile? employee;
//   final int? index;
//   const Editdetails({
//     super.key,
//     this.employee,
//     this.index,
//   });
//
//   @override
//   State<Editdetails> createState() => EditdetailsState();
// }
//
// class EditdetailsState extends State<Editdetails> {
//   EmployeeFormController employeeFormController =
//       Get.put(EmployeeFormController());
//   Future<void> pdf(filePath) async {
//     try {
//       openFilex.OpenResult result = await openFilex.OpenFilex.open(filePath);
//
//       if (result.type != openFilex.ResultType.done) {
//         primaryToast(
//           msg: "Failed to open file: ${result.message}",
//         );
//       }
//     } catch (e) {
//       primaryToast(
//         msg: "Error opening file: $e",
//       );
//     }
//   }
//
//   DateTime date(String date) {
//     if (widget.employee?.image != null) {
//       selectedImages = File(widget.employee!.image);
//     }
//
//     final parts = date.split('/');
//     if (parts.length == 3) {
//       final day = int.parse(parts[0]);
//       final month = int.parse(parts[1]);
//       final year = int.parse(parts[2]);
//       return DateTime(year, month, day);
//     } else {
//       throw const FormatException('Invalid date format');
//     }
//   }
//
//   void initState() {
//     super.initState();
//
//     if (widget.employee!.birthDate.isNotEmpty) {
//       try {
//         selectedDate = date(widget.employee!.birthDate);
//       } catch (e) {
//         print('Error parsing date: $e');
//       }
//     }
//     if (widget.employee!.dateFrom.isNotEmpty) {
//       try {
//         selectedDatefrom = date(widget.employee!.dateFrom);
//       } catch (e) {
//         print('Error parsing date: $e');
//       }
//     }
//
//     if (widget.employee != null) {
//       firstnamecontroller.text = widget.employee!.firstName;
//       middlenamecontroller.text = widget.employee!.middleName;
//       lastnamecontroller.text = widget.employee!.lastName;
//       // emailcontroller.text = widget.employee!.email ;
//       addresscontroller.text = widget.employee!.address;
//       aadharcontroller.text = widget.employee!.aadhar;
//       // selectedImages = widget.employee!.image ;
//       group = widget.employee!.gender;
//       emailcontroller.text = widget.employee!.email;
//
//       mobilenucontroller.text = widget.employee!.mobilenoone;
//       mobilenutwocontroller.text = widget.employee!.mobilentwo;
//       mobilenuthreecontroller.text = widget.employee!.email;
//       dropdownvaluebank = widget.employee!.bankName;
//       branchaddresscontroller.text = widget.employee!.branchAddress;
//       acnocontroller.text = widget.employee!.accountNumber;
//       ifsccontroller.text = widget.employee!.ifscCode;
//       referancecontroller.text = widget.employee!.reference;
//       officegroup = widget.employee!.employmentType;
//       srnocontroller.text = widget.employee!.srNo;
//       selectedProofs = widget.employee!.attachProof;
//       updateSelectedProofs(selectedProofs: selectedProofs);
//       log('employee_attachProof==>>${widget.employee!.attachProof}');
//       log('officegroup==>>${officegroup}');
//     }
//   }
//
//   void saveForm() {
//     if (widget.employee != null) {
//       setState(() {
//         widget.employee!.firstName = firstnamecontroller.text;
//         widget.employee!.middleName = middlenamecontroller.text;
//         widget.employee!.lastName = lastnamecontroller.text;
//         // widget.employee!.email = emailcontroller.text;
//         widget.employee!.address = addresscontroller.text;
//         widget.employee!.aadhar = aadharcontroller.text;
//         widget.employee!.gender = group!;
//         widget.employee!.mobilenoone = mobilenucontroller.text;
//         widget.employee!.mobilentwo = mobilenutwocontroller.text;
//         widget.employee!.email = emailcontroller.text;
//         widget.employee!.branchAddress = branchaddresscontroller.text;
//         widget.employee!.accountNumber = acnocontroller.text;
//         widget.employee!.ifscCode = ifsccontroller.text;
//         widget.employee!.reference = referancecontroller.text;
//         widget.employee!.employmentType = officegroup!;
//
//         widget.employee!.srNo = srnocontroller.text;
//       });
//     } else {
//       // Adding a new employee
//       // UserProfile newEmployee = UserProfile(
//       //   firstName: firstnamecontroller.text,
//       //   middleName: middlenamecontroller.text,
//       //   lastName: lastnamecontroller.text,
//       //   email: emailcontroller.text,
//       //   address: addresscontroller.text,
//       //   aadhar: aadharcontroller.text,
//       //   mobilenoone: mobilenucontroller.text,
//       //   mobilentwo: mobilenutwocontroller.text,
//       //   mobilenothree: mobilenuthreecontroller.text,
//       //   branchAddress: branchaddresscontroller.text,
//       //   accountNumber: acnocontroller.text,
//       //   ifscCode: ifsccontroller.text,
//       //   reference: referancecontroller.text,
//       //   srNo: srnocontroller.text,
//       //   // acn other fields
//       // );
//       // userprofilelist.add(newEmployee);
//     }
//   }
//
//   String? fname;
//   String? middlename;
//   String? lname;
//   String? address;
//   String? email;
//   String? aadhar;
//   String? group;
//   String? mobileNumber;
//   String? mobileNumbertwo;
//   String? mobileNumberthree;
//   String dropdownvalue = 'Indian';
//   String dropdownvaluebank = 'SBI';
//   String? branchaddres;
//   String? acno;
//   String? ifsc;
//   String? referance;
//   String? srno;
//   String? officegroup;
// // File? selectedImages;
//
//   DateTime? selectedDate;
//   DateTime? selectedDatefrom;
//
//   bool isImageChanged = false;
//
//   // UserProfile userProfile = UserProfile();
//   // void updateProofInProfile() {
//   //   setState(() {
//   //     userProfile.proof = getSelectedProofs();
//   //   });
//   // }
//
//   bool isAadharSelected = false;
//   bool isBankPassbookSelected = false;
//   bool isOtherSelected = false;
//   List selectedProofs = [];
//   void updateSelectedProofs({required selectedProofs}) {
//     isAadharSelected = selectedProofs.contains("Aadhar Card");
//     isBankPassbookSelected = selectedProofs.contains("Bank Passbook");
//     isOtherSelected = selectedProofs.contains("Other");
//     log('isAadharSelected:${isAadharSelected}');
//     log('isBankPassbookSelected:${isBankPassbookSelected}');
//     log('isOtherSelected:${isOtherSelected}');
//   }
//
//   String getSelectedProofs() {
//     return selectedProofs.isNotEmpty
//         ? selectedProofs.join(', ')
//         : "No proof selected";
//   }
//
//   void toggleProofSelection(String proof, bool isSelected) {
//     if (isSelected) {
//       if (!selectedProofs.contains(proof)) {
//         selectedProofs.add(proof);
//       }
//     } else {
//       selectedProofs.remove(proof);
//     }
//     log("Updated Proofs: $selectedProofs");
//   }
// /*  String getSelectedProofs({required selectedProofs}) {
//     if (isAadharSelected) {
//       // selectedProofs.add("Aadhar Card");
//     }
//     if (isBankPassbookSelected) {
//       // selectedProofs.add("Bank Passbook");
//     }
//     if (isOtherSelected) {
//       // selectedProofs.add("Other");
//     }
//
//     return selectedProofs.isNotEmpty
//         ? selectedProofs.join(', ')
//         : "No proof selected";
//   }*/
//
// //uploadproof
//   List<File>? selectedDocuments = [];
//   Future<void> pickDocuments() async {
//     var status = await Permission.storage.request();
//
//     if (status.isGranted) {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: true,
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
//       );
//
//       if (result != null) {
//         setState(() {
//           widget.employee!.documents.addAll(
//             result.paths
//                 .where((path) => path != null)
//                 .map((path) => path!)
//                 .toList(),
//           );
//         });
//       } else {
//         print('User canceled the picker');
//       }
//     } else {
//       print('Storage permission denied');
//     }
//   }
//
//   String? poofgroup;
//
//   DateTime selectedDateto = DateTime.now();
//   Future<void> dateSelect(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//       builder: (context, child) => commonThemeBuilder(context, child),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }
//
//   String formatDate(DateTime date) {
//     String day = date.day.toString().padLeft(2, '0');
//     String month = date.month.toString().padLeft(2, '0');
//     String year = date.year.toString();
//     return "$day - $month - $year";
//   }
//
//   String formatTo(DateTime date) {
//     String day = date.day.toString().padLeft(2, '0');
//     String month = date.month.toString().padLeft(2, '0');
//     String year = date.year.toString();
//     return "$day - $month - $year";
//   }
//
//   Future<void> selectDateFrom(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//       builder: (context, child) => commonThemeBuilder(context, child),
//     );
//     if (picked != null && picked != selectedDatefrom) {
//       setState(() {
//         selectedDatefrom = picked;
//       });
//     }
//   }
//
//   Future<void> selectDateTo(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDatefrom?.add(Duration(days: 1)) ?? DateTime.now(),
//       firstDate: selectedDatefrom?.add(Duration(days: 1)) ?? DateTime.now(),
//       lastDate: DateTime(2101),
//       builder: (context, child) => commonThemeBuilder(context, child),
//     );
//     if (picked != null && picked != selectedDateto) {
//       setState(() {
//         selectedDateto = picked;
//       });
//     }
//   }
//
//   String formatDateFrom(DateTime date) {
//     String day = date.day.toString().padLeft(2, '0');
//     String month = date.month.toString().padLeft(2, '0');
//     String year = date.year.toString();
//     return "$day - $month - $year";
//   }
//
//   String formatDateTo(DateTime date) {
//     String day = date.day.toString().padLeft(2, '0');
//     String month = date.month.toString().padLeft(2, '0');
//     String year = date.year.toString();
//     return "$day - $month - $year";
//   }
//
//   List<Map<String, dynamic>> item = [];
//   GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//   // String dropdownvalue = 'Indian';
//   List<String> items = ['USA', 'India', 'Canada'];
//   List<String> itemsbank = ['SBI', 'Axis Bank', 'ICICI Bank'];
//
//   TextEditingController firstnamecontroller = TextEditingController();
//   TextEditingController middlenamecontroller = TextEditingController();
//   TextEditingController lastnamecontroller = TextEditingController();
//   TextEditingController addresscontroller = TextEditingController();
//   TextEditingController emailcontroller = TextEditingController();
//
//   TextEditingController aadharcontroller = TextEditingController();
//   TextEditingController banknamercontroller = TextEditingController();
//   TextEditingController branchaddresscontroller = TextEditingController();
//
//   TextEditingController acnocontroller = TextEditingController();
//   TextEditingController ifsccontroller = TextEditingController();
//   TextEditingController referancecontroller = TextEditingController();
//   TextEditingController srnocontroller = TextEditingController();
//
//   TextEditingController mobilenucontroller = TextEditingController();
//   TextEditingController mobilenutwocontroller = TextEditingController();
//   TextEditingController mobilenuthreecontroller = TextEditingController();
//   TextEditingController otherTextController = TextEditingController();
//   @override
//   void dispose() {
//     otherTextController.dispose();
//     firstnamecontroller.dispose();
//     middlenamecontroller.dispose();
//     lastnamecontroller.dispose();
//     super.dispose();
//   }
//
//   @override
//   String? bankname;
//
//   String? ortherdoc;
//
//   final ImagePicker picker = ImagePicker();
//   File? selectedImages;
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Get.back();
//         Get.offAll(
//           () => BottomNavAdmin(),
//         );
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.white,
//         appBar: appBar(
//             onTap: () {
//               // Get.back();
//               Get.offAll(
//                 () => BottomNavAdmin(),
//               );
//             },
//             title: 'Edit Details',
//             actions: [
//               commonSaveButton(onPressed: () async {
//                 if (_formkey.currentState!.validate()) {
//                   fname = firstnamecontroller.text;
//                   middlename = middlenamecontroller.text;
//                   lname = lastnamecontroller.text;
//                   address = addresscontroller.text;
//                   aadhar = aadharcontroller.text;
//                   mobileNumber = mobilenucontroller.text;
//                   mobileNumbertwo = mobilenutwocontroller.text;
//                   mobileNumberthree = mobilenuthreecontroller.text;
//                   email = emailcontroller.text;
//                   acno = acnocontroller.text;
//                   ifsc = ifsccontroller.text;
//                   referance = referancecontroller.text;
//                   srno = srnocontroller.text;
//                   branchaddres = branchaddresscontroller.text;
//
//                   // Image validation
//                   String imagePath;
//                   if (selectedImages != null) {
//                     imagePath = selectedImages!.path;
//                   } else if (widget.employee?.image != null) {
//                     imagePath = widget.employee!.image;
//                   } else {
//                     primaryToast(
//                       msg: 'Please select an image or keep the existing one.',
//                     );
//                     return; // Stop execution if image validation fails
//                   }
//
//                   // Document validation
//                   if ((selectedDocuments == null ||
//                           selectedDocuments!.isEmpty) &&
//                       (widget.employee?.documents == null ||
//                           widget.employee!.documents.isEmpty)) {
//                     primaryToast(msg: "Please upload documents.");
//                     return; // Stop execution if document validation fails
//                   }
//
//                   List<String> allDocuments = [];
//                   if (widget.employee?.documents != null) {
//                     allDocuments.addAll(widget.employee!.documents);
//                   }
//                   if (selectedDocuments != null) {
//                     allDocuments.addAll(
//                         selectedDocuments!.map((file) => file.path).toList());
//                   }
//
//                   UserProfile newProfile = UserProfile(
//                       firstName: fname!,
//                       middleName: middlename!,
//                       lastName: lname!,
//                       address: address!,
//                       aadhar: aadhar!,
//                       gender: group!,
//                       birthDate:
//                           "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
//                       mobilenoone: mobileNumber!,
//                       mobilentwo: mobileNumbertwo!,
//                       email: email!,
//                       bankName: dropdownvaluebank,
//                       branchAddress: branchaddres!,
//                       accountNumber: acno!,
//                       ifscCode: ifsc!,
//                       reference: referance!,
//                       employmentType: officegroup!,
//                       dateFrom:
//                           "${selectedDatefrom!.day}/${selectedDatefrom!.month}/${selectedDatefrom!.year}",
//                       srNo: srno!,
//                       documents: allDocuments,
//                       image: imagePath,
//                       attachProof: selectedProofs,
//                       uploadedDocuments: {});
//
//                   if (widget.index != null) {
//                     userprofilelist[widget.index!] = newProfile;
//
//                     SharedPreferences prefs =
//                         await SharedPreferences.getInstance();
//                     List<Map<String, dynamic>> updatedEmployeeList =
//                         userprofilelist.map((item) => item.toMap()).toList();
//                     await prefs.setString(
//                         'employeeData', jsonEncode(updatedEmployeeList));
//                   }
//
//                   primaryToast(
//                     msg: "Update submitted successfully!",
//                   );
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => BottomNavAdmin(),
//                     ),
//                   );
//
//                   firstnamecontroller.clear();
//                   middlenamecontroller.clear();
//                 }
//               }),
//             ]),
//         body: SingleChildScrollView(
//           child: SafeArea(
//             child: Form(
//               key: _formkey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   35.height,
//                   Center(
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Container(
//                           height: 150,
//                           width: 150,
//                           decoration: BoxDecoration(
//                             color: AppColors.black,
//                             shape: BoxShape.circle,
//                             image: DecorationImage(
//                                 image: selectedImages != null
//                                     ? FileImage(selectedImages!)
//                                     : FileImage(File(widget.employee!.image)),
//                                 fit: BoxFit.cover),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 5,
//                           right: 10,
//                           child: GestureDetector(
//                             onTap: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   return Dialog(
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           color: AppColors.white),
//                                       child: Padding(
//                                         padding: 20.symmetric,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             GestureDetector(
//                                               onTap: () async {
//                                                 final XFile? photo =
//                                                     await picker.pickImage(
//                                                         source:
//                                                             ImageSource.camera);
//                                                 if (photo != null) {
//                                                   File? croppedFile =
//                                                       await ImageCropperHelper
//                                                           .cropImage(
//                                                     File(photo.path),
//                                                   );
//                                                   setState(() {
//                                                     selectedImages =
//                                                         croppedFile;
//                                                   });
//                                                   Navigator.pop(context);
//                                                 } else {}
//                                               },
//                                               child: cameraBtn(
//                                                 text: "Camera",
//                                                 image: AppSvg.takephoto,
//                                               ),
//                                             ),
//                                             20.width,
//                                             GestureDetector(
//                                               onTap: () async {
//                                                 final XFile? pickedFile =
//                                                     await picker.pickImage(
//                                                         source:
//                                                             ImageSource.gallery,
//                                                         imageQuality: 100,
//                                                         maxHeight: 1000,
//                                                         maxWidth: 1000);
//                                                 if (pickedFile != null) {
//                                                   File? croppedFile =
//                                                       await ImageCropperHelper
//                                                           .cropImage(
//                                                     File(pickedFile.path),
//                                                   );
//                                                   setState(() {
//                                                     selectedImages =
//                                                         croppedFile;
//                                                   });
//                                                 } else {}
//                                                 Navigator.pop(context);
//                                               },
//                                               child: cameraBtn(
//                                                 text: "Gallery",
//                                                 image: AppSvg.gallery,
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                             child: Container(
//                               height: 30,
//                               width: 30,
//                               decoration: BoxDecoration(
//                                   color: AppColors.white,
//                                   shape: BoxShape.circle),
//                               child: Icon(
//                                 Icons.camera_alt,
//                                 color: AppColors.black,
//                                 size: 19,
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   35.height,
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: 15.horizontal,
//                         child: Container(
//                           width: double.maxFinite,
//                           padding: const EdgeInsets.all(10),
//                           decoration: commonDecoration(),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Center(
//                                 child: commonProfileLabel(
//                                   label: "Personal information",
//                                 ),
//                               ),
//                               commonDivider(),
//                               commontext(text: "First Name"),
//                               fieldBottomHeight(),
//                               commontextfield(
//                                 controller: firstnamecontroller,
//                                 onChanged: (value) {
//                                   fname = value;
//                                 },
//                                 text: "Enter First name",
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your First name';
//                                   }
//
//                                   return null;
//                                 },
//                               ),
//                               labelHeight(),
//                               commontext(text: "Last Name"),
//                               fieldBottomHeight(),
//                               commontextfield(
//                                 controller: lastnamecontroller,
//                                 onChanged: (value) {
//                                   lname = value;
//                                 },
//                                 text: "Enter Last name",
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your Last name';
//                                   }
//
//                                   return null;
//                                 },
//                               ),
//                               labelHeight(),
//                               commontext(text: "Birth Date"),
//                               fieldBottomHeight(),
//                               commonDateCon(
//                                 label: selectedDate != null
//                                     ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
//                                     : 'No date selected',
//                                 onTap: () {
//                                   dateSelect(context);
//                                 },
//                               ),
//                               labelHeight(),
//                               commontext(text: "Gender"),
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                   right: 20.0,
//                                   // left: 4,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     radioBtn(
//                                         value: commonString.female,
//                                         groupValue: group,
//                                         onChanged: (val) {
//                                           setState(() {
//                                             group = val;
//                                           });
//                                         }),
//                                     Text(
//                                       "Female",
//                                       style: poppinsStyle(),
//                                     ),
//                                     Spacer(),
//                                     radioBtn(
//                                         value: commonString.male,
//                                         groupValue: group,
//                                         onChanged: (val) {
//                                           setState(() {
//                                             group = val;
//                                           });
//                                         }),
//                                     Text(
//                                       "Male",
//                                       style: poppinsStyle(),
//                                     ),
//                                     Spacer(),
//                                     radioBtn(
//                                         value: commonString.other,
//                                         groupValue: group,
//                                         onChanged: (val) {
//                                           setState(() {
//                                             group = val;
//                                           });
//                                         }),
//                                     Text(
//                                       "Other",
//                                       style: poppinsStyle(),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               labelHeight(),
//                               commontext(text: "Aadhar"),
//                               fieldBottomHeight(),
//                               commontextfield(
//                                 keyboardType: TextInputType.number,
//                                 controller: aadharcontroller,
//                                 onChanged: (value) {
//                                   aadhar = value;
//                                 },
//                                 text: "Enter Aadhar",
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter Aadhar No';
//                                   }
//
//                                   return null;
//                                 },
//                               ),
//                               labelHeight(),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   commontext(text: "Email ID"),
//                                   fieldBottomHeight(),
//                                   commontextfield(
//                                     keyboardType: TextInputType.emailAddress,
//                                     controller: emailcontroller,
//                                     onChanged: (value) {
//                                       email = value;
//                                     },
//                                     text: "Email ID",
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter an email';
//                                       }
//                                       RegExp emailRegExp = RegExp(
//                                           r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$');
//                                       if (!emailRegExp.hasMatch(value)) {
//                                         return 'Invalid email format';
//                                       }
//
//                                       return null;
//                                     },
//                                   ),
//                                   labelHeight(),
//                                   commontext(text: "Mobile no 1"),
//                                   fieldBottomHeight(),
//                                   commontextfield(
//                                     keyboardType: TextInputType.number,
//                                     controller: mobilenucontroller,
//                                     onChanged: (value) {
//                                       mobileNumber = value;
//                                     },
//                                     text: "Enter Mobile no 1",
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.digitsOnly,
//                                       LengthLimitingTextInputFormatter(10),
//                                     ],
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter mobile no 1';
//                                       }
//                                       if (value.length != 10) {
//                                         return 'Mobile number must be exactly 10 digits';
//                                       }
//
//                                       return null;
//                                     },
//                                   ),
//                                   labelHeight(),
//                                   commontext(text: "Mobile no 2"),
//                                   fieldBottomHeight(),
//                                   commontextfield(
//                                     keyboardType: TextInputType.number,
//                                     controller: mobilenutwocontroller,
//                                     onChanged: (value) {
//                                       mobileNumbertwo = value;
//                                     },
//                                     text: "Enter Mobile no 2",
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.digitsOnly,
//                                       LengthLimitingTextInputFormatter(10),
//                                     ],
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter mobile no 2';
//                                       }
//                                       if (value.length != 10) {
//                                         return 'Mobile number must be exactly 10 digits';
//                                       }
//
//                                       return null;
//                                     },
//                                   ),
//                                   labelHeight(),
//                                   commontext(text: "Residential Address"),
//                                   fieldBottomHeight(),
//                                   commontextfield(
//                                     maxLines: 3,
//                                     controller: addresscontroller,
//                                     onChanged: (value) {
//                                       address = value;
//                                     },
//                                     text: "Enter Address",
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter your Address';
//                                       }
//
//                                       return null;
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       // 25.height,
//                       Padding(
//                         padding: 10.vertical,
//                         child: commonDivider(
//                             color: AppColors.grey.withOpacity(0.5)),
//                       ),
//
//                       Padding(
//                         padding: 15.horizontal,
//                         child: Container(
//                           width: double.maxFinite,
//                           padding: const EdgeInsets.all(10),
//                           decoration: commonDecoration(),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Center(
//                                 child: commonProfileLabel(
//                                   label: "Bank Details",
//                                 ),
//                               ),
//                               commonDivider(),
//                               commontext(text: "Bank Name"),
//                               fieldBottomHeight(),
//                               DropdownButtonFormField<String>(
//                                 hint: Text(
//                                   "Bank Name",
//                                   style:
//                                       poppinsStyle(color: AppColors.hinttext),
//                                 ),
//                                 value: dropdownvaluebank.isNotEmpty
//                                     ? dropdownvaluebank
//                                     : null,
//                                 isExpanded: true,
//                                 icon: Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color: AppColors.hinttext,
//                                 ),
//                                 decoration: commonDropdownDeco(),
//                                 dropdownColor: AppColors.white,
//                                 items: itemsbank.map((String item) {
//                                   return DropdownMenuItem(
//                                     value: item,
//                                     child: Text(
//                                       item,
//                                       style: poppinsStyle(
//                                         color: AppColors.hinttext,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (String? val) {
//                                   setState(() {
//                                     dropdownvaluebank = val!;
//                                   });
//                                 },
//                               ),
//                               labelHeight(),
//                               commontext(text: "Ac No"),
//                               fieldBottomHeight(),
//                               commontextfield(
//                                 keyboardType: TextInputType.number,
//                                 controller: acnocontroller,
//                                 inputFormatters: [
//                                   FilteringTextInputFormatter.digitsOnly,
//                                   LengthLimitingTextInputFormatter(15),
//                                 ],
//                                 onChanged: (value) {
//                                   acno = value;
//                                 },
//                                 text: "Enter Ac No",
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your Ac no';
//                                   }
//
//                                   return null;
//                                 },
//                               ),
//                               labelHeight(),
//                               commontext(text: "IFSC"),
//                               fieldBottomHeight(),
//                               commontextfield(
//                                 inputFormatters: [
//                                   FilteringTextInputFormatter.allow(RegExp(
//                                       r'[A-Z0-9]')), // Allow only uppercase letters and digits
//                                   LengthLimitingTextInputFormatter(
//                                       11), // Limit to 11 characters
//                                 ],
//                                 // keyboardType: TextInputType.number,
//                                 controller: ifsccontroller,
//                                 onChanged: (value) {
//                                   ifsc = value;
//                                 },
//                                 text: "Enter IFSC",
//                                 validator: (value) {
//                                   final ifscPattern =
//                                       RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
//
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your IFSC';
//                                   } else if (!ifscPattern.hasMatch(value)) {
//                                     return 'Invalid IFSC code';
//                                   }
//
//                                   return null;
//                                 },
//                               ),
//                               labelHeight(),
//                               commontext(text: "Branch Address"),
//                               fieldBottomHeight(),
//                               commontextfield(
//                                 // keyboardType: TextInputType.number,
//                                 controller: branchaddresscontroller,
//                                 onChanged: (value) {
//                                   branchaddres = value;
//                                 },
//                                 text: "Enter Branch Address",
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your Branch Address';
//                                   }
//
//                                   return null;
//                                 },
//                               ),
//
//                               labelHeight(),
//                               commontext(text: "Reference"),
//                               fieldBottomHeight(),
//                               commontextfield(
//                                 controller: referancecontroller,
//                                 onChanged: (value) {
//                                   referance = value;
//                                 },
//                                 text: "Enter Reference",
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter Reference';
//                                   }
//
//                                   return null;
//                                 },
//                               ),
//                               labelHeight(),
//                               Text(
//                                 "Attach Proofs",
//                                 style: poppinsStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 17,
//                                 ),
//                               ),
//                               // 5.height,
//                               CheckboxListTile(
//                                 activeColor: AppColors.primarycolor,
//                                 title: Text(
//                                   "Aadhar Card",
//                                   style: poppinsStyle(),
//                                 ),
//                                 value: isAadharSelected,
//                                 onChanged: (bool? value) {
//                                   setState(() {
//                                     isAadharSelected = value!;
//                                     toggleProofSelection(
//                                         "Aadhar Card", isAadharSelected);
//                                     // updateProofInProfile();
//                                   });
//                                 },
//                               ),
//                               CheckboxListTile(
//                                 activeColor: AppColors.primarycolor,
//                                 title: Text(
//                                   "Bank Passbook",
//                                   style: poppinsStyle(),
//                                 ),
//                                 value: isBankPassbookSelected,
//                                 onChanged: (bool? value) {
//                                   setState(() {
//                                     isBankPassbookSelected = value!;
//                                     toggleProofSelection("Bank Passbook",
//                                         isBankPassbookSelected);
//
//                                     // updateProofInProfile();
//                                   });
//                                 },
//                               ),
//                               CheckboxListTile(
//                                 activeColor: AppColors.primarycolor,
//                                 title: Text(
//                                   "Other",
//                                   style: poppinsStyle(),
//                                 ),
//                                 value: isOtherSelected,
//                                 onChanged: (bool? value) {
//                                   setState(() {
//                                     isOtherSelected = value!;
//                                     toggleProofSelection(
//                                         "Other", isOtherSelected);
//
//                                     // updateProofInProfile();
//                                   });
//                                 },
//                               ),
//                               if (isOtherSelected)
//                                 commontextfield(
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter your Other Document';
//                                       }
//
//                                       return null;
//                                     },
//                                     text: "Enter Other Document",
//                                     onChanged: (value) {
//                                       ortherdoc = value;
//                                     },
//                                     controller: otherTextController),
//
//                               labelHeight(),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Add Document",
//                                     style: poppinsStyle(
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 17,
//                                     ),
//                                   ),
//                                   addBtn(
//                                     onTap: () {
//                                       pickDocuments();
//                                     },
//                                   )
//                                 ],
//                               ),
//                               10.height,
//                               Visibility(
//                                 visible: widget.employee!.documents.isNotEmpty,
//                                 child: Container(
//                                     padding: 5.symmetric,
//                                     decoration: commonDecoration(),
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       physics: NeverScrollableScrollPhysics(),
//                                       itemCount:
//                                           widget.employee!.documents.length,
//                                       itemBuilder: (context, index) {
//                                         String documentPath =
//                                             widget.employee!.documents[index];
//                                         String fileName =
//                                             documentPath.split('/').last;
//                                         String fileType = documentPath
//                                             .split('.')
//                                             .last
//                                             .toUpperCase();
//
//                                         return ListTile(
//                                           leading:
//                                               const Icon(Icons.file_present),
//                                           title: Text(
//                                             fileName,
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: poppinsStyle(
//                                                 color: AppColors.black,
//                                                 fontSize: 13),
//                                           ),
//                                           subtitle: Text(
//                                             "File Type: $fileType",
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: poppinsStyle(
//                                                 color: AppColors.hinttext,
//                                                 fontSize: 13),
//                                           ),
//                                           trailing: GestureDetector(
//                                             child: Icon(
//                                               Icons.delete_rounded,
//                                               color: AppColors.black
//                                                   .withOpacity(0.6),
//                                             ),
//                                             onTap: () {
//                                               showDialog(
//                                                 context: context,
//                                                 builder: (context) {
//                                                   return commonLogOutDialog(
//                                                     title: 'Delete',
//                                                     iconColor: AppColors.red,
//                                                     deleteButtonColor:
//                                                         AppColors.red,
//                                                     subTitle:
//                                                         'Are you sure you want to delete this file?',
//                                                     confirmText: 'Delete',
//                                                     cancelText: 'Cancel',
//                                                     icon: Icons
//                                                         .warning_amber_rounded,
//                                                     cancelOnPressed: () {
//                                                       Get.back();
//                                                     },
//                                                     logOutOnPressed: () {
//                                                       setState(() {
//                                                         widget
//                                                             .employee!.documents
//                                                             .removeAt(index);
//                                                       });
//                                                       Get.back();
//                                                     },
//                                                   );
//                                                 },
//                                               );
//                                             },
//                                           ),
//                                           onTap: () {
//                                             pdf(documentPath);
//                                           },
//                                         );
//                                       },
//                                     )),
//                               ),
//                               /*  selectedDocuments!.isNotEmpty
//                                   ? 10.height
//                                   : 0.height,
//                               selectedDocuments!.isNotEmpty
//                                   ? Container(
//                                       padding: 5.symmetric,
//                                       decoration: BoxDecoration(
//                                         color: AppColors.white,
//                                         borderRadius: BorderRadius.circular(8),
//                                         boxShadow: const [
//                                           BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: 10,
//                                             spreadRadius: 2,
//                                             offset: Offset(0, 2),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Column(
//                                         children:
//                                             selectedDocuments!.map((file) {
//                                           return ListTile(
//                                             onTap: () {
//                                               pdf(file.path);
//                                             },
//                                             leading:
//                                                 const Icon(Icons.file_present),
//                                             title: Text(
//                                               file.path.split('/').last,
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: poppinsStyle(
//                                                   color: AppColors.black,
//                                                   fontSize: 13),
//                                             ),
//                                             subtitle: Text(
//                                               "File Type: ${file.path.split('.').last.toUpperCase()}",
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: poppinsStyle(
//                                                   color: AppColors.hinttext,
//                                                   fontSize: 13),
//                                             ),
//                                             trailing: IconButton(
//                                               icon: Icon(
//                                                 Icons.delete_rounded,
//                                                 color: AppColors.black
//                                                     .withOpacity(0.6),
//                                               ),
//                                               onPressed: () {
//                                                 setState(() {
//                                                   selectedDocuments
//                                                       ?.remove(file);
//                                                 });
//                                               },
//                                             ),
//                                           );
//                                         }).toList(),
//                                       ))
//                                   : Container(),*/
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: 10.vertical,
//                     child:
//                         commonDivider(color: AppColors.grey.withOpacity(0.5)),
//                   ),
//                   Padding(
//                     padding: 15.horizontal,
//                     child: Container(
//                       // height: 380,
//                       width: double.maxFinite,
//                       padding: const EdgeInsets.all(10),
//                       decoration: commonDecoration(),
//
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Center(
//                             child: commonProfileLabel(
//                               label: "Office Use Only",
//                             ),
//                           ),
//                           commonDivider(),
//                           commontext(text: "Employee Type"),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                               right: 20.0,
//                               left: 4,
//                             ),
//                             child: Row(
//                               children: [
//                                 radioBtn(
//                                     value: commonString.office,
//                                     groupValue: officegroup,
//                                     onChanged: (val) {
//                                       setState(() {
//                                         officegroup = val;
//                                       });
//                                     }),
//
//                                 Text(
//                                   "OFFICE",
//                                   style: poppinsStyle(),
//                                 ),
//                                 30.width,
//                                 radioBtn(
//                                     value: commonString.mfgdept,
//                                     groupValue: officegroup,
//                                     onChanged: (val) {
//                                       setState(() {
//                                         officegroup = val;
//                                       });
//                                     }),
//
//                                 Text(
//                                   "MFGDEPT",
//                                   style: poppinsStyle(),
//                                 ),
//                                 // const Spacer(),
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               labelHeight(),
//                               commontext(text: "Joinning Date"),
//                               fieldBottomHeight(),
//                               commonDateCon(
//                                 label: selectedDatefrom != null
//                                     ? ("${selectedDatefrom!.day}/${selectedDatefrom!.month}/${selectedDatefrom!.year}")
//                                     : 'No date selected',
//                                 onTap: () {
//                                   selectDateFrom(context);
//                                 },
//                               ),
//                               /*        Container(
//                                 width: double.maxFinite,
//                                 padding: 10.symmetric,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: AppColors.black.withOpacity(0.2),
//                                   ),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     // commontext(text: ""),
//                                     Text(
//                                       selectedDatefrom != null
//                                           ? ("${selectedDatefrom!.day}/${selectedDatefrom!.month}/${selectedDatefrom!.year}")
//                                           : 'No date selected',
//                                       style: poppinsStyle(
//                                         color: AppColors.hinttext,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const Spacer(),
//                                     GestureDetector(
//                                       onTap: () => selectDateFrom(context),
//                                       child: const Icon(
//                                         Icons.calendar_month,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),*/
//
//                               // Container(
//                               //   width: double.maxFinite,
//                               //   padding: EdgeInsets.all(10),
//                               //   decoration: BoxDecoration(
//                               //     border: Border.all(
//                               //       color: AppColors.black.withOpacity(0.2),
//                               //     ),
//                               //     borderRadius: BorderRadius.circular(5),
//                               //   ),
//                               //   child: Row(
//                               //     children: [
//                               //       commontext(text: "To  :  "),
//                               //       Text(
//                               //         selectedDateto != null
//                               //             ? ("${selectedDateto.day}/${selectedDateto.month}/${selectedDateto.year}")
//                               //             : 'No date selected',
//                               //         style: poppinsStyle(
//                               //           color: AppColors.hinttext,
//                               //           fontSize: 14,
//                               //           fontWeight: FontWeight.w500,
//                               //         ),
//                               //       ),
//                               //       const Spacer(),
//                               //       GestureDetector(
//                               //         onTap: () => _selectDateTo(context),
//                               //         child: const Icon(
//                               //           Icons.calendar_month,
//                               //         ),
//                               //       ),
//                               //     ],
//                               //   ),
//                               // ),
//
//                               labelHeight(),
//                               commontext(text: "Employee ID"),
//                               fieldBottomHeight(),
//
//                               commontextfield(
//                                 readOnly: true,
//                                 keyboardType: TextInputType.number,
//                                 controller: srnocontroller,
//                                 onChanged: (value) {
//                                   srno = value;
//                                 },
//                                 text: "Employee ID",
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter employee ID';
//                                   }
//
//                                   return null;
//                                 },
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // 20.height,
//                   /* Padding(
//                     padding: 20.horizontal,
//                     child: primarybutton(
//                         text: "Submit",
//                         onPressed: () async {
//                           if (_formkey.currentState!.validate()) {
//                             fname = firstnamecontroller.text;
//                             middlename = middlenamecontroller.text;
//                             lname = lastnamecontroller.text;
//                             address = addresscontroller.text;
//                             aadhar = aadharcontroller.text;
//                             mobileNumber = mobilenucontroller.text;
//                             mobileNumbertwo = mobilenutwocontroller.text;
//                             mobileNumberthree = mobilenuthreecontroller.text;
//                             email = emailcontroller.text;
//                             acno = acnocontroller.text;
//                             ifsc = ifsccontroller.text;
//                             referance = referancecontroller.text;
//                             srno = srnocontroller.text;
//                             branchaddres = branchaddresscontroller.text;
//
//                             // Image validation
//                             String imagePath;
//                             if (selectedImages != null) {
//                               imagePath = selectedImages!.path;
//                             } else if (widget.employee?.image != null) {
//                               imagePath = widget.employee!.image;
//                             } else {
//                               primaryToast(
//                                 msg:
//                                     'Please select an image or keep the existing one.',
//                               );
//                               return; // Stop execution if image validation fails
//                             }
//
//                             // Document validation
//                             if ((selectedDocuments == null ||
//                                     selectedDocuments!.isEmpty) &&
//                                 (widget.employee?.documents == null ||
//                                     widget.employee!.documents.isEmpty)) {
//                               primaryToast(msg: "Please upload documents.");
//                               return; // Stop execution if document validation fails
//                             }
//
//                             List<String> allDocuments = [];
//                             if (widget.employee?.documents != null) {
//                               allDocuments.addAll(widget.employee!.documents);
//                             }
//                             if (selectedDocuments != null) {
//                               allDocuments.addAll(selectedDocuments!
//                                   .map((file) => file.path)
//                                   .toList());
//                             }
//
//                             UserProfile newProfile = UserProfile(
//                               firstName: fname!,
//                               middleName: middlename!,
//                               lastName: lname!,
//                               address: address!,
//                               aadhar: aadhar!,
//                               gender: group!,
//                               birthDate:
//                                   "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
//                               mobilenoone: mobileNumber!,
//                               mobilentwo: mobileNumbertwo!,
//                               email: email!,
//                               bankName: dropdownvaluebank,
//                               branchAddress: branchaddres!,
//                               accountNumber: acno!,
//                               ifscCode: ifsc!,
//                               reference: referance!,
//                               employmentType: officegroup!,
//                               dateFrom:
//                                   "${selectedDatefrom!.day}/${selectedDatefrom!.month}/${selectedDatefrom!.year}",
//                               srNo: srno!,
//                               documents: allDocuments,
//                               image: imagePath,
//                               attachProof: selectedProofs,
//                             );
//
//                             if (widget.index != null) {
//                               userprofilelist[widget.index!] = newProfile;
//
//                               SharedPreferences prefs =
//                                   await SharedPreferences.getInstance();
//                               List<Map<String, dynamic>> updatedEmployeeList =
//                                   userprofilelist
//                                       .map((item) => item.toMap())
//                                       .toList();
//                               await prefs.setString('employeeData',
//                                   jsonEncode(updatedEmployeeList));
//                             }
//
//                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                               content: Text(
//                                 "Update submitted successfully!",
//                                 style: poppinsStyle(color: AppColors.white),
//                               ),
//                             ));
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => BottomNavAdmin(),
//                               ),
//                             );
//
//                             firstnamecontroller.clear();
//                             middlenamecontroller.clear();
//                           }
//                         }),
//                   ),*/
//                   20.height,
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
