import 'package:flutter/material.dart';

class ThemeDate {
  static const PrimaryColor = Color(0xff20232C);
  static const AppYellow = Color(0xfffbdd33);
  static const AppGray = Color(0xff74777f);
  
}

appTheme() {
    return new ThemeData(
        primaryColor: ThemeDate.PrimaryColor,
        scaffoldBackgroundColor: ThemeDate.PrimaryColor,
        accentColor:ThemeDate. PrimaryColor);
  }