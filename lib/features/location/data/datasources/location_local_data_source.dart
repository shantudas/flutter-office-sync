import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/hive_keys.dart';
import '../../../../core/error/exceptions.dart';
import '../models/office_location_model.dart';

abstract class LocationLocalDataSource {
  Future<void> saveOfficeLocation(OfficeLocationModel location);
  Future<OfficeLocationModel> getOfficeLocation();
  Future<void> deleteOfficeLocation();
}

@LazySingleton(as: LocationLocalDataSource)
class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final Box<OfficeLocationModel> box;

  LocationLocalDataSourceImpl(this.box);

  @override
  Future<void> saveOfficeLocation(OfficeLocationModel location) async {
    try {
      await box.put(HiveKeys.officeLocationKey, location);
    } catch (e) {
      throw CacheException('Failed to save office location: ${e.toString()}');
    }
  }

  @override
  Future<OfficeLocationModel> getOfficeLocation() async {
    try {
      final location = box.get(HiveKeys.officeLocationKey);
      if (location == null) {
        throw CacheException('Office location not found');
      }
      return location;
    } catch (e) {
      throw CacheException('Failed to get office location: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteOfficeLocation() async {
    try {
      await box.delete(HiveKeys.officeLocationKey);
    } catch (e) {
      throw CacheException('Failed to delete office location: ${e.toString()}');
    }
  }
}
