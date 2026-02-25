# Office Sync - Implementation Guide

## 🎯 Overview

Office Sync is a **GPS-only attendance tracking application** built with Flutter that enables location-based attendance marking. The app uses Clean Architecture with BLoC state management and Hive for local storage. No maps visualization or geocoding services are used - it's purely coordinate-based distance validation.

## ✅ Implemented Features

### Core Features
1. ✅ **Location Permission Handling** - Checks and requests location permissions via Geolocator
2. ✅ **GPS Status Detection** - Detects if GPS is enabled/disabled
3. ✅ **Set Office Location** - Captures current GPS coordinates as office location
4. ✅ **50 Meters Geofence Validation** - Validates user within 50m radius using Haversine formula
5. ✅ **Real-time Distance Tracking** - Live streaming of distance from office location
6. ✅ **Attendance Marking** - Mark attendance when within geofence with timestamp and coordinates
7. ✅ **Attendance History** - View past attendance records with distance and time
8. ✅ **Reset Office Location** - Clear and reset office location
9. ✅ **Clean Architecture** - Domain, Data, Presentation layers properly separated
10. ✅ **BLoC State Management** - Event-driven state management with location and attendance blocs
11. ✅ **Hive Local Storage** - Offline-first persistent storage with TypeAdapters
12. ✅ **Dependency Injection** - GetIt service locator (manual setup, no code generation)

## 🏗️ Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────────────────┐
│           Presentation Layer                     │
│  ┌─────────────┐  ┌──────────────────────────┐ │
│  │   BLoCs     │  │   UI Screens & Widgets   │ │
│  │  - Location │  │   - AttendanceScreen     │ │
│  │  - Attendnc │  │   - Custom Widgets       │ │
│  └─────────────┘  └──────────────────────────┘ │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│              Domain Layer                        │
│  ┌─────────────┐  ┌──────────┐  ┌────────────┐ │
│  │  Entities   │  │Use Cases │  │Repositories│ │
│  │ (Pure Dart) │  │(Business)│  │(Interfaces)│ │
│  └─────────────┘  └──────────┘  └────────────┘ │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│               Data Layer                         │
│  ┌─────────────────┐  ┌──────────────────────┐ │
│  │ Repository Impl │  │   Data Sources       │ │
│  │                 │  │  (Hive + Geolocator) │ │
│  └─────────────────┘  └──────────────────────┘ │
└─────────────────────────────────────────────────┘
```

## 📁 Current Project Structure

```
lib/
├── main.dart                           # App entry point with Hive initialization
├── app.dart                            # Root app widget with BlocProviders
├── core/
│   ├── constants/
│   │   ├── app_constants.dart         # App name, routes
│   │   ├── storage_keys.dart          # Hive box names and type IDs
│   │   └── geo_constants.dart         # Geofencing constants (50m radius)
│   ├── error/
│   │   ├── failures.dart              # Failure types (LocationPermission, etc)
│   │   └── exceptions.dart            # Exception types
│   ├── usecases/
│   │   └── usecase.dart               # Base UseCase abstract class
│   ├── utils/
│   │   └── distance_calculator.dart   # Haversine formula for GPS distance
│   └── di/
│       └── injection_container.dart   # GetIt DI manual setup
├── features/
│   └── attendance/
│       ├── data/
│       │   ├── models/
│       │   │   ├── office_location_model.dart    # Hive TypeAdapter
│       │   │   ├── office_location_model.g.dart  # Generated
│       │   │   ├── attendance_record_model.dart  # Hive TypeAdapter
│       │   │   └── attendance_record_model.g.dart
│       │   ├── datasources/
│       │   │   ├── location_local_data_source.dart   # Hive operations
│       │   │   └── attendance_local_data_source.dart # Hive operations
│       │   └── repositories/
│       │       ├── location_repository_impl.dart     # Uses Geolocator
│       │       └── attendance_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── office_location.dart          # Pure Dart entity
│       │   │   └── attendance_record.dart        # Pure Dart entity
│       │   ├── repositories/
│       │   │   ├── location_repository.dart      # Interface
│       │   │   └── attendance_repository.dart    # Interface
│       │   └── usecases/
│       │       ├── get_current_location.dart
│       │       ├── save_office_location.dart
│       │       ├── get_office_location.dart
│       │       ├── reset_office_location.dart
│       │       ├── calculate_distance.dart
│       │       ├── validate_geo_fence.dart
│       │       ├── check_location_permission.dart
│       │       ├── request_location_permission.dart
│       │       ├── check_location_service.dart
│       │       ├── mark_attendance.dart
│       │       ├── get_attendance_history.dart
│       │       ├── delete_attendance.dart
│       │       └── clear_all_attendance.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── location/
│           │   │   ├── location_bloc.dart
│           │   │   ├── location_event.dart
│           │   │   └── location_state.dart
│           │   └── attendance/
│           │       ├── attendance_bloc.dart
│           │       ├── attendance_event.dart
│           │       └── attendance_state.dart
│           ├── pages/
│           │   └── attendance_screen.dart
│           └── widgets/
│               ├── distance_indicator.dart
│               ├── attendance_button.dart
│               ├── setup_location_widget.dart
│               ├── permission_request_widget.dart
│               └── loading_indicator.dart
└── config/
    ├── routes/
    │   └── app_routes.dart
    └── theme/
        ├── app_theme.dart
        └── app_colors.dart
