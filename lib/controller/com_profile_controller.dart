import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:employeeform/common/comman_widget.dart';
import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/config/color.dart';
import 'package:employeeform/view/admin_side/bottom_nav_admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/imagehelper.dart';
import '../config/list.dart';
import '../model/com_profile_model.dart';

class CompanyProfileController extends GetxController {
  var profile = Rxn<CompanyProfile>(); // Nullable profile object
  var isProfileAdded = false.obs;
  var editScreen = false.obs;
  // var profileImagePath = ''.obs;
  // var backgroundImagePath = ''.obs;
  var profileImage = Rx<File?>(null);
  var backgroundImage = Rx<File?>(null);

  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  Rx<TextEditingController> companySizeController = TextEditingController().obs;

  Rx<TextEditingController> industryController = TextEditingController().obs;
  Rx<TextEditingController> countryController = TextEditingController().obs;
  Rx<TextEditingController> stateController = TextEditingController().obs;
  Rx<TextEditingController> cityController = TextEditingController().obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> websiteController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> linkedInController = TextEditingController().obs;
  Rx<TextEditingController> instagramController = TextEditingController().obs;
  Rx<TextEditingController> foundedYearController = TextEditingController().obs;
  Rx<TextEditingController> zipCodeController = TextEditingController().obs;

  RxString companyName = ''.obs;
  RxString companySize = ''.obs;
  RxString industry = ''.obs;
  RxString searchIndustry = ''.obs;
  RxString description = ''.obs;
  RxString email = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString website = ''.obs;
  RxString address = ''.obs;
  RxString linkedIn = ''.obs;
  RxString instagram = ''.obs;
  RxString foundedYear = ''.obs;
  RxString zipCode = ''.obs;
  RxString search = ''.obs;
  RxString countrySearch = ''.obs;
  RxString stateSearch = ''.obs;
  RxString citySearch = ''.obs;
  RxInt selectedCountryIndex = 0.obs; // No country selected initially
  RxInt selectedStateIndex = 0.obs; // No state selected initially
  RxInt selectedCity = 0.obs;
  RxList<String> services = <String>[].obs;
  RxList<String> selectedServices = <String>[].obs;
  RxList<IndustryModel> filteredIndustryList = <IndustryModel>[].obs;
  var filteredCountryList = <CountryModel>[].obs;
  RxList<StateModel> filteredStateList = <StateModel>[].obs;
  RxList<String> filteredCityList = <String>[].obs;

  var isTapped = false.obs;
  @override
  void onInit() {
    loadCompanyProfile();
    filteredIndustryList.assignAll(industryList);
    selectCountry();
    log("selectedCountryList==>>${filteredCountryList}");
    super.onInit();
  }

