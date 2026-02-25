import 'package:hive/hive.dart';
import '../../domain/entities/attendance_record.dart';

part 'attendance_record_model.g.dart';

@HiveType(typeId: 1)
class AttendanceRecordModel extends AttendanceRecord {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final double latitude;

  @HiveField(3)
  final double longitude;

  @HiveField(4)
  final double distanceFromOffice;

  @HiveField(5)
  final String type;

  const AttendanceRecordModel({
    required this.id,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.distanceFromOffice,
    required this.type,
  }) : super(
         id: id,
         timestamp: timestamp,
         latitude: latitude,
         longitude: longitude,
         distanceFromOffice: distanceFromOffice,
         type: type,
       );

  factory AttendanceRecordModel.fromEntity(AttendanceRecord entity) {
    return AttendanceRecordModel(
      id: entity.id,
      timestamp: entity.timestamp,
      latitude: entity.latitude,
      longitude: entity.longitude,
      distanceFromOffice: entity.distanceFromOffice,
      type: entity.type,
    );
  }

  AttendanceRecord toEntity() {
    return AttendanceRecord(
      id: id,
      timestamp: timestamp,
      latitude: latitude,
      longitude: longitude,
      distanceFromOffice: distanceFromOffice,
      type: type,
    );
  }
}
