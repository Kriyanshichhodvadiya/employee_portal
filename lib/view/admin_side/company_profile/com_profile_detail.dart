import 'dart:developer';
import 'dart:io';

import 'package:employeeform/config/images.dart';
import 'package:employeeform/controller/employeeformContro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../common/comman_widget.dart';
import '../../../common/global_widget.dart';
import '../../../config/color.dart';
import '../../../controller/com_profile_controller.dart';
import '../bottom_nav_admin.dart';
import 'co_profile_form.dart';

class CompanyProfileDetails extends StatefulWidget {
  @override
  State<CompanyProfileDetails> createState() => _CompanyProfileDetailsState();
}

class _CompanyProfileDetailsState extends State<CompanyProfileDetails> {
  CompanyProfileController controller = Get.put(CompanyProfileController());
  EmployeeFormController employeeFormController = Get.find();

  @override
  void initState() {
    controller.loadCompanyProfile();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => BottomNavAdmin());
        return false;
      },
      child: Obx(
        () => controller.profile.value == null
            ? Scaffold(body: Center(child: CupertinoActivityIndicator()))
            : Scaffold(
                backgroundColor: AppColors.white,
                appBar: appBar(
                  showBack: true,
                  title: controller.profile.value!.companyName,
                  onTap: () {
                    Get.off(() => BottomNavAdmin());
                  },
                  actions: [
                    IconButton(
                      icon: Icon(Icons.edit, color: AppColors.grey),
                      onPressed: () {
                        var profile = controller.profile.value!;
                        controller.companyNameController.value.text =
                            profile.companyName;
                        controller.companySizeController.value.text =
                            profile.companySize;
                        controller.industryController.value.text =
                            profile.industry;
                        controller.descriptionController.value.text =
                            profile.description;
                        controller.phoneNumberController.value.text =
                            profile.phoneNumber;
                        controller.emailController.value.text = profile.email;
                        controller.websiteController.value.text =
                            profile.website;
                        controller.instagramController.value.text =
                            profile.instagram;
                        controller.addressController.value.text =
                            profile.address;
                        controller.zipCodeController.value.text =
                            profile.zipCode;
                        controller.linkedInController.value.text =
                            profile.linkedIn;
                        controller.foundedYearController.value.text =
                            profile.foundedYear;
                        controller.companyName.value = profile.companyName;
                        controller.companySize.value = profile.companySize;
                        controller.industry.value = profile.industry;
                        controller.description.value = profile.description;
                        controller.phoneNumber.value = profile.phoneNumber;
                        controller.email.value = profile.email;
                        controller.website.value = profile.website;
                        controller.address.value = profile.address;
                        controller.zipCode.value = profile.zipCode;
                        controller.linkedIn.value = profile.linkedIn;
                        controller.instagram.value = profile.instagram;
                        controller.foundedYear.value = profile.foundedYear;
                        controller.profileImage.value =
                            File(profile.profileImage);
                        controller.backgroundImage.value =
                            File(profile.backgroundImage);
                        controller.editScreen.value = true;
                        employeeFormController.editCountryValue(
                          country: profile.country,
                          state: profile.state,
                          city: profile.city,
                        );
                        log("profile.country::${profile.country}");
                        log("profile.state::${profile.state}");
                        log("profile.city::${profile.city}");
                        log("profile.services::${profile.services}");
                        // controller.selectedServices.addAll(profile.services);
                        log("profile.services::${profile.services}");
                        log("controller.selectedServices::${controller.selectedServices}");
                        Get.to(() => CompanyProfileForm());
                      },
                    ),
                  ],
                ),
                body: Obx(() {
                  var profile = controller.profile.value;
                  if (profile == null) {
                    return commonLottie();
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Image + Background
                        Container(
                          height: 17.hp(context),
                          width: double.infinity,
                          child: Stack(
                            clipBehavior: Clip.none,
                            fit: StackFit.expand,
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                height: 10.hp(context),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  boxShadow: [commonShadow()],
                                  image: profile.backgroundImage.isNotEmpty
                                      ? DecorationImage(
                                          image: FileImage(
                                              File(profile.backgroundImage)),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
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
                              Positioned(
                                bottom: -50,
                                left: 16,
                                child: Center(
                                    child: Container(
                                  height: 12.hp(context),
                                  width: 12.hp(context),
                                  decoration: profile.profileImage.isNotEmpty
                                      ? BoxDecoration(
                                          color: AppColors.white,
                                          // shape: BoxShape.circle,
                                          boxShadow: [commonShadow()],
                                          border: commonBorder(),
                                          image: DecorationImage(
                                              image: FileImage(
                                                  File(profile.profileImage)),
                                              fit: BoxFit.cover))
                                      : BoxDecoration(
                                          color: AppColors.white,
                                          border: commonBorder(),
                                          // shape: BoxShape.circle,
                                          boxShadow: [commonShadow()],
                                        ),
                                  child: profile.profileImage.isEmpty
                                      ? Icon(Icons.person,
                                          size: 40, color: Colors.grey.shade700)
                                      : null,
                                )),
                              ),
                            ],
                          ),
                        ),
                        60.height,

                        // Company Info
                        Padding(
                          padding: 20.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile.companyName,
                                  style: poppinsStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              5.height,
                              Text(
                                  "${profile.industry} • ${profile.companySize} Employees",
                                  style: poppinsStyle(
                                      fontSize: 13, color: AppColors.hinttext)),
                            ],
                          ),
                        ),
                        16.height,
                        Divider(
                          thickness: 10,
                          color: AppColors.businesscborder.withOpacity(0.3),
                        ),
                        // Details Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            10.height,
                            sectionTitle(
                                title: "Services", icon: AppSvg.service),
                            5.height,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: List.generate(
                                  (profile.services.length ?? 0),
                                  (index) {
                                    bool addDot = index % 2 == 0 &&
                                        index + 1 < profile.services.length;

                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          profile.services[index],
                                          style: poppinsStyle(
                                            color: AppColors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        if (addDot) // Adds a centered dot between every two services
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 3),
                                            child: Text(
                                              "•",
                                              style: poppinsStyle(
                                                color: AppColors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            commonDivider(),
                            sectionTitle(
                                title: "About Us", icon: AppSvg.aboutus),
                            5.height,
                            detailText(profile.description),
                            commonDivider(),
                            sectionTitle(
                                title: "Contact Info",
                                icon: AppSvg.contact_info),
                            5.height,
                            detailText(profile.email, icon: Icons.email),
                            detailText(profile.phoneNumber, icon: Icons.phone),
                            detailText(
                                "${profile.address} - ${profile.zipCode}",
                                icon: Icons.location_on),
                            detailText(
                                "${profile.city.toString()},${profile.state},${profile.country}",
                                icon: Icons.public_outlined),
                            commonDivider(),
                            sectionTitle(
                                title: "Social Media",
                                icon: AppSvg.socialmedia),
                            5.height,
                            socialMediaText(
                              icon: AppSvg.linkedin,
                              label: profile.linkedIn,
                              onTap: () {
                                controller.openURL(profile.linkedIn);
                              },
                            ),
                            socialMediaText(
                              label: profile.website,
                              icon: Icons.language,
                              onTap: () {
                                controller.openURL(profile.website);
                              },
                            ),
                            socialMediaText(
                              icon: AppSvg.instagram,
                              label: profile.instagram,
                              onTap: () {
                                controller.openURL(profile.instagram);
                              },
                            ),
                            commonDivider(),
                            sectionTitle(
                                title: "Founded Year",
                                icon: AppSvg.foundedyear),
                            5.height,
                            detailText(profile.foundedYear),
                          ],
                        ),
                        20.height,
                      ],
                    ),
                  );
                }),
              ),
      ),
    );
  }

  Widget sectionTitle({required String title, required icon}) {
    return Padding(
      padding: 16.horizontal,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            height: 2.5.heightBox(),
            width: 2.5.heightBox(),
          ),
          8.width,
          Text(title,
              style: poppinsStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget detailText(String text, {IconData? icon}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: icon != null,
              child: Padding(
                padding: 2.onlyTop,
                child: Icon(icon, size: 15, color: AppColors.hinttext),
              )),
          Visibility(visible: icon != null, child: 8.width),
          Expanded(
            child: Text(text,
                style: poppinsStyle(
                  fontSize: 13,
                  color: AppColors.hinttext,
                )),
          ),
        ],
      ),
    );
  }
}

Widget comDetailText({required label}) {
  return Text(label,
      style:
          poppinsStyle(fontSize: 13, color: AppColors.grey.withOpacity(0.7)));
}

Widget socialMediaText(
    {required label, required void Function()? onTap, required icon}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: 4.onlyTop,
          child: icon is IconData
              ? Icon(
                  icon,
                  size: 1.7.heightBox(),
                  color: AppColors.primarycolor,
                )
              : SvgPicture.asset(
                  icon,
                  height: 1.7.heightBox(),
                  width: 1.7.heightBox(),
                  fit: BoxFit.fill,
                ),
        ),
        10.width,
        Expanded(
          child: RichText(
            text: TextSpan(
                text: label,
                style: poppinsStyle(
                  fontSize: 13,
                  color: AppColors.blue,
                ),
                recognizer: TapGestureRecognizer()..onTap = onTap),
          ),
        )
      ],
    ),
  );
}
