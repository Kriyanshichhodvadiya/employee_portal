import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:employeeform/common/attendanceusercommon.dart';
import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/controller/showuserattendance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/global_widget.dart';
import '../user/attendance.dart';

class ShowUserAttendance extends StatefulWidget {
  const ShowUserAttendance({super.key});

  @override
  State<ShowUserAttendance> createState() => _ShowUserAttendanceState();
}

class _ShowUserAttendanceState extends State<ShowUserAttendance> {
  ShowUserAttandanceController controller =
      Get.put(ShowUserAttandanceController());
  // List<Map<String, dynamic>> userList = []; // Stores all added users.
  // List<Map<String, dynamic>> attendanceList = [];
  // List<Map<String, dynamic>> filteredAttendanceList =
  //     []; // Stores all attendance data.
  // DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    /* controller.selectedDate.value = DateTime.now();
    controller.userData();
    controller.attendanceData();*/
  }

  /* Future<void> userData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('employeeData');

    if (userDataJson != null) {
      List<dynamic> decodedList = json.decode(userDataJson);
      setState(() {
        userList = decodedList
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      });
    }

    log("User List: $userList");
  }

  Future<void> attendanceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();

    List<Map<String, dynamic>> fetchedAttendance = [];

    for (String key in keys) {
      if (key.startsWith('attendanceData_')) {
        String? attendanceJson = prefs.getString(key);
        if (attendanceJson != null) {
          List<dynamic> decodedList = json.decode(attendanceJson);
          fetchedAttendance.addAll(
              decodedList.map((e) => Map<String, dynamic>.from(e as Map)));
        }
      }
    }

    setState(() {
      attendanceList = fetchedAttendance;
    });

    log("Attendance List: $attendanceList");
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        attendanceDate();
      });
    }
  }

  void attendanceDate() {
    if (selectedDate != null) {
      String formattedDate =
          "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

      setState(() {
        filteredAttendanceList = attendanceList.where((attendance) {
          return attendance['date'] == formattedDate;
        }).toList();
      });

      log("Filtered Attendance List: $filteredAttendanceList");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBar(
          showBack: false,
          onTap: () {
            Get.back();
          },
          title: 'Attendance'),
      /*AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Admindashboard(),
              ),
            );
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        shadowColor: AppColors.black.withOpacity(0.5),
        surfaceTintColor: AppColors.white,
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
          Padding(
            padding: 10.symmetric,
            child: Row(
              children: [
                // selectDateLabel(label: 'Select Date:'),
                Expanded(
                  child: commonDateConForLeave(
                    label: controller.selectedDate.value == null
                        ? "Select Date"
                        : DateFormat('dd-MM-yyyy')
                            .format(controller.selectedDate.value!),
                    onTap: () {
                      controller.selectDate(context);
                    },
                  ),
                ),
                /*     Expanded(
                  child: Obx(() => Container(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                controller.selectDate(context);
                              },
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                            5.width,
                            Text(
                              controller.selectedDate.value == null
                                  ? "Select Date"
                                  : "${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}",
                              style: poppinsStyle(
                                color: AppColors.primarycolor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),*/
              ],
            ),
          ),
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            width: double.maxFinite,
            decoration: commonDecoration(),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      attendancerow(
                        text: "OnTime IN",
                        color: AppColors.green,
                      ),
                      attendancerow(
                        text: "OnTime OUT",
                        color: AppColors.red,
                      ),
                      attendancerow(
                        text: "Late IN",
                        color: AppColors.blue,
                      ),
                      attendancerow(
                        text: "Early OUT",
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: double.maxFinite,
                  color: Colors.grey.withOpacity(0.6),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: attendanceTableLabel(
                          label: "Name",
                        ),
                      )),
                      Expanded(
                          child: attendanceTableLabel(
                        label: "IN",
                      )),
                      Expanded(
                          child: attendanceTableLabel(
                        label: "OUT",
                      )),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    var filteredUsers = controller.userList.where((user) {
                      var userAttendance = controller.attendanceList.firstWhere(
                        (attendance) =>
                            attendance['srNo'] == user['srNo'] &&
                            attendance['date'] ==
                                "${controller.selectedDate.value?.day}/${controller.selectedDate.value?.month}/${controller.selectedDate.value?.year}",
                        orElse: () => {'in': '-', 'out': '-'},
                      );
                      return userAttendance['in'] != '-' &&
                          userAttendance['in'].toString().trim().isNotEmpty;
                    }).toList();

                    //loader

                    if (filteredUsers.isEmpty) {
                      return commonLottie();
                    }

                    return SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          /*  var user = controller.userList[index];
                          log("user  : $user");

                          var userAttendance =
                              controller.attendanceList.firstWhere(
                            (attendance) =>
                                attendance['srNo'] == user['srNo'] &&
                                attendance['date'] ==
                                    "${controller.selectedDate.value?.day}/${controller.selectedDate.value?.month}/${controller.selectedDate.value?.year}",
                            orElse: () => {'in': '-', 'out': '-'},
                          );
                          log("userAttendance  : $userAttendance");*/

                          var user = filteredUsers[index];
                          log("Filtered user: $user");

                          var userAttendance =
                              controller.attendanceList.firstWhere(
                            (attendance) =>
                                attendance['srNo'] == user['srNo'] &&
                                attendance['date'] ==
                                    "${controller.selectedDate.value?.day}/${controller.selectedDate.value?.month}/${controller.selectedDate.value?.year}",
                            orElse: () => {'in': '-', 'out': '-'},
                          );

                          /*   if (userAttendance['in'] == '-' ||
                              userAttendance['in'].toString().trim().isEmpty) {
                            return SizedBox.shrink(); // Return an empty widget
                          }*/
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              5.height,
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: 30.onlyLeft,
                                      child: Text(
                                        "${user['firstName']} ",
                                        style: poppinsStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${userAttendance['in']}",
                                      style: poppinsStyle(
                                        fontWeight: FontWeight.w400,
                                        color: isBeforeNineAM(
                                                "${userAttendance['in']}")
                                            ? AppColors.green
                                            : AppColors.blue,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${userAttendance['out']}",
                                      style: poppinsStyle(
                                        fontWeight: FontWeight.w400,
                                        color: isBeforeSixPM(
                                                "${userAttendance['out']}")
                                            ? AppColors.red
                                            : Colors.orange,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: AppColors.grey.withOpacity(0.5),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

bool isBeforeNineAM(String inTime) {
  try {
    var timeFormat =
        formatDate(inTime as DateTime, [hh, ':', nn, ':', ss, ' ', am]);

    DateTime parsedTime = DateTime.parse(timeFormat);

    DateTime time = DateTime.now();
    DateTime nineAM = DateTime(time.year, time.month, time.day, 9, 0);

    return parsedTime.isBefore(nineAM);
  } catch (e) {
    print("Error parsing time: $e");
    return false;
  }
}

bool isBeforeSixPM(String outTime) {
  try {
    if (outTime == '-') return false;

    var timeFormat =
        formatDate(outTime as DateTime, [hh, ':', nn, ':', ss, ' ', am]);

    DateTime parsedTime = DateTime.parse(timeFormat);

    DateTime time = DateTime.now();
    DateTime sixPM = DateTime(time.year, time.month, time.day, 18, 0);

    return parsedTime.isBefore(sixPM);
  } catch (e) {
    print("Error parsing time: $e");
    return false;
  }
}

/*bool isBeforeNineAM(String inTime) {
  try {
    DateTime time = DateTime.now();
    DateTime nineAM = DateTime(time.year, time.month, time.day, 9, 0);
    return DateTime.parse(inTime).isBefore(nineAM);
  } catch (e) {
    print("Error parsing time: $e");
    return false;
  }
}

bool isBeforeSixPM(String outTime) {
  try {
    DateTime time = DateTime.now();
    DateTime sixPM = DateTime(time.year, time.month, time.day, 18, 0);
    return DateTime.parse(outTime).isBefore(sixPM);
  } catch (e) {
    print("Error parsing time: $e");
    return false;
  }
}*/
