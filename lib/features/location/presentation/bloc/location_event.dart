import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class InitializeLocationEvent extends LocationEvent {}

class CheckPermissionsEvent extends LocationEvent {}

class RequestPermissionsEvent extends LocationEvent {}

class GetCurrentLocationEvent extends LocationEvent {}

class SaveOfficeLocationEvent extends LocationEvent {
  final double latitude;
  final double longitude;
  final double radius;

  const SaveOfficeLocationEvent({
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius];
}

class LoadOfficeLocationEvent extends LocationEvent {}

class ValidateGeoFenceEvent extends LocationEvent {}

class ResetOfficeLocationEvent extends LocationEvent {}

class OpenLocationSettingsEvent extends LocationEvent {}

class StartLocationTrackingEvent extends LocationEvent {}

class StopLocationTrackingEvent extends LocationEvent {}

class LocationUpdatedEvent extends LocationEvent {
  final double latitude;
  final double longitude;

  const LocationUpdatedEvent({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}
