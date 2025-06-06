/*
import 'dart:convert';
import 'dart:developer';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/view/dashboard/admindashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Employeetask extends StatefulWidget {
  const Employeetask({super.key});

  @override
  State<Employeetask> createState() => _EmployeetaskState();
}

class _EmployeetaskState extends State<Employeetask> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController employeeidcontroller = TextEditingController();
  TextEditingController employeetaskcontroller = TextEditingController();

  String? fname;
  String? eid;
  String? etask;

  // Save the task data
  Future<void> saveTaskData(List<Map<String, String>> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedTasks = tasks.map((task) => jsonEncode(task)).toList();
    await prefs.setStringList('taskList', encodedTasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          "Task",
          style: poppinsStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: 20.horizontal,
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                20.height,
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 5,
                          offset: Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commontext(text: "Employee Name"),
                      5.height,
                      commontextfield(
                        controller: firstnamecontroller,
                        onChanged: (value) {
                          fname = value;
                        },
                        text: "Enter Employee name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your employee name';
                          }

                          return null;
                        },
                      ),
                      20.height,
                      commontext(text: "SrNo"),
                      5.height,
                      commontextfield(
                        keyboardType: TextInputType.number,
                        controller: employeeidcontroller,
                        onChanged: (value) {
                          eid = value;
                        },
                        text: "Enter SrNo",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your employee Id';
                          }

                          return null;
                        },
                      ),
                      20.height,
                      commontext(text: "Date"),
                      5.height,
                      Container(
                        width: double.maxFinite,
                        padding: 12.symmetric,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.black.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Text(
                              selectedDate != null
                                  ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                                  : 'No date selected',
                              style: poppinsStyle(
                                color: AppColors.hinttext,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => selectDate(context),
                              child: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.height,
                      commontext(text: "Employee Task"),
                      5.height,
                      commontextfield(
                        maxLines: 3,
                        controller: employeetaskcontroller,
                        onChanged: (value) {
                          etask = value;
                        },
                        text: "Employee Task",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter employee task';
                          }

                          return null;
                        },
                      ),
                      20.height,
                    ],
                  ),
                ),
                30.height,
                primarybutton(
                    text: "Submit",
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        fname = firstnamecontroller.text;
                        eid = employeeidcontroller.text;
                        etask = employeetaskcontroller.text;

                        Map<String, String> newTask = {
                          'name': fname!,
                          'id': eid!,
                          'date':
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          'task': etask!,
                        };
                        log("message : $newTask");

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        List<String> taskList =
                            prefs.getStringList('taskList') ?? [];

                        taskList.add(jsonEncode(newTask));

                        await saveTaskData(taskList.map((task) {
                          Map<String, String> taskMap =
                              Map<String, String>.from(jsonDecode(task));
                          return taskMap;
                        }).toList());

                        firstnamecontroller.clear();
                        employeeidcontroller.clear();
                        employeetaskcontroller.clear();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Task submitted successfully!')),
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
