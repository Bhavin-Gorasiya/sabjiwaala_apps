import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static Future<void> setFirstBoot(bool value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool(PreferenceKeys.firstBoot, value);
  }

  static Future<bool?> getFirstBoot() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey(PreferenceKeys.firstBoot)) {
      return _prefs.getBool(PreferenceKeys.firstBoot);
    }
    return true;
  }

  static Future<void> setLoggedin(String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(PreferenceKeys.userID, value);
  }

  static Future<String?> getLoggedin() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey(PreferenceKeys.userID)) {
      return _prefs.getString(PreferenceKeys.userID);
    }
    return null;
  }

  static Future<void> clearAll() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.clear();
  }
}

class PreferenceKeys {
  static String firstBoot = "first_boot";
  static String userID = "userID";
}
