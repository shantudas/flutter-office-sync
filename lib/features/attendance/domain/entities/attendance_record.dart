import 'package:equatable/equatable.dart';

class AttendanceRecord extends Equatable {
  final String id;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double distanceFromOffice;
  final String type; // 'check-in' or 'check-out'

  const AttendanceRecord({
    required this.id,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.distanceFromOffice,
    required this.type,
  });

  @override
  List<Object?> get props => [
    id,
    timestamp,
    latitude,
    longitude,
    distanceFromOffice,
    type,
  ];
}
