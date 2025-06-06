import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/controller/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/global_widget.dart';

class Report extends StatefulWidget {
  final String employeeName;

  const Report({super.key, required this.employeeName});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  ReportController controller = Get.put(ReportController());

  // List<Map<String, dynamic>> taskList = [];
  // List<Map<String, dynamic>> tasksdata = [];
  // String selectedFromDate = '';
  // String selectedToDate = '';

  @override
  void initState() {
    super.initState();
    controller.selectedFromDate.value = '';
    controller.selectedToDate.value = '';
    controller.employeeTasks(employeeName: widget.employeeName);
  }

  // Future<void> employeeTasks() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> storedTasks = prefs.getStringList('taskList') ?? [];
  //   setState(() {
  //     taskList = storedTasks
  //         .map((taskData) => jsonDecode(taskData) as Map<String, dynamic>)
  //         .toList();
  //
  //     tasksdata = taskList
  //         .where((task) =>
  //             task['employeeName'] != null &&
  //             task['employeeName'] == widget.employeeName)
  //         .toList();
  //   });
  // }
  // Future<void> selectFromDate(BuildContext context) async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: selectedToDate.isNotEmpty
  //         ? DateTime.parse(selectedToDate.split('/').reversed.join('-'))
  //         : DateTime(2101),
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           colorScheme: ColorScheme.light(
  //             primary: AppColors.primarycolor,
  //           ),
  //           textButtonTheme: TextButtonThemeData(
  //             style: TextButton.styleFrom(
  //               foregroundColor: AppColors.primarycolor,
  //             ),
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //
  //   if (pickedDate != null) {
  //     String formattedDate = formatDate(pickedDate, [dd, '/', mm, '/', yyyy]);
  //     setState(() {
  //       selectedFromDate = formattedDate;
  //     });
  //     selectTasksDate();
  //   }
  // }
  // Future<void> selectToDate(BuildContext context) async {
  //   if (selectedFromDate.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please select a From Date first.')),
  //     );
  //     return;
  //   }
  //
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.parse(selectedFromDate.split('/').reversed.join('-')),
  //     lastDate: DateTime(2101),
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           colorScheme: ColorScheme.light(
  //             primary: AppColors.primarycolor,
  //           ),
  //           textButtonTheme: TextButtonThemeData(
  //             style: TextButton.styleFrom(
  //               foregroundColor: AppColors.primarycolor,
  //             ),
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //
  //   if (pickedDate != null) {
  //     String formattedDate = formatDate(pickedDate, [dd, '/', mm, '/', yyyy]);
  //     setState(() {
  //       selectedToDate = formattedDate;
  //     });
  //     selectTasksDate();
  //   }
  // }
  //
  // void selectTasksDate() {
  //   if (selectedFromDate.isNotEmpty && selectedToDate.isNotEmpty) {
  //     DateTime fromDate = DateTime.parse(selectedFromDate
  //         .split('/')
  //         .reversed
  //         .join('-')); // Convert dd/MM/yyyy to yyyy-MM-dd
  //     DateTime toDate = DateTime.parse(selectedToDate
  //         .split('/')
  //         .reversed
  //         .join('-')); // Convert dd/MM/yyyy to yyyy-MM-dd
  //
  //     setState(() {
  //       tasksdata = taskList.where((task) {
  //         if (task['date'] != null) {
  //           DateTime taskDate =
  //               DateTime.parse(task['date'].split('/').reversed.join('-'));
  //           return taskDate
  //                   .isAfter(fromDate.subtract(const Duration(days: 1))) &&
  //               taskDate.isBefore(toDate.add(const Duration(days: 1)));
  //         }
  //         return false;
  //       }).toList();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBar(
          onTap: () {
            Get.back();
          },
          title: 'Task Report')

      /* AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        shadowColor: AppColors.black.withOpacity(0.5),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Task Report",
          style: poppinsStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
      )*/
      ,
      body: Column(
        children: [
          20.height,
          Padding(
            padding: 12.horizontal,
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => taskReportSelectDate(
                      onTap: () {
                        controller.selectFromDate(context);
                      },
                      label: controller.selectedFromDate.value.isEmpty
                          ? 'From'
                          : controller.selectedFromDate.value,
                    ),
                  ),
                ),
                10.width,
                Expanded(
                  child: Obx(
                    () => taskReportSelectDate(
                      onTap: () {
                        controller.selectToDate(context);
                      },
                      label: controller.selectedToDate.value.isEmpty
                          ? 'To'
                          : controller.selectedToDate.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
          /*  GestureDetector(
            onTap: () => controller.selectFromDate(context),
            child: Container(
              height: 45,
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      controller.selectedFromDate.value.isEmpty
                          ? 'From Date'
                          : controller.selectedFromDate.value,
                      style: poppinsStyle(fontSize: 16, color: AppColors.black),
                    ),
                  ),
                  Icon(Icons.calendar_today, color: AppColors.primarycolor),
                ],
              ),
            ),
          ),*/
          // 20.height,
          /*   GestureDetector(
            onTap: () => controller.selectToDate(context),
            child: Container(
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      controller.selectedToDate.value.isEmpty
                          ? 'To Date'
                          : controller.selectedToDate.value,
                      style: poppinsStyle(fontSize: 16, color: AppColors.black),
                    ),
                  ),
                  Icon(Icons.calendar_today, color: AppColors.primarycolor),
                ],
              ),
            ),
          ),*/
          Expanded(
            child: Obx(
              () => controller.tasksdata.isEmpty
                  ? commonLottie()
                  : ListView.builder(
                      // reverse: true,
                      itemCount: controller.tasksdata.length,
                      itemBuilder: (context, index) {
                        final task = controller.tasksdata[index];
                        bool isTaskStarted = task['startTime'] != null;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 3,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: 16.symmetric,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    10.width,
                                    Text(
                                      "Date: ${task['date'] ?? ''}",
                                      style: poppinsStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const Divider(
                                    color: Colors.grey,
                                    thickness: 0.5,
                                    height: 20),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.task_alt,
                                      color: AppColors.primarycolor,
                                      size: 20,
                                    ),
                                    10.width,
                                    Expanded(
                                      child: Text(
                                        "Task: ${task['task'] ?? ''}",
                                        style: poppinsStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                16.height,
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Start Task:',
                                        style: poppinsStyle(
                                          fontSize: 14,
                                          color: AppColors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        task['startTime'] ?? 'Not Started',
                                        style: poppinsStyle(
                                          fontSize: 14,
                                          color: AppColors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                8.height,
                                if (isTaskStarted)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Finish Task:',
                                          style: poppinsStyle(
                                            fontSize: 14,
                                            color: AppColors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          task['finishTime'] ?? 'Not Finished',
                                          style: poppinsStyle(
                                            fontSize: 14,
                                            color: AppColors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget taskReportSelectDate({required void Function()? onTap, required label}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: poppinsStyle(fontSize: 17, color: AppColors.black),
          ),
          Icon(
            Icons.calendar_today,
            color: AppColors.grey,
            size: 20,
          ),
        ],
      ),
    ),
  );
}
