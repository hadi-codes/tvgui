import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tvgui/db/db.dart';
import 'package:tvgui/model/channel/channel.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  BetterPlayerController betterPlayerController;

  Future<BetterPlayerController> play(String url) async {
    BetterPlayerConfiguration configuration = BetterPlayerConfiguration(
        fullScreenByDefault: true,
        allowedScreenSleep: false,
        autoPlay: true,
        looping: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          liveText: "مباشر",
          liveTextColor: Colors.yellow,
          defaultErrorText: "حصل مشكلة في تشغيل القناة",
          controlBarColor: Colors.black26,
        ),
        eventListener: (listener) {
          print("lister herer.. ${listener.betterPlayerEventType.toString()}");
        });

    BetterPlayerDataSource betterPlayerDataSource = new BetterPlayerDataSource(
      BetterPlayerDataSourceType.NETWORK,
      url,
      liveStream: true,
    );
    betterPlayerController = new BetterPlayerController(configuration,
        betterPlayerDataSource: betterPlayerDataSource);
    // await betterPlayerController.videoPlayerController.initialize();
    return betterPlayerController;
  }

  @override
  VideoState get initialState => VideoInitial();
  @override
  Stream<VideoState> mapEventToState(VideoEvent event) async* {
    yield NoVideo();

    if (event is Click) {
      print("event Click");

      print("click");
      yield InintialVideo();

      betterPlayerController = await play(event.channel.urls[0].url);
      await Future.delayed(const Duration(seconds: 2), () => "2 sec");

      yield PlayVideo(
          channel: event.channel,
          betterPlayerController: betterPlayerController);

      await betterPlayerController.play();
    }

    if (event is ChangeServer) {
      yield InintialVideo();
      betterPlayerController = await play(event.url);
      await Future.delayed(const Duration(seconds: 2), () => "2 sec");

      yield ChangeServers(betterPlayerController: betterPlayerController);
      await betterPlayerController.play();
    }
  }
}
