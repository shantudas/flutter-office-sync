// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;
import 'package:uuid/uuid.dart' as _i706;

import '../../features/attendance/data/datasources/attendance_local_data_source.dart'
    as _i769;
import '../../features/attendance/data/models/attendance_record_model.dart'
    as _i497;
import '../../features/attendance/data/repositories/attendance_repository_impl.dart'
    as _i719;
import '../../features/attendance/domain/repositories/attendance_repository.dart'
    as _i477;
import '../../features/attendance/domain/usecases/clear_all_attendance.dart'
    as _i136;
import '../../features/attendance/domain/usecases/delete_attendance.dart'
    as _i425;
import '../../features/attendance/domain/usecases/get_attendance_history.dart'
    as _i910;
import '../../features/attendance/domain/usecases/mark_attendance.dart'
    as _i532;
import '../../features/attendance/presentation/bloc/attendance/attendance_bloc.dart'
    as _i354;
import '../../features/location/data/datasources/location_local_data_source.dart'
    as _i632;
import '../../features/location/data/models/office_location_model.dart'
    as _i835;
import '../../features/location/data/repositories/location_repository_impl.dart'
    as _i115;
import '../../features/location/domain/repositories/location_repository.dart'
    as _i332;
import '../../features/location/domain/usecases/calculate_distance.dart'
    as _i692;
import '../../features/location/domain/usecases/check_location_permission.dart'
    as _i384;
import '../../features/location/domain/usecases/check_location_service.dart'
    as _i218;
import '../../features/location/domain/usecases/get_current_location.dart'
    as _i517;
import '../../features/location/domain/usecases/get_office_location.dart'
    as _i622;
import '../../features/location/domain/usecases/request_location_permission.dart'
    as _i123;
import '../../features/location/domain/usecases/reset_office_location.dart'
    as _i662;
import '../../features/location/domain/usecases/save_office_location.dart'
    as _i324;
import '../../features/location/domain/usecases/validate_geo_fence.dart'
    as _i827;
import '../../features/location/presentation/bloc/location_bloc.dart' as _i845;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i706.Uuid>(() => registerModule.uuid);
    gh.lazySingleton<_i979.Box<_i835.OfficeLocationModel>>(
        () => registerModule.officeLocationBox);
    gh.lazySingleton<_i979.Box<_i497.AttendanceRecordModel>>(
        () => registerModule.attendanceBox);
    gh.lazySingleton<_i769.AttendanceLocalDataSource>(
        () => _i769.AttendanceLocalDataSourceImpl(
              gh<_i979.Box<_i497.AttendanceRecordModel>>(),
              gh<_i706.Uuid>(),
            ));
    gh.lazySingleton<_i632.LocationLocalDataSource>(() =>
        _i632.LocationLocalDataSourceImpl(
            gh<_i979.Box<_i835.OfficeLocationModel>>()));
    gh.lazySingleton<_i477.AttendanceRepository>(() =>
        _i719.AttendanceRepositoryImpl(
            localDataSource: gh<_i769.AttendanceLocalDataSource>()));
    gh.lazySingleton<_i332.LocationRepository>(() =>
        _i115.LocationRepositoryImpl(
            localDataSource: gh<_i632.LocationLocalDataSource>()));
    gh.lazySingleton<_i425.DeleteAttendance>(
        () => _i425.DeleteAttendance(gh<_i477.AttendanceRepository>()));
    gh.lazySingleton<_i532.MarkAttendance>(
        () => _i532.MarkAttendance(gh<_i477.AttendanceRepository>()));
    gh.lazySingleton<_i136.ClearAllAttendance>(
        () => _i136.ClearAllAttendance(gh<_i477.AttendanceRepository>()));
    gh.lazySingleton<_i910.GetAttendanceHistory>(
        () => _i910.GetAttendanceHistory(gh<_i477.AttendanceRepository>()));
    gh.lazySingleton<_i827.ValidateGeoFence>(
        () => _i827.ValidateGeoFence(gh<_i332.LocationRepository>()));
    gh.lazySingleton<_i692.CalculateDistance>(
        () => _i692.CalculateDistance(gh<_i332.LocationRepository>()));
    gh.lazySingleton<_i324.SaveOfficeLocation>(
        () => _i324.SaveOfficeLocation(gh<_i332.LocationRepository>()));
    gh.lazySingleton<_i218.CheckLocationService>(
        () => _i218.CheckLocationService(gh<_i332.LocationRepository>()));
    gh.lazySingleton<_i123.RequestLocationPermission>(
        () => _i123.RequestLocationPermission(gh<_i332.LocationRepository>()));
    gh.lazySingleton<_i517.GetCurrentLocation>(
        () => _i517.GetCurrentLocation(gh<_i332.LocationRepository>()));
    gh.lazySingleton<_i662.ResetOfficeLocation>(
        () => _i662.ResetOfficeLocation(gh<_i332.LocationRepository>()));
    gh.lazySingleton<_i384.CheckLocationPermission>(
        () => _i384.CheckLocationPermission(gh<_i332.LocationRepository>()));
    gh.lazySingleton<_i622.GetOfficeLocation>(
        () => _i622.GetOfficeLocation(gh<_i332.LocationRepository>()));
    gh.factory<_i354.AttendanceBloc>(() => _i354.AttendanceBloc(
          markAttendance: gh<_i532.MarkAttendance>(),
          getAttendanceHistory: gh<_i910.GetAttendanceHistory>(),
          deleteAttendance: gh<_i425.DeleteAttendance>(),
          clearAllAttendance: gh<_i136.ClearAllAttendance>(),
        ));
    gh.factory<_i845.LocationBloc>(() => _i845.LocationBloc(
          locationRepository: gh<_i332.LocationRepository>(),
          getCurrentLocation: gh<_i517.GetCurrentLocation>(),
          checkLocationPermission: gh<_i384.CheckLocationPermission>(),
          requestLocationPermission: gh<_i123.RequestLocationPermission>(),
          checkLocationService: gh<_i218.CheckLocationService>(),
          saveOfficeLocation: gh<_i324.SaveOfficeLocation>(),
          getOfficeLocation: gh<_i622.GetOfficeLocation>(),
          resetOfficeLocation: gh<_i662.ResetOfficeLocation>(),
          validateGeoFence: gh<_i827.ValidateGeoFence>(),
          calculateDistance: gh<_i692.CalculateDistance>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
