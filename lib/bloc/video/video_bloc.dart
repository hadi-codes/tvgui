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

  @override
  Stream<VideoState> mapEventToState(VideoEvent event) async* {
    if (event is Click) {
      yield DisposeVideo();

      await Future.delayed(const Duration(milliseconds: 500), () => "2 sec");

      print("event Click");
      yield DisposeVideo();

      try {
        this.betterPlayerController.dispose();
      } catch (err) {
        print(err);
      }
      yield InintialVideo();
      this.betterPlayerController = await play(event.channel.urls[0].url);

      yield PlayVideo(
          channel: event.channel,
          betterPlayerController: this.betterPlayerController);
      await Future.delayed(const Duration(milliseconds: 500), () => "2 sec");
      if (Db.getSettings().alwaysFullscreen == true) {
        this.betterPlayerController.enterFullScreen();
      }
    }

    if (event is ChangeServer) {
      await Future.delayed(const Duration(milliseconds: 500), () => "2 sec");
      yield DisposeVideo();

      try {
        this.betterPlayerController.dispose();
      } catch (err) {
        print(err);
      }
      yield InintialVideo();
      this.betterPlayerController = await play(event.url);

      yield ChangeServers(betterPlayerController: betterPlayerController);
    }
    if (event is SettingChanged) {
      yield VideoInitial();

      await Future.delayed(const Duration(milliseconds: 500), () => "2 sec");
      try {
        this.betterPlayerController.dispose();
      } catch (err) {
        print(err);
      }
    }
    if (event is PlayInBack) {
     await this.betterPlayerController.play();
    }
  }

  @override
  VideoState get initialState => VideoInitial();

  Future<BetterPlayerController> play(String url) async {
    BetterPlayerConfiguration configuration = new BetterPlayerConfiguration(
        fullScreenByDefault: false,
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

    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.NETWORK,
      url,
      liveStream: true,
    );
    betterPlayerController = new BetterPlayerController(configuration,
        betterPlayerDataSource: betterPlayerDataSource);
    return betterPlayerController;
  }
}
