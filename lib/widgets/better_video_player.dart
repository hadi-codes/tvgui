import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tvgui/bloc/video/video_bloc.dart';
import 'package:tvgui/model/theme.dart';

class BetterVideo extends StatefulWidget {
  @override
  _BetterVideoState createState() => _BetterVideoState();
}

class _BetterVideoState extends State<BetterVideo> with WidgetsBindingObserver {
  Orientation get orientation => MediaQuery.of(context).orientation;
  //bool playInBackground = Db.getSettings().playBackGround;
 
  AppLifecycleState _notification;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // setState(() {
    //   _notification = state;

    //   print(_notification);
    //   if (_notification == AppLifecycleState.paused) {
    //   }
    //   if (_notification == AppLifecycleState.resumed) {}
    // });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBloc, VideoState>(
      builder: (context, state) {
        if (state is VideoInitial) {
          return Container(
            height: 200,
            child: new Center(child: Image.asset('assets/img/logo.png')),
          );
        }
        if (state is InintialVideo ) {
  
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: 30,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballPulseRise,
                        color: AppThemeData.AppYellow,
                      ),
                    ),
                  ),
                  Text(
                    "جاري التحميل",
                    style:
                        TextStyle(color: AppThemeData.AppYellow, fontSize: 16),
                  )
                ],
              ),
            ),
          );
        }
          if (state is DisposeVideo ) {
  
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: 30,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballPulseRise,
                        color: AppThemeData.AppYellow,
                      ),
                    ),
                  ),
                  Text(
                    "جاري التحميل",
                    style:
                        TextStyle(color: AppThemeData.AppYellow, fontSize: 16),
                  )
                ],
              ),
            ),
          );
        }
        if (state is PlayVideo) {
        
          return video(state.betterPlayerController);
        }
        if (state is ChangeServers) {
          return video(state.betterPlayerController);
        } else {
          return SizedBox(
            height: 200,
            child: Center(
                child: CircularProgressIndicator(backgroundColor: Colors.red)),
          );
        }
      },
    );
  }

  Widget video(BetterPlayerController betterPlayerController) {

    if (orientation == Orientation.landscape) {
      return Center(
        child: AspectRatio(
          aspectRatio: 16 / 4,
          child: BetterPlayer(
            controller: betterPlayerController,
          ),
        ),
      );
    } else {
      return Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(
            controller: betterPlayerController,
          ),
        ),
      );
    }
  }
}
