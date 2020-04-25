import 'package:hive/hive.dart';
part 'settings.g.dart';
@HiveType(typeId: 2)
enum SortBy {
  @HiveField(0)
  country,
  @HiveField(1)
  category
}

class Settings {
  bool playBackGround;
  bool pinVideoPlayer;
  bool alwaysFullscreen;
  SortBy sortBy;
  Settings({this.playBackGround, this.sortBy,this.pinVideoPlayer,this.alwaysFullscreen});
}
