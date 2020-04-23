import 'package:hive/hive.dart';
import 'package:tvgui/model/channel/channel.dart';
import 'package:tvgui/model/config.dart';
import 'package:tvgui/model/deviceInfo.dart';
import 'package:tvgui/model/settings.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class Db {
  static Future<void> initializ() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(UrlAdapter());
    Hive.registerAdapter(ChannelAdapter());
    Hive.registerAdapter(SortByAdapter());
    await Hive.openBox('config');
    await Hive.openBox("settings");
    await Hive.openBox("deviceInfo");
    await Hive.openBox('channels');
    await Hive.openBox('favourite');
    // Settings sett=new Settings(sortBy: SortBy.category,playBackGround: false);
    // setSettings(sett);
  }

// Setting Datebase
  static Settings getSettings() {
    print("getting settting ");
    var box = Hive.box('settings');
    var playBackGround = box.get('playBackGround');
    SortBy sortBy = box.get("sortBy");

    if (playBackGround == null) {
      playBackGround = false;
    }
    if (sortBy == null) {
      sortBy = SortBy.category;
    }
    print(playBackGround);
    return Settings(playBackGround: playBackGround, sortBy: sortBy);
  }

  static void setSettings(Settings settings) {
    print("updating settings");
    var box = Hive.box('settings');
    box.put("playBackGround", settings.playBackGround);
    box.put("sortBy", settings.sortBy);
  }
//

// Device Info Database

  static void setDeviceInfo(Info info) async {
    print("Set Device Info");

    var box = Hive.box('deviceInfo');
    box.put("id", info.id);
    box.put("model", info.model);
    box.put("manufacturer", info.manufacturer);
    box.put("sdkInt", info.sdkInt);
    box.put("release", info.release);
    box.put("appBuildNumber", info.appBuildNumber);
    box.put("appVersion", info.appVersion);
  }

  static Info getInfo() {
    var box = Hive.box('deviceInfo');
    String release = box.get("release");
    int sdkInt = box.get("sdkInt");
    String manufacturer = box.get("manufacturer");
    String model = box.get("model");
    String appVersion = box.get("appVersion");
    String appBuildNumber = box.get("appBuildNumber");
    String id = box.get("id");
    return Info(
        id: id,
        model: model,
        manufacturer: manufacturer,
        sdkInt: sdkInt,
        release: release,
        appBuildNumber: appBuildNumber,
        appVersion: appVersion);
  }

  static Future<void> clearBox(String boxName) async {
    await Hive.deleteBoxFromDisk(boxName);
    await Hive.openBox(boxName);
  }

  // Channels Database
  static List<Channel> getChannels() {
    final _configBox = Hive.box("channels");
    List<Channel> list = [];
    Map map = _configBox.toMap();
    map.forEach((k, v) => list.add(v));
    return list;
  }

  static void putChannels(List<Channel> list) async {
    final _configBox = await Hive.openBox("channels");
    var map = Map.fromIterable(list, key: (e) => e.channelId, value: (e) => e);
    _configBox.putAll(map);
  }

  //
  // Config Database =
  static void putConfig(Config config) {
    final _configBox = Hive.box("config");
    _configBox.put("channelsVersion", config.channelsVersion);
    _configBox.put("msg", config.msg);
    _configBox.put("fourceUpdate", config.fourceUpdate);
    _configBox.put("maintenance", config.maintenance);
  }

  static Config getConfig() {
    final _configBox = Hive.box("config");
    int channelsVersion = _configBox.get("channelsVersion");
    String msg = _configBox.get("msg");
    bool fourceUpdate = _configBox.get("fourceUpdate");
    bool maintenance = _configBox.get("maintenance");
    return Config(
      maintenance: maintenance,
      fourceUpdate: fourceUpdate,
      channelsVersion: channelsVersion,
      msg: msg,
    );
  }

  static Future<bool> isFirstTime() async {
    final _configBox = Hive.box("config");
    bool isFirst = _configBox.get("isFirstTime");
    if (isFirst == null) {
      print("First  Time Install");
      Info info = await Info.getInfo();
      Db.setDeviceInfo(info);
      _configBox.put("isFirstTime", false);
      return true;
    } else {
      return false;
    }
  }

  static bool getfirtTimeNotes() {
    final _configBox = Hive.box("config");
    bool isFirst = _configBox.get("notes");
    if (isFirst == null) {
      print("First  Time Install");
      return true;
    } else
      return false;
  }

  static void setFirstTimeNotes(bool value) {
    final _configBox = Hive.box("config");
    _configBox.put("notes", value);
  }

  //
  // favourite Database
  static void putToFavourite(Channel channel) {
    final _favouriteBox = Hive.box("favourite");
    _favouriteBox.put(channel.channelId, channel.channelId);
  }

  static void deleteFormFavourite(Channel channel) {
    final _favouriteBox = Hive.box("favourite");
    _favouriteBox.delete(channel.channelId);
  }

  static List<Channel> getFavouriteChannels() {
    final _channelBox = Hive.box("channels");

    final _favouriteBox = Hive.box("favourite");
    List<Channel> list = [];
    List<String> channelsIdList = [];

    Map map = _favouriteBox.toMap();
    map.forEach((k, v) => channelsIdList.add(v));
    for (var channelID in channelsIdList) {
      list.add(_channelBox.get(channelID));
    }
    return list;
  }

  static bool isInFavourite(Channel channel) {
    String channelId;
    final _favouriteBox = Hive.box("favourite");
    channelId = _favouriteBox.get(channel.channelId);
    if (channelId == null) {
      return false;
    } else {
      return true;
    }
  }
}
