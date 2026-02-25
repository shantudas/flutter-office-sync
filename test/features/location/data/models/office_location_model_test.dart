import 'package:flutter_test/flutter_test.dart';
import 'package:office_sync/features/location/data/models/office_location_model.dart';
import 'package:office_sync/features/location/domain/entities/office_location.dart';

void main() {
  group('OfficeLocationModel', () {
    final tDateTime = DateTime(2024, 1, 1);
    const tLatitude = 37.7749;
    const tLongitude = -122.4194;
    const tRadius = 100.0;
    const tAddress = '123 Main St, San Francisco, CA';

    final tOfficeLocationModel = OfficeLocationModel(
      latitude: tLatitude,
      longitude: tLongitude,
      radiusMeters: tRadius,
      address: tAddress,
      createdAt: tDateTime,
    );

    final tOfficeLocation = OfficeLocation(
      latitude: tLatitude,
      longitude: tLongitude,
      radiusMeters: tRadius,
      address: tAddress,
      createdAt: tDateTime,
    );

    test('should be a subclass of OfficeLocation entity', () {
      // assert
      expect(tOfficeLocationModel, isA<OfficeLocation>());
    });

    group('fromEntity', () {
      test('should convert OfficeLocation entity to OfficeLocationModel', () {
        // act
        final result = OfficeLocationModel.fromEntity(tOfficeLocation);

        // assert
        expect(result.latitude, tOfficeLocation.latitude);
        expect(result.longitude, tOfficeLocation.longitude);
        expect(result.radiusMeters, tOfficeLocation.radiusMeters);
        expect(result.address, tOfficeLocation.address);
        expect(result.createdAt, tOfficeLocation.createdAt);
      });

      test('should handle null address when converting from entity', () {
        // arrange
        final entityWithoutAddress = OfficeLocation(
          latitude: tLatitude,
          longitude: tLongitude,
          radiusMeters: tRadius,
          createdAt: tDateTime,
        );

        // act
        final result = OfficeLocationModel.fromEntity(entityWithoutAddress);

        // assert
        expect(result.address, isNull);
      });
    });

    group('toEntity', () {
      test('should convert OfficeLocationModel to OfficeLocation entity', () {
        // act
        final result = tOfficeLocationModel.toEntity();

        // assert
        expect(result, isA<OfficeLocation>());
        expect(result.latitude, tOfficeLocationModel.latitude);
        expect(result.longitude, tOfficeLocationModel.longitude);
        expect(result.radiusMeters, tOfficeLocationModel.radiusMeters);
        expect(result.address, tOfficeLocationModel.address);
        expect(result.createdAt, tOfficeLocationModel.createdAt);
      });

      test('should preserve null address when converting to entity', () {
        // arrange
        final modelWithoutAddress = OfficeLocationModel(
          latitude: tLatitude,
          longitude: tLongitude,
          radiusMeters: tRadius,
          createdAt: tDateTime,
        );

        // act
        final result = modelWithoutAddress.toEntity();

        // assert
        expect(result.address, isNull);
      });
    });

    group('round trip conversion', () {
      test('should maintain data integrity through fromEntity and toEntity', () {
        // act
        final model = OfficeLocationModel.fromEntity(tOfficeLocation);
        final entity = model.toEntity();

        // assert
        expect(entity.latitude, tOfficeLocation.latitude);
        expect(entity.longitude, tOfficeLocation.longitude);
        expect(entity.radiusMeters, tOfficeLocation.radiusMeters);
        expect(entity.address, tOfficeLocation.address);
        expect(entity.createdAt, tOfficeLocation.createdAt);
      });
    });
  });
}
