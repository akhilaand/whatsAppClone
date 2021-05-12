import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoginKey = "isLoggedIn";
  static String SharedPreferenceUserNameKey = "USERNAMEKEY";
  static String SharedPreferenceUsereMAILKey = "USEREMAILKEY";

//  SAVING DATA TO SHARED pREFRENCE
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.setBool(sharedPreferenceUserLoginKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userNmae) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.setString(SharedPreferenceUserNameKey, userNmae);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.setString(SharedPreferenceUsereMAILKey, userEmail);
  }

//  getting data from shared preference
  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.getBool(sharedPreferenceUserLoginKey);
  }

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.getString(SharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.getString(SharedPreferenceUsereMAILKey);
  }
}
