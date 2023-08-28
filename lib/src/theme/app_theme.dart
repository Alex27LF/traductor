import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData themeData(bool lightMode) {
    return ThemeData(
      primarySwatch: Colors.deepPurple,
      brightness: lightMode ? Brightness.dark : Brightness.light,
    );
  }
}
