import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/office_location.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/calculate_distance.dart';
import '../../domain/usecases/check_location_permission.dart';
import '../../domain/usecases/check_location_service.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/get_office_location.dart';
import '../../domain/usecases/request_location_permission.dart';
import '../../domain/usecases/reset_office_location.dart';
import '../../domain/usecases/save_office_location.dart';
import '../../domain/usecases/validate_geo_fence.dart';
import 'location_event.dart';
import 'location_state.dart';

@injectable
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository locationRepository;
  final GetCurrentLocation getCurrentLocation;
  final CheckLocationPermission checkLocationPermission;
  final RequestLocationPermission requestLocationPermission;
  final CheckLocationService checkLocationService;
  final SaveOfficeLocation saveOfficeLocation;
  final GetOfficeLocation getOfficeLocation;
  final ResetOfficeLocation resetOfficeLocation;
  final ValidateGeoFence validateGeoFence;
  final CalculateDistance calculateDistance;

  StreamSubscription? _locationStreamSubscription;

  LocationBloc({
    required this.locationRepository,
    required this.getCurrentLocation,
    required this.checkLocationPermission,
    required this.requestLocationPermission,
    required this.checkLocationService,
    required this.saveOfficeLocation,
    required this.getOfficeLocation,
    required this.resetOfficeLocation,
    required this.validateGeoFence,
    required this.calculateDistance,
  }) : super(LocationInitial()) {
    on<InitializeLocationEvent>(_onInitializeLocation);
    on<CheckPermissionsEvent>(_onCheckPermissions);
    on<RequestPermissionsEvent>(_onRequestPermissions);
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<SaveOfficeLocationEvent>(_onSaveOfficeLocation);
    on<LoadOfficeLocationEvent>(_onLoadOfficeLocation);
    on<ValidateGeoFenceEvent>(_onValidateGeoFence);
    on<ResetOfficeLocationEvent>(_onResetOfficeLocation);
    on<OpenLocationSettingsEvent>(_onOpenLocationSettings);
    on<StartLocationTrackingEvent>(_onStartLocationTracking);
    on<StopLocationTrackingEvent>(_onStopLocationTracking);
    on<LocationUpdatedEvent>(_onLocationUpdated);
  }

  @override
  Future<void> close() {
    _locationStreamSubscription?.cancel();
    return super.close();
  }

  Future<void> _onInitializeLocation(
    InitializeLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());

    // Check permissions
    final permissionResult = await checkLocationPermission(NoParams());
    await permissionResult.fold(
      (failure) async {
        emit(LocationPermissionDenied(failure.message));
      },
      (hasPermission) async {
        if (!hasPermission) {
          emit(
            const LocationPermissionDenied('Location permission is required'),
          );
          return;
        }

        // Check if location service is enabled
        final serviceResult = await checkLocationService(NoParams());
        await serviceResult.fold(
          (failure) async {
            emit(LocationServiceDisabled(failure.message));
          },
          (isEnabled) async {
            if (!isEnabled) {
              emit(
                const LocationServiceDisabled(
                  'Location services are disabled. Please enable GPS.',
                ),
              );
              return;
            }

            // Get current location
            add(GetCurrentLocationEvent());
          },
        );
      },
    );
  }

  Future<void> _onCheckPermissions(
    CheckPermissionsEvent event,
    Emitter<LocationState> emit,
  ) async {
    // Check permissions first
    final permissionResult = await checkLocationPermission(NoParams());
    await permissionResult.fold(
      (failure) async {
        emit(LocationPermissionDenied(failure.message));
      },
      (hasPermission) async {
        if (!hasPermission) {
          emit(
            const LocationPermissionDenied('Location permission is required'),
          );
          return;
        }

        // If permission granted, also check if GPS/location service is enabled
        final serviceResult = await checkLocationService(NoParams());
        await serviceResult.fold(
          (failure) async {
            emit(LocationServiceDisabled(failure.message));
          },
          (isEnabled) async {
            if (!isEnabled) {
              emit(
                const LocationServiceDisabled(
                  'Location services are disabled. Please enable GPS.',
                ),
              );
            } else {
              // Both permission and GPS are enabled
              // Try to load office location to determine next state
              final officeResult = await getOfficeLocation(NoParams());
              officeResult.fold(
                (failure) {
                  // No office location set yet, emit initial state
                  emit(LocationInitial());
                },
                (location) {
                  // Office location exists, emit loaded state
                  emit(OfficeLocationLoadedState(location));
                },
              );
            }
          },
        );
      },
    );
  }

  Future<void> _onRequestPermissions(
    RequestPermissionsEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    final result = await requestLocationPermission(NoParams());
    result.fold((failure) => emit(LocationPermissionDenied(failure.message)), (
      granted,
    ) {
      if (granted) {
        add(InitializeLocationEvent());
      } else {
        emit(
          const LocationPermissionDenied('Location permission was not granted'),
        );
      }
    });
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    final result = await getCurrentLocation(NoParams());
    result.fold((failure) => emit(LocationError(failure.message)), (position) {
      emit(
        CurrentLocationLoaded(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    });
  }

  Future<void> _onSaveOfficeLocation(
    SaveOfficeLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());

    final location = OfficeLocation(
      latitude: event.latitude,
      longitude: event.longitude,
      radiusMeters: event.radius,
      address: null,
      createdAt: DateTime.now(),
    );

    final result = await saveOfficeLocation(
      SaveOfficeLocationParams(location: location),
    );

    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (_) => emit(OfficeLocationSaved(location)),
    );
  }

  Future<void> _onLoadOfficeLocation(
    LoadOfficeLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    final result = await getOfficeLocation(NoParams());
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (location) => emit(OfficeLocationLoadedState(location)),
    );
  }

  Future<void> _onValidateGeoFence(
    ValidateGeoFenceEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());

    // Get office location
    final officeResult = await getOfficeLocation(NoParams());
    await officeResult.fold(
      (failure) async {
        emit(LocationError(failure.message));
      },
      (officeLocation) async {
        // Get current location
        final currentResult = await getCurrentLocation(NoParams());
        await currentResult.fold(
          (failure) async {
            emit(LocationError(failure.message));
          },
          (currentPosition) async {
            // Calculate distance
            final distanceResult = await calculateDistance(
              CalculateDistanceParams(
                startLatitude: currentPosition.latitude,
                startLongitude: currentPosition.longitude,
                endLatitude: officeLocation.latitude,
                endLongitude: officeLocation.longitude,
              ),
            );

            await distanceResult.fold(
              (failure) async {
                emit(LocationError(failure.message));
              },
              (distance) async {
                // Validate geo fence
                final validateResult = await validateGeoFence(
                  ValidateGeoFenceParams(
                    currentLatitude: currentPosition.latitude,
                    currentLongitude: currentPosition.longitude,
                    officeLatitude: officeLocation.latitude,
                    officeLongitude: officeLocation.longitude,
                    radius: officeLocation.radiusMeters,
                  ),
                );

                validateResult.fold(
                  (failure) => emit(LocationError(failure.message)),
                  (isWithinRange) {
                    emit(
                      LocationValidated(
                        distance: distance,
                        isWithinRange: isWithinRange,
                        officeLocation: officeLocation,
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _onResetOfficeLocation(
    ResetOfficeLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    final result = await resetOfficeLocation(NoParams());
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (_) => emit(OfficeLocationReset()),
    );
  }

  Future<void> _onOpenLocationSettings(
    OpenLocationSettingsEvent event,
    Emitter<LocationState> emit,
  ) async {
    try {
      // Open location settings
      await geo.Geolocator.openLocationSettings();
      // After opening settings, re-check permissions after a delay
      await Future.delayed(const Duration(seconds: 1));
      add(CheckPermissionsEvent());
    } catch (e) {
      emit(LocationError('Failed to open location settings: ${e.toString()}'));
    }
  }

  Future<void> _onStartLocationTracking(
    StartLocationTrackingEvent event,
    Emitter<LocationState> emit,
  ) async {
    // Cancel any existing subscription
    await _locationStreamSubscription?.cancel();

    // Start listening to location stream
    _locationStreamSubscription = locationRepository.getLocationStream().listen(
      (position) {
        // Dispatch location updated event
        add(
          LocationUpdatedEvent(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      },
      onError: (error) {
        emit(LocationError('Location stream error: ${error.toString()}'));
      },
    );

    // Trigger initial location update
    add(ValidateGeoFenceEvent());
  }

  Future<void> _onStopLocationTracking(
    StopLocationTrackingEvent event,
    Emitter<LocationState> emit,
  ) async {
    await _locationStreamSubscription?.cancel();
    _locationStreamSubscription = null;
  }

  Future<void> _onLocationUpdated(
    LocationUpdatedEvent event,
    Emitter<LocationState> emit,
  ) async {
    // Get office location
    final officeResult = await getOfficeLocation(NoParams());
    await officeResult.fold(
      (failure) async {
        // If no office location, don't emit error, just return
        return;
      },
      (officeLocation) async {
        // Calculate distance
        final distanceResult = await calculateDistance(
          CalculateDistanceParams(
            startLatitude: event.latitude,
            startLongitude: event.longitude,
            endLatitude: officeLocation.latitude,
            endLongitude: officeLocation.longitude,
          ),
        );

        await distanceResult.fold(
          (failure) async {
            emit(LocationError(failure.message));
          },
          (distance) async {
            // Debug print location tracking
            print('🎯 Location Tracking Update:');
            print(
              '   Office Location: (${officeLocation.latitude.toStringAsFixed(6)}, ${officeLocation.longitude.toStringAsFixed(6)})',
            );
            print(
              '   Current Location: (${event.latitude.toStringAsFixed(6)}, ${event.longitude.toStringAsFixed(6)})',
            );
            print('   Distance: ${distance.toStringAsFixed(2)}m');

            // Validate geo fence
            final validateResult = await validateGeoFence(
              ValidateGeoFenceParams(
                currentLatitude: event.latitude,
                currentLongitude: event.longitude,
                officeLatitude: officeLocation.latitude,
                officeLongitude: officeLocation.longitude,
                radius: officeLocation.radiusMeters,
              ),
            );

            validateResult.fold(
              (failure) => emit(LocationError(failure.message)),
              (isWithinRange) {
                print(
                  '   Within Range: $isWithinRange (radius: ${officeLocation.radiusMeters}m)\n',
                );
                emit(
                  LocationValidated(
                    distance: distance,
                    isWithinRange: isWithinRange,
                    officeLocation: officeLocation,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
