import 'dart:convert';
import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/eprofilemodel.dart';
import '../model/task_model.dart';

class UserViewTaskController extends GetxController {
  // RxMap<String, dynamic> employeeData = <String, dynamic>{}.obs;
  // RxList<Map<String, dynamic>> employeeTasks = <Map<String, dynamic>>[].obs;

  Rx<UserProfile?> employeeData = Rx<UserProfile?>(null);
  RxList<TaskModel> employeeTasks = <TaskModel>[].obs;
  RxString loggedInUserSrNo = ''.obs;
  RxString pickFilter = ''.obs;
  Rx<TextEditingController> holdReasonController = TextEditingController().obs;
  RxString holdReason = ''.obs;
  @override
  void onInit() {
    super.onInit();
    pickFilter.value = formatDate(
        DateTime.now(), [dd, '-', mm, '-', yyyy]); // Default to today
    isUserLoggedIn();
    fetchEmployeeData();
  }

  List<UserProfile> employeeList = [];
  Future<void> fetchEmployeeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');
    String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

    if (employeeListString != null && loggedInUserSrNo != null) {
      List<dynamic> jsonList = jsonDecode(employeeListString);

      // Find logged-in user
      Map<String, dynamic>? loggedInUserJson = jsonList.firstWhere(
        (employee) => employee['srNo'] == loggedInUserSrNo,
        orElse: () => {},
      );

      if (loggedInUserJson!.isNotEmpty) {
        employeeData.value = UserProfile.fromMap(loggedInUserJson);
        log('employeeData==>>${employeeData}');
        userTasks();
      } else {
        print("No employee found with srNo: $loggedInUserSrNo");
      }
    } else {
      print("No employee data or loggedInUserSrNo found.");
    }
  }

  Future<void> userTasks() async {
    if (employeeData.value != null) {
      List<TaskModel> tasks = employeeData.value!.taskRequests;
      log("tasks:${tasks}");
      // Apply date filter if selected
      if (pickFilter.value.isNotEmpty) {
        employeeTasks.value =
            tasks.where((task) => task.date == pickFilter.value).toList();
      } else {
        employeeTasks.value = tasks;
      }

      // Sort tasks by appliedTime in descending order (newest first)
      employeeTasks.sort((a, b) {
        DateTime dateA = DateTime.tryParse(a.appliedTime) ?? DateTime(2000);
        DateTime dateB = DateTime.tryParse(b.appliedTime) ?? DateTime(2000);
        return dateB.compareTo(dateA);
      });

      print("Sorted employeeTasks: ${employeeTasks.length}");
    } else {
      print("No tasks found for this user.");
    }

    /* if (employeeList.isNotEmpty && employeeData['taskRequests'] != null) {
      List<Map<String, dynamic>> tasks =
          List<Map<String, dynamic>>.from(employeeData['taskRequests']);

      if (pickFilter.value.isNotEmpty) {
        employeeTasks.value =
            tasks.where((task) => task['date'] == pickFilter.value).toList();
      } else {
        employeeTasks.value = tasks;
      }

      // Sort tasks by appliedTime in descending order (newest first)
      employeeTasks.sort((a, b) {
        DateTime dateA;
        DateTime dateB;

        // Parse appliedTime if it exists; otherwise, assign a default old date
        try {
          dateA = a['appliedTime'] != null
              ? DateTime.parse(a['appliedTime'])
              : DateTime(2000); // Fallback to old date
        } catch (e) {
          dateA = DateTime(2000);
        }

        try {
          dateB = b['appliedTime'] != null
              ? DateTime.parse(b['appliedTime'])
              : DateTime(2000);
        } catch (e) {
          dateB = DateTime(2000);
        }

        return dateB.compareTo(dateA); // Descending order
      });

      log("Sorted employeeTasks: ${employeeTasks}");
    }*/
  }

  Future<void> selectFilterDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (context, child) => commonThemeBuilder(context, child),
    );

    if (picked != null) {
      pickFilter.value = formatDate(picked, [dd, '-', mm, '-', yyyy]);
      userTasks();
    }
  }

  void resetFilter() {
    pickFilter.value = "";
    userTasks();
  }

  Future<void> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedInUserSrNo.value = prefs.getString('loggedInUserSrNo') ?? "";

    if (loggedInUserSrNo.value.isNotEmpty) {
      userTasks();
    }
  }

  Future<void> updateTaskStatus(int index, String status,
      {String? holdReason}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');
    String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

    if (employeeListString != null && loggedInUserSrNo != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);

      // Find the logged-in user
      int userIndex = employeeList
          .indexWhere((employee) => employee['srNo'] == loggedInUserSrNo);
      if (userIndex != -1) {
        Map<String, dynamic> userJson = employeeList[userIndex];
        List<dynamic> tasksJson = userJson['taskRequests'];

        if (index >= 0 && index < employeeTasks.length) {
          TaskModel sortedTask = employeeTasks[index];

          // Find original task in the stored list
          int originalIndex = tasksJson.indexWhere(
              (task) => task['appliedTime'] == sortedTask.appliedTime);
          if (originalIndex != -1) {
            // Convert JSON to TaskModel
            TaskModel task = TaskModel.fromJson(tasksJson[originalIndex]);

            // Get current time
            String currentTime = formatDate(
              DateTime.now(),
              [dd, '-', mm, '-', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am],
            );

            // Update fields based on status
            if (status == commonString.radioBtnStart) {
              task.startTime = currentTime;
              task.reasonForHold = holdReason ?? '';
            } else if (status == commonString.radioBtnHold) {
              task.holdTime = currentTime;
              task.reasonForHold = holdReason ?? '';
            } else if (status == commonString.radioBtnFinish) {
              task.finishTime = currentTime;
              task.reasonForHold = holdReason ?? '';
            }
            task.status = status;

            // Convert back to JSON and save
            tasksJson[originalIndex] = task.toJson();
            userJson['taskRequests'] = tasksJson;
            employeeList[userIndex] = userJson;

            await prefs.setString('employeeData', jsonEncode(employeeList));

            // Refresh data and update UI
            Future.delayed(Duration(milliseconds: 300), () {
              fetchEmployeeData();
              update();
            });

            log("Task Updated Successfully!");
          }
        }
      }
    }
  }

