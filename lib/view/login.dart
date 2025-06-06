import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/common/logincommon.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/view/user/bottom_nav_emp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/userdashboard_controller.dart';
import 'admin_side/bottom_nav_admin.dart';
import 'admin_side/edit_user/employeeform.dart';
import 'forgotpasswordscreen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserDashBoardController userDashBoardController =
      Get.put(UserDashBoardController());
  List<File> getUploadedDocsFromData(Map<String, dynamic> employeeData) {
    List<File> uploadedDocs = [];
    if (employeeData['proof'] != null) {
      for (String path in employeeData['proof']) {
        uploadedDocs.add(File(path));
      }
    }
    return uploadedDocs;
  }

  Map<String, dynamic>? employeeData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchEmployeeData();
  }

  Future<void> fetchUserOrAdminData(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// 1. Check for Admin
    String? adminListString = prefs.getString('adminData');
    log('adminListString${adminListString}');
    if (adminListString != null) {
      List<dynamic> adminList = jsonDecode(adminListString);
      for (var admin in adminList) {
        if (admin['email'] == email && admin['password'] == password) {
          await prefs.setString('currentAdmin', admin['srNo']);
          // await SharedPreferencesHelper.sharedPreferencesHelper
          //     .saveCurrentAdmin(admin['srNo']);
          // await SharedPreferencesHelper.sharedPreferencesHelper
          //     .saveLoginStatus(true);
          // await SharedPreferencesHelper.sharedPreferencesHelper
          //     .saveRole("admin");
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('role', 'admin');
          log('Logged in as admin, SR No: ${admin['srNo']}');

          log('Logged in as admin');
          await userDashBoardController.fetchAdminData().then(
            (value) {
              Future.delayed(
                Duration(milliseconds: 0),
                () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavAdmin(initialIndex: 0)),
                  );
                },
              );
            },
          );
          // userDashBoardController.isLoading.value = false;

          return;
        }
      }
    }

    /// 2. Check for User
    String? employeeListString = prefs.getString('employeeData');
    if (employeeListString != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);
      for (var user in employeeList) {
        if (user['email'] == email && user['password'] == password) {
          // await SharedPreferencesHelper.sharedPreferencesHelper
          //     .saveCurrentUser(user['srNo']);
          // await SharedPreferencesHelper.sharedPreferencesHelper
          //     .saveLoginStatus(true);
          // await SharedPreferencesHelper.sharedPreferencesHelper
          //     .saveRole("user");
          await prefs.setString('loggedInUserSrNo', user['srNo']);
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('role', 'user');
          log('Logged in as user');
          userDashBoardController.fetchEmployeeData().then(
            (value) {
              Future.delayed(
                Duration(milliseconds: 0),
                () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BottomNavEmployee()),
                  );
                },
              );
            },
          );
          return;
        }
      }
    }

    primaryToast(msg: 'Invalid credentials');
  }

  // Future<void> fetchEmployeeData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // await prefs.setString('loggedInUserSrNo', employeeData!['srNo']);
  //
  //   String? employeeListString = prefs.getString('employeeData');
  //
  //   if (employeeListString != null) {
  //     List<dynamic> employeeList = jsonDecode(employeeListString);
  //
  //     employeeData = employeeList.firstWhere(
  //       (employee) => employee['email'] == mobileNumber,
  //       orElse: () => null,
  //     );
  //
  //     if (employeeData != null) {
  //       await prefs.setString('loggedInUserSrNo', employeeData!['srNo']);
  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }
  Future<void> fetchEmployeeData(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeListString = prefs.getString('employeeData');

    if (employeeListString != null) {
      List<dynamic> employeeList = jsonDecode(employeeListString);

      employeeData = employeeList.firstWhere(
        (employee) =>
            employee['email'] == email && employee['password'] == password,
        orElse: () => null,
      );

      if (employeeData != null) {
        await SharedPreferencesHelper.sharedPreferencesHelper
            .saveCurrentUser(employeeData!['srNo']);
        // await prefs.setString('loggedInUserSrNo', employeeData!['srNo']);
      }
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordVisible = true;
  String? mobileNumber;
  String? password;
  bool validateAllFields() {
    String email = mobileController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty) {
      primaryToast(msg: 'Please enter your email');
      return false;
    }

    RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$');
    if (!emailRegExp.hasMatch(email)) {
      primaryToast(msg: 'Invalid email format');
      return false;
    }

    if (password.isEmpty) {
      primaryToast(msg: 'Please enter your password');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return showExitConfirmationDialog(
                  noOnTap: () {
                    Get.back();
                  },
                  yesOnTap: () {
                    SystemNavigator.pop();
                  },
                );
              },
            );

            return false;
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: 20.horizontal,
                  child: Form(
                    key: _formKey,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          20.height,
                          // SizedBox(
                          //   height: 8.hp(context),
                          // ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: logintext(text: "Login here"),
                            ),
                          ),
                          25.height,
                          Text(
                            textAlign: TextAlign.center,
                            "Welcome back! You’ve\nbeen missed!",
                            style: poppinsStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 17),
                          ),
                          40.height,
                          logintextfiled(
                            controller: mobileController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              }
                              RegExp emailRegExp = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$');
                              if (!emailRegExp.hasMatch(value)) {
                                return 'Invalid email format';
                              }

                              return null;
                            },
                            text: "Email ID",
                            onChanged: (value) {
                              mobileNumber = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          20.height,
                          logintextfiled(
                            controller: passwordController,
                            suffixIcon: GestureDetector(
                                //iconSize: 15,
                                onTap: () {
                                  passwordVisible = !passwordVisible;
                                  setState(() {});
                                },
                                child: visibilityIcon(
                                  icon: passwordVisible == true
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                )),
                            text: 'Enter Password',
                            onChanged: (value) {
                              password = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            obscureText: passwordVisible,
                          ),
                          const SizedBox(height: 10),

                          Align(
                            alignment: FractionalOffset.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => ForgotPasswordScreen());
                              },
                              child: Container(
                                // color: AppColors.red,
                                child: Padding(
                                  padding: 5.vertical,
                                  child: Text(
                                    'Forgot Your Password?',
                                    style: poppinsStyle(
                                      color: AppColors.primarycolor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          primarybutton(
                            text: "Sign In",
                            onPressed: () async {
                              log("Mobile Number: $mobileNumber");
                              log("Password: $password");
                              if (!validateAllFields()) return;
                              String emailInput = mobileController.text.trim();
                              String passwordInput =
                                  passwordController.text.trim();
                              await fetchUserOrAdminData(
                                  emailInput, passwordInput);
                              mobileController.clear();
                              passwordController.clear();
                              // }
                            },
                          ),
                          30.height,
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                height: 1,
                                decoration:
                                    BoxDecoration(color: AppColors.textcolor),
                              )),
                              10.width,
                              commontextlogin(
                                text: "Or continue with",
                                color: AppColors.textcolor,
                              ),
                              10.width,
                              Expanded(
                                  child: Container(
                                height: 1,
                                decoration:
                                    BoxDecoration(color: AppColors.textcolor),
                              )),
                            ],
                          ),
                          20.height,

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              commontextlogin(
                                text: "Don't have an account?",
                                color: AppColors.primarycolor,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                      () => Emoployeeform(
                                            label: 'Admin',
                                          ),
                                      transition: Transition.noTransition,
                                      duration: Duration(milliseconds: 300));
                                },
                                child: commontextlogin(
                                  text: "Admin Register",
                                  color: AppColors.green,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: userDashBoardController.isLoading.value == true,
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CupertinoActivityIndicator()),
              ),
            ))
      ],
    );
  }
}

