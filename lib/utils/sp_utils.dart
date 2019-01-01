import 'dart:async';
import 'dart:convert';

import 'package:flutter_mcu/bean/Token.dart';
import 'package:flutter_mcu/bean/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  static const String _TOKEN = "SP_TOKEN";
  static const String _USER = "SP_USER";
  static const String _THEME = "SP_THEME";

  static Future<int> getTheme() async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    if (null == spf.getInt(_THEME)) {
      return 0;
    } else {
      return spf.getInt(_THEME);
    }
  }

  static void saveTheme(int value) async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    spf.setInt(_THEME, value);
  }

  static void saveToken(String jsonToken) async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    spf.setString(_TOKEN, jsonToken);
  }

  static Future<Token> getToken() async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    if (spf.getString(_TOKEN) == null) return null;
    return Token.fromJson(json.decode(spf.getString(_TOKEN)));
  }

  static void saveUser(String jsonUser) async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    spf.setString(_USER, jsonUser);
  }

  static Future<User> getUser() async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    if (spf.getString(_USER) == null) return null;
    return User.fromJson(json.decode(spf.getString(_USER)));
  }

  static void clearLogin() async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    spf.setString(_TOKEN, "");
    spf.setString(_USER, "");
  }
}
