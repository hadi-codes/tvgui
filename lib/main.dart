import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvgui/model/theme.dart';
import 'package:tvgui/pages/bottomNavBar.dart';
import 'package:tvgui/pages/setting.dart';
import 'package:tvgui/pages/welcom_fetch.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  final Color color = const Color(0xff20232C);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light));
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  static const PrimaryColor = Color(0xff20232C);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: appTheme(),
      home: BottomNavBarPage(),
    );
  }
}
