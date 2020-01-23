import 'package:flutter/material.dart';
import 'package:tvgui/model/theme.dart';

class Maintenance extends StatelessWidget {
  const Maintenance({Key key,this.msg}) : super(key: key);
  final String msg;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: appTheme(),
        home: Scaffold(
            body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/img/maintenance.png"),
            Text(msg,style: TextStyle(color: AppThemeData.AppYellow,fontSize: 18),)
          ],
        )));
  }
}
