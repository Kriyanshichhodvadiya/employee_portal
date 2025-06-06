import 'dart:convert';
import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/comman_widget.dart';

class ReportAttandanceController extends GetxController {
  RxString selectedDate = ''.obs;

  var attendanceData = Rxn<Map<String, dynamic>>();

  // @override
  // void onInit() {
  //   super.onInit();
  //   final currentDate = DateTime.now();
  //   selectedDate.value = formatDate(currentDate, [dd, '-', mm, '-', yyyy]);
  //   fetchAttendanceData(selectedDate.value);
  // }

  void fetchAttendanceData(String date) async {
    final prefs = await SharedPreferences.getInstance();
    String? storedAttendanceStatus = prefs.getString('attendanceStatus_$date');

    if (storedAttendanceStatus != null) {
      attendanceData.value = jsonDecode(storedAttendanceStatus);
    } else {
      attendanceData.value = null;
      attendanceData.value = {};
      log("No attendance data found for date: $date");
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) => commonThemeBuilder(context, child),
    );

    if (pickedDate != null) {
      String formattedDate = formatDate(pickedDate, [dd, '-', mm, '-', yyyy]);
      selectedDate.value = formattedDate;
      fetchAttendanceData(formattedDate);
    }
  }
}
