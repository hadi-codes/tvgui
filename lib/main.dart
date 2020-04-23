import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvgui/bloc/Channels/channels_bloc.dart';
import 'package:tvgui/bloc/simpleBlocDelegate.dart';
import 'package:tvgui/model/theme.dart';

import 'bloc/Page/page_bloc.dart';
import 'bloc/video/video_bloc.dart';
import 'db/db.dart';
import 'pages/welcom_fetch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BlocSupervisor.delegate = SimpleBlocDelegate();


  final Color color = const Color(0xff20232C);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light));
  await Db.initializ();
  runApp(BlocProvider(create: (context) => VideoBloc(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  static const PrimaryColor = Color(0xff20232C);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChannelsBloc>(
          create: (BuildContext context) => ChannelsBloc(),
        ),
        BlocProvider<VideoBloc>(
          create: (BuildContext context) => VideoBloc(),
        ),
        BlocProvider<PageBloc>(
          create: (BuildContext context) => PageBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Home',
        theme: appTheme(),
        home: WelcomFetch(),
      ),
    );
  }
}

