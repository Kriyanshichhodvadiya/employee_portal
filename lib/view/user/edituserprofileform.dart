import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:employeeform/model/eprofilemodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/comman_widget.dart';
import '../../common/dashboardcommon.dart';
import '../../common/global_widget.dart';
import '../../config/color.dart';
import '../../config/images.dart';
import '../../config/list.dart';
import '../../controller/employeeformContro.dart';
import '../../controller/userviewtask_controller.dart';
import '../admin_side/company_profile/co_profile_form.dart';
import '../admin_side/edit_user/profile_details.dart';

class EditUserProfileScreen extends StatefulWidget {
  EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  EmployeeFormController employeeFormController = Get.find();

  // UserDashBoardController userDashBoardController = Get.find();
  UserViewTaskController controller = Get.put(UserViewTaskController());

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  File? bankPassbookFile;
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
        employeeFormController.resetCountryValue();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: appBar(
            onTap: () {
              // Get.back();
              employeeFormController.resetValue();
              employeeFormController.resetCountryValue();
              Get.back();
            },
            title: 'Edit Details',
            actions: [
              commonSaveButton(onPressed: () async {
                // if (_formkey.currentState!.validate()) {
                if (!employeeFormController.validateUserSideFields()) return;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? employeeListString = prefs.getString('employeeData');
                String? loggedInUserSrNo = prefs.getString('loggedInUserSrNo');

                if (employeeListString != null && loggedInUserSrNo != null) {
                  List<dynamic> employeeList = jsonDecode(employeeListString);
                  int index = employeeList.indexWhere(
                      (element) => element['srNo'] == loggedInUserSrNo);

                  if (index != -1) {
                    // Update fields using your controller
                    String imagePath =
                        employeeFormController.selectedImage.value?.path ?? '';

                    List<OtherDocumentsModel> otherDocumentsList = [];

                    for (var doc in employeeFormController.otherDocuments) {
                      otherDocumentsList.add(OtherDocumentsModel(
                        name: doc.name,
                        check: doc.check,
                        otherFile: doc.otherFile,
                      ));
                    }
                    AadharCardModel aadharCard = AadharCardModel(
                      frontSidePath:
                          employeeFormController.frontAadharFilePath.value,
                      backSidePath:
                          employeeFormController.backAadharFilePath.value,
                    );
                    UploadedDocumentsModel attachedFiles =
                        UploadedDocumentsModel(
                      aadharCard: aadharCard,
                      bankPassbookFile: bankPassbookFile,
                      otherFiles: otherDocumentsList,
                    );

                    UserProfile updatedEmployee = UserProfile(
                        srNo: loggedInUserSrNo,
                        firstName: employeeFormController
                            .firstnamecontroller.value.text,
                        middleName: employeeFormController
                            .middlenamecontroller.value.text,
                        lastName: employeeFormController
                            .lastnamecontroller.value.text,
                        address:
                            employeeFormController.addresscontroller.value.text,
                        aadhar:
                            employeeFormController.aadharcontroller.value.text,
                        gender: employeeFormController.group.value,
                        birthDate: DateFormat('dd-MM-yyyy')
                            .format(employeeFormController.selectedDate.value),
                        mobilenoone: employeeFormController
                            .mobilenucontroller.value.text,
                        mobilentwo: employeeFormController
                            .mobilenutwocontroller.value.text,
                        email:
                            employeeFormController.emailcontroller.value.text,
                        bankName: employeeFormController
                            .banknamercontroller.value.text,
                        branchAddress: employeeFormController
                            .branchaddresscontroller.value.text,
                        accountNumber:
                            employeeFormController.acnocontroller.value.text,
                        ifscCode:
                            employeeFormController.ifsccontroller.value.text,
                        reference:
                            employeeFormController.referancecontroller.value.text,
                        employmentType: employeeFormController.officegroup.value,
                        dateFrom: DateFormat('dd-MM-yyyy').format(employeeFormController.selectedDateFrom.value),
                        image: imagePath,
                        zipCode: employeeFormController.zipCodeController.value.text,
                        country: employeeFormController.countryController.value.text,
                        state: employeeFormController.stateController.value.text,
                        city: employeeFormController.cityController.value.text,
                        documents: employeeFormController.selectedDocuments.map((file) => file.path).toList() ?? [],
                        attachProof: employeeFormController.selectedProofs,
                        password: employeeFormController.passwordController.value.text,
                        confirmPass: employeeFormController.confirmPasswordController.value.text,
                        uploadedDocuments: {},
                        attachedFiles: attachedFiles);
                    // Replace the data at that index
                    employeeList[index] = updatedEmployee.toMap();

                    // Save back to shared preferences
                    await prefs.setString(
                        'employeeData', jsonEncode(employeeList));
                    log('Updated Employee Data => ${jsonEncode(employeeList[index])}');
                    controller.fetchEmployeeData();
                    primaryToast(msg: "Profile updated successfully");
                    employeeFormController.resetValue();
                    employeeFormController.resetCountryValue();
                    Get.offAll(
                      () => ProfileDetail(
                        backBtn: true,
                        adminProfile: true,
                        adminEdit: false,
                        editMode: true,
                        userprofile: controller.employeeData.value!,
                      ),
                    );
                    // Get.back(result: true);
                  } else {
                    primaryToast(msg: "User not found");
                  }
                }
              }
                  // },
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
                                        borderRadius: BorderRadius.circular(8),
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
                                                      source:
                                                          ImageSource.camera);
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
                                                      source:
                                                          ImageSource.gallery);
                                              /*  final XFile? pickedFile =
                                                      await picker.pickImage(
                                                          source:
                                                              ImageSource.gallery,
                                                          imageQuality: 100,
                                                          maxHeight: 1000,
                                                          maxWidth: 1000);
                                                  if (pickedFile != null) {

                                                  } else {}
                                                  Navigator.pop(context);*/
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
                                color: AppColors.white, shape: BoxShape.circle),
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
                                    employeeFormController.email.value = value;
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
                                    employeeFormController.mobileNumber.value =
                                        value;
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
                                                prefixIcon: countrySearchBtn(),
                                                onChanged: (value) {
                                                  employeeFormController
                                                          .countrySearch.value =
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
                                                        child: searchLottie())
                                                    : Expanded(
                                                        child: ListView.builder(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          itemCount:
                                                              employeeFormController
                                                                  .filteredCountryList
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
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
                                                              title:
                                                                  country.title,
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
                                                .selectedCountryIndex.value];

                                        employeeFormController.filteredStateList
                                            .value = selectedCountry.states;

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return searchDialog(
                                              searchField: commontextfield(
                                                text: "Search State...",
                                                prefixIcon: countrySearchBtn(),
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

                                                return filteredStates.isEmpty
                                                    ? Expanded(
                                                        child: searchLottie())
                                                    : Expanded(
                                                        child: ListView.builder(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5),
                                                          itemCount:
                                                              filteredStates
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
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
                                            .filteredCityList.value = countries[
                                                employeeFormController
                                                    .selectedCountryIndex.value]
                                            .states[employeeFormController
                                                .selectedStateIndex.value]
                                            .cities;

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return searchDialog(
                                              searchField: commontextfield(
                                                text: "Search City...",
                                                prefixIcon: countrySearchBtn(),
                                                onChanged: (value) {
                                                  employeeFormController
                                                          .citySearch.value =
                                                      value.toLowerCase();
                                                  employeeFormController
                                                      .filteredCityList
                                                      .value = countries[
                                                          employeeFormController
                                                              .selectedCountryIndex
                                                              .value]
                                                      .states[
                                                          employeeFormController
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
                                                        child: searchLottie())
                                                    : Expanded(
                                                        child: ListView.builder(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          itemCount:
                                                              employeeFormController
                                                                  .filteredCityList
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final city =
                                                                employeeFormController
                                                                        .filteredCityList[
                                                                    index];
                                                            return searchDialogItem(
                                                              title: city,
                                                              onTap: () {
                                                                employeeFormController
                                                                    .selectCityOnTap(
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
                                    if (value.length < 5 || value.length > 6) {
                                      return 'Zip Code must be 5 or 6 digits';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                labelHeight(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
