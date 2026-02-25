/// Base exception class
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException(super.message);
}

class CacheException extends AppException {
  CacheException(super.message);
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class LocationPermissionException extends AppException {
  LocationPermissionException(super.message);
}

class LocationServiceException extends AppException {
  LocationServiceException(super.message);
}

class LocationTimeoutException extends AppException {
  LocationTimeoutException(super.message);
}

class LocationNotFoundException extends AppException {
  LocationNotFoundException(super.message);
}
