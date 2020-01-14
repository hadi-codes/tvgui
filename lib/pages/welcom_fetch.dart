import 'package:flutter/material.dart';
import 'package:tvgui/model/theme.dart';
import 'package:tvgui/model/fetch_channels.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tvgui/pages/home.dart';

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
                          color: ThemeDate.AppYellow,
                        ))
                  ],
                );
              } else
              
              return MyHomePage(
                title: 'Home',
              //  cache: snapshot.data,
              );
            },
          ),
        ),
      ),
    );
  }
}
