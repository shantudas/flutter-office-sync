import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance_record.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, AttendanceRecord>> markAttendance(
    double latitude,
    double longitude,
    double distanceFromOffice,
    String type,
  );
  Future<Either<Failure, List<AttendanceRecord>>> getAttendanceHistory();
  Future<Either<Failure, void>> deleteAttendance(String id);
  Future<Either<Failure, void>> clearAllAttendance();
}