/*
  Future<void> updateTaskStatus(int index, String status,
      {String? holdReason}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');

    if (employeeListString != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);

      int userIndex = employeeList.indexWhere(
        (employee) => employee['srNo'] == loggedInUserSrNo.value,
      );

      if (userIndex != -1) {
        List<dynamic> tasks = employeeList[userIndex]['taskRequests'];

        if (index >= 0 && index < employeeTasks.length) {
          Map<String, dynamic> sortedTask = employeeTasks[index];

          int originalIndex = tasks.indexWhere(
            (task) => task['appliedTime'] == sortedTask['appliedTime'],
          );

          if (originalIndex != -1) {
            Map<String, dynamic> task = tasks[originalIndex];

            String currentTime = formatDate(DateTime.now(),
                [dd, '-', mm, '-', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am]);

            log("Before Update: ${jsonEncode(task)}");

            */
/* if (status == 'hold') {
              task['holdTime'] = currentTime; // Always update hold time
              task['reasonForHold'] = holdReason ?? ''; // Update hold reason
            }
*/ /*


            if (status == 'start') {
              task['startTime'] = currentTime;
              task['reasonForHold'] =
                  holdReason ?? ''; // Store the start reason
            } else if (status == 'hold') {
              task['holdTime'] = currentTime; // Always update hold time
              task['reasonForHold'] = holdReason ?? ''; // Store the hold reason
            } else if (status == 'finish') {
              task['finishTime'] = currentTime;
              task['reasonForHold'] =
                  holdReason ?? ''; // Store the finish reason
            }
            task['status'] = status;

            // Save updated task back to the list
            tasks[originalIndex] = task;
            employeeList[userIndex]['taskRequests'] = tasks;

            log("After Update: ${jsonEncode(tasks[originalIndex])}");

            // Save updated data in SharedPreferences
            await prefs.setString('employeeData', jsonEncode(employeeList));

            log("After Save: ${prefs.getString('employeeData')}");

            // Delay UI refresh to ensure data is saved
            Future.delayed(Duration(milliseconds: 300), () {
              fetchEmployeeData();
              update(); // 🔄 Force UI update in GetX
            });

            log("Task Updated Successfully!");
          }
        }
      }
    }
  }
*/

/*  Future<void> removeTask(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');

    if (employeeListString != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);

      int userIndex = employeeList.indexWhere(
        (employee) => employee['srNo'] == loggedInUserSrNo.value,
      );

      if (userIndex != -1) {
        List<dynamic> tasks = employeeList[userIndex]['taskRequests'];

        if (index >= 0 && index < tasks.length) {
          tasks.removeAt(index); // Remove task

          // Update shared preferences
          employeeList[userIndex]['taskRequests'] = tasks;
          prefs.setString('employeeData', jsonEncode(employeeList));

          // Update local state
          employeeData['taskRequests'] = tasks;
          userTasks();

          // Show a message
          primaryToast(
            msg: "Task removed successfully!",
          );
        }
      }
    }
  }*/

  void confirmFinishTask(int index) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return commonLogOutDialog(
          showIcon: false,
          title: "Alert",
          logOutOnPressed: () {
            Navigator.pop(context);
            clearHoldReasonField();
            updateTaskStatus(index, commonString.radioBtnFinish,
                holdReason: holdReason.value);
            primaryToast(msg: 'Task finished successfully!');
            /*ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task finished successfully!'),
                duration: Duration(seconds: 2),
              ),
            );*/
          },
          cancelOnPressed: () {
            Navigator.pop(context);
          },
          subTitle: "Are you sure you want to finish this task?",
          cancelText: "Cancel",
          confirmText: "Finish",
          deleteButtonColor: AppColors.primarycolor,
        );
      },
    );
  }

  clearHoldReasonField() {
    holdReasonController.value.clear();
    holdReason.value = '';
  }
}
