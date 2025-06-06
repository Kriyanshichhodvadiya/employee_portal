import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/controller/userattandance_controller.dart';
import 'package:employeeform/view/admin_side/reportattendance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../common/global_widget.dart';

class Userattendance extends StatefulWidget {
  final String userName;
  const Userattendance({required this.userName});

  @override
  _UserattendanceState createState() => _UserattendanceState();
}

class _UserattendanceState extends State<Userattendance> {
  UserAttandanceController controller = Get.put(UserAttandanceController());
  // int totalPresent = 0;
  // int totalAbsent = 0;
  //
  // Map<DateTime, bool> userAttendanceData = {};

  @override
  void initState() {
    super.initState();
    controller.fetchUserAttendanceData(userName: widget.userName);
  }

  // Future<void> fetchUserAttendanceData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final keys =
  //       prefs.getKeys().where((key) => key.startsWith('attendanceStatus_'));
  //   int presentCount = 0;
  //   int absentCount = 0;
  //   for (String key in keys) {
  //     final storedData = prefs.getString(key);
  //     if (storedData != null) {
  //       final data = jsonDecode(storedData);
  //       if (data.containsKey(widget.userName)) {
  //         final dateString = key.replaceFirst('attendanceStatus_', '');
  //         final dateParts = dateString.split('-');
  //         final day = int.parse(dateParts[0]);
  //         final month = int.parse(dateParts[1]);
  //         final year = int.parse(dateParts[2]);
  //
  //         final date = DateTime(year, month, day);
  //         final isPresent = data[widget.userName] as bool;
  //
  //         setState(() {
  //           userAttendanceData[date] = data[widget.userName];
  //
  //           userAttendanceData[date] = isPresent;
  //           isPresent ? presentCount++ : absentCount++;
  //         });
  //       }
  //     }
  //   }
  //   setState(() {
  //     totalPresent = presentCount;
  //     totalAbsent = absentCount;
  //   });
  // }

  // Color attendanceColor(DateTime day) {
  //   final normalizedDay = DateTime(day.year, day.month, day.day);
  //   if (userAttendanceData.containsKey(normalizedDay)) {
  //     return userAttendanceData[normalizedDay]! ? Colors.green : Colors.red;
  //   }
  //   return Colors.transparent;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBar(
          onTap: () {
            Get.off(
              () => AttendanceReportPage(),
            );
          },
          title: 'Attendance'),

      /*   AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.to(AttendanceReportPage());
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        shadowColor: AppColors.black.withOpacity(0.5),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Attendance",
          style: poppinsStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
      ),*/
      // appBar: AppBar(
      //   title: Text('Attendance for ${widget.userName}'),
      // ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 335,
                  width: double.infinity,
                  decoration: commonDecoration(),
                  child: Center(
                    child: TableCalendar(
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: poppinsStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      daysOfWeekHeight: 20,
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekendStyle: poppinsStyle(fontWeight: FontWeight.w700),
                        weekdayStyle: poppinsStyle(fontWeight: FontWeight.w700),
                      ),
                      rowHeight: 40,
                      firstDay: DateTime(2023, 1, 1),
                      lastDay: DateTime(2030, 12, 31),
                      focusedDay: DateTime.now(),
                      selectedDayPredicate: (day) =>
                          isSameDay(day, DateTime.now()),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          final isSunday = day.weekday == DateTime.sunday;

                          return Obx(
                            () => Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: controller.attendanceColor(day),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  day.day.toString(),
                                  style: poppinsStyle(
                                    fontWeight: FontWeight.w500,
                                    color: isSunday
                                        ? Colors.red
                                        : controller.attendanceColor(day) ==
                                                Colors.transparent
                                            ? Colors.black
                                            : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          final isSunday = day.weekday == DateTime.sunday;
                          return Obx(
                            () => Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: controller.attendanceColor(day) ==
                                        Colors.transparent
                                    ? Colors.blue
                                    : controller.attendanceColor(day),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  day.day.toString(),
                                  style: poppinsStyle(
                                    fontWeight: FontWeight.w500,
                                    color: isSunday ? Colors.red : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )),
              30.height,
              Obx(
                () => Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 10),
                    child: Row(
                      children: [
                        Text(
                          "Total Present",
                          style: poppinsStyle(
                            color: AppColors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${controller.totalPresent.value}",
                          style: poppinsStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 10),
                    child: Row(
                      children: [
                        Text(
                          "Total Absent",
                          style: poppinsStyle(
                            color: AppColors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${controller.totalAbsent.value}",
                          style: poppinsStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: AppColors.yellow.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 10),
                  child: Row(
                    children: [
                      Text(
                        "Leaves",
                        style: poppinsStyle(
                          color: AppColors.yellowtext,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "0",
                        style: poppinsStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
