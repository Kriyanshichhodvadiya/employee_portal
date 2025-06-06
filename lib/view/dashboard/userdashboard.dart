import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/dashboardcommon.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/config/list.dart';
import 'package:employeeform/controller/userdashboard_controller.dart';
import 'package:employeeform/view/login.dart';
import 'package:employeeform/view/user/attendance.dart';
import 'package:employeeform/view/user/userviewtask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/eprofilemodel.dart';
import '../admin_side/edit_user/profile_details.dart';

class Userdashboard extends StatefulWidget {
  const Userdashboard({super.key});

  @override
  State<Userdashboard> createState() => _UserdashboardState();
}

class _UserdashboardState extends State<Userdashboard> {
  UserDashBoardController controller = Get.put(UserDashBoardController());

  // List<File> uploadedDoc(Map<String, dynamic> employeeData) {
  //   List<File> uploadedDocslist = [];
  //   if (employeeData['proof'] != null) {
  //     for (String path in employeeData['proof']) {
  //       uploadedDocslist.add(File(path));
  //     }
  //   }
  //   return uploadedDocslist;
  // }

  // Map<String, dynamic>? employeeData;
  // bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller.fetchEmployeeData();
  }

  // Future<void> fetchEmployeeData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? employeeListString = prefs.getString('employeeData');
  //   String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');
  //
  //   if (employeeListString != null) {
  //     List<dynamic> employeeList = jsonDecode(employeeListString);
  //
  //     controller.employeeData.value = employeeList.firstWhere(
  //       (employee) => employee['srNo'] == loggedInUserSrNo,
  //       orElse: () => {},
  //     );
  //
  //     setState(() {
  //       controller.isLoading.value = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          shadowColor: AppColors.black.withOpacity(0.5),
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Dash Board",
            style: poppinsStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.white),
                        child: Padding(
                          padding: 25.symmetric,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Log Out",
                                style: poppinsStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                              10.height,
                              Text(
                                "Are you sure you want to logout?",
                                style: poppinsStyle(
                                    color: AppColors.grey, fontSize: 14),
                              ),
                              28.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: poppinsStyle(
                                          color: AppColors.primarycolor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  30.width,
                                  GestureDetector(
                                    onTap: () async {
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
                                    child: Text(
                                      "Ok",
                                      style: poppinsStyle(
                                          color: AppColors.primarycolor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              20.height,
              Padding(
                padding: 10.symmetric,
                child: Container(
                  padding: 10.symmetric,
                  decoration: commonDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "Daily Uses",
                      //   style: style(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      20.height,
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 13,
                                mainAxisSpacing: 15,
                                mainAxisExtent: 95,
                                crossAxisCount: 3),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userdashboardlist.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {
                              if (userdashboardlist[i]['label'] ==
                                  "Profile \n") {
                                Get.to(
                                    () => ProfileDetail(
                                          backBtn: true,
                                          adminEdit: false,
                                          adminProfile: false,
                                          editMode: false,
                                          userprofile: UserProfile.fromMap(
                                            controller.employeeData,
                                            // Pass uploaded docs list
                                          ),
                                        ),
                                    transition: Transition.noTransition,
                                    duration:
                                        const Duration(milliseconds: 300));
                                /*  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    */ /* Profileage(
                                      firstname:
                                          "${controller.employeeData['firstName']}",
                                      middlename:
                                          "${controller.employeeData['middleName']}",
                                      lastname:
                                          "${controller.employeeData['lastName']}",
                                      address:
                                          "${controller.employeeData['address']}",
                                      aadharcard:
                                          "${controller.employeeData['aadhar']}",
                                      gender:
                                          "${controller.employeeData['gender']}",
                                      mobile1:
                                          "${controller.employeeData['mobileNumber']}",
                                      mobile2:
                                          "${controller.employeeData['mobileNumberTwo']}",
                                      mobile3:
                                          "${controller.employeeData['email']}",
                                      banknm:
                                          "${controller.employeeData['bankname']}",
                                      branadd:
                                          "${controller.employeeData['branchAddress']}",
                                      acno:
                                          "${controller.employeeData['accountNumber']}",
                                      ifsccode:
                                          "${controller.employeeData['ifscCode']}",
                                      refereance:
                                          "${controller.employeeData['reference']}",
                                      etype:
                                          "${controller.employeeData['employeetype']}",
                                      eid: "${controller.employeeData['srNo']}",
                                      birthdate:
                                          "${controller.employeeData['birthdate']}",
                                      joinningdate:
                                          "${controller.employeeData['joindate']}",
                                      aproof:
                                          "${controller.employeeData['proof']}",
                                      photo:
                                          "${controller.employeeData['image']}",
                                      uploaddoc: controller
                                          .uploadedDoc(controller.employeeData),
                                    )*/ /*
                                    ,
                                  ),
                                );*/
                              } else if (userdashboardlist[i]['label'] ==
                                  "Task\n") {
                                Get.to(Userviewtask(),
                                    transition: Transition.noTransition,
                                    duration: Duration(milliseconds: 300));
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => Userviewtask()),
                                // );
                              } else if (userdashboardlist[i]['label'] ==
                                  "Attendance\n") {
                                Get.to(const Attendance(),
                                    transition: Transition.noTransition,
                                    duration: Duration(milliseconds: 300));
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => Attendance()),
                                // );
                              }
                            },
                            child: dashboarddata(
                              label: userdashboardlist[i]['label'],
                              img: userdashboardlist[i]['image'],
                            ),
                          );
                        },
                      ),
                      10.height,
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
