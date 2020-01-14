import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tvgui/channelspls/channel.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future fetchServer() async {
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(ChannelAdapter());
  final channelsBox = await Hive.openBox('channels');
  final configBox = await Hive.openBox('configBox');
  var channelsVer = await http.get('https://api.hadi.wtf/config');
  var jsondata = json.decode(channelsVer.body);
  var versionChannels = jsondata["channelsVer"];
  print(versionChannels);

  print(configBox.toMap());
  if (configBox.get('channelsVersion') == null) {
    configBox.put('channelsVersion', versionChannels);
    await fetchChannels();
    return (true);
  } else {
    if (versionChannels == configBox.get('channelsVersion')) {
      print("no update on db");
      return (true);
    } else {
      print(" update on db");

      configBox.put('channelsVersion', versionChannels);
      await deleteBox();
      await fetchChannels();
      return (true);
    }
  }
}

fetchChannels() async {
  final channelsBox = await Hive.openBox('channels');
  var resData = await http.get('https://api.hadi.wtf/channels');
  var data = json.decode(resData.body);

  // print(data);
  for (var i in data) {
    Channel channel = Channel(
      countryCode: i["countryCode"],
      logo: i["logo"],
      categories: i['categories'],
      title: i["title"],
      urls: i["urls"][0]["url"],
      // urls:i["urls"][0]["url"],
    );

    channelsBox.add(channel);
  }
}

deleteBox() async {
  await Hive.deleteBoxFromDisk("channels");
  await Hive.openBox('channels');
}
