import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/location_repository.dart';

@lazySingleton
class RequestLocationPermission implements UseCase<bool, NoParams> {
  final LocationRepository repository;

  RequestLocationPermission(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.requestLocationPermission();
  }
}