class SharedPreferencesHelper {
  SharedPreferencesHelper._();
  static SharedPreferencesHelper sharedPreferencesHelper =
      SharedPreferencesHelper._();
  var currentAdminKey = 'currentAdmin';
  var currentUserKey = 'loggedInUserSrNo';
  var isLoggedIn = 'isLoggedIn';
  var role = 'role';
  var employeeData = 'employeeData';
  var adminData = 'adminData';

  /// current admin
  Future<void> saveCurrentAdmin(String adminSrNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(currentAdminKey, adminSrNo);
  }

  Future<String?> getCurrentAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentAdminKey);
  }

  /// current user
  Future<void> saveCurrentUser(String adminSrNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(currentUserKey, adminSrNo);
  }

  Future<String?> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentUserKey);
  }

  ///set login status
  Future<void> saveLoginStatus(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedIn, value);
  }

  Future<bool?> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedIn);
  }

  /// set role
  Future<void> saveRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(role, role);
  }

  Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(role);
  }

  //save employee data
  Future<void> saveEmployee(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(employeeData, data);
  }

  Future<String?> getEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(employeeData);
    // return prefs.getString(role);
  }

  //save admin data
  Future<void> saveAdmin(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(adminData, data);
  }

  Future<String?> getAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(adminData);
    // return prefs.getString(role);
  }
}

var adminSrNo = '';
