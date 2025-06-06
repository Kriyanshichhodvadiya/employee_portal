// import 'dart:developer';
// import 'dart:io';
//
// import 'package:employeeform/common/comman_widget.dart';
// import 'package:employeeform/config/color.dart';
// import 'package:employeeform/model/eprofilemodel.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:open_filex/open_filex.dart' as openFilex;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../common/global_widget.dart';
// import '../../../controller/userdashboard_controller.dart';
// import '../../login.dart';
//
// class ProfileDetail extends StatefulWidget {
//   UserProfile userprofile;
//   final bool adminProfile;
//
//   ProfileDetail(
//       {super.key, required this.userprofile, required this.adminProfile});
//
//   @override
//   State<ProfileDetail> createState() => _ProfileDetailState();
// }
//
// class _ProfileDetailState extends State<ProfileDetail> {
//   UserDashBoardController controller = Get.put(UserDashBoardController());
//   Future<void> opendoc(String filePath) async {
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
//   @override
//   void initState() {
//     log(widget.userprofile.mobilenoone);
//     log(widget.userprofile.birthDate);
//     log(widget.userprofile.bankName);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: appBar(
//           // showBack: widget.adminProfile == true ? true : false,
//           showBack: false,
//           onTap: () {
//             // Get.back();
//           },
//           title: 'Profile',
//           actions: [
//             Visibility(
//               visible: widget.adminProfile == true,
//               child: IconButton(
//                 icon: const Icon(Icons.logout),
//                 onPressed: () async {
//                   showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     builder: (BuildContext context) {
//                       return commonLogOutDialog(
//                         title: "Log Out",
//                         subTitle: "Are you sure you want to logout?",
//                         icon: Icons.exit_to_app,
//                         cancelText: "Cancel",
//                         deleteButtonColor: AppColors.primarycolor,
//                         confirmText: "Logout",
//                         iconColor: AppColors.primarycolor,
//                         cancelOnPressed: () {
//                           Get.back();
//                         },
//                         logOutOnPressed: () async {
//                           SharedPreferences prefs =
//                               await SharedPreferences.getInstance();
//                           await prefs.remove('isLoggedIn');
//                           await prefs.remove('role');
//                           Get.offAll(() => Login());
//                           // Navigator.pushReplacement(
//                           //   context,
//                           //   MaterialPageRoute(
//                           //     builder: (context) => const Login(),
//                           //   ),
//                           // );
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ]),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Column(
//               children: [
//                 20.height,
//                 Container(
//                   height: 130,
//                   width: 130,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: AppColors.primarycolor, width: 3),
//                     shape: BoxShape.circle,
//                     color: AppColors.primarycolor,
//                     image: DecorationImage(
//                       image: widget.adminProfile
//                           ? (widget.userprofile.image.contains('assets/')
//                               ? AssetImage(widget.userprofile.image)
//                                   as ImageProvider
//                               : FileImage(File(widget.userprofile.image)))
//                           : FileImage(File(widget.userprofile.image)),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 5.height,
//               ],
//             ),
//             profileDetailConHeight(),
//             Padding(
//               padding: 15.horizontal,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   commonProfileLabel(
//                     label: "Personal information",
//                   ),
//                   profileDetailLabelHeight(),
//                   Container(
//                     width: double.maxFinite,
//                     padding: const EdgeInsets.all(12),
//                     decoration: commonDecoration(),
//                     child: Column(
//                       children: [
//                         commonrowprofile(
//                           labeltext: "Name",
//                           fetchname:
//                               "${widget.userprofile.firstName} ${widget.userprofile.lastName}",
//                         ),
//                         profileDetailHeight(),
//                         commonrowprofile(
//                           labeltext: "Aadhar",
//                           fetchname: widget.userprofile.aadhar ?? "",
//                         ),
//                         profileDetailHeight(),
//                         commonrowprofile(
//                             labeltext: "Gender",
//                             fetchname: widget.userprofile.gender ?? ""),
//                         profileDetailHeight(),
//                         commonrowprofile(
//                             labeltext: "Birth Date",
//                             fetchname: widget.userprofile.birthDate),
//                       ],
//                     ),
//                   ),
//                   profileDetailConHeight(),
//                   commonProfileLabel(
//                     label: "Contact Details",
//                   ),
//                   profileDetailLabelHeight(),
//                   Container(
//                     width: double.maxFinite,
//                     padding: const EdgeInsets.all(8),
//                     decoration: commonDecoration(),
//                     child: Column(
//                       children: [
//                         commonrowprofile(
//                             labeltext: "Mobile Number 1",
//                             fetchname: widget.userprofile.mobilenoone),
//                         profileDetailHeight(),
//                         commonrowprofile(
//                             labeltext: "Mobile Number 2",
//                             fetchname: widget.userprofile.mobilentwo),
//                         profileDetailHeight(),
//                         commonrowprofile(
//                             labeltext: "Email",
//                             fetchname: widget.userprofile.email),
//                         profileDetailHeight(),
//                         commonrowprofile(
//                             labeltext: "Address",
//                             fetchname: widget.userprofile.address),
//                       ],
//                     ),
//                   ),
//                   profileDetailConHeight(),
//                   commonProfileLabel(
//                     label: "Bank Details",
//                   ),
//                   profileDetailLabelHeight(),
//                   Container(
//                     width: double.maxFinite,
//                     padding: const EdgeInsets.all(10),
//                     decoration: commonDecoration(),
//                     child: Column(
//                       children: [
//                         commonrowprofile(
//                             labeltext: "Bank Name",
//                             fetchname: widget.userprofile.bankName),
//                         profileDetailHeight(),
//                         commonrowprofile(
//                             labeltext: "Branch Address",
//                             fetchname: widget.userprofile.branchAddress),
//                         profileDetailHeight(),
//                         commonrowprofile(
//                             labeltext: "Ac No",
//                             fetchname: widget.userprofile.accountNumber),
//                         profileDetailHeight(),
//                         commonrowprofile(
//                             labeltext: "IFSC",
//                             fetchname: widget.userprofile.ifscCode),
//                         profileDetailHeight(),
//                         commonrowprofile(
//                             labeltext: "Referance",
//                             fetchname: widget.userprofile.reference),
//                         profileDetailHeight(),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                                 flex: 4,
//                                 child:
//                                     textprofilelist(label: "Uploaded Proof")),
//                             Expanded(child: Text(":")),
//                             Expanded(
//                               flex: 5,
//                               child: SizedBox(
//                                 child: ListView.separated(
//                                   separatorBuilder: (context, index) =>
//                                       10.height,
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   itemCount:
//                                       widget.userprofile.documents.length ?? 0,
//                                   itemBuilder: (context, index) {
//                                     String documentPath =
//                                         widget.userprofile.documents[index] ??
//                                             "";
//                                     return GestureDetector(
//                                       onTap: () {
//                                         opendoc(documentPath);
//                                       },
//                                       child: Container(
//                                         decoration: commonDecoration(),
//                                         child: Padding(
//                                           padding: 8.symmetric,
//                                           child: Text(
//                                             widget.userprofile.documents[index]
//                                                     .split('/')
//                                                     .last ??
//                                                 "",
//                                             maxLines: 3,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: poppinsStyle(
//                                               decoration:
//                                                   TextDecoration.underline,
//                                               decorationColor: AppColors.blue,
//                                               color: AppColors.blue,
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   profileDetailConHeight(),
//                   commonProfileLabel(
//                     label: "Office Details",
//                   ),
//                   profileDetailLabelHeight(),
//                   Container(
//                     width: double.maxFinite,
//                     padding: const EdgeInsets.all(10),
//                     decoration: commonDecoration(),
//                     child: Column(
//                       children: [
//                         commonrowprofile(
//                             labeltext: "Employee Type",
//                             fetchname: widget.userprofile.employmentType),
//                         profileDetailHeight(),
//                         commonrowprofile(
//                             labeltext: "Joining Date",
//                             fetchname: widget.userprofile.dateFrom),
//                         profileDetailHeight(),
//                         commonrowprofile(
//                             labeltext: "Employee ID",
//                             fetchname: widget.userprofile.srNo),
//                       ],
//                     ),
//                   ),
//                   10.height,
//                 ],
//               ),
//             ),
//
//             // commontext(text: "text"),
//           ],
//         ),
//       ),
//     );
//   }
// }
