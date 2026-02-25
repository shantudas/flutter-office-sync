import 'package:equatable/equatable.dart';
import '../../domain/entities/office_location.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationPermissionDenied extends LocationState {
  final String message;

  const LocationPermissionDenied(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationServiceDisabled extends LocationState {
  final String message;

  const LocationServiceDisabled(this.message);

  @override
  List<Object?> get props => [message];
}

class CurrentLocationLoaded extends LocationState {
  final double latitude;
  final double longitude;

  const CurrentLocationLoaded({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class OfficeLocationSaved extends LocationState {
  final OfficeLocation location;

  const OfficeLocationSaved(this.location);

  @override
  List<Object?> get props => [location];
}

class OfficeLocationLoadedState extends LocationState {
  final OfficeLocation officeLocation;

  const OfficeLocationLoadedState(this.officeLocation);

  @override
  List<Object?> get props => [officeLocation];
}

class LocationValidated extends LocationState {
  final double distance;
  final bool isWithinRange;
  final OfficeLocation officeLocation;

  const LocationValidated({
    required this.distance,
    required this.isWithinRange,
    required this.officeLocation,
  });

  @override
  List<Object?> get props => [distance, isWithinRange, officeLocation];
}

class OfficeLocationReset extends LocationState {}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}
