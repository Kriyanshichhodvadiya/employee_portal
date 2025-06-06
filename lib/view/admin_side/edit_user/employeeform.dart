import 'dart:developer';
import 'dart:io';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/config/images.dart';
import 'package:employeeform/controller/userdashboard_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart' as openFilex;

import '../../../common/dashboardcommon.dart';
import '../../../common/global_widget.dart';
import '../../../config/list.dart';
import '../../../controller/employeeformContro.dart';
import '../company_profile/co_profile_form.dart';

class Emoployeeform extends StatefulWidget {
  final String label;

  Emoployeeform({
    super.key,
    required this.label,
  });

  @override
  State<Emoployeeform> createState() => _EmoployeeformState();
}

class _EmoployeeformState extends State<Emoployeeform> {
  // AddEmployeeController addEmployeeController =
  EmployeeFormController employeeFormController =
      Get.put(EmployeeFormController());
  UserDashBoardController userDashBoardController =
      Get.put(UserDashBoardController());

  // String? fname;
  List<Map<String, dynamic>> item = [];

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  List<String> items = ['USA', 'India', 'Canada'];

  List<String> itemsbank = [
    'SBI',
    'Axis Bank',
    'ICICI Bank',
    'HDFC Bank',
    'Bank of Baroda'
  ];
  Future<void> openFile(File? file) async {
    if (file != null && await file.exists()) {
      try {
        openFilex.OpenResult result = await openFilex.OpenFilex.open(file.path);
        if (result.type != openFilex.ResultType.done) {
          primaryToast(msg: "Failed to open file: ${result.message}");
        }
      } catch (e) {
        primaryToast(msg: "Error opening file: $e");
      }
    } else {
      primaryToast(msg: "No file found to open.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        employeeFormController.resetValue();
        // employeeFormController.selectCountry();
        employeeFormController.resetCountryValue();
        return true;
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.white,
            appBar: appBar(
                onTap: () {
                  // employeeFormController.selectCountry();
                  employeeFormController.resetValue();
                  employeeFormController.resetCountryValue();
                  Get.back();
                },
                title: widget.label == "Admin"
                    ? 'Admin Details'
                    : 'Employee Details',
                actions: [
                  commonSaveButton(
                    onPressed: widget.label == "Admin"
                        ? () {
                            employeeFormController.AdminRegistration(
                                userDashBoardController);
                          }
                        : () {
                            employeeFormController.submitBtn();
                          },
                  ),
                ]),
            body: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fieldBottomHeight(),
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Obx(
                            () => Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: AppColors.black,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: employeeFormController
                                                .selectedImage.value !=
                                            null
                                        ? FileImage(employeeFormController
                                            .selectedImage.value!)
                                        : AssetImage(AppImages.attendance)
                                            as ImageProvider,
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: AppColors.white),
                                        child: Padding(
                                          padding: 20.symmetric,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  employeeFormController
                                                      .pickImageFromCamera(
                                                          source: ImageSource
                                                              .camera);
                                                },
                                                child: cameraBtn(
                                                  text: "Camera",
                                                  image: AppSvg.takephoto,
                                                ),
                                              ),
                                              20.width,
                                              GestureDetector(
                                                onTap: () async {
                                                  employeeFormController
                                                      .pickImageFromCamera(
                                                          source: ImageSource
                                                              .gallery);
                                                },
                                                child: cameraBtn(
                                                  text: "Gallery",
                                                  image: AppSvg.gallery,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: AppColors.black,
                                  size: 19,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    20.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: 15.horizontal,
                          child: Container(
                            // height: 950,
                            width: double.maxFinite,
                            // margin: const EdgeInsets.symmetric(
                            //     vertical: 10, horizontal: 20),
                            padding: const EdgeInsets.all(10),
                            decoration: commonDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: commonProfileLabel(
                                    label: "Personal information",
                                  ),
                                ),
                                commonDivider(),
                                commontext(text: "First Name"),
                                fieldBottomHeight(),
                                commontextfield(
                                  controller: employeeFormController
                                      .firstnamecontroller.value,
                                  onChanged: (value) {
                                    employeeFormController.fname.value = value;
                                  },
                                  text: "Enter First name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your First name';
                                    }

                                    return null;
                                  },
                                ),
                                labelHeight(),
                                commontext(text: "Last Name"),
                                fieldBottomHeight(),
                                commontextfield(
                                  controller: employeeFormController
                                      .lastnamecontroller.value,
                                  onChanged: (value) {
                                    employeeFormController.lname.value = value;
                                  },
                                  text: "Enter Last name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Last name';
                                    }

                                    return null;
                                  },
                                ),
                                labelHeight(),
                                commontext(text: "Birth Date"),
                                fieldBottomHeight(),
                                Obx(
                                  () => commonDateCon(
                                    label:
                                        "${employeeFormController.selectedDate.value.day.toString().padLeft(2, '0')}-"
                                        "${employeeFormController.selectedDate.value.month.toString().padLeft(2, '0')}-"
                                        "${employeeFormController.selectedDate.value.year}",
                                    onTap: () {
                                      employeeFormController
                                          .selectDate(context);
                                    },
                                  ),
                                ),
                                labelHeight(),
                                commontext(text: "Gender"),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 20.0,
                                    // left: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Obx(
                                        () => radioBtn(
                                            value: commonString.female,
                                            groupValue: employeeFormController
                                                .group.value,
                                            onChanged: (val) {
                                              employeeFormController
                                                  .group.value = val!;
                                            }),
                                      ),
                                      Text(
                                        "Female",
                                        style: poppinsStyle(),
                                      ),
                                      const Spacer(),
                                      Obx(() => radioBtn(
                                          value: commonString.male,
                                          groupValue: employeeFormController
                                              .group.value,
                                          onChanged: (val) {
                                            employeeFormController.group.value =
                                                val!;
                                          })),
                                      Text(
                                        "Male",
                                        style: poppinsStyle(),
                                      ),
                                      const Spacer(),
                                      Obx(() => radioBtn(
                                          value: commonString.other,
                                          groupValue: employeeFormController
                                              .group.value,
                                          onChanged: (val) {
                                            employeeFormController.group.value =
                                                val!;
                                          })),
                                      Text(
                                        "Other",
                                        style: poppinsStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                                labelHeight(),
                                commontext(text: "Aadhar"),
                                fieldBottomHeight(),
                                commontextfield(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(12),
                                  ],
                                  keyboardType: TextInputType.number,
                                  controller: employeeFormController
                                      .aadharcontroller.value,
                                  onChanged: (value) {
                                    employeeFormController.aadhar.value = value;
                                  },
                                  text: "Enter Aadhar",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Aadhar No';
                                    }

                                    return null;
                                  },
                                ),
                                labelHeight(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    commontext(text: "Email Id"),
                                    fieldBottomHeight(),
                                    commontextfield(
                                      text: "Email Id",
                                      controller: employeeFormController
                                          .emailcontroller.value,
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (value) {
                                        employeeFormController.email.value =
                                            value;
                                      },
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
                                    ),
                                    labelHeight(),
                                    commontext(text: "Mobile no 1"),
                                    fieldBottomHeight(),
                                    commontextfield(
                                      keyboardType: TextInputType.number,
                                      controller: employeeFormController
                                          .mobilenucontroller.value,
                                      onChanged: (value) {
                                        employeeFormController
                                            .mobileNumber.value = value;
                                      },
                                      text: "Enter Mobile no 1",
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter mobile no 1';
                                        }
                                        if (value.length != 10) {
                                          return 'Mobile number must be exactly 10 digits';
                                        }

                                        return null;
                                      },
                                    ),
                                    labelHeight(),
                                    commontext(text: "Mobile no 2"),
                                    fieldBottomHeight(),
                                    commontextfield(
                                      keyboardType: TextInputType.number,
                                      controller: employeeFormController
                                          .mobilenutwocontroller.value,
                                      onChanged: (value) {
                                        employeeFormController
                                            .mobileNumbertwo.value = value;
                                      },
                                      text: "Enter Mobile no 2",
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter mobile no 2';
                                        }
                                        if (value.length != 10) {
                                          return 'Mobile number must be exactly 10 digits';
                                        }

                                        return null;
                                      },
                                    ),
                                    labelHeight(),
                                    commontext(text: "Residential Address"),
                                    fieldBottomHeight(),
                                    commontextfield(
                                      maxLines: 3,
                                      controller: employeeFormController
                                          .addresscontroller.value,
                                      onChanged: (value) {
                                        employeeFormController.address.value =
                                            value;
                                      },
                                      text: "Enter Address",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your Address';
                                        }

                                        return null;
                                      },
                                    ),
                                    labelHeight(),
                                    commontext(text: "Select Country"),
                                    fieldBottomHeight(),
                                    Obx(() => commontextfield(
                                          readOnly: true,
                                          controller: employeeFormController
                                              .countryController.value,
                                          text: "Select Country",
                                          validator: (value) {
                                            // if (value == null ||
                                            //     value.isEmpty) {
                                            //   return 'Please select a country';
                                            // }
                                            // return null;
                                          },
                                          suffixIcon: fieldSuffixIcon(),
                                          onTap: () {
                                            employeeFormController
                                                .filteredCountryList
                                                .value = countries;
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return searchDialog(
                                                  searchField: commontextfield(
                                                    text: "Search Country...",
                                                    prefixIcon:
                                                        countrySearchBtn(),
                                                    onChanged: (value) {
                                                      employeeFormController
                                                              .countrySearch
                                                              .value =
                                                          value.toLowerCase();
                                                      employeeFormController
                                                              .filteredCountryList
                                                              .value =
                                                          countries
                                                              .where((country) => country
                                                                  .title
                                                                  .toLowerCase()
                                                                  .contains(value
                                                                      .toLowerCase()))
                                                              .toList();
                                                    },
                                                  ),
                                                  title: "Select Country",
                                                  listView: Obx(() {
                                                    return employeeFormController
                                                            .filteredCountryList
                                                            .isEmpty
                                                        ? Expanded(
                                                            child:
                                                                searchLottie())
                                                        : Expanded(
                                                            child: ListView
                                                                .builder(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              itemCount:
                                                                  employeeFormController
                                                                      .filteredCountryList
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final country =
                                                                    employeeFormController
                                                                            .filteredCountryList[
                                                                        index];
                                                                final originalIndex =
                                                                    countries.indexWhere((c) =>
                                                                        c.title ==
                                                                        country
                                                                            .title);

                                                                return searchDialogItem(
                                                                  title: country
                                                                      .title,
                                                                  onTap: () {
                                                                    employeeFormController.selectCountryOnTap(
                                                                        originalIndex:
                                                                            originalIndex,
                                                                        country:
                                                                            country);
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          );
                                                  }),
                                                );
                                              },
                                            ).whenComplete(() {
                                              employeeFormController
                                                  .countrySearch.value = '';
                                            });
                                          },
                                        )),
                                    labelHeight(),
                                    commontext(text: "Select State"),
                                    fieldBottomHeight(),
                                    Obx(() => commontextfield(
                                          readOnly: true,
                                          controller: employeeFormController
                                              .stateController.value,
                                          text: "Select State",
                                          suffixIcon: fieldSuffixIcon(),
                                          onTap: () {
                                            final selectedCountry = countries[
                                                employeeFormController
                                                    .selectedCountryIndex
                                                    .value];

                                            employeeFormController
                                                .filteredStateList
                                                .value = selectedCountry.states;

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return searchDialog(
                                                  searchField: commontextfield(
                                                    text: "Search State...",
                                                    prefixIcon:
                                                        countrySearchBtn(),
                                                    onChanged: (value) {
                                                      final lowerValue =
                                                          value.toLowerCase();
                                                      employeeFormController
                                                          .stateSearch
                                                          .value = lowerValue;

                                                      employeeFormController
                                                              .filteredStateList
                                                              .value =
                                                          selectedCountry.states
                                                              .where((state) => state
                                                                  .name
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      lowerValue))
                                                              .toList();
                                                    },
                                                  ),
                                                  title: "Select State",
                                                  listView: Obx(() {
                                                    final filteredStates =
                                                        employeeFormController
                                                            .filteredStateList;

                                                    return filteredStates
                                                            .isEmpty
                                                        ? Expanded(
                                                            child:
                                                                searchLottie())
                                                        : Expanded(
                                                            child: ListView
                                                                .builder(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 5),
                                                              itemCount:
                                                                  filteredStates
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final selectedState =
                                                                    filteredStates[
                                                                        index];
                                                                final originalIndex = selectedCountry
                                                                    .states
                                                                    .indexWhere((s) =>
                                                                        s.name
                                                                            .toLowerCase() ==
                                                                        selectedState
                                                                            .name
                                                                            .toLowerCase());

                                                                return searchDialogItem(
                                                                  title:
                                                                      selectedState
                                                                          .name,
                                                                  onTap: () {
                                                                    if (originalIndex !=
                                                                        -1) {
                                                                      employeeFormController
                                                                          .selectStateOnTap(
                                                                        selectedCountry:
                                                                            selectedCountry,
                                                                        selectedState:
                                                                            selectedState,
                                                                      );
                                                                    } else {
                                                                      print(
                                                                          'Error: selected state not found');
                                                                    }
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          );
                                                  }),
                                                );
                                              },
                                            ).whenComplete(() {
                                              employeeFormController
                                                  .stateSearch.value = '';
                                            });
                                          },
                                        )),
                                    labelHeight(),
                                    commontext(text: "Select City"),
                                    fieldBottomHeight(),
                                    Obx(() => commontextfield(
                                          readOnly: true,
                                          controller: employeeFormController
                                              .cityController.value,
                                          text: "Select City",
                                          suffixIcon: fieldSuffixIcon(),
                                          onTap: () {
                                            employeeFormController
                                                .filteredCityList
                                                .value = countries[
                                                    employeeFormController
                                                        .selectedCountryIndex
                                                        .value]
                                                .states[employeeFormController
                                                    .selectedStateIndex.value]
                                                .cities;

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return searchDialog(
                                                  searchField: commontextfield(
                                                    text: "Search City...",
                                                    prefixIcon:
                                                        countrySearchBtn(),
                                                    onChanged: (value) {
                                                      employeeFormController
                                                              .citySearch
                                                              .value =
                                                          value.toLowerCase();
                                                      employeeFormController
                                                          .filteredCityList
                                                          .value = countries[
                                                              employeeFormController
                                                                  .selectedCountryIndex
                                                                  .value]
                                                          .states[employeeFormController
                                                              .selectedStateIndex
                                                              .value]
                                                          .cities
                                                          .where((city) => city
                                                              .toLowerCase()
                                                              .contains(value
                                                                  .toLowerCase()))
                                                          .toList();
                                                    },
                                                  ),
                                                  title: "Select City",
                                                  listView: Obx(() {
                                                    return employeeFormController
                                                            .filteredCityList
                                                            .isEmpty
                                                        ? Expanded(
                                                            child:
                                                                searchLottie())
                                                        : Expanded(
                                                            child: ListView
                                                                .builder(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              itemCount:
                                                                  employeeFormController
                                                                      .filteredCityList
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final city =
                                                                    employeeFormController
                                                                            .filteredCityList[
                                                                        index];
                                                                return searchDialogItem(
                                                                  title: city,
                                                                  onTap: () {
                                                                    employeeFormController.selectCityOnTap(
                                                                        city:
                                                                            city,
                                                                        index:
                                                                            index);
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          );
                                                  }),
                                                );
                                              },
                                            ).whenComplete(() {
                                              employeeFormController
                                                  .citySearch.value = '';
                                            });
                                          },
                                        )),
                                    labelHeight(),
                                    commontext(text: "ZipCode"),
                                    fieldBottomHeight(),
                                    commontextfield(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(6),
                                        FilteringTextInputFormatter.digitsOnly,
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d{0,6}$')),
                                      ],
                                      controller: employeeFormController
                                          .zipCodeController.value,
                                      onChanged: (value) {
                                        employeeFormController.zipCode.value =
                                            value;
                                      },
                                      text: "Enter Zipcode",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter ZipCode';
                                        }
                                        if (value.length < 5 ||
                                            value.length > 6) {
                                          return 'Zip Code must be 5 or 6 digits';
                                        }
                                        return null;
                                      },
                                    ),
                                    labelHeight(),
                                    commontext(text: "Password"),
                                    fieldBottomHeight(),
                                    Obx(
                                      () => commontextfield(
                                        obscureText: employeeFormController
                                            .obscurePassword.value,
                                        suffixIcon: Obx(
                                          () => GestureDetector(
                                            onTap: () {
                                              employeeFormController
                                                      .obscurePassword.value =
                                                  !employeeFormController
                                                      .obscurePassword.value;
                                            },
                                            child: visibilityIcon(
                                              icon: employeeFormController
                                                      .obscurePassword.value
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                        controller: employeeFormController
                                            .passwordController.value,
                                        onChanged: (value) {
                                          employeeFormController.pass.value =
                                              value;
                                        },
                                        text: "Enter Password",
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Password';
                                          }
                                          if (value.length < 8) {
                                            return 'Password must be at least 8 characters';
                                          }
                                          if (!RegExp(r'[A-Z]')
                                              .hasMatch(value)) {
                                            return 'Password must have at least one uppercase letter';
                                          }
                                          if (!RegExp(r'[!@#\$&*~_]')
                                              .hasMatch(value)) {
                                            return 'Password must have at least one special character';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    labelHeight(),
                                    commontext(text: "Confirm Password"),
                                    fieldBottomHeight(),
                                    Obx(
                                      () => commontextfield(
                                        obscureText: employeeFormController
                                            .obscureConfirm.value,
                                        suffixIcon: Obx(
                                          () => GestureDetector(
                                            onTap: () {
                                              employeeFormController
                                                      .obscureConfirm.value =
                                                  !employeeFormController
                                                      .obscureConfirm.value;
                                            },
                                            child: visibilityIcon(
                                              icon: employeeFormController
                                                      .obscureConfirm.value
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                        controller: employeeFormController
                                            .confirmPasswordController.value,
                                        onChanged: (value) {
                                          employeeFormController
                                              .confirmPass.value = value;
                                        },
                                        text: "Enter Confirm PassWord",
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Confirm Password';
                                          }
                                          if (value !=
                                              employeeFormController
                                                  .pass.value) {
                                            return 'Passwords do not match';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 2fieldBottomHeight(),
                        Padding(
                          padding: 10.vertical,
                          child: commonDivider(
                              color: AppColors.grey.withOpacity(0.5)),
                        ),
                        Padding(
                          padding: 15.horizontal,
                          child: Container(
                            // height: 750,
                            width: double.maxFinite,
                            // margin: const EdgeInsets.symmetric(
                            //     vertical: 10, horizontal: 20),
                            padding: const EdgeInsets.all(10),
                            decoration: commonDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: commonProfileLabel(
                                    label: "Bank Details",
                                  ),
                                ),
                                commonDivider(),
                                commontext(text: "Bank Name"),
                                fieldBottomHeight(),
                                Obx(
                                  () => DropdownButtonFormField<String>(
                                    borderRadius: BorderRadius.circular(6),
                                    hint: Text(
                                      "Bank Name",
                                      style: poppinsStyle(
                                          color: AppColors.hinttext),
                                    ),
                                    value: employeeFormController
                                            .dropdownvaluebank.value.isNotEmpty
                                        ? employeeFormController
                                            .dropdownvaluebank.value
                                        : null,
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.hinttext,
                                    ),
                                    dropdownColor: AppColors.white,
                                    decoration: commonDropdownDeco(),
                                    items: itemsbank.map((String item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: poppinsStyle(
                                            color: AppColors.hinttext,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? val) {
                                      employeeFormController
                                          .dropdownvaluebank.value = val!;
                                    },
                                  ),
                                ),

                                labelHeight(),
                                commontext(text: "Ac No"),
                                fieldBottomHeight(),
                                commontextfield(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(15),
                                  ],
                                  keyboardType: TextInputType.number,
                                  controller: employeeFormController
                                      .acnocontroller.value,
                                  onChanged: (value) {
                                    employeeFormController.acno.value = value;
                                  },
                                  text: "Enter Ac No",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Ac no';
                                    }

                                    return null;
                                  },
                                ),
                                labelHeight(),
                                commontext(text: "IFSC"),
                                fieldBottomHeight(),
                                commontextfield(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'[A-Z0-9]')), // Allow only uppercase letters and digits
                                    LengthLimitingTextInputFormatter(
                                        11), // Limit to 11 characters
                                    UpperCaseTextFormatter(),
                                  ],
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  keyboardType: TextInputType.text,
                                  controller: employeeFormController
                                      .ifsccontroller.value,
                                  onChanged: (value) {
                                    employeeFormController.ifsc.value = value;
                                  },
                                  text: "Enter IFSC",
                                  validator: (value) {
                                    final ifscPattern =
                                        RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your IFSC';
                                    } else if (!ifscPattern.hasMatch(value)) {
                                      return 'Invalid IFSC code';
                                    }
                                    return null;
                                  },
                                ),
                                labelHeight(),
                                commontext(text: "Branch Address"),
                                fieldBottomHeight(),
                                commontextfield(
                                  // keyboardType: TextInputType.number,
                                  controller: employeeFormController
                                      .branchaddresscontroller.value,
                                  onChanged: (value) {
                                    employeeFormController.branchaddres.value =
                                        value;
                                  },
                                  text: "Enter Branch Address",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Branch Address';
                                    }

                                    return null;
                                  },
                                ),
                                labelHeight(),
                                commontext(text: "Reference"),
                                fieldBottomHeight(),
                                commontextfield(
                                  controller: employeeFormController
                                      .referancecontroller.value,
                                  onChanged: (value) {
                                    employeeFormController.referance.value =
                                        value;
                                  },
                                  text: "Enter Reference",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Reference';
                                    }

                                    return null;
                                  },
                                ),
                                labelHeight(),
                                Text(
                                  "Attach Proofs",
                                  style: poppinsStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                                Obx(() => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              activeColor:
                                                  AppColors.primarycolor,
                                              value: employeeFormController
                                                  .isAadharSelected.value,
                                              onChanged: (bool? value) {
                                                employeeFormController
                                                    .isAadharSelected
                                                    .value = value!;
                                                employeeFormController
                                                    .getSelectedProofs();
                                                if (!value) {
                                                  employeeFormController
                                                      .removeDocuments(
                                                          commonString.aadhar);
                                                }
                                              },
                                            ),
                                            Text("Aadhar Card",
                                                style:
                                                    poppinsStyle()), // Document Name
                                            Spacer(),
                                            if (employeeFormController
                                                .isAadharSelected.value)
                                              addBtn(
                                                onTap: () {
                                                  // Show dialog to choose front or back side
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (context) {
                                                      return selectAadharSideDialog(
                                                        title:
                                                            "Select Document Side",
                                                        FrontOnTap: () {
                                                          Navigator.pop(
                                                              context); // Close the dialog
                                                          // Open file picker for front side
                                                          employeeFormController
                                                              .pickAadharDoc(
                                                                  commonString
                                                                      .aadhar,
                                                                  "front");
                                                        },
                                                        backOnTap: () {
                                                          Navigator.pop(
                                                              context); // Close the dialog
                                                          // Open file picker for back side
                                                          employeeFormController
                                                              .pickAadharDoc(
                                                                  commonString
                                                                      .aadhar,
                                                                  "back");
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                          ],
                                        ),
                                        Obx(() {
                                          return Column(
                                            children: [
                                              // Display front side Aadhar image with delete and open functionality
                                              if (employeeFormController
                                                  .frontAadharFilePath
                                                  .isNotEmpty)
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    aadharLabelText(
                                                        side: 'Front View'),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12.0),
                                                      child: ListTile(
                                                        onTap: () async {
                                                          final file = File(
                                                              employeeFormController
                                                                  .frontAadharFilePath
                                                                  .value);
                                                          openFile(
                                                              file); // Using the common method for opening file
                                                        },
                                                        leading: const Icon(
                                                            Icons.file_present),
                                                        title: selectedDocTitle(
                                                          label: employeeFormController
                                                              .frontAadharFilePath
                                                              .value
                                                              .split('/')
                                                              .last,
                                                        ),
                                                        subtitle:
                                                            selectedDocSubTitle(
                                                          subTitle:
                                                              "File Type: ${employeeFormController.frontAadharFilePath.value.split('.').last.toUpperCase()}",
                                                        ),
                                                        trailing:
                                                            GestureDetector(
                                                          child:
                                                              selectedDocDelete(),
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return commonLogOutDialog(
                                                                  title:
                                                                      'Delete',
                                                                  iconColor:
                                                                      AppColors
                                                                          .red,
                                                                  deleteButtonColor:
                                                                      AppColors
                                                                          .red,
                                                                  subTitle:
                                                                      'Are you sure you want to delete this file?',
                                                                  confirmText:
                                                                      'Delete',
                                                                  cancelText:
                                                                      'Cancel',
                                                                  icon: Icons
                                                                      .warning_amber_rounded,
                                                                  cancelOnPressed:
                                                                      () => Get
                                                                          .back(),
                                                                  logOutOnPressed:
                                                                      () {
                                                                    print(
                                                                        "DELETE CONFIRMED ✅");
                                                                    employeeFormController
                                                                        .frontAadharFilePath
                                                                        .value = '';
                                                                    Get.back();
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                              // Display back side Aadhar image with delete and open functionality
                                              if (employeeFormController
                                                  .backAadharFilePath
                                                  .isNotEmpty)
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    aadharLabelText(
                                                        side: 'Back View'),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12.0),
                                                      child: ListTile(
                                                        onTap: () async {
                                                          final file = File(
                                                              employeeFormController
                                                                  .backAadharFilePath
                                                                  .value);
                                                          openFile(
                                                              file); // Using the common method for opening file
                                                        },
                                                        leading: const Icon(
                                                            Icons.file_present),
                                                        title: selectedDocTitle(
                                                          label: employeeFormController
                                                              .backAadharFilePath
                                                              .value
                                                              .split('/')
                                                              .last,
                                                        ),
                                                        subtitle:
                                                            selectedDocSubTitle(
                                                          subTitle:
                                                              "File Type: ${employeeFormController.backAadharFilePath.value.split('.').last.toUpperCase()}",
                                                        ),
                                                        trailing:
                                                            GestureDetector(
                                                          child:
                                                              selectedDocDelete(),
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return commonLogOutDialog(
                                                                  title:
                                                                      'Delete',
                                                                  iconColor:
                                                                      AppColors
                                                                          .red,
                                                                  deleteButtonColor:
                                                                      AppColors
                                                                          .red,
                                                                  subTitle:
                                                                      'Are you sure you want to delete this file?',
                                                                  confirmText:
                                                                      'Delete',
                                                                  cancelText:
                                                                      'Cancel',
                                                                  icon: Icons
                                                                      .warning_amber_rounded,
                                                                  cancelOnPressed:
                                                                      () => Get
                                                                          .back(),
                                                                  logOutOnPressed:
                                                                      () {
                                                                    print(
                                                                        "DELETE CONFIRMED ✅");
                                                                    employeeFormController
                                                                        .backAadharFilePath
                                                                        .value = '';
                                                                    Get.back();
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          );
                                        }),
                                      ],
                                    )),
                                Obx(() => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              activeColor:
                                                  AppColors.primarycolor,
                                              value: employeeFormController
                                                  .isBankPassbookSelected.value,
                                              onChanged: (bool? value) {
                                                employeeFormController
                                                    .isBankPassbookSelected
                                                    .value = value!;
                                                employeeFormController
                                                    .getSelectedProofs();
                                                if (!value) {
                                                  employeeFormController
                                                      .removeDocuments(
                                                          commonString
                                                              .passbook);
                                                }
                                              },
                                            ),
                                            Text("Bank Passbook",
                                                style: poppinsStyle()),
                                            Spacer(),
                                            if (employeeFormController
                                                .isBankPassbookSelected.value)
                                              addBtn(
                                                onTap: () {
                                                  employeeFormController
                                                      .pickDocumentFor(
                                                          commonString
                                                              .passbook);
                                                },
                                              ),
                                          ],
                                        ),
                                        if (employeeFormController
                                                    .bankPassbookFile.value !=
                                                null &&
                                            employeeFormController
                                                .isBankPassbookSelected.value)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: ListTile(
                                              onTap: () async {
                                                final file =
                                                    employeeFormController
                                                        .bankPassbookFile
                                                        .value!;
                                                openFile(file);
                                              },
                                              leading: const Icon(
                                                  Icons.file_present),
                                              title: selectedDocTitle(
                                                label: employeeFormController
                                                    .bankPassbookFile
                                                    .value!
                                                    .path
                                                    .split('/')
                                                    .last,
                                              ),
                                              subtitle: selectedDocSubTitle(
                                                subTitle:
                                                    "File Type: ${employeeFormController.bankPassbookFile.value!.path.split('.').last.toUpperCase()}",
                                              ),
                                              trailing: GestureDetector(
                                                child: selectedDocDelete(),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return commonLogOutDialog(
                                                        title: 'Delete',
                                                        iconColor:
                                                            AppColors.red,
                                                        deleteButtonColor:
                                                            AppColors.red,
                                                        subTitle:
                                                            'Are you sure you want to delete this file?',
                                                        confirmText: 'Delete',
                                                        cancelText: 'Cancel',
                                                        icon: Icons
                                                            .warning_amber_rounded,
                                                        cancelOnPressed: () =>
                                                            Get.back(),
                                                        logOutOnPressed: () {
                                                          print(
                                                              "DELETE CONFIRMED ✅");
                                                          log(" employeeFormController1${employeeFormController.bankPassbookFile.value}");
                                                          employeeFormController
                                                              .bankPassbookFile
                                                              .value = null;
                                                          log(" employeeFormController2${employeeFormController.bankPassbookFile.value}");

                                                          Get.back();
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                      ],
                                    )),
                                Obx(
                                  () => ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: employeeFormController
                                        .otherDocuments.length,
                                    itemBuilder: (context, index) {
                                      final doc = employeeFormController
                                          .otherDocuments[index];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Obx(
                                                () => Checkbox(
                                                  activeColor:
                                                      AppColors.primarycolor,
                                                  value: employeeFormController
                                                              .selectedDocs[
                                                          index] ??
                                                      false,
                                                  onChanged: (bool? value) {
                                                    employeeFormController
                                                        .toggleDocSelection(
                                                      index,
                                                      doc.name.toString(),
                                                      value ?? false,
                                                    );
                                                    if (value == false) {
                                                      employeeFormController
                                                          .removeNewFiles(
                                                              index);
                                                    }
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(doc.name.toString(),
                                                    style: poppinsStyle()),
                                              ),
                                              Obx(() {
                                                final isChecked =
                                                    employeeFormController
                                                                .selectedDocs[
                                                            index] ??
                                                        false;
                                                return isChecked
                                                    ? addBtn(
                                                        onTap: () {
                                                          employeeFormController
                                                              .pickMultiFile(
                                                                  index);
                                                        },
                                                      )
                                                    : const SizedBox(); // Hide button if not selected
                                              }),
                                              5.width,
                                              GestureDetector(
                                                child: selectedDocDelete(),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return commonLogOutDialog(
                                                        title: 'Delete',
                                                        iconColor:
                                                            AppColors.red,
                                                        deleteButtonColor:
                                                            AppColors.red,
                                                        subTitle:
                                                            'Are you sure you want to delete this Document',
                                                        confirmText: 'Delete',
                                                        cancelText: 'Cancel',
                                                        icon: Icons
                                                            .warning_amber_rounded,
                                                        cancelOnPressed: () =>
                                                            Get.back(),
                                                        logOutOnPressed: () {
                                                          if (index >= 0 &&
                                                              index <
                                                                  employeeFormController
                                                                      .otherDocuments
                                                                      .length) {
                                                            employeeFormController
                                                                .otherDocuments
                                                                .removeAt(
                                                                    index); // Remove the document itself
                                                            employeeFormController
                                                                .selectedDocs
                                                                .remove(
                                                                    index); // Remove checkbox selection
                                                            employeeFormController
                                                                .otherDocuments
                                                                .refresh(); // Notify UI to rebuild
                                                            employeeFormController
                                                                .selectedDocs
                                                                .refresh();
                                                          }
                                                          Get.back();
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          if (doc.otherFile != null)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: ListTile(
                                                onTap: () async {
                                                  final file = doc.otherFile;

                                                  if (file != null &&
                                                      await file.exists()) {
                                                    openFile(file);
                                                  } else {
                                                    primaryToast(
                                                        msg:
                                                            "No file found to open.");
                                                  }
                                                },
                                                leading: const Icon(
                                                    Icons.file_present),
                                                title: selectedDocTitle(
                                                  label: doc.otherFile != null
                                                      ? doc.otherFile!.path
                                                          .split('/')
                                                          .last
                                                      : 'No file selected',
                                                ),
                                                subtitle: selectedDocSubTitle(
                                                  subTitle:
                                                      "File Type: ${doc.otherFile!.path.split('.').last.toUpperCase()}",
                                                ),
                                                trailing: GestureDetector(
                                                  child: selectedDocDelete(),
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return commonLogOutDialog(
                                                          title: 'Delete',
                                                          iconColor:
                                                              AppColors.red,
                                                          deleteButtonColor:
                                                              AppColors.red,
                                                          subTitle:
                                                              'Are you sure you want to delete this file?',
                                                          confirmText: 'Delete',
                                                          cancelText: 'Cancel',
                                                          icon: Icons
                                                              .warning_amber_rounded,
                                                          cancelOnPressed: () =>
                                                              Get.back(),
                                                          logOutOnPressed: () {
                                                            employeeFormController
                                                                .removeNewFiles(
                                                                    index);
                                                            Get.back();
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),

                                Obx(() => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              activeColor:
                                                  AppColors.primarycolor,
                                              value: employeeFormController
                                                  .isOtherSelected.value,
                                              onChanged: (value) {
                                                employeeFormController
                                                    .isOtherSelected
                                                    .value = value!;
                                                employeeFormController
                                                    .getSelectedProofs();
                                              },
                                            ),
                                            Text("Other Documents",
                                                style:
                                                    poppinsStyle()), // Document Name
                                            Spacer(),
                                          ],
                                        ),
                                        Visibility(
                                          visible: employeeFormController
                                                  .isOtherSelected.value ==
                                              true,
                                          child: commontextfield(
                                            controller: employeeFormController
                                                .customDocNameController.value,
                                            onChanged: (value) {
                                              employeeFormController
                                                  .documentName.value = value;
                                            },
                                            text: "Enter Proof Title",
                                            validator: (value) {
                                              /*   if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter Reference';
                                              }

                                              return null;*/
                                            },
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                Icons.check,
                                                color: AppColors.primarycolor,
                                              ),
                                              onPressed: () {
                                                employeeFormController
                                                    .addDocumentName();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                /*  Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CheckboxListTile(
                                      activeColor: AppColors.primarycolor,
                                      title: Row(
                                        children: [
                                          Text("Other Documents", style: poppinsStyle()),
                                          Spacer(),
                                          if (employeeFormController.isOtherSelected.value)
                                            addBtn(onTap: () {
                                              employeeFormController.pickDocumentFor(commonString.aadhar);
                                            }),
                                        ],
                                      ),
                                      value: employeeFormController.isOtherSelected.value,
                                      onChanged: (bool? value) {
                                        employeeFormController.isOtherSelected.value = value!;
                                        employeeFormController.getSelectedProofs();
                                        if (!value) {
                                          employeeFormController.uploadedMultipleDocuments["Other Documents"]?.clear();
                                        }
                                      },
                                    ),

                                    if (employeeFormController.uploadedMultipleDocuments.containsKey("Other Documents") &&
                                        employeeFormController.uploadedMultipleDocuments["Other Documents"]!.isNotEmpty)
                                      ...employeeFormController.uploadedMultipleDocuments["Other Documents"]!.asMap().entries.map(
                                            (entry) {
                                          final index = entry.key;
                                          final file = entry.value;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                            child: ListTile(
                                              onTap: () async {
                                                try {
                                                  openFilex.OpenResult result = await openFilex.OpenFilex.open(file.path);
                                                  if (result.type != openFilex.ResultType.done) {
                                                    primaryToast(msg: "Failed to open file: ${result.message}");
                                                  }
                                                } catch (e) {
                                                  primaryToast(msg: "Error opening file: $e");
                                                }
                                              },
                                              leading: const Icon(Icons.file_present),
                                              title: selectedDocTitle(label: file.path.split('/').last),
                                              subtitle: selectedDocSubTitle(subTitle: "File Type: ${file.path.split('.').last.toUpperCase()}"),
                                              trailing: GestureDetector(
                                                child: selectedDocDelete(),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return commonLogOutDialog(
                                                        title: 'Delete',
                                                        iconColor: AppColors.red,
                                                        deleteButtonColor: AppColors.red,
                                                        subTitle: 'Are you sure you want to delete this file?',
                                                        confirmText: 'Delete',
                                                        cancelText: 'Cancel',
                                                        icon: Icons.warning_amber_rounded,
                                                        cancelOnPressed: () => Get.back(),
                                                        logOutOnPressed: () {
                                                          employeeFormController.uploadedMultipleDocuments["Other Documents"]!.removeAt(index);
                                                          Get.back();
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                  ],
                                ))*/

                                labelHeight(),
                                /*  Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Upload Document",
                                      style: poppinsStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                      ),
                                    ),
                                    addBtn(
                                      onTap: () {
                                        employeeFormController.pickDocuments();
                                      },
                                    )
                                  ],
                                ),*/
                                // 10.height,
                                // documentUploadBtn(
                                //     onPressed: () {
                                //       employeeFormController.pickDocuments();
                                //     },
                                //     label: 'Upload Documents'),
                                Visibility(
                                    visible: employeeFormController
                                        .selectedDocuments.isNotEmpty,
                                    child: 10.height),
                                Obx(
                                  () => employeeFormController
                                          .selectedDocuments.isEmpty
                                      ? Container()
                                      : Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 8),
                                          decoration: commonDecoration(),
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: employeeFormController
                                                .selectedDocuments.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const Divider(
                                              color: Colors.grey,
                                              thickness: 1,
                                            ),
                                            itemBuilder: (context, index) {
                                              var file = employeeFormController
                                                  .selectedDocuments[index];
                                              return ListTile(
                                                onTap: () async {
                                                  openFile(file);
                                                  /* try {
                                                    openFilex.OpenResult
                                                        result = await openFilex
                                                                .OpenFilex
                                                            .open(file.path);

                                                    if (result.type !=
                                                        openFilex
                                                            .ResultType.done) {
                                                      primaryToast(
                                                        msg:
                                                            "Failed to open file: ${result.message}",
                                                      );
                                                    }
                                                  } catch (e) {
                                                    primaryToast(
                                                      msg:
                                                          "Error opening file: $e",
                                                    );
                                                  }*/
                                                },
                                                leading: const Icon(
                                                    Icons.file_present),
                                                title: Text(
                                                  file.path.split('/').last,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: poppinsStyle(
                                                      color: AppColors.black,
                                                      fontSize: 13),
                                                ),
                                                subtitle: Text(
                                                  "File Type: ${file.path.split('.').last.toUpperCase()}",
                                                  style: poppinsStyle(
                                                      color: AppColors.hinttext,
                                                      fontSize: 13),
                                                ),
                                                trailing: GestureDetector(
                                                  child: Icon(
                                                    Icons.delete_rounded,
                                                    color: AppColors.black
                                                        .withOpacity(0.6),
                                                  ),
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return commonLogOutDialog(
                                                          title: 'Delete',
                                                          iconColor:
                                                              AppColors.red,
                                                          deleteButtonColor:
                                                              AppColors.red,
                                                          subTitle:
                                                              'Are you sure you want to delete this file?',
                                                          confirmText: 'Delete',
                                                          cancelText: 'Cancel',
                                                          icon: Icons
                                                              .warning_amber_rounded,
                                                          cancelOnPressed: () {
                                                            Get.back();
                                                          },
                                                          logOutOnPressed: () {
                                                            employeeFormController
                                                                .removeDocument(
                                                                    file);
                                                            Get.back();
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.label != "Admin")
                      Padding(
                        padding: 10.vertical,
                        child: commonDivider(
                            color: AppColors.grey.withOpacity(0.5)),
                      ),
                    if (widget.label != "Admin")
                      Padding(
                        padding: 15.horizontal,
                        child: Container(
                          // height: 380,
                          width: double.maxFinite,
                          padding: const EdgeInsets.all(10),
                          decoration: commonDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: commonProfileLabel(
                                  label: "Office Use Only",
                                ),
                              ),
                              commonDivider(),
                              commontext(text: "Employee Type"),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 20.0,
                                  left: 4,
                                ),
                                child: Row(
                                  children: [
                                    Obx(() => radioBtn(
                                        value: commonString.office,
                                        groupValue: employeeFormController
                                            .officegroup.value,
                                        onChanged: (val) {
                                          employeeFormController
                                              .officegroup.value = val!;
                                        })),
                                    Text(
                                      "OFFICE",
                                      style: poppinsStyle(),
                                    ),
                                    30.width,
                                    Obx(() => radioBtn(
                                        value: commonString.mfgdept,
                                        groupValue: employeeFormController
                                            .officegroup.value,
                                        onChanged: (val) {
                                          employeeFormController
                                              .officegroup.value = val!;
                                        })),
                                    Text(
                                      "MFGDEPT",
                                      style: poppinsStyle(),
                                    ),
                                    // const Spacer(),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  labelHeight(),
                                  commontext(text: "Joinning Date"),
                                  fieldBottomHeight(),
                                  Obx(
                                    () => commonDateCon(
                                      label:
                                          "${employeeFormController.selectedDateFrom.value.day.toString().padLeft(2, '0')}-"
                                          "${employeeFormController.selectedDateFrom.value.month.toString().padLeft(2, '0')}-"
                                          "${employeeFormController.selectedDateFrom.value.year}",
                                      onTap: () {
                                        employeeFormController
                                            .selectDateFrom(context);
                                      },
                                    ),
                                  ),
                                  labelHeight(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    /* 20.height,
                    Padding(
                      padding: 20.horizontal,
                      child: primarybutton(
                        text: "Submit",
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            employeeFormController.submitBtn();
                          }
                        },
                      ),
                    ),*/
                    labelHeight(),
                  ],
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
      ),
    );
  }
}

Widget documentUploadBtn(
    {required label, required void Function()? onPressed}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    ),
    onPressed: onPressed,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.add,
          size: 5.heightBox(),
          color: AppColors.grey,
        ),
        Text(
          label,
          style: poppinsStyle(
            color: AppColors.hinttext,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget visibilityIcon({required icon}) {
  return Icon(
    icon,
    size: 20,
  );
}

Widget selectedDocTitle({required label}) {
  return Text(
    label,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: poppinsStyle(color: AppColors.black, fontSize: 13),
  );
}

Widget selectedDocSubTitle({required subTitle}) {
  return Text(
    subTitle,
    style: poppinsStyle(color: AppColors.hinttext, fontSize: 13),
  );
}

Widget selectedDocDelete() {
  return Icon(Icons.delete_rounded, color: AppColors.black.withOpacity(0.6));
}

Widget selectAadharSideDialog({
  required title,
  required void Function()? FrontOnTap,
  required void Function()? backOnTap,
}) {
  return Dialog(
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 5,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        20.height,
        Text(
          title,
          style: poppinsStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        commonDivider(),
        Padding(
          padding: 15.symmetric,
          child: Row(
            children: [
              15.width,
              Expanded(
                child: GestureDetector(
                    onTap: FrontOnTap, // Handle Front Side tap
                    child: commonAadharBtn(label: "Front View")),
              ),
              10.width,
              // Back Side Button
              Expanded(
                child: GestureDetector(
                    onTap: backOnTap, // Handle Front Side tap
                    child: commonAadharBtn(label: "Back View")),
              ),
              15.width,
            ],
          ),
        ),
      ],
    ),
  );
}

Widget commonAadharBtn({required label}) {
  return Container(
    height: 6.2.heightBox(),
    // width: 33.widthBox(),
    decoration: BoxDecoration(
      color: AppColors.primarycolor,

      borderRadius: BorderRadius.circular(8), // Optional: adds rounded corners
    ),
    child: Center(
      child: Text(
        label,
        style: poppinsStyle(
            fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.white),
      ),
    ),
  );
}

Widget aadharLabelText({required side}) {
  return Padding(
    padding: 17.onlyLeft,
    child: Text(
      side,
      style: poppinsStyle(color: AppColors.grey),
    ),
  );
}
