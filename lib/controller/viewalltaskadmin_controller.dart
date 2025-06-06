import 'dart:convert';
import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/comman_widget.dart';

class ViewAllTaskAdminController extends GetxController {
  RxString bgroup = commonString.radioBtnPending.obs;
  // RxString selectedDate =
  //     formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]).obs;
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;
  RxString selectedEmployee = 'All'.obs;
  RxList<TaskModel> taskList = <TaskModel>[].obs;
  RxList<TaskModel> filteredTaskList = <TaskModel>[].obs;
  RxList<String> employeeNames = <String>[].obs;
  RxMap<String, String> employeeNamesWithId = <String, String>{}.obs;
  RxMap<String, String> employeeLastNamesWithId = <String, String>{}.obs;

  String startDateFor(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "N/A"; // Handle null cases
    List<String> parts = dateTime.split(' ');
    return parts.isNotEmpty ? parts[0] : "N/A"; // Extract Date: '24-03-2025'
  }

  String startTimeFor(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "N/A"; // Handle null cases
    List<String> parts = dateTime.split(' ');
    return parts.length >= 3
        ? "${parts[1]} ${parts[2]}"
        : "N/A"; // Extract Time: '11:22:19 AM'
  }

  Future<void> allTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeDataString = prefs.getString('employeeData');

