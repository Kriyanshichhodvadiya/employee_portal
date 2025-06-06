import 'dart:convert';
import 'dart:developer';

import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/controller/userdashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/comman_widget.dart';
import '../model/leaverequest_model.dart';

class LeaveController extends GetxController {
  var leaveRequests = <LeaveRequest>[].obs;
  var filteredLeaveForAdmin = <LeaveRequest>[].obs;
  var expandedIndexes = <bool>[].obs;
  // var pickFilterForAdmin = ''.obs;
  // var statusFilterForAdmin = 'All'.obs;
  UserDashBoardController controller = Get.put(UserDashBoardController());
  var statusFilter = 'All'.obs;
  var fetchData = <LeaveRequest>[].obs;
  var startDate = ''.obs;
  var endDate = ''.obs;
  var reason = ''.obs;
  var rejection = ''.obs;
  var pickFilter = ''.obs; // Default: Current Date
  String? loggedInUserSrNo;
  RxBool isSwiped = false.obs;

  var selectedLeaveRequests = <LeaveRequest>[].obs;
  Rx<TextEditingController> reasonController = TextEditingController().obs;
  Rx<TextEditingController> rejectionController = TextEditingController().obs;
  @override
  void onInit() {
    super.onInit();
    loadLoggedInUserSrNo();

    fetchLeaveRequests();
    filterLeaveRequestsForAdminSide();
    getLoginSrNo();
  }

  void expantionTileLength(int length) {
    if (expandedIndexes.isEmpty) {
      expandedIndexes.assignAll(List.generate(length, (index) => false));
    }
  }

  void toggleExpansion(int index) {
    // expandedIndexes[index] = !expandedIndexes[index];
    if (index < expandedIndexes.length) {
      expandedIndexes[index] = !expandedIndexes[index];
    }
  }

  Future<void> loadLoggedInUserSrNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('loggedInUserSrNo');
    // controller.employeeData["srNo"];
    loggedInUserSrNo = controller.employeeData["srNo"];
    ;
    log("loggedInUserSrNo===>>${loggedInUserSrNo}");

