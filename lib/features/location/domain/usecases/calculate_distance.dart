import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/location_repository.dart';

@lazySingleton
class CalculateDistance implements UseCase<double, CalculateDistanceParams> {
  final LocationRepository repository;

  CalculateDistance(this.repository);

  @override
  Future<Either<Failure, double>> call(CalculateDistanceParams params) async {
    return await repository.calculateDistance(
      params.startLatitude,
      params.startLongitude,
      params.endLatitude,
      params.endLongitude,
    );
  }
}

class CalculateDistanceParams extends Equatable {
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;

  const CalculateDistanceParams({
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
  });

  @override
  List<Object> get props => [
    startLatitude,
    startLongitude,
    endLatitude,
    endLongitude,
  ];
}
