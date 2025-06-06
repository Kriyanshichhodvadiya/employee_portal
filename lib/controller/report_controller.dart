import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/comman_widget.dart';

class ReportController extends GetxController {
  RxList<Map<String, dynamic>> taskList =
      <Map<String, dynamic>>[].obs; // All tasks
  RxList<Map<String, dynamic>> tasksdata =
      <Map<String, dynamic>>[].obs; // Filtered tasks
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;

  String? currentEmployeeName; // Track the currently selected employee

  Future<void> employeeTasks({required String employeeName}) async {
    currentEmployeeName = employeeName; // Set the current employee
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedTasks = prefs.getStringList('taskList') ?? [];
    taskList.value = storedTasks
        .map((taskData) => jsonDecode(taskData) as Map<String, dynamic>)
        .toList();

    // Filter tasks for the selected employee
    tasksdata.value = taskList
        .where((task) =>
            task['employeeName'] != null &&
            task['employeeName'] == employeeName)
        .toList();
  }

  Future<void> selectFromDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: selectedToDate.value.isNotEmpty
          ? DateTime.parse(selectedToDate.value.split('/').reversed.join('-'))
          : DateTime(2101),
      builder: (context, child) => commonThemeBuilder(context, child),
    );
    if (pickedDate != null) {
      String formattedDate = formatDate(pickedDate, [dd, '/', mm, '/', yyyy]);
      selectedFromDate.value = formattedDate;
      selectTasksDate();
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    if (selectedFromDate.value.isEmpty) {
      primaryToast(msg: 'Please select a From Date first.');
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a From Date first.')),
      );*/
      return;
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate:
          DateTime.parse(selectedFromDate.value.split('/').reversed.join('-')),
      lastDate: DateTime(2101),
      builder: (context, child) => commonThemeBuilder(context, child),
    );

    if (pickedDate != null) {
      String formattedDate = formatDate(pickedDate, [dd, '/', mm, '/', yyyy]);
      selectedToDate.value = formattedDate;
      selectTasksDate();
    }
  }

  void selectTasksDate() {
    if (selectedFromDate.value.isNotEmpty && selectedToDate.value.isNotEmpty) {
      DateTime fromDate = DateTime.parse(selectedFromDate.value
          .split('/')
          .reversed
          .join('-')); // Convert dd/MM/yyyy to yyyy-MM-dd
      DateTime toDate = DateTime.parse(selectedToDate.value
          .split('/')
          .reversed
          .join('-')); // Convert dd/MM/yyyy to yyyy-MM-dd

      // Filter tasks for the selected employee and date range
      tasksdata.value = taskList.where((task) {
        if (task['date'] != null &&
            task['employeeName'] == currentEmployeeName) {
          // Ensure filtering by employee
          DateTime taskDate =
              DateTime.parse(task['date'].split('/').reversed.join('-'));
          return taskDate.isAfter(fromDate.subtract(const Duration(days: 1))) &&
              taskDate.isBefore(toDate.add(const Duration(days: 1)));
        }
        return false;
      }).toList();
    }
  }
}

// import 'dart:convert';

// import 'package:date_format/date_format.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../config/color.dart';

// class ReportController extends GetxController {
//   RxList<Map<String, dynamic>> taskList = <Map<String, dynamic>>[].obs;
//   RxList<Map<String, dynamic>> tasksdata = <Map<String, dynamic>>[].obs;
//   RxString selectedFromDate = ''.obs;
//   RxString selectedToDate = ''.obs;

//   Future<void> employeeTasks({required employeeName}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> storedTasks = prefs.getStringList('taskList') ?? [];
//     // taskList.clear();
//     taskList.value = storedTasks
//         .map((taskData) => jsonDecode(taskData) as Map<String, dynamic>)
//         .toList();

//     tasksdata.value = taskList
//         .where((task) =>
//             task['employeeName'] != null &&
//             task['employeeName'] == employeeName)
//         .toList();
//   }

//   Future<void> selectFromDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: selectedToDate.value.isNotEmpty
//           ? DateTime.parse(selectedToDate.value.split('/').reversed.join('-'))
//           : DateTime(2101),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppColors.primarycolor,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: AppColors.primarycolor,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (pickedDate != null) {
//       String formattedDate = formatDate(pickedDate, [dd, '/', mm, '/', yyyy]);
//       selectedFromDate.value = formattedDate;
//       selectTasksDate();
//     }
//   }

//   Future<void> selectToDate(BuildContext context) async {
//     if (selectedFromDate.value.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select a From Date first.')),
//       );
//       return;
//     }

//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate:
//           DateTime.parse(selectedFromDate.value.split('/').reversed.join('-')),
//       lastDate: DateTime(2101),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppColors.primarycolor,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style: TextButton.styleFrom(
//                 foregroundColor: AppColors.primarycolor,
//               ),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (pickedDate != null) {
//       String formattedDate = formatDate(pickedDate, [dd, '/', mm, '/', yyyy]);
//       selectedToDate.value = formattedDate;
//       selectTasksDate();
//     }
//   }

//   void selectTasksDate() {
//     if (selectedFromDate.value.isNotEmpty && selectedToDate.value.isNotEmpty) {
//       DateTime fromDate = DateTime.parse(selectedFromDate.value
//           .split('/')
//           .reversed
//           .join('-')); // Convert dd/MM/yyyy to yyyy-MM-dd
//       DateTime toDate = DateTime.parse(selectedToDate
//           .split('/')
//           .reversed
//           .join('-')); // Convert dd/MM/yyyy to yyyy-MM-dd

//       tasksdata.value = taskList.where((task) {
//         if (task['date'] != null) {
//           DateTime taskDate =
//               DateTime.parse(task['date'].split('/').reversed.join('-'));
//           return taskDate.isAfter(fromDate.subtract(const Duration(days: 1))) &&
//               taskDate.isBefore(toDate.add(const Duration(days: 1)));
//         }
//         return false;
//       }).toList();
//     }
//   }
// }
