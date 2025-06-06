import 'dart:convert';
import 'dart:developer';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/config/images.dart';
import 'package:employeeform/controller/employeeformContro.dart';
import 'package:employeeform/model/eprofilemodel.dart';
import 'package:employeeform/view/admin_side/company_profile/co_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart' as openFilex;
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/com_profile_controller.dart';
import 'attendanceadmin.dart';
import 'company_profile/com_profile_detail.dart';
import 'edit_user/editdetails.dart';
import 'edit_user/employeeform.dart';
import 'edit_user/profile_details.dart';

List<UserProfile> userprofilelist = [];

class EmployeeDetails extends StatefulWidget {
  const EmployeeDetails({super.key});

  @override
  State<EmployeeDetails> createState() => EmployeeDetailsState();
}

class EmployeeDetailsState extends State<EmployeeDetails> {
  CompanyProfileController controller = Get.put(CompanyProfileController());
  EmployeeFormController employeeFormController =
      Get.put(EmployeeFormController());

  @override
  void initState() {
    super.initState();
    employeeDetails();
  }

  Future<void> employeeDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeDataJson = prefs.getString('employeeData');

    if (employeeDataJson != null) {
      setState(() {
        log("JSON DATA ===> $employeeDataJson");
        List<dynamic> employeeData = jsonDecode(employeeDataJson);
        log("JSON  ===> $employeeData");
        userprofilelist =
            employeeData.map((item) => UserProfile.fromMap(item)).toList();

        log("Profiles ===> $userprofilelist");
      });
    }
  }

  Future<void> openPDF(filePath) async {
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

  void deleteEmployee(int index) async {
    setState(() {
      userprofilelist.removeAt(index);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> updatedEmployeeList =
        userprofilelist.map((item) => item.toMap()).toList();
    await prefs.setString('employeeData', jsonEncode(updatedEmployeeList));

    log("Updated: ${prefs.getString('employeeData')}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: appBar(
            showBack: false,
            onTap: () {
              Get.back();
              /*Get.off(
                () => Admindashboard(),
              );*/
            },
            title: 'Employee Details',
            actions: [
              commonCompanyIcon(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var isProfileAdded = prefs.getBool('isProfileAdded');

                  log(" controller.isProfileAdded.value::${controller.isProfileAdded.value}");
                  log(" isProfileAdded::${isProfileAdded}");
                  Get.off(() => isProfileAdded == true
                      ? CompanyProfileDetails()
                      : CompanyProfileForm());
                },
                image: AppSvg.companyProfile,
              ),
              16.width,
            ]),
        body: SafeArea(
          child: userprofilelist.isEmpty
              ? Center(child: commonLottie())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      20.height,
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            width: double.maxFinite,
                            height: 65.heightBox(),
                            // constraints: BoxConstraints(
                            //   maxHeight: 60.hp(context),
                            // ),
                            // height: 50.hp(context),
                            decoration: commonDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(6),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        attendanceTableLabel(
                                          label: 'No.',
                                        ),
                                        attendanceTableLabel(
                                          label: 'Name',
                                        ),
                                        Padding(
                                            padding: 15.symmetric,
                                            child: SizedBox()),
                                      ],
                                    ),
                                  ],
                                ),
                                commonDivider(),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: userprofilelist.length,
                                    itemBuilder: (context, index) {
                                      log("user:country:${userprofilelist[index].country}");
                                      log("user:state:${userprofilelist[index].state}");
                                      log("user:city:${userprofilelist[index].city}");
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15.0,
                                                  ),
                                                  child: Text('${index + 1}',
                                                      style: poppinsStyle(
                                                          color: AppColors
                                                              .hinttext,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15)),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 7.0,
                                                          bottom: 7,
                                                          left: 10),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProfileDetail(
                                                                  adminEdit:
                                                                      false,
                                                                  backBtn: true,
                                                                  editMode:
                                                                      false,
                                                                  adminProfile:
                                                                      false,
                                                                  userprofile:
                                                                      userprofilelist[
                                                                          index],
                                                                )),
                                                      );
                                                    },
                                                    child: Text(
                                                        '${userprofilelist[index].firstName ?? 'N/A'} ${userprofilelist[index].lastName ?? ''} ',
                                                        style: poppinsStyle(
                                                            color: AppColors
                                                                .hinttext,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15)),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: PopupMenuButton<int>(
                                                  color: AppColors.white,
                                                  icon: Icon(
                                                    Icons.more_vert_outlined,
                                                    color: AppColors.hinttext,
                                                  ),
                                                  onSelected: (value) {
                                                    if (value == 0) {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Editdetails(
                                                            employee:
                                                                userprofilelist[
                                                                    index],
                                                            index: index,
                                                          ),
                                                        ),
                                                      );
                                                    } else if (value == 1) {
                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              context) {
                                                            return commonLogOutDialog(
                                                              title:
                                                                  'Delete Employee',
                                                              iconColor:
                                                                  AppColors.red,
                                                              deleteButtonColor:
                                                                  AppColors.red,
                                                              subTitle:
                                                                  'Are you sure you want to delete this employee?',
                                                              confirmText:
                                                                  'Delete',
                                                              cancelText:
                                                                  'Cancel',
                                                              icon: Icons
                                                                  .warning_amber_rounded,
                                                              cancelOnPressed:
                                                                  () {
                                                                Get.back();
                                                              },
                                                              logOutOnPressed:
                                                                  () {
                                                                deleteEmployee(
                                                                    index);
                                                                Get.back();
                                                              },
                                                            );
                                                          });
                                                      // showDeleteEmployeeDialog(
                                                      //     index);
                                                      // deleteEmployee(index);
                                                    } /*else if (value == 2) {}*/
                                                  },
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                      value: 0,
                                                      child: editPopUp(
                                                          icon: Icons.edit,
                                                          label: 'Edit'),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 1,
                                                      child: editPopUp(
                                                          icon: Icons.delete,
                                                          label: 'Delete'),
                                                    ),

                                                    /*  PopupMenuItem(
                                                value: 2,
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.cancel,
                                                        color: Colors.grey),
                                                    8.width,
                                                    Text(
                                                      'Cancel',
                                                      style: style(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors.black
                                                              .withOpacity(
                                                                  0.4)),
                                                    ),
                                                  ],
                                                ),
                                              ),*/
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                              height: 0, color: Colors.grey),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
                      20.height,
                    ],
                  ),
                ),
        ),
        floatingActionButton: commonFloatingBtn(
          onPressed: () async {
            log('country:${employeeFormController.countryController.value.text}');
            log('state:${employeeFormController.stateController.value.text}');
            log('city:${employeeFormController.cityController.value.text}');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Emoployeeform(
                    label: 'admin',
                  ),
                ));
          },
        ));
  }
}
