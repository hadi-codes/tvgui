import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'channel.g.dart';

@HiveType(typeId: 0)
class Channel {
  @HiveField(0)
  String title;
  @HiveField(1)
  String logo;
  @HiveField(2)
  String categories;
  @HiveField(3)
  String countryCode;
  @HiveField(4)
  List<Url> urls;
  @HiveField(5)
  String channelId;

  Channel(
      {this.title,
      this.logo,
      this.categories,
      this.countryCode,
      this.urls,
      this.channelId});

  factory Channel.fromJson(Map<String, dynamic> json) {
    var list = json['urls'] as List;
    List<Url> urlsList = list.map((i) => Url.fromJson(i)).toList();
    return Channel(
      channelId: json['_id'] as String,
      title: json['title'] as String,
      logo: json['logo'] as String,
      categories: json['categories'] as String,
      countryCode: json['countryCode'] as String,
      urls: urlsList,
    );
  }
  static Channel testChannel() {
    return Channel(
        title: "test",
        categories: "news",
        logo: "https://i.imgur.com/FVNVC73.png",
        urls: [
          Url(
              url:
                  "http://livecdnh2.tvanywhere.ae/hls/mbc3/02.m3u8?sd=10&rebase=on",
              isOk: true)
        ]);
  }

  static Future<List<Channel>> fetchChannels(http.Client client) async {
    print("fetching channnels");
    final response = await client.get('https://api.hadi.wtf/channels');

    return compute(parseChannels, response.body);
  }

  static List<Channel> parseChannels(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Channel>((json) => Channel.fromJson(json)).toList();
  }
}

@HiveType(typeId: 1)
class Url {
  @HiveField(0)
  String url;
  @HiveField(1)
  bool isOk;
  Url({this.url, this.isOk});
  factory Url.fromJson(Map<String, dynamic> json) {
    return Url(
      url: json['url'] as String,
      isOk: json['isOk'] as bool,
    );
  }
}