```

## 🚀 Setup Instructions

### 1. Dependencies

**Current dependencies** (no Google Maps, no geocoding, no injectable):

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  
  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.8
  
  # Dependency Injection (manual setup)
  get_it: ^7.7.0
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # GPS Location (no maps visualization)
  geolocator: ^13.0.2
  permission_handler: ^11.3.1
  
  # Functional Programming
  dartz: ^0.10.1
  
  # Utilities
  intl: ^0.19.0
  uuid: ^4.5.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  
  # Code Generation (Hive only)
  build_runner: ^2.4.13
  hive_generator: ^2.0.1
  
  # Testing
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
```

### 2. Platform Configuration

#### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<manifest>
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
</manifest>
```

#### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs your location to set and verify office attendance</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs your location to set and verify office attendance</string>
```

### 3. Install Dependencies & Generate Code

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the App

```bash
flutter run
```

## 🎯 How It Works

### Phase 1: Initial Setup
1. User opens app
2. App checks location permissions (via Geolocator)
3. If denied, shows permission request UI
4. App checks if GPS is enabled
5. If disabled, shows alert to enable GPS
6. User sees "Set Office Location" button
7. User clicks button → app fetches current GPS coordinates
8. Coordinates saved to Hive with 50m radius
9. Automatic transition to tracking mode

### Phase 2: Real-Time Tracking
1. After office location is set, live tracking starts automatically
2. App streams position updates via `Geolocator.getPositionStream()`
3. For each position update:
   - Calculate distance using Haversine formula
   - Check if within 50m geofence
   - Update distance indicator UI
4. Distance indicator shows:
   - Circular progress (Apple AirTag-inspired)
   - Exact distance in meters
   - Status (within range / outside range)
   - Color coding (green = in range, orange = out of range)

### Phase 3: Attendance Marking
1. "Mark Attendance" button enabled only when within 50m
2. Button disabled when outside geofence or loading
3. User clicks "Mark Attendance"
4. App saves attendance record with:
   - UUID
   - Timestamp
   - GPS coordinates (lat/lon)
   - Distance from office
   - Attendance type ('check-in')
5. Record stored in Hive locally
6. Success notification shown

### Phase 4: View History
1. User can view attendance history
2. Records displayed with date, time, and distance
3. Can delete individual records
4. Can clear all attendance history

## 🔑 Key Technical Components

### 1. Distance Calculation (Haversine Formula)

```dart
// lib/core/utils/distance_calculator.dart
static double calculateDistance(
  double lat1, double lon1,
  double lat2, double lon2,
) {
  const double earthRadius = 6371000; // meters
  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);
  
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
      sin(dLon / 2) * sin(dLon / 2);
  
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c; // distance in meters
}
```

### 2. Real-Time Location Streaming

```dart
// In LocationRepositoryImpl
@override
Stream<Position> getLocationStream() {
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Update every 10 meters
  );
  return Geolocator.getPositionStream(locationSettings: locationSettings);
}
```

### 3. Geofence Validation

