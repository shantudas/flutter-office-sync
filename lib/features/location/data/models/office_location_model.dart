import 'package:hive/hive.dart';
import '../../domain/entities/office_location.dart';

part 'office_location_model.g.dart';

@HiveType(typeId: 0)
class OfficeLocationModel extends OfficeLocation {
  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final double radiusMeters;

  @HiveField(3)
  final String? address;

  @HiveField(4)
  final DateTime createdAt;

  const OfficeLocationModel({
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    this.address,
    required this.createdAt,
  }) : super(
         latitude: latitude,
         longitude: longitude,
         radiusMeters: radiusMeters,
         address: address,
         createdAt: createdAt,
       );

  factory OfficeLocationModel.fromEntity(OfficeLocation entity) {
    return OfficeLocationModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      radiusMeters: entity.radiusMeters,
      address: entity.address,
      createdAt: entity.createdAt,
    );
  }

  OfficeLocation toEntity() {
    return OfficeLocation(
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
      address: address,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'radiusMeters': radiusMeters,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OfficeLocationModel.fromJson(Map<String, dynamic> json) {
    return OfficeLocationModel(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      radiusMeters: json['radiusMeters'] as double,
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
