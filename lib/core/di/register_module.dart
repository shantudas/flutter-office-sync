import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../constants/hive_keys.dart';
import '../../features/attendance/data/models/attendance_record_model.dart';
import '../../features/location/data/models/office_location_model.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Uuid get uuid => const Uuid();

  @lazySingleton
  Box<OfficeLocationModel> get officeLocationBox =>
      Hive.box<OfficeLocationModel>(HiveKeys.officeLocationBox);

  @lazySingleton
  Box<AttendanceRecordModel> get attendanceBox =>
      Hive.box<AttendanceRecordModel>(HiveKeys.attendanceBox);
}
