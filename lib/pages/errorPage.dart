import 'package:flutter/material.dart';
import 'package:tvgui/model/theme.dart';
import 'package:tvgui/pages/welcom_fetch.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key key, this.errorMsg}) : super(key: key);
  final String errorMsg;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: appTheme(),
        home: Scaffold(
            body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/img/error.png"),
            Text(
              "oops something went wrong...",
              style: TextStyle(
                color: AppThemeData.AppYellow,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            // Text(
            //   "Error : ${errorMsg}",
            //   style: TextStyle(
            //     color: AppThemeData.AppYellow,
            //     fontSize: 18,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            RaisedButton(
              color: AppThemeData.AppYellow,
              onPressed: () {
                  Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => WelcomFetch()),
            );

              },
              child: const Text(
                'try Again',
                style:
                    TextStyle(fontSize: 14, color: AppThemeData.PrimaryColor),
              ),
            )
          ],
        )));
  }
}