    fetchLeaveRequests();
  }

  getLoginSrNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedInUserSrNo = prefs.getString('loggedInUserSrNo');
    log('loggedInUserSrNo!==>${loggedInUserSrNo}');
  }

  void resetAddLeaveValue() {
    startDate.value = "";
    endDate.value = "";
    reason.value = "";
    reasonController.value.clear();
  }

  Future<void> addLeaveRequest() async {
    if (startDate.value.isEmpty ||
        endDate.value.isEmpty ||
        reason.value.isEmpty) {
      primaryToast(msg: "Please fill in all fields.");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');
    String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

    if (employeeListString != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);
      Map<String, dynamic>? employee = employeeList.firstWhere(
        (emp) => emp['srNo'] == loggedInUserSrNo,
        orElse: () => null,
      );

      if (employee != null) {
        String appliedDateTime =
            DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());

        // Create a new leave request
        LeaveRequest leaveRequest = LeaveRequest(
          srNo: employee['srNo'],
          name: "${employee['firstName']} ${employee['lastName']}",
          startDate: startDate.value,
          endDate: endDate.value,
          reason: reason.value,
          appliedDateTime: appliedDateTime,
        );

        // Update employee's leave data
        if (employee['leaveRequests'] == null) {
          employee['leaveRequests'] = [];
        }
        (employee['leaveRequests'] as List).add(leaveRequest.toJson());

        // Save updated employee data in SharedPreferences
        int index =
            employeeList.indexWhere((emp) => emp['srNo'] == loggedInUserSrNo);
        if (index != -1) {
          employeeList[index] = employee;
        }

        prefs.setString('employeeData', jsonEncode(employeeList));

        // Update leaveRequests observable list
        leaveRequests.add(leaveRequest);

        Get.back();
        fetchLeaveRequests(); // Fetch updated employee data

        log("leaveRequests::${leaveRequests}");
        primaryToast(msg: "Leave request submitted successfully!");
        resetAddLeaveValue();
      } else {
        primaryToast(msg: "User data not found!");
      }
    }
  }

  Future<void> updateLeaveRequest({
    required String leaveId,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    log(" Starting updateLeaveRequest with leaveId: $leaveId");

    // 🔒 Validate date first
    DateTime start = DateFormat('dd-MM-yyyy').parse(startDate);
    DateTime end = DateFormat('dd-MM-yyyy').parse(endDate);

    if (end.isBefore(start)) {
      primaryToast(msg: "To date cannot be before from date.");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');
    String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

    log(" Fetched data from SharedPreferences");
    log("employeeListString: $employeeListString");
    log("loggedInUserSrNo: $loggedInUserSrNo");

    if (employeeListString != null && loggedInUserSrNo != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);

      log(" Decoded employeeList: $employeeList");

      int employeeIndex =
          employeeList.indexWhere((emp) => emp['srNo'] == loggedInUserSrNo);

      if (employeeIndex != -1) {
        Map<String, dynamic> employee = employeeList[employeeIndex];

        log(" Found employee: $employee");

        if (employee['leaveRequests'] != null) {
          List<dynamic> leaveRequestsList = employee['leaveRequests'];

          log(" Existing leaveRequests: $leaveRequestsList");

          int leaveIndex = leaveRequestsList.indexWhere(
            (leave) => leave['appliedDateTime'] == leaveId,
          );

          if (leaveIndex != -1) {
            log(" Found leave to update at index: $leaveIndex");

            LeaveRequest updatedLeave = LeaveRequest(
              srNo: employee['srNo'],
              name: "${employee['firstName']} ${employee['lastName']}",
              startDate: startDate,
              endDate: endDate,
              reason: reason,
              appliedDateTime: leaveId, // Keep it same
            );

            log(" Updated leave object: ${updatedLeave.toJson()}");

            leaveRequestsList[leaveIndex] = updatedLeave.toJson();

            employee['leaveRequests'] = leaveRequestsList;
            employeeList[employeeIndex] = employee;

            // Save to SharedPreferences
            prefs.setString('employeeData', jsonEncode(employeeList));

            log(" Updated employeeList saved to SharedPreferences");

            // Fix: Clear & addAll to update UI properly
            await fetchLeaveRequests(); // updates fetchData
            leaveRequests.clear();
            leaveRequests.addAll(fetchData);
            leaveRequests.refresh();

            log(" Refreshed fetchData and leaveRequests");
            log(" Final leaveRequests list after update:");
            for (var request in leaveRequests) {
              log(request.toJson().toString());
            }

            Get.back();
            resetAddLeaveValue();
            primaryToast(msg: "Leave updated successfully!");
          } else {
            log(" Leave not found for update.");
            primaryToast(msg: "Leave not found for update.");
          }
        } else {
          log(" No leave requests to update.");
          primaryToast(msg: "No leave requests to update.");
        }
      } else {
        log(" Employee not found.");
        primaryToast(msg: "User not found.");
      }
    } else {
      log(" Missing SharedPreferences data.");
      primaryToast(msg: "Missing user data.");
    }
  }

  //
  // Future<void> updateLeaveRequest({
  //   required String leaveId,
  //   required String startDate,
  //   required String endDate,
  //   required String reason,
  // }) async {
  //   log(" Starting updateLeaveRequest with leaveId: $leaveId");
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? employeeListString = prefs.getString('employeeData');
  //   String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');
  //
  //   log(" Fetched data from SharedPreferences");
  //   log("employeeListString: $employeeListString");
  //   log("loggedInUserSrNo: $loggedInUserSrNo");
  //
  //   if (employeeListString != null && loggedInUserSrNo != null) {
  //     List<dynamic> employeeList = jsonDecode(employeeListString);
  //
  //     log(" Decoded employeeList: $employeeList");
  //
  //     int employeeIndex =
  //         employeeList.indexWhere((emp) => emp['srNo'] == loggedInUserSrNo);
  //
  //     if (employeeIndex != -1) {
  //       Map<String, dynamic> employee = employeeList[employeeIndex];
  //
  //       log(" Found employee: $employee");
  //
  //       if (employee['leaveRequests'] != null) {
  //         List<dynamic> leaveRequestsList = employee['leaveRequests'];
  //
  //         log(" Existing leaveRequests: $leaveRequestsList");
  //
  //         int leaveIndex = leaveRequestsList.indexWhere(
  //           (leave) => leave['appliedDateTime'] == leaveId,
  //         );
  //
  //         if (leaveIndex != -1) {
  //           log(" Found leave to update at index: $leaveIndex");
  //
  //           LeaveRequest updatedLeave = LeaveRequest(
  //             srNo: employee['srNo'],
  //             name: "${employee['firstName']} ${employee['lastName']}",
  //             startDate: startDate,
  //             endDate: endDate,
  //             reason: reason,
  //             appliedDateTime: leaveId, // Keep it same
  //           );
  //
  //           log(" Updated leave object: ${updatedLeave.toJson()}");
  //
  //           leaveRequestsList[leaveIndex] = updatedLeave.toJson();
  //
  //           employee['leaveRequests'] = leaveRequestsList;
  //           employeeList[employeeIndex] = employee;
  //
  //           // Save to SharedPreferences
  //           prefs.setString('employeeData', jsonEncode(employeeList));
  //
  //           log(" Updated employeeList saved to SharedPreferences");
  //
  //           //  Fix: Clear & addAll to update UI properly
  //           await fetchLeaveRequests(); // updates fetchData
  //           leaveRequests.clear();
  //           leaveRequests.addAll(fetchData);
  //           leaveRequests.refresh();
  //
  //           log(" Refreshed fetchData and leaveRequests");
  //           log(" Final leaveRequests list after update:");
  //           for (var request in leaveRequests) {
  //             log(request.toJson().toString());
  //           }
  //
  //           Get.back();
  //           primaryToast(msg: "Leave updated successfully!");
  //           resetAddLeaveValue();
  //         } else {
  //           log(" Leave not found for update.");
  //           primaryToast(msg: "Leave not found for update.");
  //         }
  //       } else {
  //         log(" No leave requests to update.");
  //         primaryToast(msg: "No leave requests to update.");
  //       }
  //     } else {
  //       log(" Employee not found.");
  //       primaryToast(msg: "User not found.");
  //     }
  //   } else {
  //     log(" Missing SharedPreferences data.");
  //     primaryToast(msg: "Missing user data.");
  //   }
  // }

// from date and to date
  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    DateTime? initialDate = DateTime.now();
    DateTime? firstDate = DateTime.now(); // Default first date

    if (!isStartDate && startDate.value.isNotEmpty) {
      firstDate = DateFormat('dd-MM-yyyy')
          .parse(startDate.value)
          .add(Duration(days: 1));
      initialDate = firstDate;
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      builder: (context, child) => commonThemeBuilder(context, child),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      if (isStartDate) {
        startDate.value = formattedDate;
      } else {
        endDate.value = formattedDate;
      }
    }
  }

