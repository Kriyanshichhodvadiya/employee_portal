import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/controller/taskreport_controller.dart';
import 'package:employeeform/view/admin_side/employee_details.dart';
import 'package:employeeform/view/report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/global_widget.dart';
import 'attendanceadmin.dart';

class Taskreport extends StatefulWidget {
  const Taskreport({super.key});

  @override
  State<Taskreport> createState() => _TaskreportState();
}

class _TaskreportState extends State<Taskreport> {
  TaskReportController controller = Get.put(TaskReportController());
  @override
  void initState() {
    super.initState();
    controller.employeeDetails();
  }

  // Future<void> employeeDetails() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? employeeDataJson = prefs.getString('employeeData');
  //
  //   if (employeeDataJson != null) {
  //     setState(() {
  //       log("JSON DATA ===> $employeeDataJson");
  //       List<dynamic> employeeData = jsonDecode(employeeDataJson);
  //       log("JSON  ===> $employeeData");
  //       userprofilelist =
  //           employeeData.map((item) => UserProfile.fromMap(item)).toList();
  //
  //       log("Profiles ===> $userprofilelist");
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBar(
          showBack: false,
          onTap: () {
            Get.back();
          },
          title: 'Task Report'),
      /*AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Admindashboard(),
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
          "Task Report",
          style: poppinsStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
      ),*/
      body: userprofilelist.isEmpty
          ? commonLottie()
          : Column(
              children: [
                20.height,
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      width: double.maxFinite,
                      constraints: BoxConstraints(
                        maxHeight: 73.5.hp(context),
                      ),
                      decoration: commonDecoration(),
                      child: Column(
                        children: [
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(3),
                            },
                            children: [
                              TableRow(
                                children: [
                                  attendanceTableLabel(
                                    label: 'No.',
                                  ),
                                  attendanceTableLabel(
                                    label: 'Name',
                                  ),
                                  Padding(
                                      padding: 15.symmetric, child: SizedBox()),
                                ],
                              ),
                            ],
                          ),
                          commonDivider(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: userprofilelist.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0, vertical: 12),
                                            child: Text('${index + 1}',
                                                style: poppinsStyle(
                                                    color: AppColors.hinttext,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15)),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Report(
                                                    employeeName:
                                                        userprofilelist[index]
                                                                .firstName ??
                                                            '',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                                '${userprofilelist[index].firstName ?? ''} ${userprofilelist[index].lastName ?? ''} ',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: poppinsStyle(
                                                    color: AppColors.hinttext,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(height: 0, color: Colors.grey),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
    );
  }
}
