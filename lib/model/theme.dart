import 'package:flutter/material.dart';

class AppThemeData {
  static const PrimaryColor = Color(0xff20232C);
  static const AppYellow = Color(0xfffbdd33);
  static const AppGray = Color(0xff74777f);
  
}

appTheme() {
    return new ThemeData(
        primaryColor: AppThemeData.PrimaryColor,
        scaffoldBackgroundColor: AppThemeData.PrimaryColor,
        accentColor:AppThemeData. PrimaryColor);
  }