```dart
// ValidateGeoFence use case
Future<Either<Failure, bool>> call(ValidateGeoFenceParams params) async {
  final distance = DistanceCalculator.calculateDistance(
    params.currentLatitude,
    params.currentLongitude,
    params.officeLatitude,
    params.officeLongitude,
  );
  return Right(distance <= params.radiusMeters);
}
```

### 4. Hive Local Storage

**OfficeLocationModel** (`office_location_box`):
```dart
@HiveType(typeId: 0)
class OfficeLocationModel {
  @HiveField(0) final double latitude;
  @HiveField(1) final double longitude;
  @HiveField(2) final double radiusMeters;
  @HiveField(3) final DateTime createdAt;
}
```

**AttendanceRecordModel** (`attendance_box`):
```dart
@HiveType(typeId: 1)
class AttendanceRecordModel {
  @HiveField(0) final String id;
  @HiveField(1) final DateTime timestamp;
  @HiveField(2) final double latitude;
  @HiveField(3) final double longitude;
  @HiveField(4) final double distanceFromOffice;
  @HiveField(5) final String type;
}
```

### 5. BLoC State Management

#### LocationBloc

**Events:**
- `InitializeLocationEvent` - Initial setup (permissions + GPS check)
- `CheckPermissionsEvent` - Check location permission status
- `RequestPermissionsEvent` - Request location permissions
- `GetCurrentLocationEvent` - Fetch single GPS position
- `SaveOfficeLocationEvent` - Save office location to Hive
- `LoadOfficeLocationEvent` - Load saved office location
- `ValidateGeoFenceEvent` - Check if within 50m (single check)
- `StartLocationTrackingEvent` - Start live position streaming
- `StopLocationTrackingEvent` - Stop live position streaming
- `LocationUpdatedEvent` - Internal event for stream updates
- `ResetOfficeLocationEvent` - Clear office location

**States:**
- `LocationInitial` - Initial state
- `LocationLoading` - Loading GPS/data
- `LocationPermissionDenied(message)` - Permission denied
- `LocationServiceDisabled(message)` - GPS disabled
- `CurrentLocationLoaded(lat, lon)` - Single position fetched
- `OfficeLocationLoadedState(location)` - Office location loaded from Hive
- `OfficeLocationSaved` - Location saved successfully
- `LocationValidated(distance, isWithinRange, location)` - Validation result with live updates
- `OfficeLocationReset` - Location cleared
- `LocationError(message)` - Error occurred

#### AttendanceBloc

**Events:**
- `MarkAttendanceEvent(lat, lon, distance, type)`
- `LoadAttendanceHistoryEvent`
- `DeleteAttendanceEvent(id)`
- `ClearAllAttendanceEvent`

**States:**
- `AttendanceInitial`
- `AttendanceLoading`
- `AttendanceMarked`
- `AttendanceHistoryLoaded(records)`
- `AttendanceDeleted`
- `AttendanceCleared`
- `AttendanceError(message)`

## 📱 UI Components

### AttendanceScreen (`attendance_screen.dart`)

**Main screen with three conditional states:**

1. **No Office Location Set:**
   - Shows `SetupLocationWidget`
   - "Set Office Location" button
   - Location icon placeholder
   - Info text explaining setup

2. **Office Location Set (Normal Mode):**
   - Shows `DistanceIndicator` widget (circular progress)
   - Live distance updates via location stream
   - Shows `AttendanceButton` widget
     - Enabled only when within 50m
     - Disabled with grey styling when outside range
   - Reset button in app bar

3. **Permission/GPS Issues:**
   - Shows `PermissionRequestWidget`
   - Request permission button
   - Enable GPS instructions

### Custom Widgets

**DistanceIndicator:**
- Apple AirTag-inspired circular design
- Shows exact distance (e.g., "12m away")
- Color-coded (green = within range, orange = outside)
- Smooth animations
- Real-time updates

**AttendanceButton:**
- Large primary button
- Enabled/disabled based on geofence
- Loading state during attendance marking
- Color changes based on validity

**SetupLocationWidget:**
- Shown when no office location set
- Clean card-based design
- Call-to-action button

**PermissionRequestWidget:**
- Shown when permissions denied
- Explains why permission needed
- Request button

## 🔧 Customization

### Change Geofence Radius

