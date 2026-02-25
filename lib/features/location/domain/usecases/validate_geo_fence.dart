import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/location_repository.dart';

@lazySingleton
class ValidateGeoFence implements UseCase<bool, ValidateGeoFenceParams> {
  final LocationRepository repository;

  ValidateGeoFence(this.repository);

  @override
  Future<Either<Failure, bool>> call(ValidateGeoFenceParams params) async {
    return await repository.validateGeoFence(
      params.currentLatitude,
      params.currentLongitude,
      params.officeLatitude,
      params.officeLongitude,
      params.radius,
    );
  }
}

class ValidateGeoFenceParams extends Equatable {
  final double currentLatitude;
  final double currentLongitude;
  final double officeLatitude;
  final double officeLongitude;
  final double radius;

  const ValidateGeoFenceParams({
    required this.currentLatitude,
    required this.currentLongitude,
    required this.officeLatitude,
    required this.officeLongitude,
    required this.radius,
  });

  @override
  List<Object> get props => [
    currentLatitude,
    currentLongitude,
    officeLatitude,
    officeLongitude,
    radius,
  ];
}
