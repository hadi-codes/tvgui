import 'package:flutter/foundation.dart';

class Category {
  int rank;
  String ar;
  String en;
  Category({this.rank, this.ar, this.en});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        rank: json["rank"],
        ar: json["ar"],
        en: json["en"],
      );

  Map<String, dynamic> toJson() => {
        "rank": rank,
        "ar": ar,
        "en": en,
      };
}


class SortedByCountry {
    String rank;
    String countryCode;
    String ar;
    String img;

    SortedByCountry({
        this.rank,
        this.countryCode,
        this.ar,
        this.img,
    });

    factory SortedByCountry.fromJson(Map<String, dynamic> json) => SortedByCountry(
        rank: json["rank"],
        countryCode: json["countryCode"] == null ? null : json["countryCode"],
        ar: json["ar"],
        img: json["img"],
    );

    Map<String, dynamic> toJson() => {
        "rank": rank,
        "countryCode": countryCode == null ? null : countryCode,
        "ar": ar,
        "img": img,
    };
}
