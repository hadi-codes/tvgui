import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvgui/bloc/Channels/channels_bloc.dart';
import 'package:tvgui/model/theme.dart';
import 'package:tvgui/pages/welcom_fetch.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key key, this.errorMsg}) : super(key: key);
  final String errorMsg;
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
              Flexible(child: Image.asset("assets/img/error.png")),
              Flexible(
                child: Text(
                  "oops something went wrong...",
                  style: TextStyle(
                    color: AppThemeData.AppYellow,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
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
          BlocProvider.of<ChannelsBloc>(context).add(FetchChannels());
                },
                child: const Text(
                  'try Again',
                  style:
                      TextStyle(fontSize: 14, color: AppThemeData.PrimaryColor),
                ),
              )
          ],
        ),
            )));
  }
}
