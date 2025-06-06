import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAttandanceController extends GetxController {
  RxInt totalPresent = 0.obs;
  RxInt totalAbsent = 0.obs;

  RxMap<DateTime, bool> userAttendanceData = RxMap<DateTime, bool>({});

  Future<void> fetchUserAttendanceData({required userName}) async {
    final prefs = await SharedPreferences.getInstance();
    final keys =
        prefs.getKeys().where((key) => key.startsWith('attendanceStatus_'));
    int presentCount = 0;
    int absentCount = 0;
    for (String key in keys) {
      final storedData = prefs.getString(key);
      if (storedData != null) {
        final data = jsonDecode(storedData);
        if (data.containsKey(userName)) {
          final dateString = key.replaceFirst('attendanceStatus_', '');
          final dateParts = dateString.split('-');
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);

          final date = DateTime(year, month, day);
          final isPresent = data[userName] as bool;

          userAttendanceData[date] = data[userName];

          userAttendanceData[date] = isPresent;
          isPresent ? presentCount++ : absentCount++;
        }
      }
    }

    totalPresent.value = presentCount;
    totalAbsent.value = absentCount;
  }

  Color attendanceColor(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    if (userAttendanceData.containsKey(normalizedDay)) {
      return userAttendanceData[normalizedDay]! ? Colors.green : Colors.red;
    }
    return Colors.transparent;
  }
}
