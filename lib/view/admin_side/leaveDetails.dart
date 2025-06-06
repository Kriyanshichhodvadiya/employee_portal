import 'dart:developer';

import 'package:employeeform/common/comman_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/global_widget.dart';
import '../../config/color.dart';

class LeaveDetails extends StatelessWidget {
  LeaveDetails({super.key});
  @override
  Widget build(BuildContext context) {
    var name = Get.arguments['name'];
    var status = Get.arguments['status'];
    var employeeId = Get.arguments['srNo'];
    var from = Get.arguments["from"];
    var to = Get.arguments["to"];
    var reason = Get.arguments['reason'];
    var appliedDate = Get.arguments['appliedDate'];
    log("name${name}");
    log("status${status}");
    log("employeeId${employeeId}");
    log("from${from}");
    log("to${to}");
    log("reason${reason}");
    log("appliedDate${appliedDate}");
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: appBar(
            title: '${name}',
            onTap: () {
              Get.back();
            },
            showBack: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: 16.symmetric,
            child: Column(
              children: [
                Container(
                  decoration: commonDecoration(),
                  child: Padding(
                    padding: 16.symmetric,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            leaveLabel(label: "Employee Id:"),
                            10.width,
                            leaveData(label: employeeId),
                          ],
                        ),
                        commonDivider(),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  leaveLabel(label: "From:"),
                                  10.width,
                                  leaveData(label: from),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  leaveLabel(label: "To:"),
                                  10.width,
                                  leaveData(label: to),
                                ],
                              ),
                            ),
                          ],
                        ),
                        leaveLabelSpace(),
                        leaveLabel(label: "Reason:"),
                        leaveData(label: reason),
                        leaveLabelSpace(),
                        leaveLabel(label: "Status:"),
                        leaveData(
                          label: status,
                          color: status == "Approved"
                              ? Colors.green
                              : status == "Rejected"
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

Widget leaveLabelSpace() {
  return 10.height;
}

Widget leaveLabel({required label}) {
  return Text(
    label,
    style: poppinsStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
  );
}

Widget leaveData({required label, Color? color}) {
  return Text(
    label,
    style: poppinsStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.hinttext),
  );
}
