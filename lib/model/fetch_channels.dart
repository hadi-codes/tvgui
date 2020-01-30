import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'dart:convert';
import 'package:tvgui/channelspls/channel.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:tvgui/channelspls/config.dart';
import 'package:dio/dio.dart';
import 'package:device_info/device_info.dart';

Future fetchServer() async {
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Dio dio = new Dio();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  var release = androidInfo.version.release;
  var sdkInt = androidInfo.version.sdkInt;
  var manufacturer = androidInfo.manufacturer;
  var model = androidInfo.model;
  String phoneInfo =
      ('Android $release (SDK $sdkInt), ManuF $manufacturer Model $model');

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;
  final configBox = await Hive.openBox('configBox');
  var configResponse = await dio.post('https://api.hadi.wtf/config',
      data: ({
        "deviceInfo": phoneInfo,
        "version": version,
        "buildNumber": buildNumber
      }));
  Config config = configParser(configResponse);
// check if the app need to update
  if (config.fourceUpdate == true) {
    return ("update");
  }
// check if the app in maintance mode
  if (config.maintenance == true) {
    return ("maintenance");
  }
// check if there is new Channels

  print(configBox.toMap());

  if (configBox.get('channelsVersion') == null) {
    configBox.put('channelsVersion', config.channelsVersion);
    var list = await updateChannelsDB();
    return (list);
  }
  if (config.channelsVersion == configBox.get('channelsVersion')) {
    print("no update on db");
    var list = await dbGetChannels();
    print(list);
    return (list);
  } else {
    print(" update on db");

    configBox.put('channelsVersion', config.channelsVersion);

    await deleteBox();
    var list = await updateChannelsDB();
    return (list);
  }
}

updateChannelsDB() async {
  final channelsBox = await Hive.openBox('channels');
  List<Channel> list = await fetchChannels2(http.Client());
  var map1 = Map.fromIterable(list, key: (e) => e.hashCode, value: (e) => e);
  print(map1);
  channelsBox.putAll(map1);

  return list;
}

dbGetChannels() async {
  final channelsBox = await Hive.openBox('channels');
  List<Channel> list = [];
  var x = channelsBox.toMap();
  print(x);
  Map map = channelsBox.toMap();
  map.forEach((k, v) => list.add(v));
  return list;
}

Future<List<Channel>> fetchChannels2(http.Client client) async {
  print("fetching channnels");
  final response = await client.get('https://api.hadi.wtf/channels');

  return compute(parseChannels, response.body);
}

List<Channel> parseChannels(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Channel>((json) => Channel.fromJson(json)).toList();
}

Config configParser(Response responseBody) {
  return new Config.fromJson(json.decode(responseBody.toString()));
}

deleteBox() async {
  await Hive.deleteBoxFromDisk("channels");
  await Hive.openBox('channels');
}
