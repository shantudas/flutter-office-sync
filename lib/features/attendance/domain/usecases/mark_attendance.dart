import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/attendance_record.dart';
import '../repositories/attendance_repository.dart';

@lazySingleton
class MarkAttendance
    implements UseCase<AttendanceRecord, MarkAttendanceParams> {
  final AttendanceRepository repository;

  MarkAttendance(this.repository);

  @override
  Future<Either<Failure, AttendanceRecord>> call(
    MarkAttendanceParams params,
  ) async {
    return await repository.markAttendance(
      params.latitude,
      params.longitude,
      params.distanceFromOffice,
      params.type,
    );
  }
}

class MarkAttendanceParams extends Equatable {
  final double latitude;
  final double longitude;
  final double distanceFromOffice;
  final String type;

  const MarkAttendanceParams({
    required this.latitude,
    required this.longitude,
    required this.distanceFromOffice,
    required this.type,
  });

  @override
  List<Object> get props => [latitude, longitude, distanceFromOffice, type];
}
