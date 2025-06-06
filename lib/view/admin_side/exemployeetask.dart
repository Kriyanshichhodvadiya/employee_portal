import 'dart:convert';
import 'dart:developer';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/controller/employeetask_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/task_model.dart';
import 'bottom_nav_admin.dart';
import 'company_profile/co_profile_form.dart';

class Exemployeetask extends StatefulWidget {
  const Exemployeetask({super.key});

  @override
  State<Exemployeetask> createState() => _ExemployeetaskState();
}

class _ExemployeetaskState extends State<Exemployeetask> {
  EmployeeTaskController controller = Get.put(EmployeeTaskController());
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // String? dropdownvalue;
  // String? eid;
  // String? etask;

  // List<String> employeeNames = [];
  // Map<String, String> employeeMap = {};

  // DateTime selectedDate = DateTime.now();

  // String selectedDate = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);
  //
  // TextEditingController employeeidcontroller = TextEditingController();
  // TextEditingController employeetaskcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.employeeData();
    ever(controller.employeeNames, (List<String> list) {
      if (list.isEmpty) {
        controller.dropdownvalue.value = '';
        controller.employeeidcontroller.value.text = '';
      }
    });
  }

  // Future<void> employeeData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? employeeData = prefs.getString('employeeData');
  //   if (employeeData != null) {
  //     List<dynamic> employeeList = jsonDecode(employeeData);
  //     setState(() {
  //       employeeNames = employeeList
  //           .map<String>((employee) => employee['firstName'])
  //           .toList();
  //       employeeMap = {
  //         for (var employee in employeeList)
  //           employee['firstName']: employee['srNo'].toString()
  //       };
  //
  //       if (employeeNames.isNotEmpty) {
  //         dropdownvalue = employeeNames.first;
  //         employeeidcontroller.text = employeeMap[dropdownvalue] ?? '';
  //       }
  //     });
  //   }
  // }

  // void updateSrno(String? employeeName) {
  //   setState(() {
  //     employeeidcontroller.text = employeeMap[employeeName] ?? '';
  //   });
  // }

  // Future<void> selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
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
  //   if (picked != null) {
  //     selectedDate = formatDate(picked, [dd, '/', mm, '/', yyyy]);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    bool edit = Get.arguments['edit'];
    log('edit==>>${edit}');
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBar(
        onTap: () {
          Get.back();
        },
        title: edit ? 'Update Task' : 'Add Task',
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Padding(
            padding: 15.symmetric,
            child: Column(
              children: [
                // 20.height,
                Container(
                  width: double.maxFinite,
                  padding: 10.symmetric,
                  decoration: commonDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commontext(text: "Employee Name"),
                      fieldBottomHeight(),
                      Obx(
                        () => DropdownButtonFormField<String>(
                          borderRadius: BorderRadius.circular(3),
                          value: controller.dropdownvalue.value,
                          isExpanded: true,
                          icon: fieldSuffixIcon(
                              color: edit == true
                                  ? Colors.transparent
                                  : AppColors.hinttext),
                          decoration: commonDropdownDeco(),
                          dropdownColor: AppColors.white,
                          items: controller.employeeNames.map((String name) {
                            return DropdownMenuItem(
                              value: name,
                              child: Text(
                                name,
                                style: poppinsStyle(color: AppColors.hinttext),
                              ),
                            );
                          }).toList(),
                          onChanged: edit == true
                              ? null
                              : (String? newValue) {
                                  setState(() {
                                    controller.dropdownvalue.value = newValue!;
                                    controller.updateSrno(newValue);
                                  });
                                },
                        ),
                      ),
                      labelHeight(),
                      commontext(text: "Employee ID"),
                      fieldBottomHeight(),
                      commontextfield(
                        focusColor: AppColors.black.withOpacity(0.2),
                        keyboardType: TextInputType.text,
                        controller: controller.employeeidcontroller.value,
                        onChanged: (value) {
                          controller.eid.value = value;
                        },
                        text: "Employee ID",
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your employee ID';
                          }
                          return null;
                        },
                      ),
                      labelHeight(),
                      commontext(text: "Date"),
                      fieldBottomHeight(),
                      Obx(
                        () => commonDateCon(
                          label: controller.selectedDate.value,
                          onTap: () {
                            controller.selectDate(context);
                          },
                        ),
                      ),
                      labelHeight(),
                      commontext(text: "Employee Task"),
                      fieldBottomHeight(),
                      commontextfield(
                        maxLines: 3,
                        controller: controller.employeetaskcontroller.value,
                        onChanged: (value) {
                          controller.etask.value = value;
                        },
                        text: "Employee Task",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter employee task';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                20.height,
                primarybutton(
                    text: edit == true ? "Update" : "Submit",
                    onPressed: edit == true
                        ? () async {
                            if (controller
                                .employeetaskcontroller.value.text.isEmpty) {
                              primaryToast(msg: "Please enter employee task.");
                              return;
                            }
                            // if (_formkey.currentState!.validate()) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? employeeDataString =
                                prefs.getString('employeeData');

                            if (employeeDataString != null) {
                              List<dynamic> employeeList =
                                  jsonDecode(employeeDataString);

                              for (var employee in employeeList) {
                                if (employee['srNo'] == controller.eid.value) {
                                  if (employee['taskRequests'] != null &&
                                      employee['taskRequests'].isNotEmpty) {
                                    int taskIndex =
                                        employee['taskRequests'].indexWhere(
                                      (task) =>
                                          task['task'] ==
                                              controller.oldTask.value &&
                                          task['appliedTime'] ==
                                              controller.oldAppliedDate.value,
                                    );

                                    if (taskIndex != -1) {
                                      // 🔹 Update the existing task instead of adding a new one
                                      employee['taskRequests'][taskIndex]
                                              ['date'] =
                                          controller.selectedDate.value;
                                      employee['taskRequests'][taskIndex]
                                          ['task'] = controller.etask.value;
                                    } else {
                                      log("Task not found for update.");
                                    }
                                  }
                                  break;
                                }
                              }
                              await prefs.setString(
                                  'employeeData', jsonEncode(employeeList));

                              log("Task updated successfully!");
                              controller.employeetaskcontroller.value.clear();
                              controller.oldTask.value = '';
                              controller.oldAppliedDate.value = '';

                              primaryToast(msg: 'Task updated successfully!');
                              Get.off(
                                  () => BottomNavAdmin(
                                        initialIndex: 1,
                                      ),
                                  transition: Transition.noTransition,
                                  duration: Duration(milliseconds: 300));
                              controller.employeeData();
                              // }
                            }
                          }
                        : () async {
                            if (controller
                                .employeetaskcontroller.value.text.isEmpty) {
                              primaryToast(msg: "Please enter employee task.");
                              return;
                            }
                            // if (_formkey.currentState!.validate()) {
                            controller.eid.value =
                                controller.employeeidcontroller.value.text;
                            controller.etask.value =
                                controller.employeetaskcontroller.value.text;
                            String currentDateTime =
                                DateTime.now().toIso8601String();

                            // Create new task data
                            TaskModel newTask = TaskModel(
                              employeeName: controller.dropdownvalue.value,
                              employeeLastName: controller
                                  .getLastNameBySrNo(controller.eid.value),
                              srNo: controller.eid.value,
                              appliedTime: currentDateTime,
                              task: controller.etask.value,
                              date: controller.selectedDate.value,
                            );

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            // Fetch the existing employee data
                            String? employeeDataString =
                                prefs.getString('employeeData');
                            if (employeeDataString != null) {
                              List<dynamic> employeeList =
                                  jsonDecode(employeeDataString);

                              // Find the employee by srNo
                              for (var employee in employeeList) {
                                if (employee['srNo'] == controller.eid.value) {
                                  // Append the new task
                                  employee['taskRequests'] ??= [];
                                  employee['taskRequests'].add(newTask);
                                  break;
                                }
                              }

                              // Save updated employee data back
                              await prefs.setString(
                                  'employeeData', jsonEncode(employeeList));
                            }

                            log("Task submitted: $newTask");

                            // Clear input fields
                            controller.employeetaskcontroller.value.clear();
                            primaryToast(msg: "Task submitted successfully!");
                            /*ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Task submitted successfully!'),
                              ),
                            );*/

                            // Navigate to BottomNavAdmin screen
                            Get.off(
                              () => BottomNavAdmin(initialIndex: 1),
                              transition: Transition.noTransition,
                              duration: Duration(milliseconds: 300),
                            );

                            // Refresh employee data after submission
                            controller.employeeData();
                          }
                    // },
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
