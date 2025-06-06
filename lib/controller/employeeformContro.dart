import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:employeeform/common/global_widget.dart';
import 'package:employeeform/view/login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/comman_widget.dart';
import '../config/imageHelper.dart';
import '../config/list.dart';
import '../model/com_profile_model.dart';
import '../model/eprofilemodel.dart';
import '../view/admin_side/bottom_nav_admin.dart';

class EmployeeFormController extends GetxController {
  ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);

  Rx<TextEditingController> firstnamecontroller = TextEditingController().obs;
  Rx<TextEditingController> middlenamecontroller = TextEditingController().obs;
  Rx<TextEditingController> lastnamecontroller = TextEditingController().obs;
  Rx<TextEditingController> addresscontroller = TextEditingController().obs;

  Rx<TextEditingController> aadharcontroller = TextEditingController().obs;
  Rx<TextEditingController> banknamercontroller = TextEditingController().obs;
  Rx<TextEditingController> branchaddresscontroller =
      TextEditingController().obs;
  Rx<TextEditingController> countryController = TextEditingController().obs;
  Rx<TextEditingController> stateController = TextEditingController().obs;
  Rx<TextEditingController> cityController = TextEditingController().obs;

  Rx<TextEditingController> acnocontroller = TextEditingController().obs;
  Rx<TextEditingController> ifsccontroller = TextEditingController().obs;
  Rx<TextEditingController> referancecontroller = TextEditingController().obs;
  Rx<TextEditingController> srnocontroller = TextEditingController().obs;

  Rx<TextEditingController> mobilenucontroller = TextEditingController().obs;
  Rx<TextEditingController> mobilenutwocontroller = TextEditingController().obs;
  Rx<TextEditingController> emailcontroller = TextEditingController().obs;
  Rx<TextEditingController> otherTextController = TextEditingController().obs;
  Rx<TextEditingController> zipCodeController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController =
      TextEditingController().obs;
  var obscurePassword = true.obs;
  var obscureConfirm = true.obs;
  RxString fname = ''.obs;
  RxString middlename = ''.obs;
  RxString lname = ''.obs;
  RxString address = ''.obs;
  RxString aadhar = ''.obs;
  RxString group = ''.obs;
  RxString mobileNumber = ''.obs;
  RxString mobileNumbertwo = ''.obs;
  RxString email = ''.obs;
  RxString dropdownvalue = 'Indian'.obs;
  RxString dropdownvaluebank = 'SBI'.obs;
  RxString branchaddres = ''.obs;
  RxString acno = ''.obs;
  RxString ifsc = ''.obs;
  RxString referance = ''.obs;
  RxString officegroup = ''.obs;
  RxString pass = ''.obs;
  RxString confirmPass = ''.obs;
  RxString seletedproof = ''.obs;
  RxString bankname = ''.obs;
  RxString ortherdoc = ''.obs;
  RxString poofgroup = ''.obs;
  var filteredCountryList = <CountryModel>[].obs;
  RxList<StateModel> filteredStateList = <StateModel>[].obs;
  RxList<String> filteredCityList = <String>[].obs;
  RxInt selectedCountryIndex = 0.obs; // No country selected initially
  RxInt selectedStateIndex = 0.obs; // No state selected initially
  RxInt selectedCity = 0.obs;
  RxString countrySearch = ''.obs;
  RxString zipCode = ''.obs;
  RxString stateSearch = ''.obs;
  RxString citySearch = ''.obs;
  var isAadharSelected = false.obs;
  var isBankPassbookSelected = false.obs;
  var isOtherSelected = false.obs;
  List<String> selectedProofs = [];
  RxList<File> selectedDocuments = <File>[].obs;
  var selectedDate = DateTime.now().obs;
  Rx<DateTime> selectedDateFrom = DateTime.now().obs;
  RxMap<String, File?> uploadedDocuments = <String, File?>{}.obs;
  Rx<TextEditingController> customDocNameController =
      TextEditingController().obs;
  var documentName = ''.obs;
  var otherDocuments = <OtherDocumentsModel>[].obs;
  var uploadedMultipleDocuments = <String, List<File>>{}.obs;
  var selectedDocs = <int, bool>{}.obs;
  RxString frontAadharFilePath = "".obs; // To store the front file path
  RxString backAadharFilePath = "".obs;
  @override
  void onInit() {
    selectCountry();
    log("selectedCountryList==>>${filteredCountryList}");
    super.onInit();
  }

  void resetCountryValue() {
    if (countries.isNotEmpty) {
      selectedCountryIndex.value = 0;
      final firstCountry = countries[0];
      countryController.value.text = firstCountry.title;

      final states = firstCountry.states;
      if (states.isNotEmpty) {
        selectedStateIndex.value = 0;
        final firstState = states[0];
        stateController.value.text = firstState.name;

        final cities = firstState.cities;
        if (cities.isNotEmpty) {
          cityController.value.text = cities[0];
          filteredCityList.value = cities; // Ensure the cities are updated here
        } else {
          cityController.value.clear();
          filteredCityList.value = []; // Clear the city list if no cities found
        }

        filteredStateList.value =
            states; // Ensure the filtered state list is set
      } else {
        stateController.value.clear();
        cityController.value.clear();

        selectedStateIndex.value = 0;
        filteredStateList.value = [];
        filteredCityList.value = []; // Clear city list when no states
      }

      filteredCountryList.value = countries;
    } else {
      // No countries
      countryController.value.clear();
      stateController.value.clear();
      cityController.value.clear();

      selectedCountryIndex.value = 0;
      selectedStateIndex.value = 0;

      filteredCountryList.value = [];
      filteredStateList.value = [];
      filteredCityList.value = [];
    }

    log('Reset to:');
    log('Country: ${countryController.value.text}');
    log('State: ${stateController.value.text}');
    log('City: ${cityController.value.text}');
  }

  void editCountryValue({String? country, String? state, String? city}) {
    selectedCountryIndex.value = 0;
    selectedStateIndex.value = 0;

    if (countries.isNotEmpty) {
      print('All Countries: ${countries.map((c) => c.title).toList()}');

      final countryIndex = countries.indexWhere((c) => c.title == country);
      if (countryIndex != -1) {
        selectedCountryIndex.value = countryIndex;
      }

      final selectedCountry = countries[selectedCountryIndex.value];
      countryController.value.text = selectedCountry.title;
      filteredCountryList.value = List.from(countries); // Clone country list

      print('Selected Country: ${selectedCountry.title}');
      print(
          'States in ${selectedCountry.title}: ${selectedCountry.states.map((s) => s.name).toList()}');

      final stateIndex =
          selectedCountry.states.indexWhere((s) => s.name == state);
      if (stateIndex != -1) {
        selectedStateIndex.value = stateIndex;
      }

      final selectedState = selectedCountry.states.isNotEmpty
          ? selectedCountry.states[selectedStateIndex.value]
          : null;

      print('✅ Selected State: ${selectedState?.name ?? "None"}');
      print('📍 State Index: ${selectedStateIndex.value}');

      if (selectedState != null) {
        stateController.value.text = selectedState.name;

        // Clone the state list so we don’t modify the original
        filteredStateList.value = List.from(selectedCountry.states);

        print('🏙 Cities in ${selectedState.name}: ${selectedState.cities}');

        if (selectedState.cities.isNotEmpty) {
          final clonedCities = List<String>.from(selectedState.cities);

          if (city != null && clonedCities.contains(city)) {
            cityController.value.text = city;
          } else {
            cityController.value.text = clonedCities[0];
          }

          filteredCityList.value = clonedCities;
          print('✅ Selected City: ${cityController.value.text}');
        } else {
          cityController.value.clear();
          filteredCityList.clear();
          print('⚠️ No cities found in ${selectedState.name}');
        }
      } else {
        stateController.value.clear();
        cityController.value.clear();
        filteredStateList.clear();
        filteredCityList.clear();
      }
    } else {
      countryController.value.clear();
      stateController.value.clear();
      cityController.value.clear();
      filteredCountryList.clear();
      filteredStateList.clear();
      filteredCityList.clear();
      print('❌ No countries found.');
    }

    print('🔄 Final Edit Values:');
    print('Country: ${countryController.value.text}');
    print('State: ${stateController.value.text}');
    print('City: ${cityController.value.text}');
  }

  // void editCountryValue({String? country, String? state, String? city}) {
  //   selectedCountryIndex.value = 0;
  //   selectedStateIndex.value = 0;
  //
  //   // If countries list is available
  //   if (countries.isNotEmpty) {
  //     final countryIndex = countries.indexWhere((c) => c.title == country);
  //     if (countryIndex != -1) {
  //       selectedCountryIndex.value = countryIndex;
  //     }
  //
  //     final selectedCountry = countries[selectedCountryIndex.value];
  //     countryController.value.text = selectedCountry.title;
  //     filteredCountryList.value = countries;
  //
  //     print('Selected Country: ${selectedCountry.title}');
  //     print('Selected Country Index: ${selectedCountryIndex.value}');
  //
  //     final stateIndex =
  //         selectedCountry.states.indexWhere((s) => s.name == state);
  //     if (stateIndex != -1) {
  //       selectedStateIndex.value = stateIndex;
  //     }
  //
  //     final selectedState = selectedCountry.states.isNotEmpty
  //         ? selectedCountry.states[selectedStateIndex.value]
  //         : null;
  //
  //     print('Selected State: ${selectedState?.name ?? "None"}');
  //     print('Selected State Index: ${selectedStateIndex.value}');
  //
  //     if (selectedState != null) {
  //       stateController.value.text = selectedState.name;
  //       filteredStateList.value = selectedCountry.states;
  //
  //       if (selectedState.cities.isNotEmpty) {
  //         if (city != null && selectedState.cities.contains(city)) {
  //           cityController.value.text = city;
  //         } else {
  //           cityController.value.text = selectedState.cities[0];
  //         }
  //         filteredCityList.value = selectedState.cities;
  //
  //         print('Selected City: ${cityController.value.text}');
  //       } else {
  //         cityController.value.clear();
  //         filteredCityList.value = [];
  //       }
  //     } else {
  //       stateController.value.clear();
  //       cityController.value.clear();
  //       filteredStateList.value = [];
  //       filteredCityList.value = [];
  //     }
  //   } else {
  //     countryController.value.clear();
  //     stateController.value.clear();
  //     cityController.value.clear();
  //     filteredCountryList.value = [];
  //     filteredStateList.value = [];
  //     filteredCityList.value = [];
  //   }
  //
  //   print('Edit to:');
  //   print('Country: ${countryController.value.text}');
  //   print('State: ${stateController.value.text}');
  //   print('City: ${cityController.value.text}');
  // }

  void removeNewFiles(
    int index,
  ) {
    if (index >= 0 && index < otherDocuments.length) {
      otherDocuments[index].otherFile = null;

      otherDocuments.refresh();
    }
  }

  void removeAadharCard() {
    frontAadharFilePath.value = '';
    backAadharFilePath.value = '';
  }

