/*
import 'dart:io';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/controller/profilepage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/global_widget.dart';

class Profileage extends StatefulWidget {
  final String firstname;
  final String middlename;
  final String lastname;
  final String address;
  final String aadharcard;
  final String gender;
  // final String nationality;
  final String mobile1;
  final String mobile2;
  final String mobile3;
  final String banknm;
  final String branadd;
  final String acno;
  final String ifsccode;
  final String refereance;
  final String etype;
  final String eid;
  final String birthdate;
  final String joinningdate;
  final String aproof;
  final String photo;
  List<File> uploaddoc;

  Profileage({
    super.key,
    required this.firstname,
    required this.middlename,
    required this.lastname,
    required this.address,
    required this.aadharcard,
    required this.gender,
    required this.mobile1,
    required this.mobile2,
    required this.mobile3,
    // required this.nationality,
    required this.banknm,
    required this.branadd,
    required this.acno,
    required this.ifsccode,
    required this.refereance,
    required this.etype,
    required this.eid,
    required this.birthdate,
    required this.joinningdate,
    required this.aproof,
    required this.photo,
    required this.uploaddoc,
  });

  @override
  State<Profileage> createState() => _ProfileageState();
}

class _ProfileageState extends State<Profileage> {
  ProfileController controller = Get.put(ProfileController());
  // Future<void> opedoc(String filePath) async {
  //   final result = await OpenFilex.open(filePath);
  //   if (result.type == ResultType.error) {
  //     throw 'Could not open the document';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBar(
          onTap: () {
            Get.back();
          },
          title:
              'Profile') */
