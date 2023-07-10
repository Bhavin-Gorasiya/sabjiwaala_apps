import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static Future<void> setTime(String time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferenceKeys.firstBoot, time);
  }

  static Future<String?> getTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PreferenceKeys.firstBoot) ?? DateTime.now().toString();
  }

  static Future<void> setLoggedin(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferenceKeys.userID, value);
  }

  static Future<String?> getLoggedin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(PreferenceKeys.userID)) {
      return prefs.getString(PreferenceKeys.userID);
    }
    return null;
  }

  static Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> setAttendance(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PreferenceKeys.attendance, value);
  }

  static Future<bool> getAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PreferenceKeys.attendance) ?? false;
  }
}

class PreferenceKeys {
  static String firstBoot = "time";
  static String userID = "userID";
  static String attendance = "attendance";
}
