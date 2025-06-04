import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'fontsizes.dart';

class SharedPreferenceUtils {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _loginModelKey = 'loginModel';
  static const String _isSkippedKey = 'isSkipped';
  static const String _fontKey = 'fontKey';
  static const String _notificationKey = 'notificationKey';
  static const userModelKey = 'user_model';

  static Future<void> setNotificationStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationKey, status);
  }

  static Future<bool> getNotificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationKey) ?? true;
  }

  static Future<void> setFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    baseFontSize = size;
    await prefs.setDouble(_fontKey, size);
  }

  static Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_fontKey) ?? 16.00;
  }

  static Future<void> saveUserModel(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    print(user.avatarUrl);
    final userModelJson = jsonEncode(user.toJson());
    await prefs.setString(userModelKey, userModelJson);
  }

  static Future<UserModel?> getUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    final userModelJson = prefs.getString(userModelKey);

    if (userModelJson != null) {
      final Map<String, dynamic> json = jsonDecode(userModelJson);
      return UserModel.fromJson(json);
    }
    return null;
  }

  static Future<void> setLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<void> setSkipStatus(bool isSkipped) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isSkippedKey, isSkipped);
  }

  static Future<bool> getSkipStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isSkippedKey) ?? false;
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> clearUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginModelKey);
  }
}
