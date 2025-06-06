import 'dart:convert';
import 'dart:developer';

import 'package:employeeform/model/eprofilemodel.dart';
import 'package:employeeform/view/admin_side/employee_details.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskReportController extends GetxController {
  Future<void> employeeDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeDataJson = prefs.getString('employeeData');

    if (employeeDataJson != null) {
      log("JSON DATA ===> $employeeDataJson");
      List<dynamic> employeeData = jsonDecode(employeeDataJson);
      log("JSON  ===> $employeeData");
      userprofilelist =
          employeeData.map((item) => UserProfile.fromMap(item)).toList();

      log("Profiles ===> $userprofilelist");
    }
  }
}
