import 'package:flutter_test/flutter_test.dart';
import 'package:office_sync/features/location/domain/entities/office_location.dart';

void main() {
  group('OfficeLocation', () {
    final tDateTime = DateTime(2024, 1, 1);
    
    test('should create an instance with all properties', () {
      // arrange
      const latitude = 37.7749;
      const longitude = -122.4194;
      const radiusMeters = 100.0;
      const address = '123 Main St, San Francisco, CA';
      
      // act
      final officeLocation = OfficeLocation(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        address: address,
        createdAt: tDateTime,
      );
      
      // assert
      expect(officeLocation.latitude, latitude);
      expect(officeLocation.longitude, longitude);
      expect(officeLocation.radiusMeters, radiusMeters);
      expect(officeLocation.address, address);
      expect(officeLocation.createdAt, tDateTime);
    });

    test('should create an instance without optional address', () {
      // arrange & act
      final officeLocation = OfficeLocation(
        latitude: 37.7749,
        longitude: -122.4194,
        radiusMeters: 100.0,
        createdAt: tDateTime,
      );
      
      // assert
      expect(officeLocation.address, isNull);
    });

    test('should support value equality', () {
      // arrange
      final location1 = OfficeLocation(
        latitude: 37.7749,
        longitude: -122.4194,
        radiusMeters: 100.0,
        address: '123 Main St',
        createdAt: tDateTime,
      );
      
      final location2 = OfficeLocation(
        latitude: 37.7749,
        longitude: -122.4194,
        radiusMeters: 100.0,
        address: '123 Main St',
        createdAt: tDateTime,
      );
      
      // assert
      expect(location1, equals(location2));
    });

    test('should not be equal when properties differ', () {
      // arrange
      final location1 = OfficeLocation(
        latitude: 37.7749,
        longitude: -122.4194,
        radiusMeters: 100.0,
        createdAt: tDateTime,
      );
      
      final location2 = OfficeLocation(
        latitude: 37.7750,
        longitude: -122.4194,
        radiusMeters: 100.0,
        createdAt: tDateTime,
      );
      
      // assert
      expect(location1, isNot(equals(location2)));
    });

    test('should have correct props for equality', () {
      // arrange
      final location = OfficeLocation(
        latitude: 37.7749,
        longitude: -122.4194,
        radiusMeters: 100.0,
        address: '123 Main St',
        createdAt: tDateTime,
      );
      
      // assert
      expect(
        location.props,
        [37.7749, -122.4194, 100.0, '123 Main St', tDateTime],
      );
    });
  });
}
