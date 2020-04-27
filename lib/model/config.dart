//this config class to determine what state should the app show
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tvgui/model/categories.dart';
import 'package:tvgui/model/deviceInfo.dart';

class Config {
  int channelsVersion;
  bool fourceUpdate;
  bool maintenance;
  String msg;
  String searchApp;
  String searchToken;
  List<Category> categories;
  List<SortedByCountry> sortedByCountry;
  Config({
    this.channelsVersion,
    this.fourceUpdate,
    this.maintenance,
    this.msg,
    this.categories,
    this.sortedByCountry,
    this.searchApp,
    this.searchToken,
  });

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        channelsVersion: json["channelsVer"],
        fourceUpdate: json["fourceUpdate"],
        maintenance: json["maintenance"],
        msg: json["msg"],
        searchApp: json["searchApp"],
        searchToken: json["searchToken"],
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
        sortedByCountry: List<SortedByCountry>.from(
            json["sortedByCountry"].map((x) => SortedByCountry.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "channelsVer": channelsVersion,
        "fourceUpdate": fourceUpdate,
        "maintenance": maintenance,
        "msg": msg,
        "searchApp": searchApp,
        "searchToken": searchToken,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "sortedByCountry":
            List<dynamic>.from(sortedByCountry.map((x) => x.toJson())),
      };

  static Future<dynamic> postConfig(Info info) async {
    Dio dio = new Dio();

    try {
      Response response = await dio.post(
        'https://api.hadi.wtf/config',
        data: ({
          "deviceInfo": {
            "device_id": info.id,
            "android": info.release,
            "sdk": info.sdkInt,
            "manufacturer": info.manufacturer,
            "model": info.model
          },
          "version": info.appVersion,
          "buildNumber": info.appBuildNumber
        }),
      );
      return configParser(response);
    } on DioError catch (e) {
      if (e.response != null) {
        // print(e.response.data);
        // // print(e.response.headers);
        // print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        // print(e.request);
        // print(e.message);
        return (e);
      }
    }
  }

  static Config configParser(Response response) {
    return new Config.fromJson(json.decode(response.toString()));
  }
}