    if (employeeDataString != null) {
      List<dynamic> employeeList = jsonDecode(employeeDataString);
      List<TaskModel> tasks = [];

      Map<String, String> uniqueNames = {"All": "All"};
      Map<String, String> uniqueLastNames = {"All": "All"};

      for (var employee in employeeList) {
        String employeeName = employee['firstName'] ?? '';
        String employeeLastName = employee['lastName'] ?? '';
        String employeeId = employee['srNo'] ?? '';

        log('employeeLastName ==> $employeeLastName');

        if (employeeName.isNotEmpty &&
            employeeLastName.isNotEmpty &&
            employeeId.isNotEmpty) {
          uniqueNames[employeeId] = employeeName;
          uniqueLastNames[employeeId] = employeeLastName;
        }

        if (employee['taskRequests'] != null) {
          List<dynamic> taskRequests = employee['taskRequests'];
          for (var task in taskRequests) {
            TaskModel taskModel = TaskModel(
              employeeName: employeeName,
              employeeLastName: employeeLastName,
              srNo: employee['srNo'] ?? '',
              task: task['task'] ?? '',
              date: task['date'] ?? '',
              appliedTime: task['appliedTime'] ?? '',
              startTime: task['startTime'] ?? '',
              finishTime: task['finishTime'] ?? '',
              holdTime: task['holdTime'] ?? '',
              reasonForHold: task['reasonForHold'] ?? '',
              status: task['status'] ?? 'Pending',
            );
            tasks.add(taskModel);
          }
        }
      }

      // Sort tasks by appliedTime (newest first)
      tasks.sort((a, b) => b.appliedTime.compareTo(a.appliedTime));

      taskList.value = tasks;
      employeeNamesWithId.value = uniqueNames;
      employeeLastNamesWithId.value = uniqueLastNames;

      filterTasks(); // Refresh filtered task list
    }
  }

  void filterTasks() {
    log("taskList ==>> $taskList");

    filteredTaskList.value = taskList.where((task) {
      log('filteredTaskList == ${task.date}');
      log('startTime == ${task.startTime}');
      log('finishTime == ${task.finishTime}');
      log('holdTime == ${task.holdTime}');

      // Handle date range filter
      bool matchesDate = true;
      if (selectedFromDate.value.isNotEmpty &&
          selectedToDate.value.isNotEmpty) {
        try {
          final fromParts = selectedFromDate.value.split('-');
          final toParts = selectedToDate.value.split('-');
          final taskParts = task.date.split('-');

          final fromDate = DateTime(
            int.parse(fromParts[2]),
            int.parse(fromParts[1]),
            int.parse(fromParts[0]),
          );
          final toDate = DateTime(
            int.parse(toParts[2]),
            int.parse(toParts[1]),
            int.parse(toParts[0]),
          );
          final taskDate = DateTime(
            int.parse(taskParts[2]),
            int.parse(taskParts[1]),
            int.parse(taskParts[0]),
          );

          matchesDate = taskDate.isAtSameMomentAs(fromDate) ||
              taskDate.isAtSameMomentAs(toDate) ||
              (taskDate.isAfter(fromDate) && taskDate.isBefore(toDate));
        } catch (e) {
          log("Date parsing error: $e");
          matchesDate = false;
        }
      } else if (selectedFromDate.value.isNotEmpty) {
        matchesDate = task.date == selectedFromDate.value;
      }

      final matchesEmployee = selectedEmployee.value == "All" ||
          task.employeeName == selectedEmployee.value;

      switch (bgroup.value) {
        case commonString.radioBtnStart:
          return matchesDate &&
              matchesEmployee &&
              task.status == commonString.radioBtnStart;

        case commonString.radioBtnPending:
          return matchesDate &&
              matchesEmployee &&
              (task.startTime?.isEmpty ?? true);

        case commonString.radioBtnHold:
          return matchesDate &&
              matchesEmployee &&
              task.status == commonString.radioBtnHold;

        case commonString.radioBtnFinish:
          return matchesDate &&
              matchesEmployee &&
              task.status == commonString.radioBtnFinish;

        default:
          return matchesDate && matchesEmployee;
      }
    }).toList();
  }

  /*
  Future<void> allTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeDataString = prefs.getString('employeeData');

    if (employeeDataString != null) {
      List<dynamic> employeeList = jsonDecode(employeeDataString);
      List<TaskModel> tasks = [];
      Map<String, String> uniqueNames = {"All": "All"};
      // Map<String, String> uniqueLastNames = {"All": "All"};

      for (var employee in employeeList) {
        String employeeName = employee['firstName'] ?? '';
        String employeeLastName = employee['lastName'] ?? '';
        String employeeId = employee['srNo'] ?? '';
        log('employeeLastName==>${employeeLastName}');
        if (employeeName.isNotEmpty &&
            employeeId.isNotEmpty &&
            employeeLastName.isNotEmpty) {
          uniqueNames[employeeId] = employeeName;
          // uniqueLastNames[employeeId] = employeeLastName;
        }

        if (employee['taskRequests'] != null) {
          List<dynamic> taskRequests = employee['taskRequests'];
          for (var task in taskRequests) {
            TaskModel taskModel = TaskModel(
                employeeName: employeeName,
                employeeLastName: ,
                srNo: employee['srNo'] ?? '',
                task: task['task'] ?? '',
                date: task['date'] ?? '',
                appliedTime: task['appliedTime'] ?? '',
                startTime: task['startTime'] ?? '',
                finishTime: task['finishTime'] ?? '',
                holdTime: task['holdTime'] ?? '',
                reasonForHold: task['reasonForHold'] ?? '',
                status: task['status'] ?? 'Pending');
            tasks.add(taskModel);
          }
        }
      }

      // Sort tasks based on appliedTime in descending order (newest first)
      tasks.sort((a, b) => b.appliedTime.compareTo(a.appliedTime));

      taskList.value = tasks;
      employeeNamesWithId.value = uniqueNames;
      // employeeLastNamesWithId.value = uniqueLastNames;

      filterTasks(); // Refresh filtered tasks
    }
  }

  void filterTasks() {
    log("taskList==>>$taskList");

    filteredTaskList.value = taskList.where((task) {
      log('filteredTaskList==${task.date}');
      log('startTime==${task.startTime}');
      log('finishTime==${task.finishTime}');
      log('holdTime==${task.holdTime}');

      // Handle date range filter
      bool matchesDate = true;
      if (selectedFromDate.value.isNotEmpty &&
          selectedToDate.value.isNotEmpty) {
        try {
          final fromParts = selectedFromDate.value.split('-');
          final toParts = selectedToDate.value.split('-');
          final taskParts = task.date.split('-');

          final fromDate = DateTime(
            int.parse(fromParts[2]),
            int.parse(fromParts[1]),
            int.parse(fromParts[0]),
          );
          final toDate = DateTime(
            int.parse(toParts[2]),
            int.parse(toParts[1]),
            int.parse(toParts[0]),
          );
          final taskDate = DateTime(
            int.parse(taskParts[2]),
            int.parse(taskParts[1]),
            int.parse(taskParts[0]),
          );

          matchesDate = taskDate.isAtSameMomentAs(fromDate) ||
              taskDate.isAtSameMomentAs(toDate) ||
              (taskDate.isAfter(fromDate) && taskDate.isBefore(toDate));
        } catch (e) {
          log("Date parsing error: $e");
          matchesDate = false;
        }
      } else if (selectedFromDate.value.isNotEmpty) {
        matchesDate = task.date == selectedFromDate.value;
      }

      final matchesEmployee = selectedEmployee.value == "All" ||
          task.employeeName == selectedEmployee.value;

      switch (bgroup.value) {
        case commonString.radioBtnStart:
          return matchesDate &&
              matchesEmployee &&
              task.status == commonString.radioBtnStart;

        case commonString.radioBtnPending:
          return matchesDate &&
              matchesEmployee &&
              (task.startTime?.isEmpty ?? true);

        case commonString.radioBtnHold:
          return matchesDate &&
              matchesEmployee &&
              task.status == commonString.radioBtnHold;

        case commonString.radioBtnFinish:
          return matchesDate &&
              matchesEmployee &&
              task.status == commonString.radioBtnFinish;

        default:
          return matchesDate && matchesEmployee;
      }
    }).toList();
  }
*/

  Future<void> selectDate(BuildContext context,
      {required bool selectFrom}) async {
    DateTime initial = DateTime.now();
    DateTime first = DateTime(2000);

    if (!selectFrom && selectedFromDate.value.isNotEmpty) {
      List<String> parts = selectedFromDate.value.split('-');
      first = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );

      if (initial.isBefore(first)) {
        initial = first;
      }
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime(2100),
      builder: (context, child) => commonThemeBuilder(context, child),
    );

    if (pickedDate != null) {
      final formattedDate = formatDate(pickedDate, [dd, '-', mm, '-', yyyy]);

      if (selectFrom) {
        selectedFromDate.value = formattedDate;
        filterTasks();
      } else {
        selectedToDate.value = formattedDate;
        filterTasks();
      }
    }
  }

  /* Future<void> selectDate(BuildContext context, {required selectFrom}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => commonThemeBuilder(context, child),
    );

    if (pickedDate != null) {
      if (selectFrom == true) {
        selectedFromDate.value =
            formatDate(pickedDate, [dd, '-', mm, '-', yyyy]);
        filterTasks();
      } else {
        selectedFromDate.value =
            formatDate(pickedDate, [dd, '-', mm, '-', yyyy]);
      }
    }
  }*/

  void deleteTask(TaskModel task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeDataString = prefs.getString('employeeData');

    if (employeeDataString != null) {
      List<dynamic> employeeList = jsonDecode(employeeDataString);

      for (var employee in employeeList) {
        if (employee['srNo'] == task.srNo && employee['taskRequests'] != null) {
          // Remove the task from taskRequests list
          List<dynamic> taskRequests = employee['taskRequests'];
          taskRequests.removeWhere((t) =>
              t['task'] == task.task &&
              t['date'] == task.date &&
              t['appliedTime'] == task.appliedTime);

          // Update the employee's taskRequests
          employee['taskRequests'] = taskRequests;
          break; // No need to continue once task is removed
        }
      }

      // Save the updated employee data back to SharedPreferences
      await prefs.setString('employeeData', jsonEncode(employeeList));

      // Update the taskList and filteredTaskList in GetX
      allTasks(); // Refresh task data from SharedPreferences

      primaryToast(msg: "The task has been successfully deleted.");
    }
  }
}
