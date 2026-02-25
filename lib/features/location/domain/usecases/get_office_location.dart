import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/office_location.dart';
import '../repositories/location_repository.dart';

@lazySingleton
class GetOfficeLocation implements UseCase<OfficeLocation, NoParams> {
  final LocationRepository repository;

  GetOfficeLocation(this.repository);

  @override
  Future<Either<Failure, OfficeLocation>> call(NoParams params) async {
    return await repository.getOfficeLocation();
  }
}
