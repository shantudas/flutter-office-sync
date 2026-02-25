import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/attendance_record.dart';
import '../repositories/attendance_repository.dart';

@lazySingleton
class GetAttendanceHistory
    implements UseCase<List<AttendanceRecord>, NoParams> {
  final AttendanceRepository repository;

  GetAttendanceHistory(this.repository);

  @override
  Future<Either<Failure, List<AttendanceRecord>>> call(NoParams params) async {
    return await repository.getAttendanceHistory();
  }
}
