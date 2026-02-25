import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/attendance_repository.dart';

@lazySingleton
class DeleteAttendance implements UseCase<void, DeleteAttendanceParams> {
  final AttendanceRepository repository;

  DeleteAttendance(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAttendanceParams params) async {
    return await repository.deleteAttendance(params.id);
  }
}

class DeleteAttendanceParams extends Equatable {
  final String id;

  const DeleteAttendanceParams(this.id);

  @override
  List<Object> get props => [id];
}
