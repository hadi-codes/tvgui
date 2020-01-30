import 'package:flutter/material.dart';
import 'package:tvgui/model/theme.dart';
import 'package:tvgui/model/fetch_channels.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tvgui/pages/maintenancePage.dart';
import 'package:tvgui/pages/updatePage.dart';
import 'bottomNavBar.dart';


class WelcomFetch extends StatelessWidget {
  const WelcomFetch({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome',
      theme: appTheme(),
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: fetchServer(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot);

              if (snapshot.data == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(child: Image.asset('assets/img/logo.png')),
                    Container(
                        height: 30,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballPulseRise,
                          color: AppThemeData.AppYellow,
                        ))
                  ],
                );
              } else if (snapshot.data == "maintenance") {
                return Maintenance(msg:"maintenance mode ... we will back soon ." ,);
              } else if (snapshot.data == "update") {
               return UpdatePage(msg: "Please Upadate The App ..",);
              } else
                return BottomNavBar(
                  //title: 'Home',
                  cache: snapshot.data,
                );
            },
          ),
        ),
      ),
    );
  }
}
