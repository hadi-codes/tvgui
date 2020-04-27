import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tvgui/db/db.dart';
import 'package:tvgui/model/categories.dart';
import 'package:tvgui/model/channel/channel.dart';
import 'package:tvgui/model/config.dart';
import 'package:tvgui/model/deviceInfo.dart';
import "package:http/http.dart";
part 'channels_event.dart';
part 'channels_state.dart';

class ChannelsBloc extends Bloc<ChannelsEvent, ChannelsState> {
  @override
  ChannelsState get initialState => Fetching();

  @override
  Stream<ChannelsState> mapEventToState(
    ChannelsEvent event,
  ) async* {
    print(event);
    if (event is FetchChannels) {
      try {
        bool isFirstTime = await Db.isFirstTime();
        print("is First time = ${isFirstTime}");
        Info info = Db.getInfo();
        print(info.toString());
        Config phoneConfig = Db.getConfig();
        Config serverConfig = await Config.postConfig(info);
        print("sor ${serverConfig.categories[1].ar}");
        print(
            "server version :${serverConfig.channelsVersion}  || Phone Versoin ${phoneConfig.channelsVersion}");
        if (serverConfig.fourceUpdate == true) {
          yield ForceUpdate();
        }
// check if the app in maintance mode
        if (serverConfig.maintenance == true) {
          yield Maintenance();
        }
// check if there is new Channels
        if (isFirstTime == true) {
          try {
            List<Channel> list = await Channel.fetchChannels(http.Client());
            Db.putConfig(serverConfig);
            await Db.clearBox("channels");
            Db.putChannels(list);
            yield Success(
                list: list,
                category: serverConfig.categories,
                sortedByCoutry: serverConfig.sortedByCountry);
          } catch (e) {
            yield Error();
          }
        }
        if (phoneConfig.channelsVersion == serverConfig.channelsVersion &&
            serverConfig.fourceUpdate == false &&
            serverConfig.maintenance == false) {
          print("no update on db");
          List<Channel> list = Db.getChannels();
          Db.putConfig(serverConfig);

          print(list);
          yield Success(
              list: list,
              category: serverConfig.categories,
              sortedByCoutry: serverConfig.sortedByCountry);
        }
        if (phoneConfig.channelsVersion != serverConfig.channelsVersion &&
            serverConfig.fourceUpdate == false &&
            serverConfig.maintenance == false &&
            isFirstTime == false) {
          print(
              "server version :${serverConfig.channelsVersion}  || Phone Versoin ${phoneConfig.channelsVersion}");

          print("there is update on channels");
          try {
            List<Channel> list = await Channel.fetchChannels(http.Client());
            Db.putChannels(list);
            print(list);

            Db.putConfig(serverConfig);
            yield Success(
                list: list,
                category: serverConfig.categories,
                sortedByCoutry: serverConfig.sortedByCountry);
          } catch (e) {
            yield Error();
          }
        }
      } catch (e) {
        yield Error();
      }
    }
  }
}
