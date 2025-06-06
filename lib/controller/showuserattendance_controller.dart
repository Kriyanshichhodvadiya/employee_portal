import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/color.dart';

class ShowUserAttandanceController extends GetxController {
  RxList<Map<String, dynamic>> userList =
      <Map<String, dynamic>>[].obs; // Stores all added users.
  RxList<Map<String, dynamic>> attendanceList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredAttendanceList =
      <Map<String, dynamic>>[].obs; // Stores all attendance data.Rx

  Rx<DateTime?> selectedDate = DateTime.now().obs;
  @override
  void onInit() {
    userData();
    attendanceData();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> userData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataJson = prefs.getString('employeeData');

    if (userDataJson != null) {
      List<dynamic> decodedList = json.decode(userDataJson);

      userList.value =
          decodedList.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }

    log("User List: ${userList}");
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

    attendanceList.value = fetchedAttendance;
    update();
    log("Attendance List: ${attendanceList}");
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primarycolor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primarycolor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      log("selectedDate : ${selectedDate.value}");
      attendanceDate();
      update();
    }
  }

  void attendanceDate() {
    if (selectedDate.value != null && attendanceList.isNotEmpty) {
      String formattedDate =
          "${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}";

      filteredAttendanceList.value = attendanceList.where((attendance) {
        return attendance['date'] == formattedDate;
      }).toList();

      log("Filtered Attendance List: ${filteredAttendanceList}");
      update();
    }
  }

  // void attendanceDate() {
  //   if (selectedDate.value != null && userList.isNotEmpty) {
  //     String formattedDate =
  //         "${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}";
  //
  //     // Create a list to store attendance for all users based on the selected date
  //     List<Map<String, dynamic>> updatedAttendanceList = [];
  //
  //     for (var user in userList) {
  //       // Filter attendance data for the selected user and date
  //       var userAttendance = attendanceList.firstWhere(
  //             (attendance) =>
  //         attendance['srNo'] == user['srNo'] &&
  //             attendance['date'] == formattedDate,
  //         orElse: () => {},
  //       );
  //
  //       // Add the attendance record or default values to the list
  //       updatedAttendanceList.add({
  //         'srNo': user['srNo'],
  //         'firstName': user['firstName'],
  //         'in': userAttendance != null ? userAttendance['in'] : '-',
  //         'out': userAttendance != null ? userAttendance['out'] : '-',
  //       });
  //     }
  //
  //     // Update the filtered attendance list
  //     filteredAttendanceList.value = updatedAttendanceList;
  //
  //     log("Filtered Attendance List for selected date $formattedDate: ${filteredAttendanceList}");
  //   }
  // }

/*  void attendanceDate() {
    if (selectedDate.value != null && userList.isNotEmpty) {
      String formattedDate =
          "${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}";

      // Create a list to store attendance for all users
      List<Map<String, dynamic>> updatedAttendanceList = [];

      for (var user in userList) {
        // Check if the user has attendance data for the selected date
        var userAttendance = attendanceList.firstWhere(
          (attendance) =>
              attendance['srNo'] == user['srNo'] &&
              attendance['date'] == formattedDate,
          orElse: () => {'in': '-', 'out': '-'},
        );

        // Add the attendance record or default values to the list
        updatedAttendanceList.add({
          'srNo': user['srNo'],
          'firstName': user['firstName'],
          'in': userAttendance['in'],
          'out': userAttendance['out'],
        });
      }

      // Update the filtered attendance list
      filteredAttendanceList.value = updatedAttendanceList;

      log("Filtered Attendance List for date $formattedDate: ${filteredAttendanceList}");
    }
  }*/
}
