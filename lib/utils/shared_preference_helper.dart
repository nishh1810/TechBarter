import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences Helper Class
class SPHelper {
  static const KEY_TOKEN = "KEY_TOKEN";
  static const KEY_SELECTED_PRODUCT = "KEY_SELECTED_PRODUCT";

  static Future<void> setData(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> removeData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    print("❌ key Cleared : $key");
  }

  static Future<void> clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("⚠️ All Data Cleared from SharedPreferences");
  }
}