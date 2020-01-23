import 'package:hive/hive.dart';

// part 'channel.g.dart';

@HiveType(typeId: 0)
class Channel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String logo;
  @HiveField(2)
  final String categories;
  @HiveField(3)
  final String countryCode;
  @HiveField(4)
  final List<Url> urls;

  Channel({
    this.title,
    this.logo,
    this.categories,
    this.countryCode,
    this.urls,
  });
}

class Url {
  final String url;
  final bool isOk;
  Url({this.url, this.isOk});
}
