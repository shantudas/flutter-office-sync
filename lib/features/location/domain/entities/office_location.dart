import 'package:equatable/equatable.dart';

class OfficeLocation extends Equatable {
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final String? address;
  final DateTime createdAt;

  const OfficeLocation({
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    this.address,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    radiusMeters,
    address,
    createdAt,
  ];
}