  Future<void> pickImage(bool isProfile) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File? croppedFile = await ImageCropperHelper.cropImage(
        File(pickedFile.path),
      );
      if (croppedFile != null) {
        if (isProfile) {
          profileImage.value = croppedFile;
        } else {
          backgroundImage.value = croppedFile;
        }
      }
    }
  }

  Future<void> selectCountry() async {
    selectedCountryIndex.value = 0;
    selectedStateIndex.value = 0;
    selectedCity.value = 0;

    log('filteredStateList: ${filteredStateList}');
    filteredCountryList.clear();
    filteredStateList.clear();
    filteredCityList.clear();
    filteredCountryList.assignAll(countries);
    log('filteredCountryList==>>${filteredCountryList}');
    if (filteredCountryList.isNotEmpty) {
      selectedCountryIndex.value = 0;
      countryController.value.text = filteredCountryList[0].title;

      if (filteredCountryList[0].states.isNotEmpty) {
        selectedStateIndex.value = 0;
        stateController.value.text = filteredCountryList[0].states[0].name;

        // Assign cities from the first state's list
        filteredCityList.assignAll(filteredCountryList[0].states[0].cities);

        if (filteredCityList.isNotEmpty) {
          selectedCity.value = 0;
          cityController.value.text = filteredCityList[0];
        }
      }
    }
  }

  Future<void> saveCompanyProfile(CompanyProfile companyProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'companyProfile', json.encode(companyProfile.toJson()));
    await prefs.setBool('isProfileAdded', true);
    profile.value = companyProfile;
    isProfileAdded.value = true;
  }

  /// Load Company Profile
  Future<void> loadCompanyProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('companyProfile');
    isProfileAdded.value = prefs.getBool('isProfileAdded') ?? false;
    log("isProfileAdded::${isProfileAdded.value}");
    if (jsonString != null) {
      profile.value = CompanyProfile.fromJson(json.decode(jsonString));
      log("After loading profile: ${profile.value!.services}");

      /// Ensure `selectedServices` is updated properly

      selectedServices.clear();
      selectedServices.addAll(profile.value!.services ?? []);
      log("loading profile: ${selectedServices}");
    }
    log('profile::${profile}');
  }

  Future<void> clearProfile() async {
    isProfileAdded.value = false;
    profile.value = null;
    profileImage.value = null;
    backgroundImage.value = null;
    companyNameController.value.clear();
    companySizeController.value.clear();
    industryController.value.clear();
    descriptionController.value.clear();
    emailController.value.clear();
    phoneNumberController.value.clear();
    websiteController.value.clear();
    zipCodeController.value.clear();
    addressController.value.clear();
    linkedInController.value.clear();
    instagramController.value.clear();
    foundedYearController.value.clear();
    companyName.value = '';
    companySize.value = '';
    industry.value = '';
    description.value = '';
    email.value = '';
    phoneNumber.value = '';
    website.value = '';
    address.value = '';
    zipCode.value = '';
    linkedIn.value = '';
    instagram.value = '';
    foundedYear.value = '';
    editScreen.value = false;
    selectedServices.clear();
    services.clear();

    // ✅ Reload country, state, and city lists

    // selectCountry();
    // Reassign country, state, and city lists

    log('filteredStateList clearProfile: ${filteredStateList}');
    // selectedCountryIndex.value = 0; // No country selected initially
    // selectedStateIndex.value = 0; // No state selected initially
    // selectedCity.value = 0;
    // filteredIndustryList.clear();
    // filteredCityList.clear();
    // filteredStateList.clear();
    // filteredCountryList.clear();
    // filteredCityList.clear();
    // filteredStateList.clear();
    // filteredCountryList.clear();

    // Reassign country, state, and city lists
    /* if (countries.isNotEmpty) {
      // Reset country selection
      selectedCountryIndex.value = 0;
      countryController.value.text = countries[0].title;

      // ✅ Update filteredStateList based on selected country
      filteredStateList.assignAll(countries[0].states);

      if (filteredStateList.isNotEmpty) {
        // Reset state selection
        selectedStateIndex.value = 0;
        stateController.value.text = filteredStateList[0].name;

        // ✅ Update filteredCityList based on selected state
        filteredCityList.assignAll(filteredStateList[0].cities);

        if (filteredCityList.isNotEmpty) {
          // Reset city selection
          selectedCity.value = 0;
          cityController.value.text = filteredCityList[0];
        }
      }
    }*/
    // Reassign default country and state lists
    // selectCountry();
  }

  bool validateAllFields() {
    // if (profileImage.value == null || profileImage.value!.path.isEmpty) {
    //   primaryToast(msg: "Please upload a Profile Image.");
    //   return false;
    // }
    //
    // if (backgroundImage.value == null || backgroundImage.value!.path.isEmpty) {
    //   primaryToast(msg: "Please upload a Cover Image.");
    //   return false;
    // }

    if (companyName.value.trim().isEmpty) {
      primaryToast(msg: "Please enter your Company name.");
      return false;
    }

    if (companySize.value.trim().isEmpty) {
      primaryToast(msg: "Please select number of employees.");
      return false;
    }

    if (industry.value.trim().isEmpty) {
      primaryToast(msg: "Please select Industry.");
      return false;
    }
    if (selectedServices.isEmpty) {
      primaryToast(msg: 'Please select at least one service.');
      return false;
    }
    if (description.value.trim().isEmpty) {
      primaryToast(msg: 'Please enter about your company.');
      return false;
    }
    if (email.value.trim().isEmpty) {
      primaryToast(msg: 'Please enter your email.');
      return false;
    }

    RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$');
    if (!emailRegExp.hasMatch(email.value.trim())) {
      primaryToast(msg: 'Please enter a valid email.');
      return false;
    }

    if (phoneNumber.value.trim().isEmpty) {
      primaryToast(msg: 'Please enter your mobile number.');
      return false;
    }

    if (phoneNumber.value.trim().length != 10) {
      primaryToast(msg: 'Mobile number must be exactly 10 digits.');
      return false;
    }

    if (website.value.trim().isEmpty) {
      primaryToast(msg: 'Please enter website URL.');
      return false;
    }

    RegExp websiteRegExp = RegExp(
      r'^(www\.)[a-z0-9-]+\.[a-z]{2,6}$',
    );
    if (!websiteRegExp.hasMatch(website.value.trim())) {
      primaryToast(msg: 'Please enter a valid website URL.');
      return false;
    }

    if (address.value.trim().isEmpty) {
      primaryToast(msg: 'Please enter address.');
      return false;
    }
    if (zipCode.value.trim().isEmpty) {
      primaryToast(msg: 'Please enter Zip Code.');
      return false;
    }

    if (zipCode.value.trim().length < 5 || zipCode.value.trim().length > 6) {
      primaryToast(msg: 'Zip Code must be 5 or 6 digits.');
      return false;
    }

    if (linkedIn.value.trim().isEmpty) {
      primaryToast(msg: 'Please enter LinkedIn profile URL.');
      return false;
    }

    RegExp linkedInRegExp = RegExp(
      r'^(https?:\/\/)?(www\.)?linkedin\.com(\/[a-zA-Z0-9-_/]+\/?)?$',
    );
    if (!linkedInRegExp.hasMatch(linkedIn.value.trim())) {
      primaryToast(msg: 'Please enter a valid LinkedIn profile URL.');
      return false;
    }

    if (instagram.value.trim().isEmpty) {
      primaryToast(msg: 'Please enter Instagram profile URL.');
      return false;
    }

    RegExp instagramRegExp = RegExp(
      r'^(https?:\/\/)?(www\.)?instagram\.com(\/[a-zA-Z0-9_.]+\/?)?$',
    );
    if (!instagramRegExp.hasMatch(instagram.value.trim())) {
      primaryToast(msg: 'Please enter a valid Instagram profile URL.');
      return false;
    }

    if (foundedYear.value.trim().isEmpty) {
      primaryToast(msg: 'Please select the founded year.');
      return false;
    }
    return true; // ✅ All fields are valid
  }

  Future<void> selectYear(BuildContext context) async {
    int currentYear = DateTime.now().year;
    int firstYear = 1900;
    RxInt selectedYear = RxInt(int.tryParse(foundedYear.value) ?? currentYear);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: 16.symmetric,
            decoration: commonDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Select Year",
                    style: poppinsStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                10.height,
                SizedBox(
                  height: 25.hp(context),
                  child: Theme(
                    data: ThemeData(
                      primaryColor: AppColors.primarycolor, // Set primary color
                      colorScheme: ColorScheme.light(
                        primary: AppColors.primarycolor, // Apply color scheme
                      ),
                      dividerColor: AppColors.hinttext,
                    ),
                    child: Obx(() => YearPicker(
                          firstDate: DateTime(firstYear),
                          lastDate: DateTime(currentYear),
                          selectedDate: DateTime(selectedYear.value),
                          onChanged: (DateTime date) {
                            selectedYear.value = date.year; // Update RxInt
                          },
                        )),
                  ),
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    alertButton(
                      label: "Cancel",
                      buttonColor: AppColors.bordercolor,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    alertButton(
                        label: "OK",
                        onPressed: () {
                          foundedYear.value = selectedYear.value.toString();
                          foundedYearController.value.text =
                              selectedYear.value.toString();
                          Get.back(); // Close dialog and save
                        },
                        fontColor: AppColors.white,
                        buttonColor: AppColors.primarycolor)
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openURL(String url) async {
    final Uri uri = Uri.parse(
      url.startsWith('http') ? url : 'https://$url',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // You can show a toast/snackbar here
      print("Could not launch $url");
    }

    // if (await canLaunchUrl(Uri.parse(url))) {
    //   await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    // } else {
    //   primaryToast(
    //     msg: "Could not launch $url",
    //   );
    // }
  }

  Future<void> deleteProfile() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("companyProfile");
    prefs.remove("isProfileAdded");
    clearProfile();
    Get.to(() => BottomNavAdmin());
  }
}
