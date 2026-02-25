import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

// Location specific failures
class LocationPermissionFailure extends Failure {
  const LocationPermissionFailure(super.message);
}

class LocationServiceFailure extends Failure {
  const LocationServiceFailure(super.message);
}

class LocationTimeoutFailure extends Failure {
  const LocationTimeoutFailure(super.message);
}

class LocationNotSetFailure extends Failure {
  const LocationNotSetFailure(super.message);
}

// Geofence failures
class OutOfGeofenceFailure extends Failure {
  const OutOfGeofenceFailure(super.message);
}

// General failures
class InvalidInputFailure extends Failure {
  const InvalidInputFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
