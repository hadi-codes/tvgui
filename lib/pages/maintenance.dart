import 'package:flutter/material.dart';
import 'package:tvgui/model/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({Key key, this.msg}) : super(key: key);
  final String msg;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: appTheme(),
        home: Scaffold(
            body: Center(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
              Flexible(child: Image.asset("assets/img/maintenance.png")),
              Flexible(
                child: Text(
                  msg,
                  style: TextStyle(
                    color: AppThemeData.AppYellow,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                child: RaisedButton(
                  color: AppThemeData.AppYellow,
                  onPressed: () {
                    _launchURL("hadishlabs@gmail.com", "Contact us ", "");
                  },
                  child: const Text(
                    'Contact Us',
                    style:
                        TextStyle(fontSize: 14, color: AppThemeData.PrimaryColor),
                  ),
                ),
              )
          ],
        ),
            )));
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
