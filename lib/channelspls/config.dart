//this config class to determine what state should the app show
class Config {
  final int channelsVersion;
  final bool fourceUpdate;
  final bool maintenance;
  final String msg;
  Config({this.channelsVersion, this.fourceUpdate, this.maintenance, this.msg});
 
  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      channelsVersion: json['channelsVer'] as int,
      fourceUpdate: json['fourceUpdate'] as bool,
      maintenance: json['maintenance'] as bool,
      msg: json['msg'] as String,
    );
  }
}