// user side select filter date
  Future<void> selectFilterDate(BuildContext context, bool adminSide) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2200),
      builder: (context, child) => commonThemeBuilder(context, child),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      pickFilter.value = formattedDate;

      if (adminSide) {
        log("pickFilter: ${pickFilter.value}");
        filterLeaveRequestsForAdminSide();
      } else {
        fetchLeaveRequests();
      }
    }
  }

  void updateStatusFilter(String status, bool adminSide) {
    statusFilter.value = status;
    if (adminSide == false) {
      fetchLeaveRequests(); // Refresh data with new filter
    } else {
      filterLeaveRequestsForAdminSide();
    }
  }

//user side fetch filter data with all

  Future<void> fetchLeaveRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');

    if (employeeListString != null && loggedInUserSrNo != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);
      Map<String, dynamic>? employee = employeeList.firstWhere(
        (emp) => emp['srNo'] == loggedInUserSrNo,
        orElse: () => null,
      );

      if (employee != null) {
        List<LeaveRequest> allRequests =
            (employee['leaveRequests'] as List<dynamic>?)
                    ?.map((e) => LeaveRequest.fromJson(e))
                    .toList() ??
                [];

        // Convert selected filter date to DateTime format safely
        DateTime? selectedDate;
        if (pickFilter.value.isNotEmpty) {
          try {
            selectedDate = DateFormat('dd-MM-yyyy').parse(pickFilter.value);
          } catch (e) {
            log("Invalid selected date format: ${pickFilter.value}");
            selectedDate = null;
          }
        }

        // Apply filters
        fetchData.value = allRequests.where((leave) {
          try {
            DateTime startDate =
                DateFormat('dd-MM-yyyy').parse(leave.startDate);
            DateTime endDate = DateFormat('dd-MM-yyyy').parse(leave.endDate);

            bool isWithinRange = selectedDate == null ||
                (selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
                    selectedDate.isBefore(endDate.add(Duration(days: 1))));

            bool matchStatus = statusFilter.value == 'All' ||
                leave.status == statusFilter.value;

            return isWithinRange && matchStatus;
          } catch (e) {
            log("Error filtering leave request: $e");
            return false;
          }
        }).toList();

        // Sort by appliedDateTime (newest first), with error handling
        fetchData.sort((a, b) {
          try {
            DateTime aDate =
                DateFormat('dd-MM-yyyy HH:mm:ss').parse(a.appliedDateTime);
            DateTime bDate =
                DateFormat('dd-MM-yyyy HH:mm:ss').parse(b.appliedDateTime);
            return bDate.compareTo(aDate);
          } catch (e) {
            log("Error sorting appliedDateTime: $e");
            return 0;
          }
        });

        expandedIndexes.clear();
        log("Filtered fetchData: $fetchData");
      } else {
        fetchData.clear();
      }
    }
  }

  // fetch filter data
  Future<void> filterLeaveRequestsForAdminSide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');

    if (employeeListString != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);
      List<LeaveRequest> allRequests = [];

      // Collect leave requests from all employees
      for (var employee in employeeList) {
        if (employee['leaveRequests'] != null) {
          List<LeaveRequest> employeeLeaves =
              (employee['leaveRequests'] as List<dynamic>)
                  .map((e) => LeaveRequest.fromJson(e))
                  .toList();
          allRequests.addAll(employeeLeaves);
        }
      }

      // Convert selected filter date to DateTime format safely
      DateTime? selectedDate;
      if (pickFilter.value.isNotEmpty) {
        try {
          selectedDate = DateFormat('dd-MM-yyyy').parse(pickFilter.value);
        } catch (e) {
          log("❌ Invalid selected filter date format: $e");
          selectedDate = null;
        }
      }

      List<LeaveRequest> filteredList = allRequests.where((leave) {
        try {
          if (leave.startDate.isEmpty || leave.endDate.isEmpty) {
            log("⚠️ Skipping leave with empty start/end date: $leave");
            return false;
          }

          DateTime startDate = DateFormat('dd-MM-yyyy').parse(leave.startDate);
          DateTime endDate = DateFormat('dd-MM-yyyy').parse(leave.endDate);

          bool isWithinRange = selectedDate == null ||
              (selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
                  selectedDate.isBefore(endDate.add(Duration(days: 1))));

          bool matchesStatus =
              statusFilter.value == 'All' || leave.status == statusFilter.value;

          return isWithinRange && matchesStatus;
        } catch (e) {
          log("❌ Error parsing leave dates: $e");
          return false;
        }
      }).toList();

      // Sort by appliedDateTime safely
      filteredList.sort((a, b) {
        try {
          return DateFormat('dd-MM-yyyy HH:mm:ss')
              .parse(b.appliedDateTime)
              .compareTo(
                  DateFormat('dd-MM-yyyy HH:mm:ss').parse(a.appliedDateTime));
        } catch (e) {
          log("❌ Error sorting appliedDateTime: $e");
          return 0;
        }
      });

      filteredLeaveForAdmin.value = filteredList;

      expandedIndexes.clear();
      log("✅ Filtered Admin Leave Data: $filteredLeaveForAdmin");
    } else {
      filteredLeaveForAdmin.clear();
    }
  }

  /* Future<void> filterLeaveRequestsForAdminSide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');

    if (employeeListString != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);
      List<LeaveRequest> allRequests = [];

      // Collect leave requests from all employees
      for (var employee in employeeList) {
        if (employee['leaveRequests'] != null) {
          List<LeaveRequest> employeeLeaves =
              (employee['leaveRequests'] as List<dynamic>)
                  .map((e) => LeaveRequest.fromJson(e))
                  .toList();
          allRequests.addAll(employeeLeaves);
        }
      }

      // Convert selected filter date to DateTime format
      DateTime? selectedDate;
      if (pickFilter.value.isNotEmpty) {
        selectedDate = DateFormat('dd-MM-yyyy').parse(pickFilter.value);
      }

      // Apply filters (Date Range + Status)
      List<LeaveRequest> filteredList = allRequests.where((leave) {
        DateTime startDate = DateFormat('dd-MM-yyyy').parse(leave.startDate);
        DateTime endDate = DateFormat('dd-MM-yyyy').parse(leave.endDate);

        bool isWithinRange = selectedDate == null ||
            (selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
                selectedDate.isBefore(endDate.add(Duration(days: 1))));

        bool matchesStatus =
            statusFilter.value == 'All' || leave.status == statusFilter.value;

        return isWithinRange && matchesStatus;
      }).toList();

      // Sort by appliedDateTime (newest first)
      filteredList.sort((a, b) => DateFormat('dd-MM-yyyy HH:mm:ss')
          .parse(b.appliedDateTime)
          .compareTo(
              DateFormat('dd-MM-yyyy HH:mm:ss').parse(a.appliedDateTime)));

      filteredLeaveForAdmin.value = filteredList;

      expandedIndexes.clear();
      log("Filtered Admin Leave Data: $filteredLeaveForAdmin");
    } else {
      filteredLeaveForAdmin.clear();
    }
  }*/

  //delete leave from user

  void deleteLeaveRequest(int index) async {
    if (index < 0 || index >= fetchData.length) return;

    LeaveRequest removedLeave = fetchData[index];

    // Remove from local list
    fetchData.removeAt(index);
    selectedLeaveRequests.remove(removedLeave);

    // Update SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');

    if (employeeListString != null && loggedInUserSrNo != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);
      Map<String, dynamic>? employee = employeeList.firstWhere(
        (emp) => emp['srNo'] == loggedInUserSrNo,
        orElse: () => null,
      );

      if (employee != null) {
        employee['leaveRequests'].removeWhere(
            (e) => e['appliedDateTime'] == removedLeave.appliedDateTime);

        // Update SharedPreferences
        prefs.setString('employeeData', jsonEncode(employeeList));
      }
    }

    // Notify UI to rebuild
    update();
  }

  Future<void> updateLeaveStatus(
    String srNo,
    String appliedDateTime,
    String newStatus, {
    String? reason,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');

    if (employeeListString != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);

      for (var employee in employeeList) {
        if (employee['srNo'] == srNo && employee['leaveRequests'] != null) {
          for (var leave in employee['leaveRequests']) {
            if (leave['appliedDateTime'] == appliedDateTime) {
              leave['status'] = newStatus;
              // if (newStatus == "Rejected" && reason != null) {
              leave['rejectionReason'] =
                  (newStatus == commonString.statusRejected) ? reason : "";
              // leave['rejectionReason'] = reason;
              // }
              break;
            }
          }
        }
      }

      // Save updated employee data back to SharedPreferences
      prefs.setString('employeeData', jsonEncode(employeeList));

      // Refresh the filtered leave requests for the admin side
      await filterLeaveRequestsForAdminSide();

      primaryToast(msg: "Leave status updated successfully!");
    } else {
      primaryToast(msg: "Error: Employee data not found!");
    }
  }
}

