//userviewtask(getx)
import 'dart:developer';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/config/images.dart';
import 'package:employeeform/controller/userviewtask_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../admin_side/edit_user/profile_details.dart';

class Userviewtask extends StatefulWidget {
  const Userviewtask({super.key});

  @override
  State<Userviewtask> createState() => _UserviewtaskState();
}

class _UserviewtaskState extends State<Userviewtask> {
  UserViewTaskController controller = Get.put(UserViewTaskController());

  @override
  void initState() {
    super.initState();
    controller.isUserLoggedIn();
    controller.fetchEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: appBar(
            title: "Task",
            showBack: false,
            onTap: () {
              Get.back();
            },
            actions: [
              commonCompanyIcon(
                onTap: () async {
                  if (controller.employeeData.value != null) {
                    Get.to(
                      () => ProfileDetail(
                        backBtn: true,
                        adminProfile: true,
                        adminEdit: false,
                        editMode: true,
                        userprofile: controller.employeeData.value!,
                      ),
                    );
                  } else {
                    // Optionally handle the null case
                    primaryToast(msg: "Employee data not available");
                  }
                },
                image: AppSvg.profile,
              ),
              16.width,
            ]),
        body: Obx(() => Column(mainAxisSize: MainAxisSize.min, children: [
              10.height,
              Padding(
                  padding: 16.horizontal,
                  child: Obx(() => Row(children: [
                        Expanded(
                            child: commonDateConForLeave(
                          label: controller.pickFilter.value.isEmpty
                              ? 'Select Date'
                              : controller.pickFilter.value,
                          onTap: () {
                            controller.selectFilterDate(context);
                          },
                        ))
                      ]))),
              15.height,
              controller.employeeTasks.isEmpty
                  ? Expanded(child: commonLottie())
                  : Expanded(
                      child: ListView.separated(
                          separatorBuilder: (context, index) => 10.height,
                          padding: 16.symmetric,
                          itemCount: controller.employeeTasks.length,
                          itemBuilder: (context, index) {
                            var task = controller.employeeTasks[index];
                            // TaskModel task = controller.employeeTasks[index];
                            return Container(
                                decoration: commonDecoration(),
                                child: Padding(
                                    padding: 10.symmetric,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: 10.horizontal,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    textAlign: TextAlign.start,
                                                    "${task.date}",
                                                    style: TextStyle(
                                                        color: AppColors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontFamily: 'Poppins')),
                                                GestureDetector(
                                                  onTap: (task.status ==
                                                              commonString
                                                                  .radioBtnFinish ||
                                                          task.finishTime !=
                                                              null)
                                                      ? () {
                                                          primaryToast(
                                                              msg:
                                                                  "This task is already finished.");
                                                        }
                                                      : null,
                                                  child: AbsorbPointer(
                                                    absorbing: (task.status ==
                                                            commonString
                                                                .radioBtnFinish ||
                                                        task.finishTime !=
                                                            null),
                                                    child: PopupMenuButton<
                                                            String>(
                                                        color: AppColors.white,
                                                        onSelected: (String
                                                            value) async {
                                                          // Prevent any action if the task is already finished
                                                          if (task.finishTime !=
                                                                  null ||
                                                              task.status ==
                                                                  commonString
                                                                      .radioBtnFinish) {
                                                            if (value ==
                                                                commonString
                                                                    .radioBtnFinish) {
                                                              // Show the confirmation dialog to update the finish time
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    false,
                                                                builder:
                                                                    (context) {
                                                                  return commonLogOutDialog(
                                                                    showIcon:
                                                                        false,
                                                                    title:
                                                                        "Task Already Finished",
                                                                    cancelText:
                                                                        "No",
                                                                    confirmText:
                                                                        "Yes",
                                                                    subTitle:
                                                                        "This task has already been finished. Do you want to update the finish time?",
                                                                    cancelOnPressed:
                                                                        () {
                                                                      Get.back();
                                                                    },
                                                                    logOutOnPressed:
                                                                        () {
                                                                      controller
                                                                          .clearHoldReasonField();
                                                                      controller.updateTaskStatus(
                                                                          index,
                                                                          commonString
                                                                              .radioBtnFinish,
                                                                          holdReason: controller
                                                                              .holdReason
                                                                              .value);

                                                                      primaryToast(
                                                                          msg:
                                                                              'Task has been updated successfully!');
                                                                      /*     ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        const SnackBar(
                                                                          content:
                                                                              Text('Task has been updated successfully!'),
                                                                          duration:
                                                                              Duration(seconds: 2),
                                                                        ),
                                                                      );*/
                                                                      Get.back();
                                                                      log("==>> Task finish time updated");
                                                                    },
                                                                    deleteButtonColor:
                                                                        AppColors
                                                                            .primarycolor,
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              primaryToast(
                                                                  msg:
                                                                      "This task is already finished. You cannot restart or hold it.");
                                                            }
                                                            return;
                                                          }
                                                          if (task.status ==
                                                              null) {
                                                            if (value ==
                                                                commonString
                                                                    .statusPending) {
                                                              controller
                                                                  .clearHoldReasonField();
                                                              controller.updateTaskStatus(
                                                                  index,
                                                                  commonString
                                                                      .radioBtnStart,
                                                                  holdReason:
                                                                      controller
                                                                          .holdReason
                                                                          .value);
                                                              primaryToast(
                                                                  msg:
                                                                      "Task has been started successfully!");
                                                              log("===>> Task Started");
                                                            } else {
                                                              primaryToast(
                                                                  msg:
                                                                      "Please start the task first before holding or finishing.");
                                                            }
                                                            return;
                                                          }

                                                          if (value ==
                                                              commonString
                                                                  .radioBtnFinish) {
                                                            controller
                                                                .confirmFinishTask(
                                                                    index);
                                                            primaryToast(
                                                                msg:
                                                                    "Task has been finished successfully!");
                                                            log("===>>> Task finished");
                                                            return;
                                                          }

                                                          if (value ==
                                                              commonString
                                                                  .statusPending) {
                                                            if (task.holdTime !=
                                                                null) {
                                                              controller
                                                                  .clearHoldReasonField();
                                                              log("==>>holdReason::${controller.holdReason.value}");
                                                              controller.updateTaskStatus(
                                                                  index,
                                                                  commonString
                                                                      .radioBtnStart,
                                                                  holdReason:
                                                                      controller
                                                                          .holdReason
                                                                          .value);
                                                              primaryToast(
                                                                  msg:
                                                                      "Task has been restarted successfully!");
                                                              log("===>> Task Restarted");
                                                            } else if (task
                                                                    .startTime ==
                                                                null) {
                                                              controller
                                                                  .clearHoldReasonField();
                                                              controller.updateTaskStatus(
                                                                  index,
                                                                  commonString
                                                                      .radioBtnStart,
                                                                  holdReason:
                                                                      controller
                                                                          .holdReason
                                                                          .value);
                                                              primaryToast(
                                                                  msg:
                                                                      "Task has been started successfully!");
                                                              log("===>> Task Started");
                                                            } else {
                                                              primaryToast(
                                                                  msg:
                                                                      "You have already started this task.");
                                                            }
                                                          } else if (value ==
                                                              commonString
                                                                  .statusHold) {
                                                            controller
                                                                .clearHoldReasonField();
                                                            controller
                                                                .holdReasonController
                                                                .value
                                                                .text = task
                                                                    .reasonForHold ??
                                                                '';
                                                            controller
                                                                    .holdReason
                                                                    .value =
                                                                task.reasonForHold ??
                                                                    '';

                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (context) {
                                                                return rejectionLeaveDialog(
                                                                  title:
                                                                      "Hold Task",
                                                                  hintText:
                                                                      "Enter reason for holding",
                                                                  onChanged:
                                                                      (p0) {
                                                                    controller
                                                                        .holdReason
                                                                        .value = p0;
                                                                  },
                                                                  cancelOnTap:
                                                                      () {
                                                                    controller
                                                                        .clearHoldReasonField();
                                                                    controller.updateTaskStatus(
                                                                        index,
                                                                        commonString
                                                                            .radioBtnHold,
                                                                        holdReason: controller
                                                                            .holdReason
                                                                            .value);
                                                                    Get.back();
                                                                  },
                                                                  controller:
                                                                      controller
                                                                          .holdReasonController
                                                                          .value,
                                                                  submitOnTap:
                                                                      () {
                                                                    if (controller
                                                                        .holdReason
                                                                        .value
                                                                        .isNotEmpty) {
                                                                      controller.updateTaskStatus(
                                                                          index,
                                                                          commonString
                                                                              .radioBtnHold,
                                                                          holdReason: controller
                                                                              .holdReason
                                                                              .value);
                                                                      Get.back();
                                                                      primaryToast(
                                                                          msg:
                                                                              "Task is now on hold.");
                                                                      log("Task Status: Hold, Reason: ${controller.holdReason.value}");
                                                                    } else {
                                                                      primaryToast(
                                                                          msg:
                                                                              "Please enter a reason");
                                                                    }
                                                                    controller
                                                                        .clearHoldReasonField();
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                        itemBuilder: (context) {
                                                          List<
                                                                  PopupMenuItem<
                                                                      String>>
                                                              menuItems = [];
                                                          print(
                                                              "task.status: '${task.status}'");
                                                          print(
                                                              "commonString.statusPending: '${commonString.statusPending}'");

                                                          // ✅ When status is Pending, only show "Start"
                                                          if (task.status ==
                                                              null) {
                                                            return [
                                                              PopupMenuItem(
                                                                value: commonString
                                                                    .statusPending,
                                                                child:
                                                                    commonPopupBtn(
                                                                  lottie: AppLottie
                                                                      .startTask,
                                                                  label: commonString
                                                                      .radioBtnStart,
                                                                ),
                                                              ),
                                                            ];
                                                          }

                                                          // 🟡 Show only "Start" when task is on hold
                                                          if (task.status ==
                                                              commonString
                                                                  .statusHold) {
                                                            menuItems.add(
                                                              PopupMenuItem(
                                                                value: commonString
                                                                    .statusPending,
                                                                child:
                                                                    commonPopupBtn(
                                                                  lottie: AppLottie
                                                                      .startTask,
                                                                  label: commonString
                                                                      .radioBtnStart,
                                                                ),
                                                              ),
                                                            );
                                                            return menuItems;
                                                          }

                                                          // 🟢 Add "Start" if task is not already started
                                                          if (task.status !=
                                                              commonString
                                                                  .radioBtnStart) {
                                                            menuItems.add(
                                                              PopupMenuItem(
                                                                value: commonString
                                                                    .statusPending,
                                                                child:
                                                                    commonPopupBtn(
                                                                  lottie: AppLottie
                                                                      .startTask,
                                                                  label: commonString
                                                                      .radioBtnStart,
                                                                ),
                                                              ),
                                                            );
                                                          }

                                                          // 🔵 Add "Hold"
                                                          menuItems.add(
                                                            PopupMenuItem(
                                                              value: commonString
                                                                  .statusHold,
                                                              child:
                                                                  commonPopupBtn(
                                                                lottie: AppLottie
                                                                    .holdtask,
                                                                label: commonString
                                                                    .radioBtnHold,
                                                              ),
                                                            ),
                                                          );

                                                          // 🔴 Add "Finish" if not already finished
                                                          if (task.status !=
                                                              commonString
                                                                  .radioBtnFinish) {
                                                            menuItems.add(
                                                              PopupMenuItem(
                                                                value: commonString
                                                                    .radioBtnFinish,
                                                                child:
                                                                    commonPopupBtn(
                                                                  lottie: AppLottie
                                                                      .finishTask,
                                                                  label: commonString
                                                                      .radioBtnFinish,
                                                                ),
                                                              ),
                                                            );
                                                          }

                                                          return menuItems;
                                                        },

                                                        /*   itemBuilder: (context) {
                                                          List<
                                                                  PopupMenuItem<
                                                                      String>>
                                                              menuItems = [];

                                                          // Show only "Start" when task is on hold
                                                          if (task.status ==
                                                              commonString
                                                                  .statusHold) {
                                                            menuItems.add(
                                                              PopupMenuItem(
                                                                value: commonString
                                                                    .statusPending,
                                                                child:
                                                                    commonPopupBtn(
                                                                  lottie: AppLottie
                                                                      .startTask,
                                                                  label: commonString
                                                                      .radioBtnStart,
                                                                ),
                                                              ),
                                                            );
                                                            return menuItems;
                                                          }

                                                          // Add "Start" if task is not already started
                                                          if (task.status !=
                                                              commonString
                                                                  .radioBtnStart) {
                                                            menuItems.add(
                                                              PopupMenuItem(
                                                                value: commonString
                                                                    .statusPending,
                                                                child:
                                                                    commonPopupBtn(
                                                                  lottie: AppLottie
                                                                      .startTask,
                                                                  label: commonString
                                                                      .radioBtnStart,
                                                                ),
                                                              ),
                                                            );
                                                          }

                                                          // Add "Hold"
                                                          menuItems.add(
                                                            PopupMenuItem(
                                                              value: commonString
                                                                  .statusHold,
                                                              child:
                                                                  commonPopupBtn(
                                                                lottie: AppLottie
                                                                    .holdtask,
                                                                label: commonString
                                                                    .radioBtnHold,
                                                              ),
                                                            ),
                                                          );

                                                          // Add "Finish" if task is not already finished
                                                          if (task.status !=
                                                              commonString
                                                                  .radioBtnFinish) {
                                                            menuItems.add(
                                                              PopupMenuItem(
                                                                value: commonString
                                                                    .radioBtnFinish,
                                                                child:
                                                                    commonPopupBtn(
                                                                  lottie: AppLottie
                                                                      .finishTask,
                                                                  label: commonString
                                                                      .radioBtnFinish,
                                                                ),
                                                              ),
                                                            );
                                                          }

                                                          return menuItems;
                                                        },*/

                                                        child: Container(
                                                            width:
                                                                28.widthBox(),
                                                            decoration:
                                                                BoxDecoration(
                                                              // color: Colors.white,

                                                              color: task.status ==
                                                                      null
                                                                  ? AppColors
                                                                      .stOrange
                                                                      .withOpacity(
                                                                          0.1)
                                                                  : task.status ==
                                                                          commonString
                                                                              .radioBtnStart
                                                                      ? AppColors
                                                                          .primarycolor
                                                                          .withOpacity(
                                                                              0.1)
                                                                      : task.status ==
                                                                              commonString
                                                                                  .radioBtnHold
                                                                          ? AppColors.stRed.withOpacity(
                                                                              0.1)
                                                                          : AppColors
                                                                              .green
                                                                              .withOpacity(0.1),
                                                              border: Border.all(
                                                                  color: task.status == null
                                                                      ? AppColors.stOrange
                                                                      : task.status == commonString.radioBtnStart
                                                                          ? AppColors.primarycolor
                                                                          : task.status == commonString.radioBtnHold
                                                                              ? AppColors.stRed
                                                                              : AppColors.green),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 5,
                                                                        top: 3,
                                                                        bottom:
                                                                            3),
                                                                child: Row(
                                                                    children: [
                                                                      Lottie.asset(
                                                                          task.status == null
                                                                              ? AppLottie.hourglass
                                                                              : task.status == commonString.radioBtnStart
                                                                                  ? AppLottie.startTask
                                                                                  : task.status == commonString.radioBtnHold
                                                                                      ? AppLottie.holdtask
                                                                                      : AppLottie.finishTask,
                                                                          height: 6.widthBox(),
                                                                          width: 6.widthBox()),
                                                                      Expanded(
                                                                          child:
                                                                              Center(
                                                                        child: Text(
                                                                            task.status == null
                                                                                ? "Pending"
                                                                                : task.status!,
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: poppinsStyle(
                                                                              fontSize: 12,
                                                                              color: task.status == null
                                                                                  ? AppColors.stOrange
                                                                                  : task.status == commonString.radioBtnStart
                                                                                      ? AppColors.primarycolor
                                                                                      : task.status == commonString.radioBtnHold
                                                                                          ? AppColors.stRed
                                                                                          : AppColors.green,
                                                                              fontWeight: FontWeight.w600,
                                                                            )),
                                                                      )),
                                                                      Icon(
                                                                        Icons
                                                                            .more_vert,
                                                                        color: task.status ==
                                                                                null
                                                                            ? AppColors.stOrange
                                                                            : task.status == commonString.radioBtnStart
                                                                                ? AppColors.primarycolor
                                                                                : task.status == commonString.radioBtnHold
                                                                                    ? AppColors.stRed
                                                                                    : Colors.transparent,
                                                                        size:
                                                                            20,
                                                                      )
                                                                    ])))),
                                                  ),
                                                )
                                              ]),
                                        ),
                                        commonDivider(),
                                        allTaskText(
                                            icon: Icons.task_alt,
                                            label: "Task",
                                            task: task.task),
                                        Visibility(
                                          visible: task.reasonForHold != null &&
                                              task.reasonForHold!.isNotEmpty,
                                          child: 5.height,
                                        ),
                                        Visibility(
                                          visible: task.reasonForHold != null &&
                                              task.reasonForHold!.isNotEmpty,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              allTaskText(
                                                  icon: Icons
                                                      .info_outline_rounded,
                                                  label: "HR",
                                                  task:
                                                      "${task.reasonForHold}"),
                                              5.height,
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: GestureDetector(
                                                  child:
                                                      commonEditBtnUserSide(),
                                                  onTap: () {
                                                    controller
                                                            .holdReasonController
                                                            .value
                                                            .text =
                                                        task.reasonForHold!;
                                                    controller
                                                            .holdReason.value =
                                                        task.reasonForHold!;
                                                    log("holdReasonController==>>${controller.holdReasonController.value.text}");
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return rejectionLeaveDialog(
                                                          title:
                                                              "Edit Hold Task Reason",
                                                          hintText:
                                                              "Enter new reason",
                                                          onChanged: (p0) {
                                                            controller
                                                                .holdReason
                                                                .value = p0;

                                                            log("==>>${controller.holdReason.value}");
                                                          },
                                                          cancelOnTap: () {
                                                            Get.back();
                                                            controller
                                                                .clearHoldReasonField();
                                                          },
                                                          controller: controller
                                                              .holdReasonController
                                                              .value,
                                                          submitOnTap: () {
                                                            log("Hold Reason before update: ${controller.holdReason.value}");

                                                            if (controller
                                                                .holdReason
                                                                .value
                                                                .isNotEmpty) {
                                                              controller
                                                                  .updateTaskStatus(
                                                                index,
                                                                commonString
                                                                    .radioBtnHold,
                                                                holdReason:
                                                                    controller
                                                                        .holdReason
                                                                        .value,
                                                              );
                                                              log("holdReason==>${controller.holdReason.value}");

                                                              Get.back();
                                                              primaryToast(
                                                                  msg:
                                                                      "Hold Reason edit SuccessFully");
                                                              log("Task Status: ${task.status}, Reason: ${controller.holdReason.value}");
                                                            } else {
                                                              controller
                                                                  .clearHoldReasonField();
                                                              controller
                                                                  .updateTaskStatus(
                                                                index,
                                                                commonString
                                                                    .radioBtnHold,
                                                                holdReason:
                                                                    controller
                                                                        .holdReason
                                                                        .value,
                                                              );
                                                              Get.back();
                                                            }
                                                            controller
                                                                .clearHoldReasonField();
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        5.height,
                                      ],
                                    )));
                          }))
            ])));
  }
}
