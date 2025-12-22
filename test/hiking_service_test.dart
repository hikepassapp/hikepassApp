import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/models/hiking_model.dart';
import 'package:hikepass_app/app/services/hiking_service.dart';

void main() {
  group('HikingService Tests', () {
    late HikingService service;

    setUp(() {
      Get.testMode = true;
      service = HikingService();
      service.onInit();
    });

    tearDown(() {
      service.onClose();
      Get.reset();
    });

    test('Service initializes empty until reservations created', () {
      expect(service.allHikings.isEmpty, true);
      expect(service.pendingCheckIns.isEmpty, true);
    });

    test('getHikingById returns null for non-existent ID', () {
      expect(service.getHikingById('non-existent'), isNull);
    });

    test('HikingStatus enum has expected values', () {
      expect(HikingStatus.pending, isNotNull);
      expect(HikingStatus.checkedIn, isNotNull);
      expect(HikingStatus.checkedOut, isNotNull);
    });

    test('HikingModel can be created with valid data', () {
      final hiking = HikingModel(
        id: 'test-hiking-1',
        reservasiId: 'test-reservasi-1',
        mountainName: 'Test Mountain',
        hikingTrail: 'Test Trail',
        startDate: DateTime.now(),
        status: HikingStatus.pending,
      );

      expect(hiking.id, 'test-hiking-1');
      expect(hiking.mountainName, 'Test Mountain');
      expect(hiking.status, HikingStatus.pending);
      expect(hiking.checkInDate, isNull);
      expect(hiking.checkOutDate, isNull);
    });

    test('HikingModel copyWith updates fields correctly', () {
      final original = HikingModel(
        id: 'test-hiking-2',
        reservasiId: 'test-reservasi-2',
        mountainName: 'Test Mountain',
        hikingTrail: 'Test Trail',
        startDate: DateTime.now(),
        status: HikingStatus.pending,
      );

      final updated = original.copyWith(
        status: HikingStatus.checkedIn,
        checkInDate: DateTime.now(),
      );

      expect(updated.status, HikingStatus.checkedIn);
      expect(updated.checkInDate, isNotNull);
      expect(updated.id, original.id); // ID should remain same
      expect(updated.mountainName, original.mountainName); // Name should remain same
    });
  });
}
