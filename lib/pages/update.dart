import 'package:flutter/material.dart';
import 'package:tvgui/model/theme.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({Key key, @required this.msg}) : super(key: key);
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
            Center(
              child: Image.asset(
                "assets/img/update.png",
                scale: 1.5,
              ),
            ),
            SizedBox(height: 50),
            Text(
              msg,
              style: TextStyle(color: AppThemeData.AppYellow, fontSize: 16),
            ),
            SizedBox(height: 50),
            RaisedButton(
              color: AppThemeData.AppYellow,
              onPressed: () {
                StoreRedirect.redirect(
                  androidAppId: "com.hadi.tvgui",
                );
              },
              child: const Text(
                'Go To Store',
                style:
                    TextStyle(fontSize: 14, color: AppThemeData.PrimaryColor),
              ),
            ),
            RaisedButton(
              color: AppThemeData.AppYellow,
              onPressed: () {
                _launchURL("hadishlabs@gmail.com", "Contact us ", "");
              },
              child: const Text(
                'Contact Us',
                style:
                    TextStyle(fontSize: 14, color: AppThemeData.PrimaryColor),
              ),
            )
          ],
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
