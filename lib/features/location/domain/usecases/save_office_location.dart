import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/office_location.dart';
import '../repositories/location_repository.dart';

@lazySingleton
class SaveOfficeLocation implements UseCase<void, SaveOfficeLocationParams> {
  final LocationRepository repository;

  SaveOfficeLocation(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveOfficeLocationParams params) async {
    return await repository.saveOfficeLocation(params.location);
  }
}

class SaveOfficeLocationParams extends Equatable {
  final OfficeLocation location;

  const SaveOfficeLocationParams({required this.location});

  @override
  List<Object> get props => [location];
}
