
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvgui/bloc/Channels/channels_bloc.dart';
import 'package:tvgui/bloc/Page/page_bloc.dart';
import 'package:tvgui/model/theme.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tvgui/pages/update.dart';
import 'bottomNavBar.dart';
import 'error.dart';
import 'maintenance.dart';

class WelcomFetch extends StatelessWidget {
  const WelcomFetch({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelsBloc, ChannelsState>(
      builder: (context, state) {
        if (state is Fetching) {
          BlocProvider.of<ChannelsBloc>(context).add(FetchChannels());
          return Scaffold(

                      body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    child: Container(child: Image.asset('assets/img/logo.png'))),
                Flexible(
                  child: Container(
                      height: 30,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballPulseRise,
                        color: AppThemeData.AppYellow,
                      )),
                )
              ],
            ),
          );
        }
        if (state is Maintenance) {
          return MaintenancePage(
            msg: "maintenance mode ... we will back soon .",
          );
        }
        if (state is ForceUpdate) {
          return UpdatePage(
            msg: "Please Upadate The App ..",
          );
        }
        if (state is Error) {
          return ErrorPage(
            errorMsg: "error happened ",
          );
        }
        if (state is Success)
          return BottomNavBar(
            //title: 'Home',
            cache: state.list,
            categories: state.category,
            sortedByCoutry:state.sortedByCoutry,
          );
      },
    );
  }
}
