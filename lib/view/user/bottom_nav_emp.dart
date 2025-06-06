import 'package:employeeform/view/user/userviewtask.dart';
import 'package:employeeform/view/user/viewallleave.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../common/comman_widget.dart';
import '../../config/color.dart';
import '../../config/images.dart';
import '../../controller/userdashboard_controller.dart';
import '../admin_side/bottom_nav_admin.dart';
import 'attendance.dart';

class BottomNavEmployee extends StatefulWidget {
  const BottomNavEmployee({super.key});

  @override
  State<BottomNavEmployee> createState() => _BottomNavEmployeeState();
}

class _BottomNavEmployeeState extends State<BottomNavEmployee> {
  UserDashBoardController controller = Get.put(UserDashBoardController());
  final Color navigationBarColor = Colors.white;
  int selectedIndex = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
    controller.fetchEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return showExitConfirmationDialog(
              noOnTap: () {
                Get.back();
              },
              yesOnTap: () {
                SystemNavigator.pop();
              },
            );
          },
        );

        return false;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: navigationBarColor,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: <Widget>[
              Userviewtask(),
              // DuePayForUser(),
              Attendance(),
              ViewAllLeave(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BottomNavDecoration(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: GNav(
                  haptic: true, // haptic feedback
                  tabBorderRadius: 15,
                  gap: 8, // the tab button gap between icon and text
                  color: AppColors.primarycolor
                      .withOpacity(0.1), // unselected icon color
                  activeColor: AppColors.primarycolor
                      .withOpacity(0.1), // selected icon and text color
                  iconSize: 24, // tab button icon size
                  tabBackgroundColor: AppColors.primarycolor
                      .withOpacity(0.1), // selected tab background color
                  textStyle: poppinsStyle(
                      color: AppColors.primarycolor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                  padding: EdgeInsets.zero,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  onTabChange: (index) {
                    setState(() {
                      selectedIndex = index; // Update index
                    });
                    pageController.jumpToPage(index); // Change PageView index
                  },
                  tabs: [
                    gBtn(label: 'Task', img: AppSvg.TaskReport),
                    // gBtn(label: 'PayRoll', img: AppImages.EmployeeAttendance),
                    gBtn(label: 'Attendance', img: AppSvg.EmployeeAttendance),
                    gBtn(label: 'Leaves', img: AppSvg.jobleave),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