/*AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        shadowColor: AppColors.black.withOpacity(0.5),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: poppinsStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
      )*/ /*

      ,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                20.height,
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.black),
                      image: DecorationImage(
                          image: FileImage(File(widget.photo)),
                          fit: BoxFit.cover),
                      shape: BoxShape.circle,
                      color: Colors.black),
                ),
                5.height,
              ],
            ),
            20.height,
            Padding(
              padding: 15.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal information",
                    style: poppinsStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  10.height,
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 3,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 3, child: textprofilelist(label: "Name")),
                            Expanded(child: Text(":")),
                            Expanded(
                              flex: 3,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: widget.firstname,
                                      style: poppinsStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: ' ',
                                      style: poppinsStyle(fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: widget.middlename,
                                      style: poppinsStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        15.height,
                        commonrowprofile(
                          labeltext: "Father Name",
                          fetchname: widget.lastname,
                        ),
                        15.height,
                        commonrowprofile(
                          labeltext: "Aadhar",
                          fetchname: widget.aadharcard,
                        ),
                        15.height,
                        commonrowprofile(
                            labeltext: "Gender", fetchname: widget.gender),
                        15.height,
                        commonrowprofile(
                            labeltext: "Birth Date",
                            fetchname: widget.birthdate),
                        // 15.height,
                        // commonrowprofile(
                        //   labeltext: "Nationality:",
                        //   fetchname: widget.nationality,
                        // ),
                      ],
                    ),
                  ),
                  20.height,
                  Text(
                    "Contact Details",
                    style: poppinsStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  10.height,
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 3,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        commonrowprofile(
                            labeltext: "Mobile Number 1",
                            fetchname: widget.mobile1),
                        15.height,
                        commonrowprofile(
                            labeltext: "Mobile Number 2",
                            fetchname: widget.mobile2),
                        15.height,
                        commonrowprofile(
                            labeltext: "Email ID", fetchname: widget.mobile3),
                        15.height,
                        commonrowprofile(
                            labeltext: "Address", fetchname: widget.address),
                      ],
                    ),
                  ),
                  20.height,
                  Text(
                    "Bank Details",
                    style: poppinsStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  10.height,
                  Container(
                    width: double.maxFinite,
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
                      children: [
                        commonrowprofile(
                            labeltext: "Bank Name", fetchname: widget.banknm),
                        15.height,
                        commonrowprofile(
                            labeltext: "Branch Address",
                            fetchname: widget.branadd),
                        15.height,
                        commonrowprofile(
                            labeltext: "Ac No", fetchname: widget.acno),
                        15.height,
                        commonrowprofile(
                            labeltext: "IFSC", fetchname: widget.ifsccode),
                        15.height,
                        commonrowprofile(
                            labeltext: "Referance",
                            fetchname: widget.refereance),
                        15.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 3,
                                child: textprofilelist(label: "Upload Proof")),
                            Expanded(child: Text(":")),
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                  child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.uploaddoc.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  String documentPath =
                                      widget.uploaddoc[index].path;

                                  return GestureDetector(
                                    onTap: () {
                                      controller.opedoc(documentPath);
                                    },
                                    child: Text(
                                      widget.uploaddoc[index].path
                                          .split('/')
                                          .last,
                                      style: poppinsStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blue,
                                        color: Color(0xFF2196F3),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  20.height,
                  Text(
                    "Office Details",
                    style: poppinsStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  10.height,
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 3,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        commonrowprofile(
                            labeltext: "Employee Type",
                            fetchname: widget.etype),
                        15.height,
                        commonrowprofile(
                            labeltext: "Joining Date",
                            fetchname: widget.joinningdate),
                        15.height,
                        commonrowprofile(
                            labeltext: "Employee ID", fetchname: widget.eid),
                      ],
                    ),
                  ),
                  // 30.height,
                  // Center(
                  //     child: primarybutton(
                  //         text: "Continue",
                  //         onPressed: () {
                  //           Navigator.pushReplacement(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) =>
                  //                     const ViewEmployeeDetails(),
                  //               ));
                  //         })),
                  20.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Column(
//   children: [
//     Center(
//       child: Container(
//         height: 150,
//         width: 150,
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: FileImage(File(widget.photo)),
//                 fit: BoxFit.cover),
//             shape: BoxShape.circle,
//             color: Colors.white),
//       ),
//     ),
//   ],
// ),

// Expanded(
//   child: SingleChildScrollView(
//     child: Padding(
//       padding: 20.horizontal,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Text(
//           //   "Personal information",
//           //   style: style(
//           //     color: AppColors.black,
//           //     fontWeight: FontWeight.w500,
//           //     fontSize: 2.2.hp(context),
//           //   ),
//           // ),
//           10.height,
//           Container(
//             // height: 550,
//             width: double.maxFinite,
//             // margin: const EdgeInsets.symmetric(
//             //     vertical: 10, horizontal: 20),
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: const [
//                 BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     spreadRadius: 5,
//                     offset: Offset(0, 5)),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: 10.onlyTop,
//                   child: edittextfiled(
//                     text: "First Name",
//                     textfetch: widget.firstname,
//                   ),
//                 ),
//                 10.height,
//                 edittextfiled(
//                     text: "Middle Name",
//                     textfetch: widget.middlename),
//                 10.height,
//                 edittextfiled(
//                     text: "Last Name", textfetch: widget.lastname),
//                 10.height,
//                 edittextfiled(
//                     text: "Address", textfetch: widget.address),
//                 10.height,
//                 edittextfiled(
//                   text: "Aadhar",
//                   textfetch: widget.aadharcard,
//                 ),
//                 10.height,
//                 edittextfiled(
//                   text: "Gender",
//                   textfetch: widget.gender,
//                 ),
//                 10.height,
//                 edittextfiled(
//                     text: "Birthdate", textfetch: widget.birthdate),
//                 10.height,
//                 edittextfiled(
//                     text: "Nationality",
//                     textfetch: widget.nationality),
//                 10.height,
//                 edittextfiled(
//                     text: "Mobile Number 1",
//                     textfetch: widget.mobile1),
//                 10.height,
//                 edittextfiled(
//                     text: "Mobile Number 2",
//                     textfetch: widget.mobile2),
//                 10.height,
//                 edittextfiled(
//                     text: "Mobile Number 3",
//                     textfetch: widget.mobile3),
//                 10.height,
//               ],
//             ),
//           ),
//           20.height,
//           Text(
//             "Bank Details",
//             style: style(
//               color: AppColors.black,
//               fontWeight: FontWeight.w500,
//               fontSize: 2.2.hp(context),
//             ),
//           ),
//           10.height,
//           Container(
//             // height: 420,
//             width: double.maxFinite,
//             // margin: const EdgeInsets.symmetric(
//             //     vertical: 10, horizontal: 20),
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: const [
//                 BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     spreadRadius: 5,
//                     offset: Offset(0, 5)),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: 10.onlyTop,
//                   child: edittextfiled(
//                       text: "Bank Name", textfetch: widget.banknm),
//                 ),
//                 10.height,
//                 edittextfiled(
//                     text: "Branch Address",
//                     textfetch: widget.branadd),
//                 10.height,
//                 edittextfiled(
//                     text: "Ac no", textfetch: widget.acno),
//                 10.height,
//                 edittextfiled(
//                     text: "IFSC", textfetch: widget.ifsccode),
//                 10.height,
//                 edittextfiled(
//                     text: "Referance",
//                     textfetch: widget.refereance),
//                 10.height,
//                 edittextfiled(
//                     text: "Attach Proof", textfetch: widget.aproof),
//                 10.height,

//                 Container(
//                   // height: 150,
//                   width: double.maxFinite,
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     boxShadow: const [
//                       BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                           offset: Offset(0, 2)),
//                     ],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             top: 5.0, left: 20),
//                         child: Text(
//                           "Upload Proof",
//                           style: style(
//                             color: AppColors.primarycolor,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         // height: 70,
//                         child: Padding(
//                             padding: const EdgeInsets.only(
//                               top: 8.0,
//                               left: 20,
//                             ),
// child: ListView.builder(
//   shrinkWrap: true,
//   physics:
//       NeverScrollableScrollPhysics(),
//   itemCount: widget.uploaddoc.length,
//   itemBuilder: (context, index) {
//     return Padding(
//       padding: 10.vertical,
//       child: Text(
//         widget.uploaddoc[index].path
//             .split('/')
//             .last,
//         style: const poppinsStyle(
//           decoration:
//               TextDecoration.underline,
//           decorationColor: Colors.blue,
//           color: Color(0xFF2196F3),
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   },
// )
//                             //     commontext(
//                             //   text: "textfetch",
//                             // ),
//                             ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // edittextfiled(
//                 //     text: "Upload Document",
//                 //     textfetch: ),
//                 // 10.height,
//               ],
//             ),
//           ),
//           20.height,
//           Text(
//             "Office Details",
//             style: style(
//               color: AppColors.black,
//               fontWeight: FontWeight.w500,
//               fontSize: 2.2.hp(context),
//             ),
//           ),
//           10.height,
//           Container(
//             // height: 300,
//             width: double.maxFinite,
//             // margin: const EdgeInsets.symmetric(
//             //     vertical: 10, horizontal: 20),
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: const [
//                 BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     spreadRadius: 5,
//                     offset: Offset(0, 5)),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: 10.onlyTop,
//                   child: edittextfiled(
//                       text: "Employee Type",
//                       textfetch: widget.etype),
//                 ),
//                 10.height,
//                 edittextfiled(
//                     text: "From Date",
//                     textfetch: widget.joinningdate),
//                 10.height,
//                 edittextfiled(text: "Sr No", textfetch: widget.eid),
//               ],
//             ),
//           ),

//           // Container(
//           //   height: 55,
//           //   width: double.maxFinite,
//           //   decoration: BoxDecoration(
//           //     color: AppColors.white,
//           //     boxShadow: [
//           //       BoxShadow(
//           //         offset: const Offset(0, 0),
//           //         spreadRadius: 0.0001,
//           //         blurRadius: 10,
//           //         color: Colors.black.withOpacity(0.07),
//           //       ),
//           //     ],
//           //     borderRadius: BorderRadius.circular(12),
//           //   ),
//           //   child: Column(
//           //     crossAxisAlignment: CrossAxisAlignment.start,
//           //     children: [
//           //       Padding(
//           //         padding:
//           //             const EdgeInsets.only(top: 5.0, left: 20),
//           //         child: Text(
//           //           "Name",
//           //           style: style(
//           //             color: AppColors.primarycolor,
//           //             fontWeight: FontWeight.w500,
//           //             fontSize: 10,
//           //           ),
//           //         ),
//           //       ),
//           //       Expanded(
//           //         child: Padding(
//           //           padding: const EdgeInsets.only(
//           //             top: 8.0,
//           //             left: 20,
//           //           ),
//           //           child: commontext(
//           //             text: fnamedata,
//           //           ),
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),

//           30.height,
//           Center(
//               child: primarybutton(
//                   text: "Continue",
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               const ViewEmployeeDetails(),
//                         ));
//                   })),
//           20.height,
//         ],
//       ),
//     ),
//   ),
// ),

// // commontext(text: "text"),
*/
