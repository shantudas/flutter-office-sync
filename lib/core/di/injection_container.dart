import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../constants/hive_keys.dart';
import '../../features/attendance/data/models/attendance_record_model.dart';
import '../../features/location/data/models/office_location_model.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
/// Initialize dependency injection
Future<void> configureDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  if (!Hive.isAdapterRegistered(HiveKeys.officeLocationTypeId)) {
    Hive.registerAdapter(OfficeLocationModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveKeys.attendanceRecordTypeId)) {
    Hive.registerAdapter(AttendanceRecordModelAdapter());
  }

  // Open Hive boxes
  await Hive.openBox<OfficeLocationModel>(HiveKeys.officeLocationBox);
  await Hive.openBox<AttendanceRecordModel>(HiveKeys.attendanceBox);

  // Initialize injectable dependencies
  getIt.init();
}
