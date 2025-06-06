import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/dashboardcommon.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/config/list.dart';
import 'package:employeeform/view/admin_side/attendanceadmin.dart';
import 'package:employeeform/view/admin_side/employee_details.dart';
import 'package:employeeform/view/admin_side/reportattendance.dart';
import 'package:employeeform/view/admin_side/showuserattendance.dart';
import 'package:employeeform/view/admin_side/taskreport.dart';
import 'package:employeeform/view/admin_side/viewalltaskadmin.dart';
import 'package:employeeform/view/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Admindashboard extends StatefulWidget {
  const Admindashboard({super.key});

  @override
  State<Admindashboard> createState() => _AdmindashboardState();
}

class _AdmindashboardState extends State<Admindashboard> {
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
            "DashBoard",
            style: poppinsStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton<int>(
              color: AppColors.white,
              icon: Icon(
                Icons.more_vert_outlined,
                color: AppColors.hinttext,
              ),
              onSelected: (value) {
                if (value == 0) {
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
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Log Out",
                                  style: poppinsStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
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
                                            await SharedPreferences
                                                .getInstance();
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
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: AppColors.black.withOpacity(0.4),
                      ),
                      8.width,
                      Text(
                        'LogOut',
                        style: poppinsStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.black.withOpacity(0.4)),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
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
                        15.height,
                        Text(
                          "Daily Uses",
                          style: poppinsStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        commonDivider(),
                        7.height,
                        GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 13,
                                  mainAxisSpacing: 15,
                                  mainAxisExtent: 100,
                                  crossAxisCount: 3),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: employeelistdata.length,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onTap: () {
                                if (employeelistdata[i]['label'] ==
                                    "Employee \nDetails") {
                                  Get.to(EmployeeDetails(),
                                      transition: Transition.noTransition,
                                      duration: Duration(milliseconds: 300));
                                } else if (employeelistdata[i]['label'] ==
                                    "Attendance\n") {
                                  Get.to(() => AttendanceAdminPage(),
                                      transition: Transition.noTransition,
                                      duration: Duration(milliseconds: 300));
                                } else if (employeelistdata[i]['label'] ==
                                    "Report\n") {
                                  Get.to(AttendanceReportPage(),
                                      transition: Transition.noTransition,
                                      duration: Duration(milliseconds: 300));
                                } /*else if (employeelistdata[i]['label'] ==
                                    "Employee \nTask") {
                                  Get.to(Exemployeetask());
                                }*/
                                else if (employeelistdata[i]['label'] ==
                                    "All \nTask") {
                                  Get.to(ViewAllTaskAdmin(),
                                      transition: Transition.noTransition,
                                      duration: Duration(milliseconds: 300));
                                } else if (employeelistdata[i]['label'] ==
                                    "Task \nReport") {
                                  Get.to(Taskreport(),
                                      transition: Transition.noTransition,
                                      duration: Duration(milliseconds: 300));
                                } else if (employeelistdata[i]['label'] ==
                                    "Employee \nAttendance") {
                                  Get.to(ShowUserAttendance(),
                                      transition: Transition.noTransition,
                                      duration: Duration(milliseconds: 300));
                                }
                              },
                              child: dashboarddata(
                                label: employeelistdata[i]['label'],
                                img: employeelistdata[i]['image'],
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
      ),
    );
  }
}
