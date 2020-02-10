import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvgui/model/theme.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    Key key,
  }) : super(key: key);

  bool platInBackground = false;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    restore();
  }

  restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      widget.platInBackground =
          (sharedPrefs.getBool('playInBackground') ?? false);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: SwitchListTile(
              activeColor: AppThemeData.AppYellow,
              inactiveThumbColor: AppThemeData.AppGray,
              inactiveTrackColor: Colors.grey,
              title: const Text(
                'Play in Background',
                style: TextStyle(color: Colors.white),
              ),
              value: widget.platInBackground,
              onChanged: (bool value) {
                setState(() {
                  widget.platInBackground = value;
                });
                save('playInBackground', value);
              },
              secondary: const Icon(
                Icons.play_circle_filled,
                color: AppThemeData.AppYellow,
              ),
            ),
          ),
          SizedBox(
            height: 250,
          ),
          Flexible(
            child: RaisedButton(
              color: AppThemeData.AppYellow,
              onPressed: () {
                LaunchReview.launch();
              },
              child: const Text(
                'Rate The App',
                style:
                    TextStyle(fontSize: 14, color: AppThemeData.PrimaryColor),
              ),
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
    );
  }
}

_launchURL(String toMailId, String subject, String body) async {
  var url = 'mailto:$toMailId?subject=$subject&body=$body';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

save(String key, dynamic value) async {
  final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  if (value is bool) {
    sharedPrefs.setBool(key, value);
  } else if (value is String) {
    sharedPrefs.setString(key, value);
  } else if (value is int) {
    sharedPrefs.setInt(key, value);
  } else if (value is double) {
    sharedPrefs.setDouble(key, value);
  } else if (value is List<String>) {
    sharedPrefs.setStringList(key, value);
  }
}
