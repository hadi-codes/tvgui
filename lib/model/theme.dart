import 'package:flutter/material.dart';

class AppThemeData {
  static const PrimaryColor = Color(0xff20232C);
  static const AppYellow = Color(0xfffbdd33);
  static const AppGray = Color(0xff74777f);
  static const Green = Color(0xff78cdd4);
  static const Red = Color(0xfff15b6c);
}

appTheme() {
  return new ThemeData(
      primaryColor: AppThemeData.PrimaryColor,
      scaffoldBackgroundColor: AppThemeData.PrimaryColor,
      accentColor: AppThemeData.PrimaryColor);
}
