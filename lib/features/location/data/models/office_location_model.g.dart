// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office_location_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfficeLocationModelAdapter extends TypeAdapter<OfficeLocationModel> {
  @override
  final int typeId = 0;

  @override
  OfficeLocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfficeLocationModel(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      radiusMeters: fields[2] as double,
      address: fields[3] as String?,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OfficeLocationModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.radiusMeters)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfficeLocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
