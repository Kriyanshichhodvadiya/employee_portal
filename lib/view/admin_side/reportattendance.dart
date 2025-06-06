import 'package:date_format/date_format.dart';
import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/controller/reportattandance_controller.dart';
import 'package:employeeform/view/userattendance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/global_widget.dart';
import '../dashboard/admindashboard.dart';
import '../user/attendance.dart';

class AttendanceReportPage extends StatefulWidget {
  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  ReportAttandanceController reportAttandanceController =
      Get.put(ReportAttandanceController());

  @override
  void initState() {
    super.initState();
    final currentDate = DateTime.now();
    reportAttandanceController.selectedDate.value =
        formatDate(currentDate, [dd, '-', mm, '-', yyyy]);
    // Fetch attendance data after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reportAttandanceController
          .fetchAttendanceData(reportAttandanceController.selectedDate.value);
    });
    // reportAttandanceController.fetchAttendanceData(reportAttandanceController
    //     .selectedDate.value); // Fetch attendance data for the current date
  }

  // String selectedDate = '';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(
          () => Admindashboard(),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: appBar(
            showBack: false,
            onTap: () {
              Get.off(
                () => Admindashboard(),
              );
            },
            title: 'Attendance Reports'),

        /*  AppBar(
          leading: GestureDetector(
              onTap: () {
                Get.to(Admindashboard());
              },
              child: const Icon(Icons.arrow_back_ios)),
          shadowColor: AppColors.black.withOpacity(0.5),
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Attendance Reports",
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
            Padding(
              padding: 15.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  15.height,
                  selectDateLabel(label: 'Select Date'),
                  5.height,
                  Obx(
                    () => commonDateCon(
                      label:
                          reportAttandanceController.selectedDate.value.isEmpty
                              ? 'Select Date'
                              : reportAttandanceController.selectedDate.value,
                      onTap: () {
                        reportAttandanceController.selectDate(context);
                      },
                    ),
                  ),
                  10.height,
                ],
              ),
            ),
            Obx(() {
              if (reportAttandanceController.attendanceData.value == null) {
                return Expanded(
                  child: Center(
                    child: Padding(
                      padding: 15.symmetric,
                      child: Text(
                          'No attendance data found for ${reportAttandanceController.selectedDate.value}.'),
                    ),
                  ),
                );
              }
              if (reportAttandanceController.attendanceData.value!.isEmpty) {
                return Expanded(child: commonLottie());
              }

              return Container(
                width: double.maxFinite,
                margin: 15.symmetric,
                decoration: commonDecoration(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: attendanceTableLabel(
                            label: 'No.',
                          ),
                        ),
                        Expanded(
                          flex: 2,
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
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1), // Matches flex: 1 in Row
                          1: FlexColumnWidth(2), // Matches flex: 2 in Row
                          2: FlexColumnWidth(3), // Matches flex: 3 in Row
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          for (int i = 0;
                              i <
                                  reportAttandanceController
                                      .attendanceData.value!.length;
                              i++) ...[
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Text('${i + 1}',
                                      style: poppinsStyle(
                                        color: AppColors.hinttext,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                                Padding(
                                  padding: 15.horizontal,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          () => Userattendance(
                                                userName:
                                                    reportAttandanceController
                                                        .attendanceData
                                                        .value!
                                                        .keys
                                                        .elementAt(i),
                                              ),
                                          transition: Transition.noTransition,
                                          duration:
                                              Duration(milliseconds: 300));
                                      // Get.to(()=>Userattendance(),arguments: {
                                      //   'userName':reportAttandanceController
                                      //       .attendanceData.value!.keys
                                      //       .elementAt(i),
                                      // });
                                    },
                                    child: Text(
                                        reportAttandanceController
                                            .attendanceData.value!.keys
                                            .elementAt(i),
                                        style: poppinsStyle(
                                          color: AppColors.hinttext,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: 15.horizontal,
                                  child: Center(
                                    child: Text(
                                      reportAttandanceController
                                              .attendanceData.value!.values
                                              .elementAt(i)
                                          ? 'Present'
                                          : 'Absent',
                                      style: poppinsStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: reportAttandanceController
                                                .attendanceData.value!.values
                                                .elementAt(i)
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (i <
                                reportAttandanceController
                                        .attendanceData.value!.length -
                                    1)
                              const TableRow(
                                children: [
                                  Divider(height: 0, color: Colors.grey),
                                  Divider(height: 0, color: Colors.grey),
                                  Divider(height: 0, color: Colors.grey),
                                ],
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),

        /*   body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Date',
                  style: style(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  )),
              10.height,
              GestureDetector(
                onTap: () => reportAttandanceController.selectDate(context),
                child: Container(
                  height: 45,
                  padding: 10.horizontal,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            reportAttandanceController.selectedDate.value.isEmpty
                                ? 'Select Date'
                                : reportAttandanceController.selectedDate.value,
                            style: poppinsStyle(
                              fontSize: 16,
                              color: reportAttandanceController
                                      .selectedDate.value.isEmpty
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          )),
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.primarycolor,
                      ),
                    ],
                  ),
                ),
              ),
              20.height,
              if (reportAttandanceController.attendanceData.value != null) ...[
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      columnWidths: const {
                        0: FixedColumnWidth(60),
                        1: FlexColumnWidth(),
                        2: FixedColumnWidth(130),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'No.',
                                style: style(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Name',
                                style: style(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Padding(
                              padding: 15.symmetric,
                              child: Text(
                                'Attendance',
                                style: style(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (int i = 0;
                            i <
                                reportAttandanceController
                                    .attendanceData.value!.length;
                            i++) ...[
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Text('${i + 1}',
                                    style: style(
                                      color: AppColors.hinttext,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              Padding(
                                padding: 15.horizontal,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Userattendance(
                                            userName: reportAttandanceController
                                                .attendanceData.value!.keys
                                                .elementAt(i),
                                          ),
                                        ));
                                  },
                                  child: Text(
                                      reportAttandanceController
                                          .attendanceData.value!.keys
                                          .elementAt(i),
                                      style: style(
                                        color: AppColors.hinttext,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              ),
                              Padding(
                                padding: 30.horizontal,
                                child: Text(
                                  reportAttandanceController
                                          .attendanceData.value!.values
                                          .elementAt(i)
                                      ? 'Present'
                                      : 'Absent',
                                  style: poppinsStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: reportAttandanceController
                                            .attendanceData.value!.values
                                            .elementAt(i)
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (i <
                              reportAttandanceController
                                      .attendanceData.value!.length -
                                  1)
                            const TableRow(
                              children: [
                                Divider(height: 0, color: Colors.grey),
                                Divider(height: 0, color: Colors.grey),
                                Divider(height: 0, color: Colors.grey),
                              ],
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ] else if (reportAttandanceController
                  .selectedDate.value.isNotEmpty) ...[
                Text(
                    'No attendance data found for ${reportAttandanceController.selectedDate.value}.'),
              ],
            ],
          ),
        ),*/
      ),
    );
  }
}
