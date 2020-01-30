import 'package:hive/hive.dart';

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

  Channel({
    this.title,
    this.logo,
    this.categories,
    this.countryCode,
    this.urls,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    var list = json['urls'] as List;
    List<Url> urlsList = list.map((i) => Url.fromJson(i)).toList();
    return Channel(
      title: json['title'] as String,
      logo: json['logo'] as String,
      categories: json['categories'] as String,
      countryCode: json['countryCode'] as String,
      urls: urlsList,
    );
  }
}

@HiveType(typeId: 1)
class Url  {
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
