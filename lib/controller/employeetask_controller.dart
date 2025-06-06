import 'dart:convert';
import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/comman_widget.dart';

class EmployeeTaskController extends GetxController {
  RxString dropdownvalue = ''.obs;
  RxString eid = ''.obs;
  RxString etask = ''.obs;
  RxString oldTask = "".obs;
  RxString oldAppliedDate = "".obs;
  RxString selectedDate =
      formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]).obs;

  RxList<String> employeeNames = <String>[].obs;
  RxMap<String, String> employeeMap = <String, String>{}.obs;
  RxMap<String, String> employeeLastNameMap = <String, String>{}.obs;
  // var employeeLastNames = <String>[].obs;

  Rx<TextEditingController> employeeidcontroller = TextEditingController().obs;
  Rx<TextEditingController> employeetaskcontroller =
      TextEditingController().obs;
  @override
  void onInit() {
    super.onInit();
    employeeData();
  }

  Future<void> employeeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeData = prefs.getString('employeeData');
    log("Raw employeeData: $employeeData");
    print("Raw employeeData: $employeeData");
    if (employeeData != null) {
      List<Map<String, dynamic>> employeeList =
          List<Map<String, dynamic>>.from(jsonDecode(employeeData));

      employeeNames.value = employeeList
          .map<String>((employee) => employee['firstName'].toString())
          .toList();
      // employeeLastNames.value = employeeList
      //     .map<String>((employee) => employee['lastName'].toString())
      //     .toList();
      employeeMap.value = {
        for (var employee in employeeList)
          employee['firstName'].toString(): employee['srNo'].toString()
      };
      employeeLastNameMap.value = {
        for (var employee in employeeList)
          employee['srNo'].toString(): employee['lastName'].toString()
      };
      log("employeeMap: $employeeMap");
      log("employeeLastNameMap: $employeeLastNameMap");
      if (employeeNames.isNotEmpty) {
        dropdownvalue.value = employeeNames.first;
        employeeidcontroller.value.text =
            employeeMap[dropdownvalue.value] ?? '';
      }
    }
  }

  void updateSrno(String? employeeName) {
    employeeidcontroller.value.text = employeeMap[employeeName] ?? '';
  }

  String getLastNameBySrNo(String srNo) {
    return employeeLastNameMap[srNo] ?? '';
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) => commonThemeBuilder(context, child),
    );
    if (picked != null) {
      selectedDate.value = formatDate(picked, [dd, '-', mm, '-', yyyy]);
    }
  }
}
