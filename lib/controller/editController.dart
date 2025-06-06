import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../common/comman_widget.dart';
import '../common/global_widget.dart';
import '../model/com_profile_model.dart';
import '../model/eprofilemodel.dart';

class EditController extends GetxController {
  RxString citySearch = ''.obs;
  RxString countrySearch = ''.obs;
  RxString frontAadharFilePath = "".obs; // To store the front file path
  RxString backAadharFilePath = "".obs;
  var filteredCountryList = <CountryModel>[].obs;
  RxList<StateModel> filteredStateList = <StateModel>[].obs;
  RxList<String> filteredCityList = <String>[].obs;
  RxInt selectedCountryIndex = 0.obs;
  RxInt selectedStateIndex = 0.obs;
  RxInt selectedCity = 0.obs;
  RxString stateSearch = ''.obs;
  var documentName = ''.obs;
  var otherDocuments = <OtherDocumentsModel>[].obs;
  Rx<TextEditingController> customDocNameController =
      TextEditingController().obs;
  var uploadedMultipleDocuments = <String, List<File>>{}.obs;
  var selectedDocs = <int, bool>{}.obs;
  void toggleDocSelection(
      int index, String docName, bool isChecked, getSelectedProofs) {
    selectedDocs[index] = isChecked;
    otherDocuments[index].check = isChecked;
    otherDocuments.refresh();
    if (isChecked) {
    } else {
      removeDocuments(docName);
    }
  }

  void removeAadharCard() {
    frontAadharFilePath.value = '';
    backAadharFilePath.value = '';
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

  void removeNewFiles(
    int index,
  ) {
    if (index >= 0 && index < otherDocuments.length) {
      otherDocuments[index].otherFile = null;

      otherDocuments.refresh();
    }
  }

  final Rxn<File> aadharFile = Rxn<File>();
  final Rxn<File> bankPassbookFile = Rxn<File>();

  void removeDocuments(String proofType) {
    if (proofType == commonString.aadhar) {
      aadharFile.value = null;
      frontAadharFilePath.value = '';
      backAadharFilePath.value = '';
    } else if (proofType == commonString.passbook) {
      bankPassbookFile.value = null;
      backAadharFilePath.value = '';
    }
    // uploadedDocuments.remove(proofType);
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
}