Edit `lib/core/constants/geo_constants.dart`:
```dart
class GeoConstants {
  static const double officeRadiusMeters = 50.0; // Change here
  static const int locationTimeoutSeconds = 30;
  static const double desiredAccuracyMeters = 10.0;
}
```

### Change Location Update Frequency

Edit `lib/features/attendance/data/repositories/location_repository_impl.dart`:
```dart
Stream<Position> getLocationStream() {
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Update every X meters (change here)
  );
  return Geolocator.getPositionStream(locationSettings: locationSettings);
}
```

### Change Theme Colors

Edit `lib/config/theme/app_colors.dart`:
```dart
class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color accent = Color(0xFFFF9800);
  // ... more colors
}
```

## 🐛 Troubleshooting

### GPS Not Working
- Ensure location permissions granted (app checks automatically)
- Check GPS enabled in device settings
- Verify `geolocator` permissions in AndroidManifest.xml/Info.plist
- Try outdoors for better GPS signal

### "Location service disabled" Error
- GPS is disabled in system settings
- App shows alert with instructions
- User must enable GPS manually in system settings

### Distance Always High/Inaccurate
- GPS takes 10-30 seconds to acquire accurate fix
- Works best outdoors with clear sky view
- Accuracy reduced indoors (normal GPS limitation)
- Check `desiredAccuracyMeters` in geo_constants.dart

### Hive Errors After Code Changes
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### App Crashes on Startup
- Check Hive adapters registered correctly in main.dart
- Verify type IDs unique in storage_keys.dart
- Run `flutter clean && flutter pub get`

## 📊 Data Storage

### Hive Boxes

**office_location_box:**
- **Key:** 'office_location' (single record)
- **Value:** OfficeLocationModel
  - latitude: double
  - longitude: double
  - radiusMeters: double (50.0)
  - createdAt: DateTime

**attendance_box:**
- **Key:** UUID string
- **Value:** AttendanceRecordModel
  - id: String (UUID)
  - timestamp: DateTime
  - latitude: double
  - longitude: double
  - distanceFromOffice: double
  - type: String ('check-in')

## ✅ Testing

### Current Tests
- Basic widget test for attendance screen loading

### Run Tests
```bash
flutter test
```

### Testing Checklist
- [x] Location permission request works
- [x] GPS enable/disable detection works
- [x] "Set Office Location" saves coordinates
- [x] Distance calculation accurate
- [x] Live distance tracking works
- [x] "Mark Attendance" enabled only within 50m
- [x] Attendance records saved to Hive
- [x] App works offline (no network needed)
- [x] Reset office location clears data
- [x] Attendance history displays correctly

## 🚀 Future Enhancements (Not Implemented)

1. **Background Monitoring** - Auto-mark when entering geofence
2. **Check-out Functionality** - Track exit time
3. **Multiple Office Locations** - Support branch offices
4. **Statistics Dashboard** - Monthly attendance percentage
5. **Export Attendance** - CSV/PDF reports
6. **Settings Screen** - App configuration
7. **Onboarding Flow** - First-time user tutorial
8. **Notifications** - Attendance reminders
9. **Backend Integration** - Sync with server

## 📄 Key Notes

### What This App Does
- ✅ GPS-only attendance tracking
- ✅ Offline-first (no internet required)
- ✅ Real-time distance monitoring
- ✅ Local storage only (Hive)
- ✅ Clean Architecture implementation
- ✅ BLoC state management

### What This App Does NOT Do
- ❌ No Google Maps visualization
- ❌ No geocoding (address lookup)
- ❌ No network/backend sync
- ❌ No onboarding screens
- ❌ No settings screen
- ❌ No background location tracking
- ❌ No code generation for DI (manual GetIt)

## 📝 Implementation Status

**Fully Implemented:**
- Core attendance features
- Location permission handling
- GPS-based geofencing
- Real-time distance tracking
- Attendance history
- Clean Architecture layers
- BLoC state management
- Hive local storage
- Custom UI widgets

**Not Implemented:**
- Onboarding feature (mentioned in README but not built)
- Settings screen
- Statistics/reports
- Background location
- Server sync
- Multiple office support

---

**Last Updated:** Based on current implementation as of project analysis.
**Architecture:** Clean Architecture + BLoC + Hive
**GPS Only:** No maps, no geocoding, purely coordinate-based validation.
