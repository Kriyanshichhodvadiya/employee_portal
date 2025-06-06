import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/images.dart';
import 'package:employeeform/controller/employeeformContro.dart';
import 'package:employeeform/view/admin_side/showuserattendance.dart';
import 'package:employeeform/view/admin_side/viewalltaskadmin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../config/color.dart';
import '../../controller/userdashboard_controller.dart';
import '../../model/eprofilemodel.dart';
import 'ad_leavescreen.dart';
import 'edit_user/profile_details.dart';
import 'employee_details.dart';

class BottomNavAdmin extends StatefulWidget {
  final int initialIndex;
  const BottomNavAdmin({super.key, this.initialIndex = 0});

  @override
  State<BottomNavAdmin> createState() => _BottomNavAdminState();
}

class _BottomNavAdminState extends State<BottomNavAdmin> {
  UserDashBoardController controller = Get.put(UserDashBoardController());
  EmployeeFormController employeeFormController =
      Get.put(EmployeeFormController());
  final Color navigationBarColor = Colors.white;
  int selectedIndex = 0;
  late PageController pageController;

  UserProfile? currentAdmin;
  @override
  void initState() {
    super.initState();
    // loadCurrentAdmin();
    selectedIndex = widget.initialIndex;
    pageController = PageController(initialPage: widget.initialIndex);
    // controller.fetchEmployeeData();
    // controller.fetchAdminData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchEmployeeData();
      controller.fetchAdminData();
    });
    // fetchLoggedInAdminData();
    // fetchAdminData();
    // fetchLastAdminData();
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
      child: /*currentAdmin == null
          ? Scaffold(
              body: Center(
                  child: CupertinoActivityIndicator(
              color: AppColors.primarycolor,
            )))
          : */
          AnnotatedRegion<SystemUiOverlayStyle>(
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
              EmployeeDetails(),
              // AttendanceReportPage(),
              // PaymentRecord(),
              ViewAllTaskAdmin(),
              AdminLeaveScreen(),
              ShowUserAttendance(),
              Obx(
                () => ProfileDetail(
                  backBtn: false,
                  adminProfile: true,
                  editMode: false,
                  adminEdit: true,
                  userprofile: UserProfile(
                    image: controller.lastAdminImage.value,
                    firstName: controller.lastAdminName.value,
                    lastName: controller.lastAdminLastName.value,
                    email: controller.lastAdminEmail.value,
                    address: controller.lastAdminAddress.value,
                    aadhar: controller.lastAdminAadhar.value,
                    gender: controller.lastAdminGender.value,
                    birthDate: controller.lastAdminBirthDate.value,
                    mobilenoone: controller.lastAdminMobileOne.value,
                    mobilentwo: controller.lastAdminMobileTwo.value,
                    bankName: controller.lastAdminBankName.value,
                    accountNumber: controller.lastAdminAccountNumber.value,
                    ifscCode: controller.lastAdminIfscCode.value,
                    employmentType: controller.lastAdminEmploymentType.value,
                    dateFrom: controller.lastAdminDateFrom.value,
                    srNo: controller.lastAdminSrNo.value,
                    documents: controller.selectedDocuments
                        .map((file) => file.path)
                        .toList(),
                    attachProof: controller.selectedProofs,
                    middleName: '',
                    branchAddress: controller.lastAdminBranchAddress.value,
                    reference: controller.lastAdminreference.value,
                    zipCode: controller.zipcode.value,
                    city: controller.city.value,
                    state: controller.state.value,
                    country: controller.country.value,
                    confirmPass: controller.confirmPass.value,
                    password: controller.password.value,
                    uploadedDocuments: {},
                    attachedFiles: UploadedDocumentsModel(
                      aadharCard: AadharCardModel(
                        frontSidePath: controller.frontAadharFilePath.value,
                        backSidePath: controller.backAadharFilePath.value,
                      ),
                      bankPassbookFile: controller.bankPassbookFile.value,
                      otherFiles: controller.otherDocuments,
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BottomNavDecoration(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: GNav(
                  selectedIndex: selectedIndex,
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
                    gBtn(label: 'Employees', img: AppSvg.EmployeeDetails),
                    gBtn(label: 'All Task', img: AppSvg.Alltask),
                    // gBtn(label: 'Pay Record', img: AppImages.EmployeeAttendance),

                    gBtn(label: 'Leave', img: AppSvg.jobleave),
                    gBtn(label: 'Attendance', img: AppSvg.EmployeeAttendance),
                    gBtn(label: 'Profile', img: AppSvg.profile),
                    // gBtn(label: 'Profile', img: AppImages.profile),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

GButton gBtn({required label, required img}) {
  return GButton(
      padding: EdgeInsets.symmetric(vertical: 10),
      icon: Icons.circle,
      iconSize: 0,
      iconColor: Colors.transparent,
      text: label,
      textColor: AppColors.black,
      leading: Padding(
        padding: EdgeInsets.only(left: 10, right: 5),
        child: SvgPicture.asset(
          img,
          width: 7.wp(Get.context!),
          height: 7.wp(Get.context!),
          color: AppColors.primarycolor,
        ),
      ));
}

Decoration BottomNavDecoration() {
  return BoxDecoration(
    color: AppColors.white, // Background color of the navigation bar
    boxShadow: [
      BoxShadow(
        color: AppColors.black.withOpacity(0.1), // Shadow color
        blurRadius: 10, // Blur effect
        spreadRadius: 2, // Spread effect
        offset: Offset(0, 3), // Moves shadow downward
      ),
    ],
    borderRadius: BorderRadius.vertical(
        top: Radius.circular(0)), // Optional: Rounded corners
  );
}