/*
import 'dart:convert';
import 'dart:developer';

import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/controller/userdashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/comman_widget.dart';
import '../model/leaverequest_model.dart';

class LeaveController extends GetxController {
  var leaveRequests = <LeaveRequest>[].obs;
  var filteredLeaveForAdmin = <LeaveRequest>[].obs;
  var expandedIndexes = <bool>[].obs;
  // var pickFilterForAdmin = ''.obs;
  // var statusFilterForAdmin = 'All'.obs;
  UserDashBoardController controller = Get.put(UserDashBoardController());
  var statusFilter = 'All'.obs;
  var fetchData = <LeaveRequest>[].obs;
  var startDate = ''.obs;
  var endDate = ''.obs;
  var reason = ''.obs;
  var rejection = ''.obs;
  var pickFilter = ''.obs; // Default: Current Date
  String? loggedInUserSrNo;
  RxBool isSwiped = false.obs;

  var selectedLeaveRequests = <LeaveRequest>[].obs;
  Rx<TextEditingController> reasonController = TextEditingController().obs;
  Rx<TextEditingController> rejectionController = TextEditingController().obs;
  @override
  void onInit() {
    super.onInit();
    loadLoggedInUserSrNo();

    fetchLeaveRequests();
    filterLeaveRequestsForAdminSide();
    getLoginSrNo();
  }

  void expantionTileLength(int length) {
    if (expandedIndexes.isEmpty) {
      expandedIndexes.assignAll(List.generate(length, (index) => false));
    }
  }

  void toggleExpansion(int index) {
    // expandedIndexes[index] = !expandedIndexes[index];
    if (index < expandedIndexes.length) {
      expandedIndexes[index] = !expandedIndexes[index];
    }
  }

  Future<void> loadLoggedInUserSrNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('loggedInUserSrNo');
    // controller.employeeData["srNo"];
    loggedInUserSrNo = controller.employeeData["srNo"];
    ;
    log("loggedInUserSrNo===>>${loggedInUserSrNo}");

    fetchLeaveRequests();
  }

  getLoginSrNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedInUserSrNo = prefs.getString('loggedInUserSrNo');
    log('loggedInUserSrNo!==>${loggedInUserSrNo}');
  }

  void resetAddLeaveValue() {
    startDate.value = "";
    endDate.value = "";
    reason.value = "";
    reasonController.value.clear();
  }

  Future<void> addLeaveRequest() async {
    if (startDate.value.isEmpty ||
        endDate.value.isEmpty ||
        reason.value.isEmpty) {
      primaryToast(msg: "Please fill in all fields.");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');
    String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

    if (employeeListString != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);
      Map<String, dynamic>? employee = employeeList.firstWhere(
        (emp) => emp['srNo'] == loggedInUserSrNo,
        orElse: () => null,
      );

      if (employee != null) {
        String appliedDateTime =
            DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());

        // Create a new leave request
        LeaveRequest leaveRequest = LeaveRequest(
          srNo: employee['srNo'],
          name: "${employee['firstName']} ${employee['lastName']}",
          startDate: startDate.value,
          endDate: endDate.value,
          reason: reason.value,
          appliedDateTime: appliedDateTime,
        );

        // Update employee's leave data
        if (employee['leaveRequests'] == null) {
          employee['leaveRequests'] = [];
        }
        (employee['leaveRequests'] as List).add(leaveRequest.toJson());

        // Save updated employee data in SharedPreferences
        int index =
            employeeList.indexWhere((emp) => emp['srNo'] == loggedInUserSrNo);
        if (index != -1) {
          employeeList[index] = employee;
        }

        prefs.setString('employeeData', jsonEncode(employeeList));

        // Update leaveRequests observable list
        leaveRequests.add(leaveRequest);

        Get.back();
        fetchLeaveRequests(); // Fetch updated employee data

        log("leaveRequests::${leaveRequests}");
        primaryToast(msg: "Leave request submitted successfully!");
        resetAddLeaveValue();
      } else {
        primaryToast(msg: "User data not found!");
      }
    }
  }

  Future<void> updateLeaveRequest({
    required leaveId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');
    String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

    if (employeeListString != null && loggedInUserSrNo != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);
      int employeeIndex =
          employeeList.indexWhere((emp) => emp['srNo'] == loggedInUserSrNo);

      if (employeeIndex != -1) {
        Map<String, dynamic> employee = employeeList[employeeIndex];

        if (employee['leaveRequests'] != null) {
          List<dynamic> leaveRequestsList = employee['leaveRequests'];
          LeaveRequest updatedLeave = LeaveRequest(
            srNo: employee['srNo'],
            name: "${employee['firstName']} ${employee['lastName']}",
            startDate: startDate.value,
            endDate: endDate.value,
            reason: reason.value,
            appliedDateTime: leaveId,
          );
          // Match using appliedDateTime
          int leaveIndex = leaveRequestsList.indexWhere(
            (leave) => leave['appliedDateTime'] == updatedLeave.appliedDateTime,
          );

          if (leaveIndex != -1) {
            leaveRequestsList[leaveIndex] = updatedLeave.toJson();

            // Update employee list
            employee['leaveRequests'] = leaveRequestsList;
            employeeList[employeeIndex] = employee;

            // Save updated list
            prefs.setString('employeeData', jsonEncode(employeeList));

            fetchLeaveRequests(); // Refresh list from local storage
            Get.back();
            primaryToast(msg: "Leave updated successfully!");
            resetAddLeaveValue();
          } else {
            primaryToast(msg: "Leave not found for update.");
          }
        } else {
          primaryToast(msg: "No leave requests to update.");
        }
      } else {
        primaryToast(msg: "User not found.");
      }
    } else {
      primaryToast(msg: "Missing user data.");
    }
  }

  */
