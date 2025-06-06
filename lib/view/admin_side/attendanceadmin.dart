import 'dart:developer';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/attandanceadmin_controller.dart';

class AttendanceAdminPage extends StatefulWidget {
  AttendanceAdminPage({super.key});

  @override
  State<AttendanceAdminPage> createState() => _AttendanceAdminPageState();
}

class _AttendanceAdminPageState extends State<AttendanceAdminPage> {
  AttandanceAdminConroller controller = Get.put(AttandanceAdminConroller());
  @override
  // void initState() {
  //   super.initState();
  //   log("controller onInit triggered");
  //   controller.attendanceData();
  //   // TODO: implement initState
  // }

  // String getCurrentDate() {
  @override
  Widget build(BuildContext context) {
    log("emp : ${controller.userProfileList}");
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBar(
          onTap: () {
            Get.back();
          },
          title: 'Attendance'),
      /*  AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        shadowColor: AppColors.black.withOpacity(0.5),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Attendance",
          style: poppinsStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
      ),*/
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Date: ",
                    style: poppinsStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.hinttext,
                    ),
                  ),
                  TextSpan(
                    text: "${controller.getCurrentDate()}",
                    style: poppinsStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: AppColors.hinttext,
                    ),
                  ),
                ],
              ),
            ),
          ),
          8.height,
          Expanded(
            child: Obx(
              () => controller.userProfileList.isEmpty
                  ? commonLottie()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        width: double.maxFinite,
                        decoration: commonDecoration(),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: attendanceTableLabel(
                                    label: 'No.',
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: attendanceTableLabel(
                                    label: 'Name',
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: attendanceTableLabel(
                                    label: 'Attendance',
                                  ),
                                ),
                              ],
                            ),
                            commonDivider(),
                            Expanded(
                              child: ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.userProfileList.length,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: 15.horizontal,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            '${i + 1}',
                                            style: poppinsStyle(
                                              color: AppColors.hinttext,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            '${controller.userProfileList[i].firstName ?? 'N/A'} ${controller.userProfileList[i].middleName ?? ''}',
                                            style: poppinsStyle(
                                              color: AppColors.hinttext,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Transform.scale(
                                            scale: 0.8,
                                            child: GetBuilder<
                                                    AttandanceAdminConroller>(
                                                builder: (controller) {
                                              log('userProfileList[i].attendance${controller.userProfileList[i].attendance}');

                                              return Switch(
                                                value: controller
                                                    .userProfileList[i]
                                                    .attendance,
                                                onChanged: (value) {
                                                  controller.attandanceSwitch(
                                                      value, i);
                                                },
                                                activeColor:
                                                    AppColors.primarycolor,
                                                inactiveTrackColor: Colors.grey,
                                              );
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    Divider(height: 0, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          Obx(
            () => controller.userProfileList.isNotEmpty
                ? Padding(
                    padding: 15.symmetric,
                    child: primarybutton(
                      text: "Save",
                      onPressed: () {
                        controller.attandanceSave();
                      },
                    ),
                  )
                : Text(""),
          )
        ],
      ),
    );
  }
}

Widget attendanceTableLabel({required label}) {
  return Padding(
    padding: const EdgeInsets.only(top: 7.0, bottom: 7, left: 10),
    child: Text(
      label,
      style: poppinsStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    ),
  );
}
