import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../../model/adminmodel.dart';
import '../../model/com_profile_model.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._();
  static SharedPreferenceHelper sharedPreferenceHelper =
      SharedPreferenceHelper._();

  static const String companyProfileKey = 'companyProfile';
  static const String isProfileAddedKey = 'isProfileAdded';

  Future<void> saveCompanyProfile(CompanyProfile companyProfile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        companyProfileKey, json.encode(companyProfile.toJson()));

    await prefs.setBool(isProfileAddedKey, true);
  }

  Future<CompanyProfile?> getCompanyProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(companyProfileKey);

    if (jsonString != null) {
      return CompanyProfile.fromJson(json.decode(jsonString));
    }
    return null;
  }

  Future<bool> isProfileAdded() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isProfileAddedKey) ?? false;
  }

  Future<void> removeCompanyProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(companyProfileKey);
    await prefs.remove(isProfileAddedKey);
  }

  // save registration
  static const String adminKey = "adminDetails";
  static const String lastRegNumKey = "lastRegistrationNumber";
  Future<void> saveAdminData(AdminModel admin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get last registration number & increment
    int lastRegNum = prefs.getInt(lastRegNumKey) ?? 1000;
    lastRegNum++;
    prefs.setInt(lastRegNumKey, lastRegNum);

    admin.registrationNumber = lastRegNum;

    // Convert admin model to JSON & save
    String adminJson = jsonEncode(admin.toJson());
    await prefs.setString(adminKey, adminJson);

    log("Admin details saved: $adminJson");
  }

  /// **Fetch Admin Data**
  Future<AdminModel?> fetchAdminData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminJson = prefs.getString(adminKey);

    if (adminJson != null) {
      return AdminModel.fromJson(jsonDecode(adminJson));
    }
    return null;
  }

  /// **Clear Admin Data**
  Future<void> clearAdminData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(adminKey);
    log("Admin details cleared");
  }
}