/* Future<void> updateLeaveRequest({
    required String leaveId, // appliedDateTime as unique ID
  }) async {
    log('===>${leaveId}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');
    String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

    if (employeeListString != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);
      int employeeIndex =
          employeeList.indexWhere((emp) => emp['srNo'] == loggedInUserSrNo);

      if (employeeIndex != -1) {
        Map<String, dynamic> employee = employeeList[employeeIndex];

        if (employee['leaveRequests'] != null) {
          List<dynamic> leaveRequests = employee['leaveRequests'];

          // Debugging: Check if leaveRequests contain the leaveId
          log("leaveId to update: $leaveId");
          log("Existing leaveRequests: $leaveRequests");

          int leaveIndex = leaveRequests.indexWhere(
            (leave) => leave['appliedDateTime'] == leaveId,
          );

          if (leaveIndex != -1) {
            // Update the leave data
            leaveRequests[leaveIndex]['startDate'] = startDate.value;
            leaveRequests[leaveIndex]['endDate'] = endDate.value;
            leaveRequests[leaveIndex]['reason'] = reason.value;

            // Save updated data back to employee list
            employee['leaveRequests'] = leaveRequests;
            employeeList[employeeIndex] = employee;

            // Store back into SharedPreferences
            prefs.setString('employeeData', jsonEncode(employeeList));

            fetchLeaveRequests(); // Refresh list
            primaryToast(msg: "Leave updated successfully!");
          } else {
            // Debugging: If leave not found
            log("Leave with appliedDateTime: $leaveId not found in leaveRequests.");
            primaryToast(msg: "Leave not found!");
          }
        } else {
          primaryToast(msg: "No leave requests found!");
        }
      } else {
        primaryToast(msg: "User not found!");
      }
    }
  }*/ /*


// from date and to date
  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    DateTime? initialDate = DateTime.now();
    DateTime? firstDate = DateTime.now(); // Default first date

    if (!isStartDate && startDate.value.isNotEmpty) {
      firstDate = DateFormat('dd-MM-yyyy')
          .parse(startDate.value)
          .add(Duration(days: 1));
      initialDate = firstDate;
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      builder: (context, child) => commonThemeBuilder(context, child),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      if (isStartDate) {
        startDate.value = formattedDate;
      } else {
        endDate.value = formattedDate;
      }
    }
  }

// user side select filter date
  Future<void> selectFilterDate(BuildContext context, bool adminSide) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2200),
      builder: (context, child) => commonThemeBuilder(context, child),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      pickFilter.value = formattedDate;

      if (adminSide) {
        log("pickFilter: ${pickFilter.value}");
        filterLeaveRequestsForAdminSide();
      } else {
        fetchLeaveRequests();
      }
    }
  }

  void updateStatusFilter(String status, bool adminSide) {
    statusFilter.value = status;
    if (adminSide == false) {
      fetchLeaveRequests(); // Refresh data with new filter
    } else {
      filterLeaveRequestsForAdminSide();
    }
  }

//user side fetch filter data with all

  Future<void> fetchLeaveRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');

    if (employeeListString != null && loggedInUserSrNo != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);
      Map<String, dynamic>? employee = employeeList.firstWhere(
        (emp) => emp['srNo'] == loggedInUserSrNo,
        orElse: () => null,
      );

      if (employee != null) {
        List<LeaveRequest> allRequests =
            (employee['leaveRequests'] as List<dynamic>?)
                    ?.map((e) => LeaveRequest.fromJson(e))
                    .toList() ??
                [];

        // Convert selected filter date to DateTime format
        DateTime? selectedDate;
        if (pickFilter.value.isNotEmpty) {
          selectedDate = DateFormat('dd-MM-yyyy').parse(pickFilter.value);
        }

        // Apply filters
        fetchData.value = allRequests.where((leave) {
          DateTime startDate = DateFormat('dd-MM-yyyy').parse(leave.startDate);
          DateTime endDate = DateFormat('dd-MM-yyyy').parse(leave.endDate);

          bool isWithinRange = selectedDate == null ||
              (selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
                  selectedDate.isBefore(endDate.add(Duration(days: 1))));

          bool matchStatus =
              statusFilter.value == 'All' || leave.status == statusFilter.value;

          return isWithinRange && matchStatus;
        }).toList();

        // Sort by appliedDateTime (newest first)
        fetchData.sort((a, b) => DateFormat('dd-MM-yyyy HH:mm:ss')
            .parse(b.appliedDateTime)
            .compareTo(
                DateFormat('dd-MM-yyyy HH:mm:ss').parse(a.appliedDateTime)));

        expandedIndexes.clear();
        log("Filtered fetchData: $fetchData");
      } else {
        fetchData.clear();
      }
    }
  }

  // fetch filter data
  Future<void> filterLeaveRequestsForAdminSide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');

    if (employeeListString != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);
      List<LeaveRequest> allRequests = [];

      // Collect leave requests from all employees
      for (var employee in employeeList) {
        if (employee['leaveRequests'] != null) {
          List<LeaveRequest> employeeLeaves =
              (employee['leaveRequests'] as List<dynamic>)
                  .map((e) => LeaveRequest.fromJson(e))
                  .toList();
          allRequests.addAll(employeeLeaves);
        }
      }

      // Convert selected filter date to DateTime format
      DateTime? selectedDate;
      if (pickFilter.value.isNotEmpty) {
        selectedDate = DateFormat('dd-MM-yyyy').parse(pickFilter.value);
      }

      // Apply filters (Date Range + Status)
      List<LeaveRequest> filteredList = allRequests.where((leave) {
        DateTime startDate = DateFormat('dd-MM-yyyy').parse(leave.startDate);
        DateTime endDate = DateFormat('dd-MM-yyyy').parse(leave.endDate);

        bool isWithinRange = selectedDate == null ||
            (selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
                selectedDate.isBefore(endDate.add(Duration(days: 1))));

        bool matchesStatus =
            statusFilter.value == 'All' || leave.status == statusFilter.value;

        return isWithinRange && matchesStatus;
      }).toList();

      // Sort by appliedDateTime (newest first)
      filteredList.sort((a, b) => DateFormat('dd-MM-yyyy HH:mm:ss')
          .parse(b.appliedDateTime)
          .compareTo(
              DateFormat('dd-MM-yyyy HH:mm:ss').parse(a.appliedDateTime)));

      filteredLeaveForAdmin.value = filteredList;

      expandedIndexes.clear();
      log("Filtered Admin Leave Data: $filteredLeaveForAdmin");
    } else {
      filteredLeaveForAdmin.clear();
    }
  }

  //delete leave from user

  void deleteLeaveRequest(int index) async {
    if (index < 0 || index >= fetchData.length) return;

    LeaveRequest removedLeave = fetchData[index];

    // Remove from local list
    fetchData.removeAt(index);
    selectedLeaveRequests.remove(removedLeave);

    // Update SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');

    if (employeeListString != null && loggedInUserSrNo != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);
      Map<String, dynamic>? employee = employeeList.firstWhere(
        (emp) => emp['srNo'] == loggedInUserSrNo,
        orElse: () => null,
      );

      if (employee != null) {
        employee['leaveRequests'].removeWhere(
            (e) => e['appliedDateTime'] == removedLeave.appliedDateTime);

        // Update SharedPreferences
        prefs.setString('employeeData', jsonEncode(employeeList));
      }
    }

    // Notify UI to rebuild
    update();
  }

  Future<void> updateLeaveStatus(
    String srNo,
    String appliedDateTime,
    String newStatus, {
    String? reason,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');

    if (employeeListString != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);

      for (var employee in employeeList) {
        if (employee['srNo'] == srNo && employee['leaveRequests'] != null) {
          for (var leave in employee['leaveRequests']) {
            if (leave['appliedDateTime'] == appliedDateTime) {
              leave['status'] = newStatus;
              // if (newStatus == "Rejected" && reason != null) {
              leave['rejectionReason'] =
                  (newStatus == commonString.statusRejected) ? reason : "";
              // leave['rejectionReason'] = reason;
              // }
              break;
            }
          }
        }
      }

      // Save updated employee data back to SharedPreferences
      prefs.setString('employeeData', jsonEncode(employeeList));

      // Refresh the filtered leave requests for the admin side
      await filterLeaveRequestsForAdminSide();

      primaryToast(msg: "Leave status updated successfully!");
    } else {
      primaryToast(msg: "Error: Employee data not found!");
    }
  }
}
*/
