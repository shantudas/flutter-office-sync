import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/error/failures.dart';
import '../entities/office_location.dart';

abstract class LocationRepository {
  Future<Either<Failure, Position>> getCurrentLocation();
  Stream<Position> getLocationStream();
  Future<Either<Failure, void>> saveOfficeLocation(OfficeLocation location);
  Future<Either<Failure, OfficeLocation>> getOfficeLocation();
  Future<Either<Failure, void>> resetOfficeLocation();
  Future<Either<Failure, double>> calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  );
  Future<Either<Failure, bool>> checkLocationPermission();
  Future<Either<Failure, bool>> requestLocationPermission();
  Future<Either<Failure, bool>> checkLocationService();
  Future<Either<Failure, bool>> validateGeoFence(
    double currentLatitude,
    double currentLongitude,
    double officeLatitude,
    double officeLongitude,
    double radius,
  );
}
