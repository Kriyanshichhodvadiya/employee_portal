import 'package:get/get.dart';

class DuePayController extends GetxController {
  final RxList<Map<String, dynamic>> attendanceList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> userList = <Map<String, dynamic>>[].obs;
  final RxInt totalWorkingDays = 26.obs; // Assume 26 working days in a month

  // Function to calculate salary for a user
  double calculateSalary(String srNo, double monthlySalary) {
    // Filter attendance records for this user
    int presentDays = attendanceList
        .where((attendance) =>
            attendance['srNo'] == srNo && attendance['in'] != '-')
        .length;

    // Calculate per day salary
    double perDaySalary = monthlySalary / totalWorkingDays.value;

    // Calculate total payable salary
    return presentDays * perDaySalary;
  }
}
