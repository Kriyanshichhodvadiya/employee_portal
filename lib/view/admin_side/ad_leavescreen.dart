import 'dart:developer';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/leavecontroller.dart';

class AdminLeaveScreen extends StatefulWidget {
  @override
  State<AdminLeaveScreen> createState() => _AdminLeaveScreenState();
}

class _AdminLeaveScreenState extends State<AdminLeaveScreen> {
  LeaveController leaveController = Get.put(LeaveController());

  @override
  void initState() {
    super.initState();
    leaveController.filterLeaveRequestsForAdminSide();
    leaveController.getLoginSrNo();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      leaveController
          .expantionTileLength(leaveController.filteredLeaveForAdmin.length);
    });
    log("filteredLeaveForAdmin${leaveController.filteredLeaveForAdmin}");
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: appBar(title: 'Leave Requests', onTap: () {}, showBack: false),
        body: Column(children: [
          10.height,
          Padding(
              padding: 16.horizontal,
              child: Row(children: [
                Expanded(
                    flex: 3,
                    child: Obx(
                      () => commonMenuFilter(
                          onSelected: (p0) {
                            leaveController.updateStatusFilter(p0, true);
                          },
                          label: "${leaveController.statusFilter.value}"),
                    )),
                10.width,
                Expanded(
                    flex: 5,
                    child: Obx(() => Row(children: [
                          Expanded(
                              child: commonDateConForLeave(
                            label: leaveController.pickFilter.value.isEmpty
                                ? 'Select Date'
                                : leaveController.pickFilter.value,
                            onTap: () {
                              leaveController.selectFilterDate(context, true);
                            },
                          )),
                          Visibility(
                              visible:
                                  leaveController.pickFilter.value.isNotEmpty,
                              child: 10.width),
                          Visibility(
                              visible:
                                  leaveController.pickFilter.value.isNotEmpty,
                              child: leaveFilterClearBtn(
                                onTap: () {
                                  leaveController.pickFilter.value = '';
                                  leaveController
                                      .filterLeaveRequestsForAdminSide();
                                },
                              ))
                        ]))),
                // 10.width,
              ])),
          10.height,
          Expanded(child: Obx(() {
            return leaveController.filteredLeaveForAdmin.isEmpty
                ? commonLottie()
                : ListView.separated(
                    padding: 16.symmetric,
                    separatorBuilder: (context, index) => 10.height,
                    itemCount: leaveController.filteredLeaveForAdmin.length,
                    itemBuilder: (context, index) {
                      var leave = leaveController.filteredLeaveForAdmin[index];

                      return Container(
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
                                  decoration: commonDecoration(),
                                  child: Theme(
                                      data: Theme.of(context).copyWith(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                          tilePadding: EdgeInsets.only(
                                              left: 15, right: 10),
                                          title: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  leave.name.split(" ")[0],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: poppinsStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              PopupMenuButton<String>(
                                                  color: AppColors.white,
                                                  onSelected:
                                                      (String value) async {
                                                    if (value == "Rejected") {
                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (context) {
                                                            return rejectionLeaveDialog(
                                                                cancelOnTap:
                                                                    () {
                                                              leaveController
                                                                  .rejection
                                                                  .value = '';
                                                              leaveController
                                                                  .rejectionController
                                                                  .value
                                                                  .clear();
                                                              leaveController
                                                                  .updateLeaveStatus(
                                                                leave.srNo,
                                                                leave
                                                                    .appliedDateTime,
                                                                "Rejected",
                                                                reason:
                                                                    leaveController
                                                                        .rejection
                                                                        .value,
                                                              );
                                                              Get.back();
                                                            }, submitOnTap:
                                                                    () async {
                                                              if (leaveController
                                                                  .rejection
                                                                  .value
                                                                  .isNotEmpty) {
                                                                leaveController
                                                                    .updateLeaveStatus(
                                                                  leave.srNo,
                                                                  leave
                                                                      .appliedDateTime,
                                                                  "Rejected",
                                                                  reason: leaveController
                                                                      .rejection
                                                                      .value,
                                                                );
                                                                leaveController
                                                                    .rejection
                                                                    .value = '';
                                                                leaveController
                                                                    .rejectionController
                                                                    .value
                                                                    .clear();
                                                                Get.back();
                                                              } else {
                                                                primaryToast(
                                                                    msg:
                                                                        "Please Enter Rejection Reason");
                                                              }
                                                            });
                                                          });
                                                    } else {
                                                      leaveController
                                                          .rejectionController
                                                          .value
                                                          .clear();
                                                      log("leaveController.rejection.value:==>>${leaveController.rejection.value}");

                                                      leaveController
                                                          .updateLeaveStatus(
                                                        leave.srNo,
                                                        leave.appliedDateTime,
                                                        value,
                                                        reason: '',
                                                      );
                                                    }
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder: (context) {
                                                    List<PopupMenuItem<String>>
                                                        menuItems = [];

                                                    // If status is "Rejected", show only "Approved"
                                                    if (leave.status ==
                                                        commonString
                                                            .statusRejected) {
                                                      menuItems.add(
                                                        PopupMenuItem(
                                                            value: commonString
                                                                .statusApproved,
                                                            child: commonLeaveStatus(
                                                                label: commonString
                                                                    .statusApproved,
                                                                icon:
                                                                    Icons.check,
                                                                color: AppColors
                                                                    .green)),
                                                      );
                                                      return menuItems;
                                                    }

                                                    // If status is NOT "Approved" and NOT "Pending", show "Pending"
                                                    if (leave.status !=
                                                            commonString
                                                                .statusApproved &&
                                                        leave.status !=
                                                            commonString
                                                                .statusPending) {
                                                      menuItems.add(
                                                        PopupMenuItem(
                                                            value: commonString
                                                                .statusPending,
                                                            child: commonLeaveStatus(
                                                                label: commonString
                                                                    .statusPending,
                                                                icon:
                                                                    Icons.check,
                                                                color: AppColors
                                                                    .green)),
                                                      );
                                                    }

                                                    // Show "Approved" if not current status
                                                    if (leave.status !=
                                                        commonString
                                                            .statusApproved) {
                                                      menuItems.add(
                                                        PopupMenuItem(
                                                            value: commonString
                                                                .statusApproved,
                                                            child: commonLeaveStatus(
                                                                label: commonString
                                                                    .statusApproved,
                                                                icon:
                                                                    Icons.check,
                                                                color: AppColors
                                                                    .green)),
                                                      );
                                                    }

                                                    // Show "Rejected" if not current status
                                                    if (leave.status !=
                                                        commonString
                                                            .statusRejected) {
                                                      menuItems.add(
                                                        PopupMenuItem(
                                                            value: commonString
                                                                .statusRejected,
                                                            child: commonLeaveStatus(
                                                                label: commonString
                                                                    .statusRejected,
                                                                icon:
                                                                    Icons.close,
                                                                color: AppColors
                                                                    .red)),
                                                      );
                                                    }

                                                    return menuItems;
                                                  },
                                                  child: Container(
                                                      width: 25.widthBox(),
                                                      decoration: BoxDecoration(
                                                        color: leave.status ==
                                                                commonString
                                                                    .statusApproved
                                                            ? AppColors.stGreen
                                                                .withOpacity(
                                                                    0.1)
                                                            : leave.status ==
                                                                    commonString
                                                                        .statusRejected
                                                                ? AppColors
                                                                    .stRed
                                                                    .withOpacity(
                                                                        0.1)
                                                                : AppColors
                                                                    .stOrange
                                                                    .withOpacity(
                                                                        0.1),
                                                        border: Border.all(
                                                          color: leave.status ==
                                                                  commonString
                                                                      .statusApproved
                                                              ? AppColors
                                                                  .stGreen
                                                              : leave.status ==
                                                                      commonString
                                                                          .statusRejected
                                                                  ? AppColors
                                                                      .stRed
                                                                  : AppColors
                                                                      .stOrange,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5,
                                                                  top: 3,
                                                                  bottom: 3),
                                                          child: Row(children: [
                                                            Expanded(
                                                                child: Center(
                                                              child: Text(
                                                                  leave.status,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      poppinsStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: leave.status ==
                                                                            commonString
                                                                                .statusApproved
                                                                        ? AppColors
                                                                            .stGreen
                                                                        : leave.status ==
                                                                                commonString.statusRejected
                                                                            ? AppColors.stRed
                                                                            : AppColors.stOrange,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )),
                                                            )),
                                                            Icon(
                                                              Icons.more_vert,
                                                              color: leave.status ==
                                                                      commonString
                                                                          .statusApproved
                                                                  ? AppColors
                                                                      .stGreen
                                                                  : leave.status ==
                                                                          commonString
                                                                              .statusRejected
                                                                      ? AppColors
                                                                          .stRed
                                                                      : AppColors
                                                                          .stOrange,
                                                              size: 20,
                                                            )
                                                          ]))))
                                            ],
                                          ),
                                          trailing: Obx(() => Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.hinttext
                                                      .withOpacity(0.1),
                                                  border: Border.all(
                                                    color: AppColors.hinttext
                                                        .withOpacity(0.8),
                                                  )),
                                              child: Icon(
                                                index <
                                                            leaveController
                                                                .expandedIndexes
                                                                .length &&
                                                        leaveController
                                                                .expandedIndexes[
                                                            index]
                                                    ? Icons.keyboard_arrow_up
                                                    : Icons.keyboard_arrow_down,
                                                color: AppColors.hinttext
                                                    .withOpacity(0.8),
                                                size: 20,
                                              ))),
                                          onExpansionChanged: (bool expanded) {
                                            leaveController
                                                .toggleExpansion(index);
                                            leaveController.expandedIndexes
                                                .refresh();
                                          },
                                          children: [
                                            Divider(
                                              color: AppColors.hinttext
                                                  .withOpacity(0.1),
                                              height: 5,
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      leaveDetailRow(
                                                          label: "Applied Date",
                                                          maxLines: 2,
                                                          value: leave
                                                              .appliedDateTime
                                                              .split(" ")[0]),
                                                      leaveDetailRow(
                                                          label: "From",
                                                          value:
                                                              leave.startDate),
                                                      leaveDetailRow(
                                                          label: "To",
                                                          value: leave.endDate),
                                                      leaveDetailRow(
                                                          label: "Reason",
                                                          value: leave.reason),
                                                      Visibility(
                                                          visible: leave
                                                                      .rejectionReason !=
                                                                  null &&
                                                              leave
                                                                  .rejectionReason
                                                                  .toString()
                                                                  .isNotEmpty,
                                                          child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      leaveDetailRow(
                                                                    flex: 3,
                                                                    labelFlex:
                                                                        2,
                                                                    maxLines: 2,
                                                                    label:
                                                                        "Rejection by Approval",
                                                                    value: leave
                                                                        .rejectionReason
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                                IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .edit,
                                                                        size: 3.hp(
                                                                            context),
                                                                        color: AppColors
                                                                            .grey),
                                                                    onPressed:
                                                                        () {
                                                                      leaveController
                                                                          .rejectionController
                                                                          .value
                                                                          .text = leave.rejectionReason.toString();

                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          barrierDismissible:
                                                                              false,
                                                                          builder:
                                                                              (context) {
                                                                            return rejectionLeaveDialog(cancelOnTap:
                                                                                () {
                                                                              Get.back();
                                                                            }, submitOnTap:
                                                                                () {
                                                                              if (leaveController.rejection.value.isNotEmpty) {
                                                                                leaveController.updateLeaveStatus(
                                                                                  leave.srNo,
                                                                                  leave.appliedDateTime,
                                                                                  leave.status,
                                                                                  reason: leaveController.rejection.value,
                                                                                );
                                                                                Get.back();
                                                                              } else {
                                                                                primaryToast(msg: "Please enter a valid reason");
                                                                              }
                                                                            });
                                                                          });
                                                                    })
                                                              ]))
                                                    ]))
                                          ])))));
                    },
                  );
          }))
        ]));
  }
}

Widget commonLeaveStatus({required label, required icon, required color}) {
  return Row(
    children: [
      Container(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 12,
          ),
        ),
      ),
      5.width,
      Text(
        label,
        style: poppinsStyle(),
      ),
    ],
  );
}
