import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todo/theme/app_theme.dart';

class Preferences {
  static SharedPreferences? preferences;
  static const String KEY_SELECTED_THEME = 'key_selected_theme';

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveTheme(bool isDarkTheme) async {
    await preferences!.setString(KEY_SELECTED_THEME, isDarkTheme.toString());
  }

  static ThemeData getTheme() {
    final theme = preferences!.getString(KEY_SELECTED_THEME);
    if (theme != null && theme == 'true') {
      return FlutterTodosTheme.dark;
    } else {
      return FlutterTodosTheme.light;
    }
  }
}
