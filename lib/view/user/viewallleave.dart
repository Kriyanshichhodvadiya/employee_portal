import 'dart:developer';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../controller/leavecontroller.dart';

class ViewAllLeave extends StatefulWidget {
  @override
  State<ViewAllLeave> createState() => _ViewAllLeaveState();
}

class _ViewAllLeaveState extends State<ViewAllLeave> {
  LeaveController leaveController = Get.put(LeaveController());
  @override
  void initState() {
    leaveController.loadLoggedInUserSrNo();
    leaveController.fetchLeaveRequests();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: appBar(
          title: 'All Leave',
          showBack: false,
          onTap: () {},
        ),
        floatingActionButton: commonFloatingBtn(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return Obx(
                  () => commonLeaveDialog(
                      title: "Apply For Leave",
                      controller: leaveController.reasonController.value,
                      onChanged: (p0) {
                        leaveController.reason.value = p0;
                      },
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'Please enter your Reason for Leave';
                        }
                        return null;
                      },
                      cancelOnTap: () {
                        Get.back();
                        leaveController.resetAddLeaveValue();
                      },
                      subMitOnTap: () {
                        Future.delayed(Duration(milliseconds: 300), () {
                          leaveController.addLeaveRequest();
                        });
                      },
                      Fromlabel: leaveController.startDate.value.isEmpty
                          ? 'Select Date'
                          : leaveController.startDate.value,
                      FromonTap: () {
                        leaveController.selectDate(context, true);
                      },
                      ToLabel: leaveController.endDate.value.isEmpty
                          ? 'Select Date'
                          : leaveController.endDate.value,
                      ToOnTap: () {
                        leaveController.selectDate(context, false);
                      }),
                );
              },
            );
          },
        ),
        body: Column(
          children: [
            10.height,
            Padding(
              padding: 16.horizontal,
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Obx(
                        () => commonMenuFilter(
                            onSelected: (p0) {
                              leaveController.updateStatusFilter(p0, false);
                            },
                            label: "${leaveController.statusFilter.value}"),
                      )),
                  Visibility(
                      visible: leaveController.statusFilter.value.isNotEmpty,
                      child: 5.width),
                  Expanded(
                    flex: 5,
                    child: Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: commonDateConForLeave(
                              label: leaveController.pickFilter.value.isEmpty
                                  ? 'Select Date'
                                  : leaveController.pickFilter.value,
                              onTap: () {
                                leaveController.selectFilterDate(
                                    context, false);
                              },
                            ),
                          ),
                          Visibility(
                              visible:
                                  leaveController.pickFilter.value.isNotEmpty,
                              child: 5.width),
                          Visibility(
                              visible:
                                  leaveController.pickFilter.value.isNotEmpty,
                              child: leaveFilterClearBtn(
                                onTap: () {
                                  leaveController.pickFilter.value = '';
                                  leaveController.fetchLeaveRequests();
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            10.height,
            Expanded(
              child: Obx(
                () {
                  if (leaveController.fetchData.isEmpty) {
                    return commonLottie();
                  }

                  return SlidableAutoCloseBehavior(
                    child: ListView.separated(
                      padding: 16.symmetric,
                      separatorBuilder: (context, index) => 10.height,
                      itemCount: leaveController.fetchData.length,
                      itemBuilder: (context, index) {
                        var leave = leaveController.fetchData[index];
                        leaveController.expantionTileLength(
                            leaveController.fetchData.length);

                        Widget leaveContainer = Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: leave.status == commonString.statusApproved
                                ? AppColors.stGreen
                                : leave.status == commonString.statusRejected
                                    ? AppColors.stRed
                                    : AppColors.stOrange,
                          ),
                          child: Padding(
                            padding: 5.onlyLeft,
                            child: Container(
                              decoration:
                                  commonDecoration(color: AppColors.white),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  dividerColor: Colors.transparent,
                                  iconTheme: IconThemeData(
                                    color: AppColors.hinttext,
                                  ),
                                ),
                                child: ExpansionTile(
                                  tilePadding: 10.horizontal,
                                  collapsedIconColor: AppColors.hinttext,
                                  iconColor: AppColors.hinttext,
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            employeeLeaveDate(
                                                label: 'From',
                                                date: leave.startDate),
                                            employeeLeaveDate(
                                                label: 'To',
                                                date: leave.endDate),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 24.widthBox(),
                                        decoration: BoxDecoration(
                                          color: leave.status ==
                                                  commonString.statusApproved
                                              ? AppColors.stGreen
                                                  .withOpacity(0.1)
                                              : leave.status ==
                                                      commonString
                                                          .statusRejected
                                                  ? AppColors.stRed
                                                      .withOpacity(0.1)
                                                  : AppColors.stOrange
                                                      .withOpacity(0.1),
                                          border: Border.all(
                                            color: leave.status ==
                                                    commonString.statusApproved
                                                ? AppColors.stGreen
                                                : leave.status ==
                                                        commonString
                                                            .statusRejected
                                                    ? AppColors.stRed
                                                    : AppColors.stOrange,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: 3.symmetric,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    leave.status,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: poppinsStyle(
                                                      fontSize: 12,
                                                      color: leave.status ==
                                                              commonString
                                                                  .statusApproved
                                                          ? AppColors.stGreen
                                                          : leave.status ==
                                                                  commonString
                                                                      .statusRejected
                                                              ? AppColors.stRed
                                                              : AppColors
                                                                  .stOrange,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  children: [
                                    Divider(
                                        color:
                                            AppColors.hinttext.withOpacity(0.1),
                                        height: 5),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          leaveDetailRow(
                                              label: "Applied Date",
                                              value: leave.appliedDateTime
                                                  .split(" ")[0]),
                                          leaveDetailRow(
                                              label: "Reason",
                                              value: leave.reason),
                                          Visibility(
                                            visible: leave.status ==
                                                commonString.statusRejected,
                                            child: leave.rejectionReason
                                                    .toString()
                                                    .isNotEmpty
                                                ? leaveDetailRow(
                                                    label:
                                                        "Rejection by Approval",
                                                    maxLines: 2,
                                                    value: leave.rejectionReason
                                                        .toString(),
                                                  )
                                                : Container(),
                                          ),
                                          Visibility(
                                            visible: leave.status ==
                                                commonString.statusPending,
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  leaveController.startDate
                                                      .value = leave.startDate;
                                                  leaveController.endDate
                                                      .value = leave.endDate;
                                                  leaveController
                                                      .reasonController
                                                      .value
                                                      .text = leave.reason;
                                                  leaveController.reason.value =
                                                      leave.reason;
                                                  log('leave.srNo==>>${leave.srNo}');

                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) {
                                                      return Obx(
                                                        () => commonLeaveDialog(
                                                            title: "Edit Leave",
                                                            controller:
                                                                leaveController
                                                                    .reasonController
                                                                    .value,
                                                            onChanged: (p0) {
                                                              leaveController
                                                                  .reason
                                                                  .value = p0;
                                                            },
                                                            validator: (p0) {
                                                              if (p0 == null ||
                                                                  p0.isEmpty) {
                                                                return 'Please enter your Reason for Leave';
                                                              }
                                                              return null;
                                                            },
                                                            cancelOnTap: () {
                                                              Get.back();
                                                              leaveController
                                                                  .resetAddLeaveValue();
                                                            },
                                                            subMitOnTap: () {
                                                              Future.delayed(
                                                                  Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  () {
                                                                log('leave.appliedDateTime${leave.appliedDateTime}');
                                                                leaveController.updateLeaveRequest(
                                                                    leaveId: leave
                                                                        .appliedDateTime,
                                                                    reason: leaveController
                                                                        .reason
                                                                        .value,
                                                                    startDate: leaveController
                                                                        .startDate
                                                                        .value,
                                                                    endDate: leaveController
                                                                        .endDate
                                                                        .value
                                                                    // leave.srNo,
                                                                    );

                                                                // Get.back();
                                                              });
                                                            },
                                                            Fromlabel: leaveController
                                                                    .startDate
                                                                    .value
                                                                    .isEmpty
                                                                ? 'Select Date'
                                                                : leaveController
                                                                    .startDate
                                                                    .value,
                                                            FromonTap: () {
                                                              leaveController
                                                                  .selectDate(
                                                                      context,
                                                                      true);
                                                            },
                                                            ToLabel: leaveController
                                                                    .endDate
                                                                    .value
                                                                    .isEmpty
                                                                ? 'Select Date'
                                                                : leaveController
                                                                    .endDate
                                                                    .value,
                                                            ToOnTap: () {
                                                              leaveController
                                                                  .selectDate(
                                                                      context,
                                                                      false);
                                                            }),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: commonEditBtnUserSide(),

                                                /*  Text(
                                                  'Edit',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primarycolor),
                                                  )*/
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                        return leave.status == commonString.statusPending
                            ? Slidable(
                                key: Key(leave.appliedDateTime),
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  extentRatio: 0.22,
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {},
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.transparent,
                                      label: '',
                                      flex: 1,
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        leaveController
                                            .deleteLeaveRequest(index);
                                      },
                                      padding: EdgeInsets.zero,
                                      backgroundColor: AppColors.red,
                                      foregroundColor: AppColors.white,
                                      icon: Icons.delete,
                                      borderRadius: BorderRadius.circular(10),
                                      label: 'Delete',
                                      flex: 6,
                                    ),
                                  ],
                                ),
                                child: leaveContainer,
                              )
                            : GestureDetector(
                                onHorizontalDragEnd: (details) {
                                  // Get.snackbar(
                                  //   '',
                                  //   'You can delete only pending leave requests.',
                                  //   duration: Duration(milliseconds: 1000),
                                  //   snackPosition: SnackPosition.BOTTOM,
                                  // );
                                  primaryToast(
                                    msg:
                                        "You can delete only pending leave requests.",
                                  );
                                },
                                child: leaveContainer,
                              ); // Return the normal container if not pending
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

Widget employeeLeaveDate({
  required label,
  required date,
}) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Text(
          label,
          maxLines: 1,
          // textAlign:
          //     TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: poppinsStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primarycolor),
        ),
      ),
      Text(
        ":",
        maxLines: 3,
        // textAlign:
        //     TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: poppinsStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primarycolor),
      ),
      10.width,
      Expanded(
        flex: 6,
        child: Text(
          date,
          maxLines: 3,
          // textAlign:
          //     TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: poppinsStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}

Widget commonLeaveDialog({
  required Fromlabel,
  required title,
  required controller,
  required void Function()? FromonTap,
  required void Function(String)? onChanged,
  required ToLabel,
  required void Function()? ToOnTap,
  required String? Function(String?)? validator,
  required void Function()? subMitOnTap,
  required void Function()? cancelOnTap,
}) {
  return Dialog(
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    insetPadding: 5.wp(Get.context!).horizontal,
    child: Padding(
      padding: 10.symmetric,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.height,
          Center(
            child: Text(
              title,
              style: poppinsStyle(
                  color: AppColors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
          ),
          commonDivider(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addLeaveLabel(label: "From Date"),
                    commonDateCon(label: Fromlabel, onTap: FromonTap),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addLeaveLabel(label: "To Date"),
                    commonDateCon(
                      label: ToLabel,
                      onTap: ToOnTap,
                    ),
                  ],
                ),
              ),
            ],
          ),
          addLeaveLabelHeight(),
          addLeaveLabel(label: "Reason for Leave"),
          commontextfield(
              onChanged: onChanged,
              controller: controller,
              maxLines: 3,
              text: "Enter reason...",
              validator: validator),
          20.height,
          Padding(
            padding: 4.hp(Get.context!).horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                alertButton(
                    buttonColor: AppColors.bordercolor,
                    label: "Cancel",
                    onPressed: cancelOnTap),
                10.width,
                alertButton(
                  label: "Submit",
                  buttonColor: AppColors.primarycolor,
                  fontColor: AppColors.white,
                  onPressed: subMitOnTap,
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget addLeaveLabel({required label}) {
  return Text(label,
      style: poppinsStyle(fontSize: 12, fontWeight: FontWeight.bold));
}

Widget addLeaveLabelHeight() {
  return 7.height;
}
