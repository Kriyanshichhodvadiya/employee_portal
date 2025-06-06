import 'dart:developer';
import 'dart:io';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/config/list.dart';
import 'package:employeeform/controller/employeeformContro.dart';
import 'package:employeeform/view/admin_side/bottom_nav_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/dashboardcommon.dart';
import '../../../common/global_widget.dart';
import '../../../config/color.dart';
import '../../../controller/com_profile_controller.dart';
import '../../../model/com_profile_model.dart';
import 'com_profile_detail.dart';

class CompanyProfileForm extends StatefulWidget {
  CompanyProfileForm({super.key});

  @override
  State<CompanyProfileForm> createState() => _CompanyProfileFormState();
}

class _CompanyProfileFormState extends State<CompanyProfileForm> {
  CompanyProfileController controller = Get.put(CompanyProfileController());

  EmployeeFormController employeeFormController =
      Get.put(EmployeeFormController());

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    log("controller.profileImage.value${controller.profileImage.value}");
    return WillPopScope(
      onWillPop: () async {
        await controller.clearProfile();
        // Get.delete<CompanyProfileController>();
        employeeFormController.resetCountryValue();
        Get.off(() => BottomNavAdmin());
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: appBar(
            title: 'Company Profile',
            onTap: () async {
              await controller.clearProfile();
              employeeFormController.resetCountryValue();
              // Get.delete<CompanyProfileController>();
              Get.off(() => BottomNavAdmin());
              // Get.back();
            },
            showBack: true,
            actions: [
              // IconButton(
              //     onPressed: () {
              //       controller.deleteProfile();
              //       Get.delete<CompanyProfileController>();
              //       Get.back();
              //     },
              //     icon: Icon(Icons.delete)),
              commonSaveButton(
                onPressed: () {
                  // if (_formkey.currentState!.validate()) {
                  if (!controller.validateAllFields()) return;
                  // if (controller.selectedServices.isNotEmpty) {
                  log("selectedServices::${controller.selectedServices}");

                  var profile = CompanyProfile(
                    companyName: controller.companyName.value,
                    companySize: controller.companySize.value,
                    industry: controller.industry.value,
                    description: controller.description.value,
                    email: controller.email.value,
                    phoneNumber: controller.phoneNumber.value,
                    website: controller.website.value,
                    address: controller.address.value,
                    country:
                        employeeFormController.countryController.value.text,
                    state: employeeFormController.stateController.value.text,
                    city: employeeFormController.cityController.value.text,
                    zipCode: controller.zipCode.value,
                    linkedIn: controller.linkedIn.value,
                    instagram: controller.instagram.value,
                    foundedYear: controller.foundedYear.value,
                    services: controller.selectedServices,
                    profileImage: controller.profileImage.value != null
                        ? controller.profileImage.value!.path
                        : "",
                    backgroundImage: controller.backgroundImage.value != null
                        ? controller.backgroundImage.value!.path
                        : "", // Add file picker later
                  );
                  controller.saveCompanyProfile(profile);
                  employeeFormController.resetCountryValue();
                  primaryToast(
                      msg: controller.editScreen.value == false
                          ? 'Details add successfully'
                          : 'Details update successfully');
                  Get.off(() => CompanyProfileDetails());
                  // } else {
                  //   primaryToast(msg: 'Please Select Services');
                  // }

                  // }
                  // ;
                },
              ),
            ]),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20.hp(context),
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Obx(() => Container(
                            height: 10.hp(context),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              boxShadow: [commonShadow()],
                              image:
                                  (controller.backgroundImage.value != null &&
                                          controller.backgroundImage.value!.path
                                              .isNotEmpty)
                                      ? DecorationImage(
                                          image: FileImage(File(controller
                                              .backgroundImage.value!.path)),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                            ),
                            child: Stack(
                              children: [
                                // Gradient shadow effect (bottom to top)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          AppColors.black.withOpacity(0.6),
                                          AppColors.black.withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: 10.symmetric,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                controller.pickImage(false);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors.black
                                                      .withOpacity(0.7),
                                                ),
                                                child: Padding(
                                                  padding: 8.symmetric,
                                                  child: Icon(
                                                      controller.editScreen
                                                                  .value ==
                                                              true
                                                          ? Icons.edit
                                                          : Icons.camera,
                                                      size: 3.hp(context),
                                                      color: AppColors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    1.heightBox().height,
                                    controller.backgroundImage.value == null ||
                                            controller.backgroundImage.value!
                                                .path.isEmpty
                                        ? Center(
                                            child: Text(
                                            "Add Cover Photo",
                                            style: poppinsStyle(),
                                          ))
                                        : Container(),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      Positioned(
                        bottom: -50,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Obx(() => Container(
                                height: 13.hp(context),
                                width: 13.hp(context),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  boxShadow: [commonShadow()],
                                  border: commonBorder(),
                                  image: (controller.profileImage.value !=
                                              null &&
                                          controller.profileImage.value!.path
                                              .isNotEmpty)
                                      ? DecorationImage(
                                          image: FileImage(File(controller
                                              .profileImage.value!.path)),
                                          fit: BoxFit.cover,
                                        )
                                      : null, // Don't set an image if the path is empty
                                ),
                                child: Stack(
                                  children: [
                                    (controller.profileImage.value == null ||
                                            controller.profileImage.value!.path
                                                .isEmpty)
                                        ? Center(
                                            child: Icon(Icons.person,
                                                size: 40,
                                                color: Colors.grey.shade700),
                                          )
                                        : Container(),
                                    Padding(
                                      padding: 2.symmetric,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.pickImage(true);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.black
                                                  .withOpacity(0.7),
                                            ),
                                            child: Padding(
                                              padding: 4.symmetric,
                                              child: Icon(
                                                  controller.editScreen.value ==
                                                          true
                                                      ? Icons.edit
                                                      : Icons.camera,
                                                  size: 2.hp(context),
                                                  color: AppColors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80),
                Padding(
                  padding: 15.horizontal,
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(10),
                    decoration: commonDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: commonProfileLabel(
                            label: "Company information",
                          ),
                        ),
                        Divider(
                          color: AppColors.black.withOpacity(0.4),
                          height: 20,
                        ),
                        commontext(text: "Company Name"),
                        fieldBottomHeight(),
                        commontextfield(
                          controller: controller.companyNameController.value,
                          onChanged: (value) {
                            controller.companyName.value = value;
                          },
                          text: "Enter Company name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Company name';
                            }

                            return null;
                          },
                        ),
                        labelHeight(),
                        commontext(text: "Number of Employees"),
                        fieldBottomHeight(),
                        DropdownButtonFormField<String>(
                          value: controller.companySize.value.isNotEmpty
                              ? controller.companySize.value
                              : null, // Initial value
                          hint: Text(
                            "Employee range",
                            style: poppinsStyle(
                              color: AppColors.hinttext,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          items: employeeNumbers.map((size) {
                            return DropdownMenuItem(
                              value: size,
                              child: Text(
                                size,
                                style: poppinsStyle(
                                  color: AppColors.hinttext,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.companySize.value = value;
                            }
                          },
                          dropdownColor: AppColors.white,
                          decoration:
                              commonDropdownDeco() /* InputDecoration(
                            errorBorder: enableBorder(),
                            focusedErrorBorder: enableBorder(),
                            enabledBorder: enableBorder(),
                            focusedBorder: enableBorder(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          )*/
                          ,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select the number of employees';
                            }
                            return null;
                          },
                        ),
                        labelHeight(),
                        commontext(text: "Industry"),
                        fieldBottomHeight(),
                        commontextfield(
                          readOnly: true,
                          controller: controller.industryController.value,
                          onChanged: (value) {
                            controller.industry.value = value;
                          },
                          text: "select Industry",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select Industry';
                            }
                            return null;
                          },
                          suffixIcon: fieldSuffixIcon(),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return searchDialog(
                                  searchField: commontextfield(
                                    text: "Search Industry...",
                                    prefixIcon: Icon(Icons.search),
                                    onChanged: (value) {
                                      controller.search.value =
                                          value.toLowerCase();
                                      controller.filteredIndustryList.value =
                                          industryList
                                              .where((industry) => industry
                                                  .title
                                                  .toLowerCase()
                                                  .contains(
                                                      value.toLowerCase()))
                                              .toList();
                                    },
                                  ),
                                  title: "Select Industry",
                                  listView: Obx(() {
                                    return Expanded(
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(left: 5),
                                        itemCount: controller
                                            .filteredIndustryList.length,
                                        itemBuilder: (context, index) {
                                          final industry = controller
                                              .filteredIndustryList[index];
                                          return searchDialogItem(
                                            title: industry.title,
                                            onTap: () {
                                              var oldValue =
                                                  controller.industry.value;
                                              if (oldValue != industry.title) {
                                                controller.selectedServices
                                                    .clear();
                                              }
                                              controller.industry.value =
                                                  industry.title;
                                              controller.industryController
                                                  .value.text = industry.title;
                                              log(' controller.industry.value::${controller.industry.value}');
                                              Get.back();
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                );
                              },
                            ).whenComplete(
                              () {
                                controller.search.value = '';
                                controller.filteredIndustryList.value =
                                    industryList;
                              },
                            );
                          },
                        ),
                        Obx(() {
                          if (controller.industry.value.isEmpty) {
                            return SizedBox();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelHeight(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  commontext(text: "Add Services"),
                                  addBtn(onTap: () {
                                    // Find selected industry from industryList using model
                                    IndustryModel? selectedIndustry =
                                        industryList.firstWhereOrNull(
                                      (industry) =>
                                          industry.title ==
                                          controller.industry.value,
                                    );

                                    List<String> services =
                                        selectedIndustry?.services ?? [];
                                    RxList<String> tempSelectedServices =
                                        RxList<String>.from(
                                            controller.selectedServices);
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return Dialog(
                                          insetPadding: 20.horizontal,
                                          child: Container(
                                            height: 63.heightBox(),
                                            padding: 16.horizontal,
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                10.height,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Select Services",
                                                        style: poppinsStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    commonSaveButton(
                                                      onPressed: () {
                                                        controller
                                                            .selectedServices
                                                            .assignAll(
                                                                tempSelectedServices);
                                                        controller
                                                            .search.value = '';
                                                        Get.back();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: AppColors.hinttext
                                                      .withOpacity(0.1),
                                                  height: 2,
                                                ),
                                                15.height,

                                                // Search TextField
                                                commontextfield(
                                                  text: 'Search services...',
                                                  prefixIcon:
                                                      Icon(Icons.search),
                                                  onChanged: (value) {
                                                    controller.search.value =
                                                        value.toLowerCase();
                                                  },
                                                ),
                                                10.height,

                                                // Service List (Filtered by Search)
                                                Obx(() {
                                                  List<String>
                                                      filteredServices =
                                                      services
                                                          .where((service) =>
                                                              service
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      controller
                                                                          .search
                                                                          .value))
                                                          .toList();

                                                  return Expanded(
                                                    child: ListView(
                                                      padding: 5.onlyLeft,
                                                      children: filteredServices
                                                          .map((service) {
                                                        return CheckboxListTile(
                                                          title: Text(
                                                            service,
                                                            style: poppinsStyle(
                                                                color: AppColors
                                                                    .grey),
                                                          ),
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          activeColor: AppColors
                                                              .primarycolor,
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                          value:
                                                              tempSelectedServices
                                                                  .contains(
                                                                      service),
                                                          onChanged: (bool?
                                                              isChecked) {
                                                            if (isChecked!) {
                                                              tempSelectedServices
                                                                  .add(service);
                                                            } else {
                                                              tempSelectedServices
                                                                  .remove(
                                                                      service);
                                                            }
                                                          },
                                                        );
                                                      }).toList(),
                                                    ),
                                                  );
                                                })
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ).whenComplete(() {
                                      controller.search.value = '';
                                    });
                                  })
                                ],
                              ),
                              Obx(() {
                                return controller.selectedServices.isEmpty
                                    ? Container()
                                    : Padding(
                                        padding: 3.vertical,
                                        child: Wrap(
                                          spacing: 4,
                                          runSpacing: 4,
                                          children: controller.selectedServices
                                              .map((service) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 3),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    service,
                                                    style: poppinsStyle(
                                                      fontSize: 12,
                                                      color: AppColors.hinttext,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  GestureDetector(
                                                    onTap: () {
                                                      controller
                                                          .selectedServices
                                                          .remove(service);
                                                    },
                                                    child: Icon(Icons.close,
                                                        size: 20,
                                                        color: AppColors.red),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      );
                              }),
                            ],
                          );
                        }),
                        labelHeight(),
                        commontext(text: "About Company"),
                        fieldBottomHeight(),
                        commontextfield(
                          controller: controller.descriptionController.value,
                          onChanged: (value) {
                            controller.description.value = value;
                          },
                          text: "Enter about your company",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter about your company';
                            }

                            return null;
                          },
                        ),
                        labelHeight(),
                        commontext(text: "Email"),
                        fieldBottomHeight(),
                        commontextfield(
                          keyboardType: TextInputType.emailAddress,
                          controller: controller.emailController.value,
                          onChanged: (value) {
                            controller.email.value = value;
                          },
                          text: "Enter email",
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
                        commontext(text: "Phone Number"),
                        fieldBottomHeight(),
                        commontextfield(
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          controller: controller.phoneNumberController.value,
                          onChanged: (value) {
                            controller.phoneNumber.value = value;
                          },
                          text: "Enter mobile number",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter mobile number';
                            }
                            if (value.length != 10) {
                              return 'Mobile number must be exactly 10 digits';
                            }
                            return null;
                          },
                        ),
                        labelHeight(),
                        commontext(text: "Website"),
                        fieldBottomHeight(),
                        commontextfield(
                          controller: controller.websiteController.value,
                          onChanged: (value) {
                            controller.website.value = value;
                          },
                          text: "Enter website URL",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a website URL';
                            }
                            RegExp websiteRegExp = RegExp(
                              r'^(www\.)[a-z0-9-]+\.[a-z]{2,6}$',
                            );
                            if (!websiteRegExp.hasMatch(value)) {
                              return 'Invalid website URL';
                            }
                            return null;
                          },
                        ),
                        labelHeight(),
                        commontext(text: "Address"),
                        fieldBottomHeight(),
                        commontextfield(
                          controller: controller.addressController.value,
                          onChanged: (value) {
                            controller.address.value = value;
                          },
                          text: "Enter address",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter address';
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
                                    .filteredCountryList.value = countries;
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return searchDialog(
                                      searchField: commontextfield(
                                        text: "Search Country...",
                                        prefixIcon: countrySearchBtn(),
                                        onChanged: (value) {
                                          employeeFormController.countrySearch
                                              .value = value.toLowerCase();
                                          employeeFormController
                                                  .filteredCountryList.value =
                                              countries
                                                  .where((country) => country
                                                      .title
                                                      .toLowerCase()
                                                      .contains(
                                                          value.toLowerCase()))
                                                  .toList();
                                        },
                                      ),
                                      title: "Select Country",
                                      listView: Obx(() {
                                        return employeeFormController
                                                .filteredCountryList.isEmpty
                                            ? Expanded(child: searchLottie())
                                            : Expanded(
                                                child: ListView.builder(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
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
                                                        countries.indexWhere(
                                                            (c) =>
                                                                c.title ==
                                                                country.title);

                                                    return searchDialogItem(
                                                      title: country.title,
                                                      onTap: () {
                                                        employeeFormController
                                                            .selectCountryOnTap(
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
                                  employeeFormController.countrySearch.value =
                                      '';
                                });
                              },
                            )),
                        labelHeight(),
                        commontext(text: "Select State"),
                        fieldBottomHeight(),
                        Obx(() => commontextfield(
                              readOnly: true,
                              controller:
                                  employeeFormController.stateController.value,
                              text: "Select State",
                              suffixIcon: fieldSuffixIcon(),
                              onTap: () {
                                final selectedCountry = countries[
                                    employeeFormController
                                        .selectedCountryIndex.value];

                                employeeFormController.filteredStateList.value =
                                    selectedCountry.states;

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
                                              .stateSearch.value = lowerValue;

                                          employeeFormController
                                                  .filteredStateList.value =
                                              selectedCountry.states
                                                  .where((state) => state.name
                                                      .toLowerCase()
                                                      .contains(lowerValue))
                                                  .toList();
                                        },
                                      ),
                                      title: "Select State",
                                      listView: Obx(() {
                                        final filteredStates =
                                            employeeFormController
                                                .filteredStateList;

                                        return filteredStates.isEmpty
                                            ? Expanded(child: searchLottie())
                                            : Expanded(
                                                child: ListView.builder(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  itemCount:
                                                      filteredStates.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final selectedState =
                                                        filteredStates[index];
                                                    final originalIndex =
                                                        selectedCountry.states
                                                            .indexWhere((s) =>
                                                                s.name
                                                                    .toLowerCase() ==
                                                                selectedState
                                                                    .name
                                                                    .toLowerCase());

                                                    return searchDialogItem(
                                                      title: selectedState.name,
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
                                  employeeFormController.stateSearch.value = '';
                                });
                              },
                            )),
                        labelHeight(),
                        commontext(text: "Select City"),
                        fieldBottomHeight(),
                        Obx(() => commontextfield(
                              readOnly: true,
                              controller:
                                  employeeFormController.cityController.value,
                              text: "Select City",
                              suffixIcon: fieldSuffixIcon(),
                              onTap: () {
                                employeeFormController.filteredCityList.value =
                                    countries[employeeFormController
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
                                          employeeFormController.citySearch
                                              .value = value.toLowerCase();
                                          employeeFormController
                                              .filteredCityList
                                              .value = countries[
                                                  employeeFormController
                                                      .selectedCountryIndex
                                                      .value]
                                              .states[employeeFormController
                                                  .selectedStateIndex.value]
                                              .cities
                                              .where((city) => city
                                                  .toLowerCase()
                                                  .contains(
                                                      value.toLowerCase()))
                                              .toList();
                                        },
                                      ),
                                      title: "Select City",
                                      listView: Obx(() {
                                        return employeeFormController
                                                .filteredCityList.isEmpty
                                            ? Expanded(child: searchLottie())
                                            : Expanded(
                                                child: ListView.builder(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
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
                                                                city: city,
                                                                index: index);
                                                      },
                                                    );
                                                  },
                                                ),
                                              );
                                      }),
                                    );
                                  },
                                ).whenComplete(() {
                                  employeeFormController.citySearch.value = '';
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
                          controller: controller.zipCodeController.value,
                          onChanged: (value) {
                            controller.zipCode.value = value;
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
                        labelHeight(),
                        commontext(text: "LinkedIn"),
                        fieldBottomHeight(),
                        commontextfield(
                          controller: controller.linkedInController.value,
                          onChanged: (value) {
                            controller.linkedIn.value = value;
                          },
                          text: "Enter LinkedIn profile",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter LinkedIn profile URL';
                            }
                            RegExp linkedInRegExp = RegExp(
                              r'^(https?:\/\/)?(www\.)?linkedin\.com(\/[a-zA-Z0-9-_/]+\/?)?$',
                            );
                            if (!linkedInRegExp.hasMatch(value)) {
                              return 'Invalid LinkedIn profile URL';
                            }
                            return null;
                          },
                        ),
                        labelHeight(),
                        commontext(text: "Instagram"),
                        fieldBottomHeight(),
                        commontextfield(
                          controller: controller.instagramController.value,
                          onChanged: (value) {
                            controller.instagram.value = value;
                          },
                          text: "Enter Instagram profile",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Instagram profile URL';
                            }
                            RegExp instagramRegExp = RegExp(
                              r'^(https?:\/\/)?(www\.)?instagram\.com(\/[a-zA-Z0-9_.]+\/?)?$',
                            );
                            if (!instagramRegExp.hasMatch(value)) {
                              return 'Invalid Instagram profile URL';
                            }
                            return null;
                          },
                        ),
                        labelHeight(),
                        commontext(text: "Founded Year"),
                        fieldBottomHeight(),
                        commontextfield(
                          readOnly: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: controller.foundedYearController.value,
                          onTap: () {
                            controller.selectYear(context);
                          },
                          text: "Select founded year",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select the founded year';
                            }
                            return null;
                          },
                        ),
                        labelHeight(),
                      ],
                    ),
                  ),
                ),
                10.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget fieldSuffixIcon({Color? color}) {
  return Icon(
    Icons.keyboard_arrow_down,
    color: color ?? AppColors.hinttext,
  );
}
