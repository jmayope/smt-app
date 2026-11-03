import 'dart:convert';

import 'package:smt_movil/app/data/constants.dart';
import 'package:smt_movil/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  
  static Future<bool> setSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN_NAME, jsonEncode(user.toJson()));
    return true;
  }

  static Future<User> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(TOKEN_NAME) ?? '{}';
    return User.fromJson(jsonDecode(raw));
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}