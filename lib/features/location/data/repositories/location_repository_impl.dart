import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../domain/entities/office_location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_data_source.dart';
import '../models/office_location_model.dart';

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource localDataSource;

  LocationRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      // Check if location service is enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left(
          LocationServiceFailure(
            'Location services are disabled. Please enable GPS.',
          ),
        );
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(
            LocationPermissionFailure('Location permission denied'),
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Left(
          LocationPermissionFailure(
            'Location permissions are permanently denied',
          ),
        );
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );

      return Right(position);
    } catch (e) {
      return Left(
        LocationServiceFailure('Failed to get location: ${e.toString()}'),
      );
    }
  }

  @override
  Stream<Position> getLocationStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  @override
  Future<Either<Failure, void>> saveOfficeLocation(
    OfficeLocation location,
  ) async {
    try {
      final model = OfficeLocationModel.fromEntity(location);
      await localDataSource.saveOfficeLocation(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to save location: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, OfficeLocation>> getOfficeLocation() async {
    try {
      final model = await localDataSource.getOfficeLocation();
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get location: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> resetOfficeLocation() async {
    try {
      await localDataSource.deleteOfficeLocation();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to reset location: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    try {
      final distance = DistanceCalculator.calculateDistance(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
      return Right(distance);
    } catch (e) {
      return Left(
        UnknownFailure('Failed to calculate distance: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> checkLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      return Right(
        permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse,
      );
    } catch (e) {
      return Left(
        LocationPermissionFailure(
          'Failed to check permission: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> requestLocationPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      return Right(
        permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse,
      );
    } catch (e) {
      return Left(
        LocationPermissionFailure(
          'Failed to request permission: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> checkLocationService() async {
    try {
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      return Right(isEnabled);
    } catch (e) {
      return Left(
        LocationServiceFailure('Failed to check service: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> validateGeoFence(
    double currentLat,
    double currentLng,
    double officeLat,
    double officeLng,
    double radius,
  ) async {
    try {
      final distance = DistanceCalculator.calculateDistance(
        currentLat,
        currentLng,
        officeLat,
        officeLng,
      );
      return Right(distance <= radius);
    } catch (e) {
      return Left(
        UnknownFailure('Failed to validate geofence: ${e.toString()}'),
      );
    }
  }
}
