import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/location_repository.dart';

@lazySingleton
class ResetOfficeLocation implements UseCase<void, NoParams> {
  final LocationRepository repository;

  ResetOfficeLocation(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.resetOfficeLocation();
  }
}
