import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/config/images.dart';
import 'package:employeeform/view/dashboard/userdashboard.dart';
import 'package:flutter/material.dart';

class exattendanceuser extends StatefulWidget {
  const exattendanceuser({super.key});

  @override
  State<exattendanceuser> createState() => _exattendanceuserState();
}

class _exattendanceuserState extends State<exattendanceuser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Userdashboard(),
              ),
            );
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        shadowColor: AppColors.black.withOpacity(0.5),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "exAttendance",
          style: poppinsStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                  bottom: 10, left: 10, right: 10, top: 10),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 3,
                    spreadRadius: 2,
                    // offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  4.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Mark Your Attendance!",
                        style: poppinsStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  10.height,
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: AppColors.hinttext,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(AppImages.attendance),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 10,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: AppColors.black,
                            size: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                  20.height,
                  Padding(
                    padding: 40.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: AppColors.green,
                              size: 20,
                            ),
                            Text(
                              "------------",
                              style: poppinsStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              "OnTime IN",
                              style: poppinsStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: AppColors.red,
                              size: 20,
                            ),
                            Text(
                              "------------",
                              style: poppinsStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              "OnTime OUT",
                              style: poppinsStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: AppColors.blue,
                              size: 20,
                            ),
                            Text(
                              "------------",
                              style: poppinsStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              "Late IN",
                              style: poppinsStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: AppColors.grey,
                              size: 20,
                            ),
                            Text(
                              "------------",
                              style: poppinsStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              "Early OUT",
                              style: poppinsStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ElevatedButton(
                  //     onPressed: () {},
                  //     style: ElevatedButton.styleFrom(
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(36))),
                  //         minimumSize: Size(160, 40),
                  //         backgroundColor: AppColors.primarycolor),
                  //     child: Text(
                  //       "Submit",
                  //       style: TextStyle(
                  //         color: AppColors.white,
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     )),
                ],
              ),
            ),
          ),
          // 20.height,
          Expanded(
            child: Container(
              // height: 200,
              margin: const EdgeInsets.only(left: 10, right: 10),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 3,
                    spreadRadius: 2,
                    // offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.height,
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(4),
                      1: FlexColumnWidth(4),
                      2: FlexColumnWidth(3),
                    },
                    children: [
                      TableRow(
                        decoration:
                            BoxDecoration(color: Colors.grey.withOpacity(0.6)),
                        children: [
                          Padding(
                            padding: 10.vertical,
                            child: Text(
                              'Date',
                              style: poppinsStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: 10.symmetric,
                            child: Text(
                              'IN',
                              style: poppinsStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: 10.symmetric,
                            child: Text(
                              'OUT',
                              style: poppinsStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, bottom: 8, top: 8),
                            child: Text(
                              '28/11/2024',
                              style: poppinsStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: 8.vertical,
                            child: Text(
                              '9:00 AM',
                              style: poppinsStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: 8.vertical,
                            child: Text(
                              '6:00 PM',
                              style: poppinsStyle(
                                color: AppColors.blue,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(height: 0, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
