import 'dart:developer';

import 'package:employeeform/common/attendance_components/app_config.dart';
import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/config/images.dart';
import 'package:employeeform/controller/employeetask_controller.dart';
import 'package:employeeform/controller/viewalltaskadmin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'company_profile/co_profile_form.dart';
import 'exemployeetask.dart';

class ViewAllTaskAdmin extends StatefulWidget {
  const ViewAllTaskAdmin({Key? key}) : super(key: key);

  @override
  State<ViewAllTaskAdmin> createState() => _ViewAllTaskAdminState();
}

class _ViewAllTaskAdminState extends State<ViewAllTaskAdmin> {
  ViewAllTaskAdminController controller = Get.put(ViewAllTaskAdminController());
  EmployeeTaskController employeeTaskController =
      Get.put(EmployeeTaskController());
  @override
  void initState() {
    super.initState();
    controller.allTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBar(
        title: "All Task",
        showBack: false,
        onTap: () {
          Get.back();
          /* Get.off(() => Admindashboard());*/
        },
      ),
      floatingActionButton: commonFloatingBtn(
        onPressed: () {
          Get.to(Exemployeetask(),
              transition: Transition.noTransition,
              duration: Duration(milliseconds: 300),
              arguments: {"edit": false});
        },
      ),
      body: Column(
        children: [
          10.height,
          Padding(
            padding: 16.horizontal,
            child: Column(
              children: [
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: commonDateConForLeave(
                          label: controller.selectedFromDate.value.isEmpty
                              ? "From"
                              : controller.selectedFromDate.value,
                          onTap: () {
                            controller.selectDate(context, selectFrom: true);
                          },
                        ),
                      ),
                      5.width,
                      5.width,
                      Expanded(
                        child: commonDateConForLeave(
                          label: controller.selectedToDate.value.isEmpty
                              ? "To"
                              : controller.selectedToDate.value,
                          onTap: () {
                            controller.selectDate(context, selectFrom: false);
                          },
                        ),
                      ),
                      5.width,
                      if (controller.selectedFromDate.value.isNotEmpty ||
                          controller.selectedToDate.value.isNotEmpty)
                        leaveFilterClearBtn(
                          onTap: () {
                            controller.selectedFromDate.value = '';
                            controller.selectedToDate.value = '';
                            controller.filterTasks();
                          },
                        ),
                    ],
                  ),
                ),
                10.height,
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(7),
                        child: Theme(
                          data: Theme.of(Get.context!).copyWith(
                            splashColor:
                                Colors.transparent, // Remove splash effect
                            highlightColor:
                                Colors.transparent, // Remove highlight effect
                          ),
                          child: PopupMenuButton<String>(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                            color: AppColors.white,
                            elevation: 5,
                            onSelected: (String id) {
                              // controller.selectedEmployee.value =
                              //     id; // Store selected ID

                              String? selectedEmployeeName =
                                  controller.employeeNamesWithId[id];
                              controller.selectedEmployee.value =
                                  selectedEmployeeName!; // Store selected ID
                              print(
                                  "Selected Employee Name: $selectedEmployeeName");
                              print(
                                  "Selected Employee ID: ${controller.selectedEmployee.value}");
                              controller.filterTasks();
                            },
                            child: Container(
                              height: 6.hp(Get.context!),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                    color: AppColors.primarycolor
                                        .withOpacity(0.3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.grey.withOpacity(0.05),
                                    spreadRadius: -1,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Obx(
                                      () => Text(
                                        controller.selectedEmployee.value ??
                                            'All',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: poppinsStyle(
                                            color: AppColors.primarycolor),
                                      ),
                                    ),
                                  ),
                                  fieldSuffixIcon(
                                      color: AppColors.primarycolor),
                                ],
                              ),
                            ),
                            itemBuilder: (BuildContext context) {
                              var entries = controller
                                  .employeeNamesWithId.entries
                                  .toList();

                              return entries.map((entry) {
                                bool isFirst = entries.indexOf(entry) ==
                                    0; // Check if it's the first entry
                                return PopupMenuItem<String>(
                                  value: entry.key, // Set ID as value
                                  child: Row(
                                    children: [
                                      isFirst
                                          ? Container()
                                          : Icon(
                                              Icons.badge_outlined,
                                              color: AppColors.grey,
                                              size: 1.8.heightBox(),
                                            ),
                                      isFirst ? 0.width : 3.width,
                                      Text(
                                        isFirst
                                            ? "${entry.value}"
                                            : "${entry.key}   ${entry.value}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: poppinsStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: 5.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Obx(() => radioBtn(
                          groupValue: controller.bgroup.value,
                          onChanged: (val) {
                            controller.bgroup.value = val;
                            controller.filterTasks();
                          },
                          value: commonString.radioBtnPending)),
                      radioBtnText(label: "Pending"),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => radioBtn(
                          groupValue: controller.bgroup.value,
                          onChanged: (val) {
                            controller.bgroup.value = val;
                            controller.filterTasks();
                          },
                          value: commonString.radioBtnStart)),
                      radioBtnText(label: "Start"),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => radioBtn(
                          value: commonString.radioBtnHold,
                          groupValue: controller.bgroup.value,
                          onChanged: (val) {
                            controller.bgroup.value = val!;
                            controller.filterTasks();
                          })),
                      radioBtnText(label: "Hold"),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => radioBtn(
                          value: commonString.radioBtnFinish,
                          groupValue: controller.bgroup.value,
                          onChanged: (val) {
                            controller.bgroup.value = val!;
                            controller.filterTasks();
                          })),
                      radioBtnText(label: "Finish"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // 5.height,
          Padding(
            padding: 16.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                commonTaskHint(
                    label: 'Start Time',
                    lottie: AppLottie.startTask,
                    // icon: AppSvg.startTask,
                    color: AppColors.primarycolor),
                10.width,
                commonTaskHint(
                    label: 'Hold Time',
                    lottie: AppLottie.holdtask,
                    // icon: AppSvg.holdTask,
                    color: AppColors.stRed),
                10.width,
                commonTaskHint(
                    label: 'Finish Time',
                    lottie: AppLottie.finishTask,
                    // icon: AppSvg.endTask,
                    color: green),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => controller.filteredTaskList.isEmpty
                  ? commonLottie()
                  : Padding(
                      padding: 10.onlyTop,
                      child: ListView.builder(
                        itemCount: controller.filteredTaskList.length,
                        itemBuilder: (context, index) {
                          var task = controller.filteredTaskList[index];
                          log("task.startTime==>>${task.startTime}");
                          log("task.finishTime==>>${task.finishTime}");
                          log("task.holdTime==>>${task.holdTime}");
                          log("task.status==>>${task.status}");
                          log("task.reasonForHold==>>${task.reasonForHold.toString()}");
                          bool isTaskStarted =
                              task.status == commonString.radioBtnStart;
                          bool isTaskFinished =
                              task.status == commonString.radioBtnFinish;
                          bool isTaskHold = task.status ==
                                  commonString
                                      .radioBtnHold /* &&
                              task.finishTime == null &&
                              task.finishTime!.isEmpty*/
                              ;

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            padding: 16.symmetric,
                            decoration:
                                commonDecoration(color: AppColors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.badge_outlined,
                                            color: AppColors.grey,
                                            size: 2.5.heightBox(),
                                          ),
                                          6.width,
                                          Text(
                                            '${task.srNo}',
                                            style: poppinsStyle(
                                              color: AppColors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          10.width,
                                          Text(
                                            ':',
                                            style: poppinsStyle(
                                              color: AppColors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          10.width,
                                          Expanded(
                                            child: Text(
                                                "${task.employeeName} ${task.employeeLastName}",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: poppinsStyle(
                                                    fontSize: 15,
                                                    color: AppColors.black,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    controller.bgroup.value ==
                                            commonString.radioBtnPending
                                        ? PopupMenuButton<int>(
                                            color: AppColors.white,
                                            onSelected: (value) {
                                              if (value == 0) {
                                                employeeTaskController
                                                    .selectedDate
                                                    .value = task.date;
                                                employeeTaskController
                                                    .dropdownvalue
                                                    .value = task.employeeName;
                                                employeeTaskController
                                                    .employeetaskcontroller
                                                    .value
                                                    .text = task.task;
                                                employeeTaskController
                                                    .oldTask.value = task.task;
                                                employeeTaskController
                                                    .oldAppliedDate
                                                    .value = task.appliedTime;
                                                Get.to(Exemployeetask(),
                                                    transition:
                                                        Transition.noTransition,
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    arguments: {"edit": true});
                                              } else if (value == 1) {
                                                // Handle delete action

                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder:
                                                        (BuildContext context) {
                                                      return commonLogOutDialog(
                                                        title: 'Delete',
                                                        iconColor:
                                                            AppColors.red,
                                                        deleteButtonColor:
                                                            AppColors.red,
                                                        subTitle:
                                                            'Are you sure you want to delete this task?',
                                                        confirmText: 'Delete',
                                                        cancelText: 'Cancel',
                                                        icon: Icons
                                                            .warning_amber_rounded,
                                                        cancelOnPressed: () {
                                                          Get.back();
                                                        },
                                                        logOutOnPressed: () {
                                                          controller
                                                              .deleteTask(task);
                                                          Get.back();
                                                        },
                                                      );
                                                    });
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 0,
                                                child: editPopUp(
                                                    icon: Icons.edit,
                                                    label: 'Edit'),
                                              ),
                                              PopupMenuItem(
                                                value: 1,
                                                child: editPopUp(
                                                    icon: Icons.delete,
                                                    label: 'Delete'),
                                              ),
                                            ],
                                            child: Icon(
                                              Icons.more_vert,
                                              color: AppColors.grey,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                commonDivider(),
                                allTaskText(
                                    icon: Icons.calendar_month,
                                    label: 'Assign Date',
                                    task: "${task.date}"),
                                allTaskText(
                                    icon: Icons.task_alt,
                                    label: 'Task',
                                    task: "${task.task}"),
                                Visibility(
                                  visible: task.reasonForHold!.isNotEmpty,
                                  child: allTaskText(
                                      icon: Icons.info_outline_rounded,
                                      label: 'HR',
                                      task: "${task.reasonForHold.toString()}"),
                                ),

                                Visibility(
                                    visible: controller.bgroup.value ==
                                        commonString.radioBtnPending,
                                    child: 10.height),
                                Visibility(
                                  visible: controller.bgroup.value ==
                                      commonString.radioBtnPending,
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.stOrange
                                            .withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: AppColors.stOrange,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Lottie.asset(AppLottie.hourglass,
                                                height: 10.widthBox(),
                                                width: 10.widthBox(),
                                                fit: BoxFit.cover),
                                            /*   Icon(Icons.hourglass_empty_rounded,
                                                color: AppColors.stOrange,
                                                size: 2.heightBox()),*/
                                            5.width,
                                            Text(
                                              "Task is Pending",
                                              style: poppinsStyle(
                                                color: AppColors.stOrange,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                    visible: isTaskHold, child: 7.height),
                                Visibility(
                                  visible: isTaskHold,
                                  child: allTaskTimeCont(
                                      // label: "Start Task:",
                                      time: controller
                                          .startTimeFor(task.holdTime!),
                                      date: controller
                                          .startDateFor(task.holdTime!),
                                      start: commonString.radioBtnHold),
                                ),
                                Visibility(
                                    visible: isTaskStarted || isTaskFinished,
                                    child: 10.height),
                                Visibility(
                                  visible: isTaskStarted || isTaskFinished,
                                  child: allTaskTimeCont(
                                      // label: "Start Task:",
                                      time: controller
                                          .startTimeFor(task.startTime!),
                                      date: controller
                                          .startDateFor(task.startTime!),
                                      start: commonString.radioBtnStart),
                                ),
                                Visibility(
                                    visible: isTaskFinished, child: 7.height),
                                // if (isTaskStarted)
                                Visibility(
                                  visible: isTaskFinished,
                                  child: allTaskTimeCont(
                                      // label: "Finish Task:",
                                      time: controller
                                          .startTimeFor(task.finishTime!),
                                      date: controller
                                          .startDateFor(task.finishTime!),
                                      start: commonString.radioBtnFinish),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
