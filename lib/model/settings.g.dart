// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SortByAdapter extends TypeAdapter<SortBy> {
  @override
  final typeId = 2;

  @override
  SortBy read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SortBy.country;
      case 1:
        return SortBy.category;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, SortBy obj) {
    switch (obj) {
      case SortBy.country:
        writer.writeByte(0);
        break;
      case SortBy.category:
        writer.writeByte(1);
        break;
    }
  }
}
