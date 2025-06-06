import 'dart:convert';
import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:employeeform/model/eprofilemodel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttandanceAdminConroller extends GetxController {
  RxList<UserProfile> userProfileList = <UserProfile>[].obs;

  String getCurrentDate() {
    DateTime now = DateTime.now();
    return formatDate(now, [dd, '-', mm, '-', yyyy]);
  }

  void onInit() {
    log("AttandanceAdminConroller onInit triggered");
    attendanceData();
    super.onInit();
  }

  void attendanceData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Employee data
    String? employeeDataJson = prefs.getString('employeeData');
    log("employeeDataJson==>>1: $employeeDataJson");

    if (employeeDataJson != null) {
      List<dynamic> employeeData = jsonDecode(employeeDataJson);
      userProfileList.value =
          employeeData.map((item) => UserProfile.fromMap(item)).toList();
    }

    // Load Attendance status
    String? attendanceStatusJson =
        prefs.getString('attendanceStatus_${getCurrentDate()}');
    log('attendanceStatusJson:${attendanceStatusJson}');
    if (attendanceStatusJson != null) {
      Map<String, dynamic> savedAttendanceStatus =
          jsonDecode(attendanceStatusJson);

      for (var user in userProfileList) {
        String fullName =
            '${user.firstName} ${user.middleName ?? ''} ${user.lastName ?? ''}'
                .trim()
                .toLowerCase(); // Convert to lowercase for consistency

        savedAttendanceStatus.forEach((key, value) {
          String formattedKey =
              key.trim().toLowerCase(); // Trim and normalize the key
          if (formattedKey == fullName) {
            user.attendance = value;
          }
        });

        log('userAttandence:${user.attendance}');
      }
    }
    userProfileList.refresh();
  }

  void attandanceSave() async {
    List<Map<String, dynamic>> employeeListData = [];
    Map<String, dynamic> attendanceStatusToSave = {};
    String currentDate = getCurrentDate();

    for (var user in userProfileList) {
      employeeListData.add(user.toMap());
      String fullName = '${user.firstName} ${user.middleName}';
      attendanceStatusToSave[fullName] = user.attendance;
    }
    log("EMP DATA CORE: $employeeListData");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('employeeData', jsonEncode(employeeListData));

    await prefs.setString(
        'attendanceStatus_$currentDate', jsonEncode(attendanceStatusToSave));

    String? storedAttendanceStatus =
        prefs.getString('attendanceStatus_$currentDate');
    if (storedAttendanceStatus != null) {
      log("Stored Attendance Status for date $currentDate: $storedAttendanceStatus");
    } else {
      log("No attendance status found for date: $currentDate");
    }
    userProfileList.refresh();
    update();
    Fluttertoast.showToast(msg: "Attendance submitted successfully!");
  }

  void attandanceSwitch(bool val, int i) {
    userProfileList[i].attendance = val;
    update();
  }
}