// select country from dialog
  void selectCountryOnTap({required originalIndex, required country}) {
    filteredStateList.value = [];
    selectedCountryIndex.value = originalIndex;
    countryController.value.text = country.title;
    if (country.states.isNotEmpty) {
      selectedStateIndex.value = 0;
      stateController.value.text = country.states[0].name;
      filteredStateList.assignAll(country.states);
      if (country.states[0].cities.isNotEmpty) {
        selectedCity.value = 0;
        cityController.value.text = country.states[0].cities[0];
        filteredCityList.assignAll(country.states[0].cities);
      }
    }
    Get.back();
  }

  void selectStateOnTap({
    required selectedCountry,
    required selectedState,
  }) {
    log('selectedCountry${selectedCountry.states}');
    log('selectedState${selectedState.cities}');
    final originalIndex = selectedCountry.states.indexWhere(
      (s) => s.name.toLowerCase() == selectedState.name.toLowerCase(),
    );
    log('originalIndex::${originalIndex}');
    if (originalIndex == -1) {
      print(' Error: Selected state not found in original list');
      return;
    }

    final actualState = selectedCountry.states[originalIndex];

    // //  If user taps the same state again, just return (no need to reprocess)
    // if (selectedStateIndex.value == originalIndex &&
    //     stateController.value.text == actualState.name &&
    //     filteredCityList.isNotEmpty &&
    //     cityController.value.text.isNotEmpty) {
    //   print(' Same state reselected. No changes made.');
    //   Get.back();
    //   return;
    // }

    //  Update state info
    selectedStateIndex.value = originalIndex;
    stateController.value.text = actualState.name;
    print(' State selected: ${actualState.name}');
    print(' State Index: $originalIndex');

    //  Reset city data
    cityController.value.clear();
    selectedCity.value = -1;
    filteredCityList.clear();

    final cities = actualState.cities;
    print(' Cities in selected state: $cities');

    if (cities.isNotEmpty) {
      filteredCityList.assignAll(cities);
      selectedCity.value = 0;
      cityController.value.text = cities[0];
      print(' First city auto-selected: ${cities[0]}');
    } else {
      print(' No cities found for this state.');
    }

    print(' Final State Selection Values:');
    print(' Country: ${selectedCountry.title}');
    print(' State: ${stateController.value.text}');
    print(' City: ${cityController.value.text}');

    Get.back();
  }

