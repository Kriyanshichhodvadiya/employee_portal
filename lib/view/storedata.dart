import 'dart:convert';

import 'package:employeeform/model/eprofilemodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormDataManager {
  final String _storageKey = 'formDataList';

  Future<void> saveFormDataList(List<UserProfile> formDataList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> formDataJsonList = formDataList.map((formData) {
      return jsonEncode(formData.toMap());
    }).toList();

    prefs.setStringList(_storageKey, formDataJsonList);
  }

  Future<List<UserProfile>> getFormDataList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? formDataJsonList = prefs.getStringList(_storageKey);

    if (formDataJsonList != null) {
      return formDataJsonList.map((jsonString) {
        Map<String, dynamic> map = jsonDecode(jsonString);
        return UserProfile.fromMap(map);
      }).toList();
    }

    return [];
  }
}


 // if (employeeDataJson != null) {
  //   List<dynamic> jsonList = jsonDecode(employeeDataJson);
  //   setState(() {
  //     userprofilelist =
  //         jsonList.map((item) => UserProfile.fromMap(item)).toList();
  //   });
  // }
