// import 'package:employeeform/common/comman_widget.dart';
// import 'package:employeeform/config/color.dart';
// import 'package:employeeform/config/images.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:open_filex/open_filex.dart' as openFilex;
//
// import '../../../common/dashboardcommon.dart';
// import '../../../common/global_widget.dart';
// import '../../../controller/employeeformContro.dart';
// import '../company_profile/co_profile_form.dart';
//
// class Emoployeeform extends StatefulWidget {
//   final String label;
//
//   Emoployeeform({
//     super.key,
//     required this.label,
//   });
//
//   @override
//   State<Emoployeeform> createState() => _EmoployeeformState();
// }
//
// class _EmoployeeformState extends State<Emoployeeform> {
//   // AddEmployeeController addEmployeeController =
//   EmployeeFormController employeeFormController =
//       Get.put(EmployeeFormController());
//
//   // String? fname;
//   List<Map<String, dynamic>> item = [];
//
//   GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//
//   List<String> items = ['USA', 'India', 'Canada'];
//
//   List<String> itemsbank = [
//     'SBI',
//     'Axis Bank',
//     'ICICI Bank',
//     'HDFC Bank',
//     'Bank of Baroda'
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: appBar(
//           onTap: () {
//             Get.back();
//           },
//           title: widget.label == "register_admin"
//               ? 'Admin Details'
//               : 'Employee Details',
//           actions: [
//             commonSaveButton(
//               onPressed: () {
//                 if (_formkey.currentState!.validate()) {
//                   employeeFormController.submitBtn();
//                 }
//               },
//             ),
//           ]) /* AppBar(
//         leading: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const Admindashboard(),
//                   ));
//             },
//             child: Icon(Icons.arrow_back_ios)),
//         shadowColor: AppColors.black.withOpacity(0.2),
//         backgroundColor: AppColors.white,
//         surfaceTintColor: AppColors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           "Employee Details",
//           style: poppinsStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 20,
//           ),
//         ),
//         automaticallyImplyLeading: false,
//       )*/
//       ,
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formkey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               fieldBottomHeight(),
//               Center(
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Obx(
//                       () => Container(
//                         height: 150,
//                         width: 150,
//                         decoration: BoxDecoration(
//                           color: AppColors.black,
//                           shape: BoxShape.circle,
//                           image: DecorationImage(
//                               image:
//                                   employeeFormController.selectedImage.value !=
//                                           null
//                                       ? FileImage(employeeFormController
//                                           .selectedImage.value!)
//                                       : AssetImage(AppImages.attendance)
//                                           as ImageProvider,
//                               fit: BoxFit.cover),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 5,
//                       right: 10,
//                       child: GestureDetector(
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) {
//                               return Dialog(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       color: AppColors.white),
//                                   child: Padding(
//                                     padding: 20.symmetric,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () async {
//                                             employeeFormController
//                                                 .pickImageFromCamera(
//                                                     source: ImageSource.camera);
//                                           },
//                                           child: cameraBtn(
//                                             text: "Camera",
//                                             image: AppSvg.takephoto,
//                                           ),
//                                         ),
//                                         20.width,
//                                         GestureDetector(
//                                           onTap: () async {
//                                             employeeFormController
//                                                 .pickImageFromCamera(
//                                                     source:
//                                                         ImageSource.gallery);
//                                             /*  final XFile? pickedFile =
//                                                 await picker.pickImage(
//                                                     source:
//                                                         ImageSource.gallery,
//                                                     imageQuality: 100,
//                                                     maxHeight: 1000,
//                                                     maxWidth: 1000);
//                                             if (pickedFile != null) {
//
//                                             } else {}
//                                             Navigator.pop(context);*/
//                                           },
//                                           child: cameraBtn(
//                                             text: "Gallery",
//                                             image: AppSvg.gallery,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                         child: Container(
//                           height: 30,
//                           width: 30,
//                           decoration: BoxDecoration(
//                               color: AppColors.white, shape: BoxShape.circle),
//                           child: Icon(
//                             Icons.camera_alt,
//                             color: AppColors.black,
//                             size: 19,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               20.height,
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: 15.horizontal,
//                     child: Container(
//                       // height: 950,
//                       width: double.maxFinite,
//                       // margin: const EdgeInsets.symmetric(
//                       //     vertical: 10, horizontal: 20),
//                       padding: const EdgeInsets.all(10),
//                       decoration: commonDecoration(),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Center(
//                             child: commonProfileLabel(
//                               label: "Personal information",
//                             ),
//                           ),
//                           commonDivider(),
//                           commontext(text: "First Name"),
//                           fieldBottomHeight(),
//                           commontextfield(
//                             controller: employeeFormController
//                                 .firstnamecontroller.value,
//                             onChanged: (value) {
//                               employeeFormController.fname.value = value;
//                             },
//                             text: "Enter First name",
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your First name';
//                               }
//
//                               return null;
//                             },
//                           ),
//                           /*  labelHeight(),
//                           commontext(text: "Middle Name"),
//                           fieldBottomHeight(),
//                           commontextfield(
//                             controller: employeeFormController
//                                 .middlenamecontroller.value,
//                             onChanged: (value) {
//                               employeeFormController.middlename.value = value;
//                             },
//                             text: "Enter Middle name",
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your Middle name';
//                               }
//
//                               return null;
//                             },
//                           ),*/
//                           labelHeight(),
//                           commontext(text: "Last Name"),
//                           fieldBottomHeight(),
//                           commontextfield(
//                             controller:
//                                 employeeFormController.lastnamecontroller.value,
//                             onChanged: (value) {
//                               employeeFormController.lname.value = value;
//                             },
//                             text: "Enter Last name",
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your Last name';
//                               }
//
//                               return null;
//                             },
//                           ),
//                           labelHeight(),
//                           commontext(text: "Birth Date"),
//                           fieldBottomHeight(),
//                           Obx(
//                             () => commonDateCon(
//                               label:
//                                   "${employeeFormController.selectedDate.value.day}/${employeeFormController.selectedDate.value.month}/${employeeFormController.selectedDate.value.year}",
//                               onTap: () {
//                                 employeeFormController.selectDate(context);
//                               },
//                             ),
//                           ),
//                           labelHeight(),
//                           commontext(text: "Gender"),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                               right: 20.0,
//                               // left: 4,
//                             ),
//                             child: Row(
//                               children: [
//                                 Obx(
//                                   () => radioBtn(
//                                       value: commonString.female,
//                                       groupValue:
//                                           employeeFormController.group.value,
//                                       onChanged: (val) {
//                                         employeeFormController.group.value =
//                                             val!;
//                                       }),
//                                 ),
//                                 Text(
//                                   "Female",
//                                   style: poppinsStyle(),
//                                 ),
//                                 const Spacer(),
//                                 Obx(() => radioBtn(
//                                     value: commonString.male,
//                                     groupValue:
//                                         employeeFormController.group.value,
//                                     onChanged: (val) {
//                                       employeeFormController.group.value = val!;
//                                     })),
//                                 Text(
//                                   "Male",
//                                   style: poppinsStyle(),
//                                 ),
//                                 const Spacer(),
//                                 Obx(() => radioBtn(
//                                     value: commonString.other,
//                                     groupValue:
//                                         employeeFormController.group.value,
//                                     onChanged: (val) {
//                                       employeeFormController.group.value = val!;
//                                     })),
//                                 Text(
//                                   "Other",
//                                   style: poppinsStyle(),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           labelHeight(),
//                           commontext(text: "Aadhar"),
//                           fieldBottomHeight(),
//                           commontextfield(
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly,
//                               LengthLimitingTextInputFormatter(12),
//                             ],
//                             keyboardType: TextInputType.number,
//                             controller:
//                                 employeeFormController.aadharcontroller.value,
//                             onChanged: (value) {
//                               employeeFormController.aadhar.value = value;
//                             },
//                             text: "Enter Aadhar",
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter Aadhar No';
//                               }
//
//                               return null;
//                             },
//                           ),
//                           labelHeight(),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               commontext(text: "Email Id"),
//                               fieldBottomHeight(),
//                               commontextfield(
//                                 text: "Email Id",
//                                 controller: employeeFormController
//                                     .emailcontroller.value,
//                                 keyboardType: TextInputType.emailAddress,
//                                 onChanged: (value) {
//                                   employeeFormController.email.value = value;
//                                 },
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter an email';
//                                   }
//                                   RegExp emailRegExp = RegExp(
//                                       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$');
//                                   if (!emailRegExp.hasMatch(value)) {
//                                     return 'Invalid email format';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               labelHeight(),
//                               commontext(text: "Mobile no 1"),
//                               fieldBottomHeight(),
//                               commontextfield(
//                                 keyboardType: TextInputType.number,
//                                 controller: employeeFormController
//                                     .mobilenucontroller.value,
//                                 onChanged: (value) {
//                                   employeeFormController.mobileNumber.value =
//                                       value;
//                                 },
//                                 text: "Enter Mobile no 1",
//                                 inputFormatters: [
//                                   FilteringTextInputFormatter.digitsOnly,
//                                   LengthLimitingTextInputFormatter(10),
//                                 ],
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter mobile no 1';
//                                   }
//                                   if (value.length != 10) {
//                                     return 'Mobile number must be exactly 10 digits';
//                                   }
//
//                                   return null;
//                                 },
//                               ),
//                               labelHeight(),
//                               commontext(text: "Mobile no 2"),
//                               fieldBottomHeight(),
//                               commontextfield(
//                                 keyboardType: TextInputType.number,
//                                 controller: employeeFormController
//                                     .mobilenutwocontroller.value,
//                                 onChanged: (value) {
//                                   employeeFormController.mobileNumbertwo.value =
//                                       value;
//                                 },
//                                 text: "Enter Mobile no 2",
//                                 inputFormatters: [
//                                   FilteringTextInputFormatter.digitsOnly,
//                                   LengthLimitingTextInputFormatter(10),
//                                 ],
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter mobile no 2';
//                                   }
//                                   if (value.length != 10) {
//                                     return 'Mobile number must be exactly 10 digits';
//                                   }
//
//                                   return null;
//                                 },
//                               ),
//                               labelHeight(),
//                               commontext(text: "Residential Address"),
//                               fieldBottomHeight(),
//                               commontextfield(
//                                 maxLines: 3,
//                                 controller: employeeFormController
//                                     .addresscontroller.value,
//                                 onChanged: (value) {
//                                   employeeFormController.address.value = value;
//                                 },
//                                 text: "Enter Address",
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter your Address';
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
//                   // 2fieldBottomHeight(),
//                   Padding(
//                     padding: 10.vertical,
//                     child:
//                         commonDivider(color: AppColors.grey.withOpacity(0.5)),
//                   ),
//                   Padding(
//                     padding: 15.horizontal,
//                     child: Container(
//                       // height: 750,
//                       width: double.maxFinite,
//                       // margin: const EdgeInsets.symmetric(
//                       //     vertical: 10, horizontal: 20),
//                       padding: const EdgeInsets.all(10),
//                       decoration: commonDecoration(),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Center(
//                             child: commonProfileLabel(
//                               label: "Bank Details",
//                             ),
//                           ),
//                           commonDivider(),
//                           commontext(text: "Bank Name"),
//                           fieldBottomHeight(),
//                           Obx(
//                             () => DropdownButtonFormField<String>(
//                               borderRadius: BorderRadius.circular(6),
//                               hint: Text(
//                                 "Bank Name",
//                                 style: poppinsStyle(color: AppColors.hinttext),
//                               ),
//                               value: employeeFormController
//                                       .dropdownvaluebank.value.isNotEmpty
//                                   ? employeeFormController
//                                       .dropdownvaluebank.value
//                                   : null,
//                               isExpanded: true,
//                               icon: Icon(
//                                 Icons.keyboard_arrow_down,
//                                 color: AppColors.hinttext,
//                               ),
//                               dropdownColor: AppColors.white,
//                               decoration: commonDropdownDeco(),
//                               items: itemsbank.map((String item) {
//                                 return DropdownMenuItem(
//                                   value: item,
//                                   child: Text(
//                                     item,
//                                     style: poppinsStyle(
//                                       color: AppColors.hinttext,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               onChanged: (String? val) {
//                                 employeeFormController.dropdownvaluebank.value =
//                                     val!;
//                               },
//                             ),
//                           ),
//
//                           labelHeight(),
//                           commontext(text: "Ac No"),
//                           fieldBottomHeight(),
//                           commontextfield(
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly,
//                               LengthLimitingTextInputFormatter(15),
//                             ],
//                             keyboardType: TextInputType.number,
//                             controller:
//                                 employeeFormController.acnocontroller.value,
//                             onChanged: (value) {
//                               employeeFormController.acno.value = value;
//                             },
//                             text: "Enter Ac No",
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your Ac no';
//                               }
//
//                               return null;
//                             },
//                           ),
//                           labelHeight(),
//                           commontext(text: "IFSC"),
//                           fieldBottomHeight(),
//                           commontextfield(
//                             inputFormatters: [
//                               FilteringTextInputFormatter.allow(RegExp(
//                                   r'[A-Z0-9]')), // Allow only uppercase letters and digits
//                               LengthLimitingTextInputFormatter(
//                                   11), // Limit to 11 characters
//                             ],
//                             keyboardType: TextInputType.text,
//                             controller:
//                                 employeeFormController.ifsccontroller.value,
//                             onChanged: (value) {
//                               employeeFormController.ifsc.value = value;
//                             },
//                             text: "Enter IFSC",
//                             validator: (value) {
//                               final ifscPattern =
//                                   RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
//
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your IFSC';
//                               } else if (!ifscPattern.hasMatch(value)) {
//                                 return 'Invalid IFSC code';
//                               }
//                               return null;
//                             },
//                           ),
//                           labelHeight(),
//                           commontext(text: "Branch Address"),
//                           fieldBottomHeight(),
//                           commontextfield(
//                             // keyboardType: TextInputType.number,
//                             controller: employeeFormController
//                                 .branchaddresscontroller.value,
//                             onChanged: (value) {
//                               employeeFormController.branchaddres.value = value;
//                             },
//                             text: "Enter Branch Address",
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your Branch Address';
//                               }
//
//                               return null;
//                             },
//                           ),
//                           labelHeight(),
//                           commontext(text: "Reference"),
//                           fieldBottomHeight(),
//                           commontextfield(
//                             controller: employeeFormController
//                                 .referancecontroller.value,
//                             onChanged: (value) {
//                               employeeFormController.referance.value = value;
//                             },
//                             text: "Enter Reference",
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter Reference';
//                               }
//
//                               return null;
//                             },
//                           ),
//                           labelHeight(),
//                           Text(
//                             "Attach Proofs",
//                             style: poppinsStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: 17,
//                             ),
//                           ),
//                           // fieldBottomHeight(),
//                           Obx(
//                             () => CheckboxListTile(
//                               activeColor: AppColors.primarycolor,
//                               title: Text(
//                                 "Aadhar Card",
//                                 style: poppinsStyle(),
//                               ),
//                               value:
//                                   employeeFormController.isAadharSelected.value,
//                               onChanged: (bool? value) {
//                                 employeeFormController.isAadharSelected.value =
//                                     value!;
//                                 employeeFormController.getSelectedProofs();
//                                 // updateProofInProfile();
//                               },
//                             ),
//                           ),
//                           Obx(
//                             () => CheckboxListTile(
//                               activeColor: AppColors.primarycolor,
//                               title: Text(
//                                 "Bank Passbook",
//                                 style: poppinsStyle(),
//                               ),
//                               value: employeeFormController
//                                   .isBankPassbookSelected.value,
//                               onChanged: (bool? value) {
//                                 employeeFormController
//                                     .isBankPassbookSelected.value = value!;
//                                 employeeFormController.getSelectedProofs();
//                                 // updateProofInProfile();
//                               },
//                             ),
//                           ),
//                           Obx(
//                             () => CheckboxListTile(
//                               activeColor: AppColors.primarycolor,
//                               title: Text(
//                                 "Other",
//                                 style: poppinsStyle(),
//                               ),
//                               value:
//                                   employeeFormController.isOtherSelected.value,
//                               onChanged: (bool? value) {
//                                 employeeFormController.isOtherSelected.value =
//                                     value!;
//                                 employeeFormController.getSelectedProofs();
//                                 // updateProofInProfile();
//                               },
//                             ),
//                           ),
//
//                           Obx(
//                             () => Visibility(
//                               visible:
//                                   employeeFormController.isOtherSelected.value,
//                               child: commontextfield(
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'Please enter your Other Document';
//                                     }
//
//                                     return null;
//                                   },
//                                   text: "Enter Other Document",
//                                   onChanged: (value) {
//                                     employeeFormController.ortherdoc.value =
//                                         value;
//                                   },
//                                   controller: employeeFormController
//                                       .otherTextController.value),
//                             ),
//                           ),
//
//                           labelHeight(),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Upload Document",
//                                 style: poppinsStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 17,
//                                 ),
//                               ),
//                               addBtn(
//                                 onTap: () {
//                                   employeeFormController.pickDocuments();
//                                 },
//                               )
//                             ],
//                           ),
//                           // 10.height,
//                           // documentUploadBtn(
//                           //     onPressed: () {
//                           //       employeeFormController.pickDocuments();
//                           //     },
//                           //     label: 'Upload Documents'),
//                           Visibility(
//                               visible: employeeFormController
//                                   .selectedDocuments.isNotEmpty,
//                               child: 10.height),
//                           Obx(
//                             () => employeeFormController
//                                     .selectedDocuments.isEmpty
//                                 ? Container()
//                                 : Container(
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 5, horizontal: 8),
//                                     decoration: commonDecoration(),
//                                     child: ListView.separated(
//                                       shrinkWrap: true,
//                                       physics: NeverScrollableScrollPhysics(),
//                                       itemCount: employeeFormController
//                                           .selectedDocuments.length,
//                                       separatorBuilder: (context, index) =>
//                                           const Divider(
//                                         color: Colors.grey,
//                                         thickness: 1,
//                                       ),
//                                       itemBuilder: (context, index) {
//                                         var file = employeeFormController
//                                             .selectedDocuments[index];
//                                         return ListTile(
//                                           onTap: () async {
//                                             try {
//                                               openFilex.OpenResult result =
//                                                   await openFilex.OpenFilex
//                                                       .open(file.path);
//
//                                               if (result.type !=
//                                                   openFilex.ResultType.done) {
//                                                 primaryToast(
//                                                   msg:
//                                                       "Failed to open file: ${result.message}",
//                                                 );
//                                               }
//                                             } catch (e) {
//                                               primaryToast(
//                                                 msg: "Error opening file: $e",
//                                               );
//                                             }
//                                           },
//                                           leading:
//                                               const Icon(Icons.file_present),
//                                           title: Text(
//                                             file.path.split('/').last,
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: poppinsStyle(
//                                                 color: AppColors.black,
//                                                 fontSize: 13),
//                                           ),
//                                           subtitle: Text(
//                                             "File Type: ${file.path.split('.').last.toUpperCase()}",
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
//                                                       employeeFormController
//                                                           .removeDocument(file);
//                                                       Get.back();
//                                                     },
//                                                   );
//                                                 },
//                                               );
//                                             },
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: 10.vertical,
//                 child: commonDivider(color: AppColors.grey.withOpacity(0.5)),
//               ),
//               Padding(
//                 padding: 15.horizontal,
//                 child: Container(
//                   // height: 380,
//                   width: double.maxFinite,
//                   padding: const EdgeInsets.all(10),
//                   decoration: commonDecoration(),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: commonProfileLabel(
//                           label: "Office Use Only",
//                         ),
//                       ),
//                       commonDivider(),
//                       commontext(text: "Employee Type"),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           right: 20.0,
//                           left: 4,
//                         ),
//                         child: Row(
//                           children: [
//                             Obx(() => radioBtn(
//                                 value: commonString.office,
//                                 groupValue:
//                                     employeeFormController.officegroup.value,
//                                 onChanged: (val) {
//                                   employeeFormController.officegroup.value =
//                                       val!;
//                                 })),
//                             Text(
//                               "OFFICE",
//                               style: poppinsStyle(),
//                             ),
//                             30.width,
//                             Obx(() => radioBtn(
//                                 value: commonString.mfgdept,
//                                 groupValue:
//                                     employeeFormController.officegroup.value,
//                                 onChanged: (val) {
//                                   employeeFormController.officegroup.value =
//                                       val!;
//                                 })),
//                             Text(
//                               "MFGDEPT",
//                               style: poppinsStyle(),
//                             ),
//                             // const Spacer(),
//                           ],
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           labelHeight(),
//                           commontext(text: "Joinning Date"),
//                           fieldBottomHeight(),
//                           Obx(
//                             () => commonDateCon(
//                               label:
//                                   "${employeeFormController.selectedDateFrom.value.day}/${employeeFormController.selectedDateFrom.value.month}/${employeeFormController.selectedDateFrom.value.year}",
//                               onTap: () {
//                                 employeeFormController.selectDateFrom(context);
//                               },
//                             ),
//                           ),
//                           labelHeight(),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               /* 20.height,
//               Padding(
//                 padding: 20.horizontal,
//                 child: primarybutton(
//                   text: "Submit",
//                   onPressed: () async {
//                     if (_formkey.currentState!.validate()) {
//                       employeeFormController.submitBtn();
//                     }
//                   },
//                 ),
//               ),*/
//               labelHeight(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// Widget documentUploadBtn(
//     {required label, required void Function()? onPressed}) {
//   return ElevatedButton(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: AppColors.white.withOpacity(0.8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//     ),
//     onPressed: onPressed,
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           Icons.add,
//           size: 5.heightBox(),
//           color: AppColors.grey,
//         ),
//         Text(
//           label,
//           style: poppinsStyle(
//             color: AppColors.hinttext,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     ),
//   );
// }
