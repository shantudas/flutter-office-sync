import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/exceptions.dart';
import '../models/attendance_record_model.dart';

abstract class AttendanceLocalDataSource {
  Future<AttendanceRecordModel> markAttendance(
    double latitude,
    double longitude,
    double distanceFromOffice,
    String type,
  );
  Future<List<AttendanceRecordModel>> getAttendanceHistory();
  Future<void> deleteAttendance(String id);
  Future<void> clearAllAttendance();
}

@LazySingleton(as: AttendanceLocalDataSource)
class AttendanceLocalDataSourceImpl implements AttendanceLocalDataSource {
  final Box<AttendanceRecordModel> box;
  final Uuid uuid;

  AttendanceLocalDataSourceImpl(this.box, this.uuid);

  @override
  Future<AttendanceRecordModel> markAttendance(
    double latitude,
    double longitude,
    double distanceFromOffice,
    String type,
  ) async {
    try {
      final record = AttendanceRecordModel(
        id: uuid.v4(),
        timestamp: DateTime.now(),
        latitude: latitude,
        longitude: longitude,
        distanceFromOffice: distanceFromOffice,
        type: type,
      );
      await box.put(record.id, record);
      return record;
    } catch (e) {
      throw CacheException('Failed to mark attendance: ${e.toString()}');
    }
  }

  @override
  Future<List<AttendanceRecordModel>> getAttendanceHistory() async {
    try {
      final records = box.values.toList();
      // Sort by timestamp descending (newest first)
      records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return records;
    } catch (e) {
      throw CacheException('Failed to get attendance history: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAttendance(String id) async {
    try {
      await box.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete attendance: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAllAttendance() async {
    try {
      await box.clear();
    } catch (e) {
      throw CacheException('Failed to clear attendance: ${e.toString()}');
    }
  }
}
