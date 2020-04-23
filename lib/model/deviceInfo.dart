import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:uuid/uuid.dart';

class Info {
  String id;
  String release;
  int sdkInt;
  String manufacturer;
  String model;
  String appVersion;
  String appBuildNumber;
  Info(
      {this.id,
      this.release,
      this.sdkInt,
      this.manufacturer,
      this.model,
      this.appBuildNumber,
      this.appVersion});

  static Future<Info> getInfo() async {
    var uuid = new Uuid();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String release = androidInfo.version.release;
    int sdkInt = androidInfo.version.sdkInt;
    String manufacturer = androidInfo.manufacturer;
    String model = androidInfo.model;
    String appVersion = packageInfo.version;
    String appBuildNumber = packageInfo.buildNumber;
    String id = uuid.v4();

    return Info(
        id: id,
        model: model,
        manufacturer: manufacturer,
        sdkInt: sdkInt,
        release: release,
        appVersion: appVersion,
        appBuildNumber: appBuildNumber);
  }
}
