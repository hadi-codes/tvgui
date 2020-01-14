// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChannelAdapter extends TypeAdapter<Channel> {
  @override
  final typeId = 0;

  @override
  Channel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Channel(
      title: fields[0] as String,
      logo: fields[1] as String,
      categories: fields[2] as String,
      countryCode: fields[3] as String,
      urls: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Channel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.logo)
      ..writeByte(2)
      ..write(obj.categories)
      ..writeByte(3)
      ..write(obj.countryCode)
      ..writeByte(4)
      ..write(obj.urls);
  }
}
