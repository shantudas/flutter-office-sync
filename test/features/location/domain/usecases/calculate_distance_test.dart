import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:office_sync/core/error/failures.dart';
import 'package:office_sync/features/location/domain/repositories/location_repository.dart';
import 'package:office_sync/features/location/domain/usecases/calculate_distance.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late CalculateDistance usecase;
  late MockLocationRepository mockLocationRepository;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    usecase = CalculateDistance(mockLocationRepository);
  });

  const tStartLatitude = 37.7749;
  const tStartLongitude = -122.4194;
  const tEndLatitude = 37.7849;
  const tEndLongitude = -122.4094;
  const tDistance = 1234.5;

  final tParams = CalculateDistanceParams(
    startLatitude: tStartLatitude,
    startLongitude: tStartLongitude,
    endLatitude: tEndLatitude,
    endLongitude: tEndLongitude,
  );

  test('should calculate distance between two coordinates', () async {
    // arrange
    when(() => mockLocationRepository.calculateDistance(
          tStartLatitude,
          tStartLongitude,
          tEndLatitude,
          tEndLongitude,
        )).thenAnswer((_) async => const Right(tDistance));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Right(tDistance));
    verify(() => mockLocationRepository.calculateDistance(
          tStartLatitude,
          tStartLongitude,
          tEndLatitude,
          tEndLongitude,
        ));
    verifyNoMoreInteractions(mockLocationRepository);
  });

  test('should return failure when calculation fails', () async {
    // arrange
    const tFailure = UnknownFailure('Failed to calculate distance');
    when(() => mockLocationRepository.calculateDistance(
          tStartLatitude,
          tStartLongitude,
          tEndLatitude,
          tEndLongitude,
        )).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Left(tFailure));
    verify(() => mockLocationRepository.calculateDistance(
          tStartLatitude,
          tStartLongitude,
          tEndLatitude,
          tEndLongitude,
        ));
    verifyNoMoreInteractions(mockLocationRepository);
  });

  group('CalculateDistanceParams', () {
    test('should support value equality', () {
      // arrange
      const params1 = CalculateDistanceParams(
        startLatitude: tStartLatitude,
        startLongitude: tStartLongitude,
        endLatitude: tEndLatitude,
        endLongitude: tEndLongitude,
      );

      const params2 = CalculateDistanceParams(
        startLatitude: tStartLatitude,
        startLongitude: tStartLongitude,
        endLatitude: tEndLatitude,
        endLongitude: tEndLongitude,
      );

      // assert
      expect(params1, equals(params2));
    });

    test('should have correct props', () {
      // assert
      expect(
        tParams.props,
        [tStartLatitude, tStartLongitude, tEndLatitude, tEndLongitude],
      );
    });
  });
}