// select state from dialog
  void selectCityOnTap({required index, required city}) {
    selectedCity.value = index;

    cityController.value.text = city;
    Get.back();
  }

  void toggleDocSelection(
    int index,
    String docName,
    bool isChecked,
  ) {
    selectedDocs[index] = isChecked;
    otherDocuments[index].check = isChecked; // <-- Important to set this
    otherDocuments.refresh();
    if (isChecked) {
      getSelectedProofs();
    } else {
      removeDocuments(docName);
    }
  }

  void addDocumentName() {
    final name = customDocNameController.value.text;
    if (name.isNotEmpty) {
      otherDocuments.add(OtherDocumentsModel(name: name));
      customDocNameController.value.clear();
    }
  }

  Future<void> pickMultiFile(int index) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      // Assign the file to the 'otherFile' field instead of 'file'
      otherDocuments[index].otherFile = File(result.files.single.path!);
      otherDocuments.refresh(); // Important to refresh the list
    }
  }

  void removeMultiDocument(int index) {
    otherDocuments.removeAt(index);
  }

  Future<void> pickAadharDoc(String documentType, String side) async {
    // Use file picker to pick the file (you can use packages like 'file_picker')
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path ?? "";

      if (side == "front") {
        frontAadharFilePath.value = filePath;
        // Update UI or save the front side file path
      } else if (side == "back") {
        backAadharFilePath.value = filePath;
        // Update UI or save the back side file path
      }

      // After selecting the file, update the UI or show the file name, etc.
      update();
    } else {
      // Handle case where no file is selected
      primaryToast(msg: "No file selected");
    }
  }

  void pickDocumentFor(String proofType) async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        File pickedFile = File(result.files.single.path!);

        // Set specific file variables based on proofType
        if (proofType == commonString.aadhar) {
          aadharFile.value = pickedFile;
        } else if (proofType == commonString.passbook) {
          bankPassbookFile.value = pickedFile;
        }

        // Also update the general map
        uploadedDocuments[proofType] = pickedFile;
      } else {
        print('User canceled the picker');
      }
    } else {
      print('Storage permission denied');
    }
  }

  void removeDocuments(String proofType) {
    if (proofType == commonString.aadhar) {
      aadharFile.value = null;
      frontAadharFilePath.value = '';
      backAadharFilePath.value = '';
    } else if (proofType == commonString.passbook) {
      bankPassbookFile.value = null;
    }
    // uploadedDocuments.remove(proofType);
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
      log('countryController${countryController.value.text}');
      if (filteredCountryList[0].states.isNotEmpty) {
        selectedStateIndex.value = 0;
        stateController.value.text = filteredCountryList[0].states[0].name;
        log('stateController${stateController.value.text}');
        // Assign cities from the first state's list
        filteredCityList.assignAll(filteredCountryList[0].states[0].cities);
        if (filteredCityList.isNotEmpty) {
          selectedCity.value = 0;
          cityController.value.text = filteredCityList[0];
          log('cityController${cityController.value.text}');
        }
      }
    }
  }

  Future<void> pickImageFromCamera({required ImageSource source}) async {
    final XFile? photo = await _picker.pickImage(source: source);
    if (photo != null) {
      File? croppedFile = await ImageCropperHelper.cropImage(
        File(photo.path),
      );
      if (croppedFile != null) {
        selectedImage.value = croppedFile;
      }
    } else {
      primaryToast(msg: "No image chosen. Select an image to continue.");
    }
    Get.back(); // Close the dialog or screen after picking the image
  }

  String getSelectedProofs() {
    // selectedProofs.clear();
    if (isAadharSelected.value == true) {
      if (!selectedProofs.contains("Aadhar Card")) {
        selectedProofs.add("Aadhar Card");
      }
    } else {
      selectedProofs.remove("Aadhar Card");
    }
    if (isBankPassbookSelected.value == true) {
      if (!selectedProofs.contains("Bank Passbook")) {
        selectedProofs.add("Bank Passbook");
      }
    } else {
      selectedProofs.remove("Bank Passbook");
    }
    if (isOtherSelected.value == true) {
      if (!selectedProofs.contains("Other")) {
        selectedProofs.add("Other");
      }
    } else {
      selectedProofs.remove("Other");
    }

    return selectedProofs.isNotEmpty
        ? selectedProofs.join(', ')
        : "No proof selected";
  }

  //uploadproof

  Future<void> pickDocuments() async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
      );

      if (result != null) {
        selectedDocuments.addAll(result.paths.map((path) => File(path!)));
      } else {
        print('User canceled the picker');
      }
    } else {
      print('Storage permission denied');
    }
  }

  void removeDocument(File file) {
    selectedDocuments.remove(file);
  }

  //
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value.isAfter(DateTime.now())
          ? DateTime.now()
          : selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => commonThemeBuilder(context, child),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  Future<void> selectDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateFrom.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) => commonThemeBuilder(context, child),
    );

    if (picked != null && picked != selectedDateFrom.value) {
      selectedDateFrom.value = picked;
    }
  }

  Future<bool> employeeIdExists(String? employeeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmployeeData = prefs.getString('employeeData');
    if (storedEmployeeData != null) {
      List<dynamic> employeeList = jsonDecode(storedEmployeeData);
      for (var employee in employeeList) {
        if (employee['srNo'] == employeeId) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> addEmployeeToAdminList(UserProfile employee) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? storedAdminData = prefs.getString('adminData');
    String? currentAdminSrNo = prefs.getString('currentAdmin');

    if (storedAdminData != null && currentAdminSrNo != null) {
      List<Map<String, dynamic>> decodedAdminList =
          List<Map<String, dynamic>>.from(jsonDecode(storedAdminData));

      List<AdminProfileModel> adminList =
          decodedAdminList.map((e) => AdminProfileModel.fromMap(e)).toList();

      for (int i = 0; i < adminList.length; i++) {
        if (adminList[i].srNo == currentAdminSrNo) {
          adminList[i].allUser.add(employee);
          break;
        }
      }

      await prefs.setString(
        'adminData',
        jsonEncode(adminList.map((e) => e.toMap()).toList()),
      );
    }
  }

  final Rxn<File> aadharFile = Rxn<File>();
  final Rxn<File> bankPassbookFile = Rxn<File>();
  bool validateAllFields() {
    // if (fname.value.trim().isEmpty ||
    //     lname.value.trim().isEmpty ||
    //     group.value.trim().isEmpty ||
    //     aadhar.value.trim().isEmpty ||
    //     email.value.trim().isEmpty ||
    //     mobileNumber.value.trim().isEmpty ||
    //     mobileNumbertwo.value.trim().isEmpty ||
    //     address.trim().isEmpty ||
    //     zipCode.isEmpty ||
    //     pass.isEmpty ||
    //     confirmPass.isEmpty ||
    //     dropdownvaluebank.value.trim().isEmpty ||
    //     acno.value.trim().isEmpty ||
    //     ifsc.isEmpty ||
    //     branchaddres.value.trim().isEmpty ||
    //     referance.value.trim().isEmpty ||
    //     selectedImage.value == null ||
    //     selectedProofs.isEmpty ||
    //     (isAadharSelected.value &&
    //         frontAadharFilePath.value.isEmpty &&
    //         backAadharFilePath.value.isEmpty) ||
    //     (isBankPassbookSelected.value && bankPassbookFile.value == null) ||
    //     otherDocuments
    //         .any((doc) => doc.check == true && doc.otherFile == null)) {
    //   primaryToast(msg: "Please enter all required fields.");
    //   return false;
    // }
    String zip = zipCode.value.trim();
    String password = pass.value.trim();
    String confirmPassword = confirmPass.value.trim();
    String ifscCode = ifsc.value.trim();
    if (selectedImage.value == null) {
      primaryToast(msg: "Please upload Profile Image.");
      return false;
    }

    if (fname.value.trim().isEmpty) {
      primaryToast(msg: "Please enter First Name");
      return false;
    }
    if (lname.value.trim().isEmpty) {
      primaryToast(msg: "Please enter Last Name");
      return false;
    }

    if (group.value.trim().isEmpty) {
      primaryToast(msg: "Please select gender.");
      return false;
    }
    if (aadhar.value.trim().isEmpty || aadhar.value.trim().length != 12) {
      primaryToast(msg: "Please enter valid 12-digit Aadhar No.");
      return false;
    }
    if (email.value.trim().isEmpty) {
      primaryToast(msg: "Please enter an email.");
      return false;
    }
    RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$');
    if (!emailRegExp.hasMatch(email.value.trim())) {
      primaryToast(msg: "Invalid email format.");
      return false;
    }

    if (mobileNumber.value.trim().isEmpty) {
      primaryToast(msg: "Please enter Mobile No 1.");
      return false;
    }
    if (mobileNumber.value.trim().length != 10) {
      primaryToast(msg: "Mobile No 1 must be exactly 10 digits.");
      return false;
    }

    if (mobileNumbertwo.value.trim().isEmpty) {
      primaryToast(msg: "Please enter Mobile No 2.");
      return false;
    }
    if (mobileNumbertwo.value.trim().length != 10) {
      primaryToast(msg: "Mobile No 2 must be exactly 10 digits.");
      return false;
    }

    if (address.isEmpty) {
      primaryToast(msg: "Please enter your Address.");
      return false;
    }
    if (zip.isEmpty) {
      primaryToast(msg: "Please enter ZipCode");
      return false;
    }
    if (zip.length < 5 || zip.length > 6) {
      primaryToast(msg: "Zip Code must be 5 or 6 digits");
      return false;
    }

    if (password.isEmpty) {
      primaryToast(msg: "Please enter Password");
      return false;
    }
    if (password.length < 8) {
      primaryToast(msg: "Password must be at least 8 characters");
      return false;
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      primaryToast(msg: "Password must have at least one uppercase letter");
      return false;
    }
    if (!RegExp(r'[!@#\$&*~_]').hasMatch(password)) {
      primaryToast(msg: "Password must have at least one special character");
      return false;
    }

    if (confirmPassword.isEmpty) {
      primaryToast(msg: "Please enter Confirm Password");
      return false;
    }
    if (confirmPassword != password) {
      primaryToast(msg: "Passwords do not match");
      return false;
    }
    if (dropdownvaluebank.value.isEmpty) {
      primaryToast(msg: "Please select Bank Name");
      return false;
    }

    if (acno.value.trim().isEmpty) {
      primaryToast(msg: "Please enter your Ac No");
      return false;
    }

    final ifscPattern = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (ifscCode.isEmpty) {
      primaryToast(msg: "Please enter your IFSC");
      return false;
    } else if (!ifscPattern.hasMatch(ifscCode)) {
      primaryToast(msg: "Invalid IFSC code");
      return false;
    }

    if (branchaddres.value.trim().isEmpty) {
      primaryToast(msg: "Please enter your Branch Address");
      return false;
    }

    if (referance.value.trim().isEmpty) {
      primaryToast(msg: "Please enter Reference");
      return false;
    }

    if (selectedProofs.isEmpty) {
      primaryToast(msg: "Please attach proofs.");
      return false;
    }
    if (isAadharSelected.value &&
        frontAadharFilePath.value.isEmpty &&
        backAadharFilePath.value.isEmpty) {
      primaryToast(msg: "Please upload Aadhar card images.");
      return false;
    }

    if (isBankPassbookSelected.value && bankPassbookFile.value == null) {
      primaryToast(msg: "Please upload Bank Passbook.");
      return false;
    }

    for (var doc in otherDocuments) {
      if (doc.check == true && doc.otherFile == null) {
        primaryToast(msg: "Please upload the ${doc.name} document.");
        return false;
      }
    }

    return true;
  }

  bool validateUserSideFields() {
    if (selectedImage.value?.path.isEmpty ?? true) {
      primaryToast(msg: "Please upload Profile Image.");
      return false;
    }
    if (firstnamecontroller.value.text.isEmpty) {
      primaryToast(msg: "Please enter First Name");
      return false;
    }
    if (lastnamecontroller.value.text.trim().isEmpty) {
      primaryToast(msg: "Please enter Last Name");
      return false;
    }
    if (emailcontroller.value.text.trim().isEmpty) {
      primaryToast(msg: "Please enter an email.");
      return false;
    }
    RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$');
    if (!emailRegExp.hasMatch(emailcontroller.value.text.trim())) {
      primaryToast(msg: "Invalid email format.");
      return false;
    }
    if (mobilenucontroller.value.text.trim().length != 10) {
      primaryToast(msg: "Mobile No 1 must be exactly 10 digits.");
      return false;
    }

    final mobile2 = mobilenutwocontroller.value.text.trim();
    if (mobile2.isEmpty || mobile2.length != 10) {
      primaryToast(msg: "Mobile No 2 must be exactly 10 digits.");
      return false;
    }

    if (addresscontroller.value.text.trim().isEmpty) {
      primaryToast(msg: "Please enter your Address.");
      return false;
    }

    final zip = zipCodeController.value.text.trim();
    if (zip.isEmpty) {
      primaryToast(msg: "Please enter ZipCode");
      return false;
    }
    if (zip.length < 5 || zip.length > 6) {
      primaryToast(msg: "Zip Code must be 5 or 6 digits");
      return false;
    }
    return true;
  }

  Future<void> submitBtn() async {
    if (!validateAllFields()) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Fetch existing employee data from SharedPreferences
    String? storedEmployeeData = prefs.getString('employeeData');
    List<UserProfile> existingProfiles = [];

    if (storedEmployeeData != null && storedEmployeeData.isNotEmpty) {
      // Decode the stored data into UserProfile objects
      List<Map<String, dynamic>> decodedData =
          List<Map<String, dynamic>>.from(jsonDecode(storedEmployeeData));
      existingProfiles =
          decodedData.map((item) => UserProfile.fromMap(item)).toList();
    }

    // Generate srNo for the new employee
    int srno = existingProfiles.isNotEmpty
        ? int.parse(existingProfiles.last.srNo) + 1
        : 1;

    // Validation
    // if (selectedImage.value == null) {
    //   primaryToast(msg: "Please upload an image.");
    //   return;
    // }
    // if (group.value.isEmpty) {
    //   primaryToast(msg: "Please select gender.");
    //   return;
    // }
    // if (selectedProofs.isEmpty) {
    //   primaryToast(msg: "Please attach proofs.");
    //   return;
    // }
    /* if (selectedDocuments.isEmpty) {
      primaryToast(msg: "Please upload documents.");
      return;
    }
*/
    log('frontAadharFilePath.value${frontAadharFilePath.value}');
    log('backAadharFilePath.value${backAadharFilePath.value}');
    // if ((isAadharSelected.value &&
    //         frontAadharFilePath.value.isEmpty &&
    //         backAadharFilePath.value.isEmpty) ||
    //     (isBankPassbookSelected.value && bankPassbookFile.value == null)) {
    //   primaryToast(msg: "Please upload documents.");
    //   return;
    // }
    // for (var i = 0; i < otherDocuments.length; i++) {
    //   log('otherDocuments[i].check=>${otherDocuments[i].check == true && otherDocuments[i].otherFile == null}');
    //   if (otherDocuments[i].check == true &&
    //       otherDocuments[i].otherFile == null) {
    //     primaryToast(
    //         msg: "Please upload the ${otherDocuments[i].name} document.");
    //     return;
    //   }
    // }
    if (await employeeIdExists(srno.toString())) {
      primaryToast(msg: "Employee ID already registered.");
      return;
    }
    List<OtherDocumentsModel> otherDocumentsList = [];
    for (int i = 0; i < otherDocuments.length; i++) {
      otherDocumentsList.add(OtherDocumentsModel(
        name: otherDocuments[i].name, // Document name
        otherFile: otherDocuments[i].otherFile, // Document file
        check: otherDocuments[i].check,
      ));
    }
    AadharCardModel aadharCard = AadharCardModel(
      frontSidePath: frontAadharFilePath.value,
      backSidePath: backAadharFilePath.value,
    );

    UploadedDocumentsModel attachedFiles = UploadedDocumentsModel(
        aadharCard: aadharCard,
        bankPassbookFile: bankPassbookFile.value,
        otherFiles: otherDocuments);
    log('otherDocuments=>>${otherDocuments}');
    // Create a new UserProfile object with the input data
    UserProfile employeeData = UserProfile(
        image: selectedImage.value!.path,
        firstName: fname.value,
        middleName: middlename.value,
        lastName: lname.value,
        address: address.value,
        aadhar: aadhar.value,
        gender: group.value,
        birthDate: "${selectedDate.value.day.toString().padLeft(2, '0')}-"
            "${selectedDate.value.month.toString().padLeft(2, '0')}-"
            "${selectedDate.value.year}",
        mobilenoone: mobileNumber.value,
        mobilentwo: mobileNumbertwo.value,
        email: email.value,
        bankName: dropdownvaluebank.value,
        branchAddress: branchaddres.value,
        accountNumber: acno.value,
        ifscCode: ifsc.value,
        reference: referance.value,
        employmentType: officegroup.value,
        dateFrom: "${selectedDateFrom.value.day.toString().padLeft(2, '0')}-"
            "${selectedDateFrom.value.month.toString().padLeft(2, '0')}-"
            "${selectedDateFrom.value.year}",
        srNo: srno.toString(),
        documents: selectedDocuments.map((file) => file.path).toList(),
        attachProof: selectedProofs,
        attendance: false,
        country: countryController.value.text,
        adminsrNo: adminSrNo,
        state: stateController.value.text,
        city: cityController.value.text,
        zipCode: zipCodeController.value.text,
        password: passwordController.value.text,
        confirmPass: confirmPasswordController.value.text,
        uploadedDocuments: uploadedDocuments,
        attachedFiles: attachedFiles);

    // Add the new employee data to the existing profiles list
    existingProfiles.add(employeeData);

    // Save the updated list to SharedPreferences
    try {
      await prefs.setString('employeeData',
          jsonEncode(existingProfiles.map((e) => e.toMap()).toList()));
      log("Employee data saved successfully: ${prefs.getString('employeeData')}");
    } catch (e) {
      log("Error saving employee data to SharedPreferences: $e");
    }

    // Reset fields after successful submission

    // Show a success message
    primaryToast(msg: "Employee added successfully!");

    // Navigate to the next screen (BottomNavAdmin)
    resetCountryValue();
    Get.off(() => BottomNavAdmin(),
        transition: Transition.noTransition,
        duration: Duration(milliseconds: 300));
    resetValue();
  }

  Future<bool> adminIdExists(String srNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedAdminData = prefs.getString('adminData');

    if (storedAdminData != null && storedAdminData.isNotEmpty) {
      List<Map<String, dynamic>> decodedData =
          List<Map<String, dynamic>>.from(jsonDecode(storedAdminData));
      return decodedData.any((item) => item['srNo'] == srNo);
    }
    return false;
  }

  Future<void> AdminRegistration(userDashBoardController) async {
    if (!validateAllFields()) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? storedAdminData = prefs.getString('adminData');
    List<AdminProfileModel> existingAdmins = [];

    if (storedAdminData != null && storedAdminData.isNotEmpty) {
      List<Map<String, dynamic>> decodedData =
          List<Map<String, dynamic>>.from(jsonDecode(storedAdminData));
      existingAdmins =
          decodedData.map((item) => AdminProfileModel.fromMap(item)).toList();
    }

    int srno =
        existingAdmins.isNotEmpty ? int.parse(existingAdmins.last.srNo) + 1 : 1;

    if (await employeeIdExists(srno.toString())) {
      primaryToast(msg: "Employee ID already registered.");
      return;
    }

    List<OtherDocumentsModel> otherDocumentsList = [];
    for (int i = 0; i < otherDocuments.length; i++) {
      otherDocumentsList.add(OtherDocumentsModel(
        name: otherDocuments[i].name, // Document name
        otherFile: otherDocuments[i].otherFile, // Document file
        check: otherDocuments[i].check,
      ));
    }
    AadharCardModel aadharCard = AadharCardModel(
      frontSidePath: frontAadharFilePath.value,
      backSidePath: backAadharFilePath.value,
    );

    UploadedDocumentsModel attachedFiles = UploadedDocumentsModel(
      aadharCard: aadharCard,
      bankPassbookFile: bankPassbookFile.value,
      otherFiles: otherDocuments,
    );

    if (await adminIdExists(srno.toString())) {
      primaryToast(msg: "Admin ID already registered.");
      return;
    }

    AdminProfileModel adminData = AdminProfileModel(
      image: selectedImage.value!.path,
      firstName: fname.value,
      middleName: middlename.value,
      lastName: lname.value,
      address: address.value,
      aadhar: aadhar.value,
      gender: group.value,
      birthDate: "${selectedDate.value.day.toString().padLeft(2, '0')}-"
          "${selectedDate.value.month.toString().padLeft(2, '0')}-"
          "${selectedDate.value.year}",
      mobilenoone: mobileNumber.value,
      mobilentwo: mobileNumbertwo.value,
      email: email.value,
      bankName: dropdownvaluebank.value,
      branchAddress: branchaddres.value,
      accountNumber: acno.value,
      ifscCode: ifsc.value,
      reference: referance.value,
      employmentType: officegroup.value,
      dateFrom: "${selectedDateFrom.value.day.toString().padLeft(2, '0')}-"
          "${selectedDateFrom.value.month.toString().padLeft(2, '0')}-"
          "${selectedDateFrom.value.year}",
      srNo: srno.toString(),
      documents: selectedDocuments.map((file) => file.path).toList(),
      attachProof: selectedProofs,
      attendance: false,
      country: countryController.value.text,
      state: stateController.value.text,
      city: cityController.value.text,
      zipCode: zipCodeController.value.text,
      password: passwordController.value.text,
      confirmPass: confirmPasswordController.value.text,
      attachedFiles: attachedFiles,
    );

    existingAdmins.add(adminData);
    log("Admin attachedFiles:");
    log("Aadhar Front: ${adminData.attachedFiles!.aadharCard!.frontSidePath}");
    log("Aadhar Back: ${adminData.attachedFiles!.aadharCard!.backSidePath}");
    log("Bank Passbook: ${adminData.attachedFiles!.bankPassbookFile}");

    for (var doc in adminData.attachedFiles!.otherFiles) {
      log("Other Doc - ${doc.name}: ${doc.otherFile}");
    }

    try {
      await prefs.setString('adminData',
          jsonEncode(existingAdmins.map((e) => e.toMap()).toList()));

      String? adminListString = prefs.getString('adminData');
      if (adminListString != null) {
        List<dynamic> adminList = jsonDecode(adminListString);

        for (var admin in adminList) {
          if (admin['email'].toString().trim() ==
                  email.value.toString().trim() &&
              admin['password'].toString().trim() ==
                  pass.value.toString().trim()) {
            await prefs.setString('currentAdmin', admin['srNo']);
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('role', 'admin');

            await userDashBoardController.fetchAdminData().then((value) {
              resetValue();
              // resetValue();
              resetCountryValue();
              primaryToast(msg: "Admin added successfully!");
              Future.delayed(
                const Duration(milliseconds: 800),
                () {
                  Navigator.pushReplacement(
                    Get.context!,
                    MaterialPageRoute(
                      builder: (context) => BottomNavAdmin(initialIndex: 0),
                    ),
                  );
                },
              );
            });

            return;
          }
        }
      }
    } catch (e) {
      log("Error saving admin data: $e");
    }
  }

  void resetValue() {
    selectedImage.value = null;
    fname.value = "";
    middlename.value = "";
    lname.value = "";
    address.value = "";
    aadhar.value = "";
    group.value = "";
    selectedDate.value = DateTime.now();
    mobileNumber.value = "";
    mobileNumbertwo.value = "";
    email.value = "";
    dropdownvaluebank.value = "";
    branchaddres.value = "";
    acno.value = "";
    ifsc.value = "";
    referance.value = "";
    zipCode.value = "";
    pass.value = "";
    confirmPass.value = "";
    frontAadharFilePath.value = "";
    backAadharFilePath.value = "";
    officegroup.value = "";
    documentName.value = "";
    selectedDateFrom.value = DateTime.now();
    selectedDocuments.clear();
    selectedProofs.clear();
    firstnamecontroller.value.clear();
    middlenamecontroller.value.clear();
    lastnamecontroller.value.clear();
    addresscontroller.value.clear();
    aadharcontroller.value.clear();
    banknamercontroller.value.clear();
    branchaddresscontroller.value.clear();
    acnocontroller.value.clear();
    ifsccontroller.value.clear();
    referancecontroller.value.clear();
    srnocontroller.value.clear();
    mobilenucontroller.value.clear();
    mobilenutwocontroller.value.clear();
    zipCodeController.value.clear();
    passwordController.value.clear();
    confirmPasswordController.value.clear();
    emailcontroller.value.clear();
    otherTextController.value.clear();
    customDocNameController.value.clear();
    // Reset proof selections
    isAadharSelected.value = false;
    isBankPassbookSelected.value = false;
    isOtherSelected.value = false;
    otherDocuments.clear();
    log('otherDocuments=>>${otherDocuments}');
    uploadedMultipleDocuments.clear();
    selectedDocs.clear();
  }

  /* @override
  void onClose() {
    firstnamecontroller.value.dispose();
    middlenamecontroller.value.dispose();
    lastnamecontroller.value.dispose();
    addresscontroller.value.dispose();

    aadharcontroller.value.dispose();
    banknamercontroller.value.dispose();
    branchaddresscontroller.value.dispose();

    acnocontroller.value.dispose();
    ifsccontroller.value.dispose();
    referancecontroller.value.dispose();
    srnocontroller.value.dispose();

    mobilenucontroller.value.dispose();
    mobilenutwocontroller.value.dispose();
    emailcontroller.value.dispose();
    otherTextController.value.dispose();

    super.onClose();
  }*/
}
