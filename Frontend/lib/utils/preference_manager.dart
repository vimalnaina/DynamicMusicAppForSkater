import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static const String IS_LOGIN = "IS_LOGIN";
  static const String AUTH_TOKEN = "AUTH_TOKEN";
  static const String USER_DATA = "USER_DATA";

  static setBoolean(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<bool> getBoolean(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  static clearAllPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    for(var key in keys) {
      if(prefs.containsKey(key)) {
        prefs.remove(key);
      }
    }
  }

  static saveUserData(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_DATA, json.encode(value));
  }

  static getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(USER_DATA) ?? "");
  }

  static clearPrefsExcept(List<String> mKeys) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    keys.removeAll(mKeys);
    for(var key in keys) {
      if(prefs.containsKey(key)) {
        prefs.remove(key);
      }
    }
  }

}