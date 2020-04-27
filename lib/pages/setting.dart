import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:share/share.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:tvgui/bloc/video/video_bloc.dart';
import 'package:tvgui/db/db.dart';
import 'package:tvgui/model/notes.dart';
import 'package:tvgui/model/settings.dart';
import 'package:tvgui/model/theme.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    Key key,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Settings settings = Settings();

  @override
  void initState() {
    super.initState();
    restore();
  }

  restore() {
    setState(() {
      settings = Db.getSettings();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('الإعدادات'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Divider(
              color: AppThemeData.AppGray,
              thickness: 2,
              height: 2,
            ),
            SwitchListTile(
              activeColor: AppThemeData.AppYellow,
              inactiveThumbColor: AppThemeData.AppGray,
              inactiveTrackColor: Colors.grey,
              title: Text(
                'تشغيل في الخلفية',
                style: TextStyle(color: Colors.white),
              ),
              value: settings.playBackGround,
              onChanged: (bool value) {
                setState(() {
                  BlocProvider.of<VideoBloc>(context).add(SettingChanged());

                  settings.playBackGround = value;
                  Db.setSettings(settings);
                });
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Directionality(
                    textDirection: TextDirection.rtl,
                    child: value
                        ? Text(" تم تفعيل الخاصية")
                        : Text("تم ايقاف الخاصية"),
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ));
              },
              secondary: const Icon(
                Icons.play_circle_filled,
                color: AppThemeData.AppYellow,
              ),
            ),
            Divider(
              color: AppThemeData.AppGray,
              thickness: 2,
              height: 2,
            ),
            SwitchListTile(
              activeColor: AppThemeData.AppYellow,
              inactiveThumbColor: AppThemeData.AppGray,
              inactiveTrackColor: Colors.grey,
              title: Text(
                'تشغيل القنوات دائما في وضع الشاشة الكاملة',
                style: TextStyle(color: Colors.white),
              ),
              value: settings.alwaysFullscreen,
              onChanged: (bool value) {
                setState(() {
                  BlocProvider.of<VideoBloc>(context).add(SettingChanged());
                  settings.alwaysFullscreen = value;
                  print(value);
                  Db.setSettings(settings);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Directionality(
                      textDirection: TextDirection.rtl,
                      child: value
                          ? Text("تم تفعيل وضع الشاشة الكاملة")
                          : Text("وضع الشاشة الكاملة غير مفعل"),
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ));
                });
              },
              secondary: const Icon(
                Icons.play_circle_filled,
                color: AppThemeData.AppYellow,
              ),
            ),
            Divider(
              color: AppThemeData.AppGray,
              thickness: 2,
              height: 2,
            ),
            SwitchListTile(
              activeColor: AppThemeData.AppYellow,
              inactiveThumbColor: AppThemeData.AppGray,
              inactiveTrackColor: Colors.grey,
              title: Text(
                'تثبيت مشغل الفيديو في الاعلى',
                style: TextStyle(color: Colors.white),
              ),
              value: settings.pinVideoPlayer,
              onChanged: (bool value) {
                setState(() {
                  BlocProvider.of<VideoBloc>(context).add(SettingChanged());

                  settings.pinVideoPlayer = value;
                  print(value);
                  Db.setSettings(settings);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Directionality(
                      textDirection: TextDirection.rtl,
                      child: value ? Text("تم تثيت المشغل") : Text("المشغل حر"),
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ));
                });
              },
              secondary: const Icon(
                Icons.play_circle_filled,
                color: AppThemeData.AppYellow,
              ),
            ),
            Divider(
              color: AppThemeData.AppGray,
              thickness: 2,
              height: 2,
            ),
            ListTile(
              leading: Icon(
                LineAwesomeIcons.sort,
                color: AppThemeData.AppYellow,
              ),
              title: Text(
                "فرز حسب ",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    child: Text("الفئة"),
                    color: settings.sortBy == SortBy.category
                        ? AppThemeData.AppYellow
                        : AppThemeData.AppGray,
                    onPressed: () {
                      setState(() {
                        settings.sortBy = SortBy.category;
                        Db.setSettings(settings);
                      });
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  FlatButton(
                    child: Text("الدولة"),
                    color: settings.sortBy == SortBy.country
                        ? AppThemeData.AppYellow
                        : AppThemeData.AppGray,
                    onPressed: () {
                      setState(() {
                        settings.sortBy = SortBy.country;
                        Db.setSettings(settings);
                      });
                    },
                  )
                ],
              ),
            ),
            Divider(
              color: AppThemeData.AppGray,
              thickness: 2,
              height: 2,
            ),
            ListTile(
              leading: Icon(
                LineAwesomeIcons.at,
                color: AppThemeData.AppYellow,
              ),
              title: Text(
                'تواصل معنا ',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      _launchURL("hadishlabs@gmail.com", "Contact us ", "");
                    },
                    icon: Icon(
                      LineAwesomeIcons.envelope,
                      color: AppThemeData.AppYellow,
                    ),
                  ),
                  SocialMediaButton.twitter(
                    url: "https://twitter.com/xohady",
                    size: 30,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            Divider(
              color: AppThemeData.AppGray,
              thickness: 2,
              height: 2,
            ),
            ListTile(
              onTap: () {
                share();
              },
              leading: Icon(
                Icons.share,
                color: AppThemeData.AppYellow,
              ),
              title: Text(
                'شارك التطبيق ',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: AppThemeData.AppYellow,
                    ),
                    onPressed: () {
                      share();
                    },
                  )
                ],
              ),
            ),
            Divider(
              color: AppThemeData.AppGray,
              thickness: 2,
              height: 2,
            ),
            ListTile(
              onTap: () {
                LaunchReview.launch();
              },
              leading: Icon(
                FontAwesomeIcons.googlePlay,
                color: AppThemeData.AppYellow,
              ),
              title: Text(
                'قيم التطبيق ',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: AppThemeData.AppYellow,
                    ),
                    onPressed: () {
                      LaunchReview.launch();
                    },
                  )
                ],
              ),
            ),
            Divider(
              color: AppThemeData.AppGray,
              thickness: 2,
              height: 2,
            ),
            ListTile(
              onTap: () {
                _paypal();
              },
              leading: Icon(
                Icons.attach_money,
                color: AppThemeData.AppYellow,
              ),
              title: Text(
                'ادعم المطور',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.paypal, color: Colors.blue),
                    onPressed: () async {
                      _paypal();
                    },
                  )
                ],
              ),
            ),
            Divider(
              color: AppThemeData.AppGray,
              thickness: 2,
              height: 2,
            ),
            ListTile(
              onTap: () {
                _devNotes(context);
              },
              leading: Icon(
                FontAwesomeIcons.dev,
                color: AppThemeData.AppYellow,
              ),
              title: Text(
                'ملاحظات المطور',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_forward,
                        color: AppThemeData.AppYellow),
                    onPressed: () async {
                      _devNotes(context);
                    },
                  )
                ],
              ),
            ),
            Divider(
              color: AppThemeData.AppGray,
              thickness: 2,
              height: 2,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _devNotes(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('ملاحظات المطور'),
        content: SingleChildScrollView(
          child: FutureBuilder(
            future: Notes.fetchNotes(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data != null) {
                List<Note> notes = snapshot.data.notes;
                List<Widget> widgets = [];
                TextStyle ts = TextStyle(fontSize: 16, color: Colors.black);
                for (var i = 0; i < notes.length; i++) {
                  widgets.add(Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            notes[i].text,
                            style: ts,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      )
                    ],
                  ));
                  widgets.add(SizedBox(
                    height: 10,
                  ));
                }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widgets,
                  ),
                );
              } else {
                return Center(
                  child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        backgroundColor: AppThemeData.AppYellow,
                      )),
                );
              }
            },
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('اوك'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

share() {
  Share.share('https://jooz.page.link/u9DC',
      subject:
          "جوز - تلفاز عربي بدون اعلانات شاهد قنوات عربية بسرعة وجودة عالية مجانا ");
}

_launchURL(String toMailId, String subject, String body) async {
  var url = 'mailto:$toMailId?subject=$subject&body=$body';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_paypal() async {
  const url = "https://www.paypal.me/xohady";
  if (await canLaunch(url))
    launch(url);
  else {
    throw 'Could not launch $url';
  }
}

/*


 */
