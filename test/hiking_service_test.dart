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

    test('Service initializes with mock data', () {
      expect(service.allHikings.isNotEmpty, true);
      expect(service.pendingCheckIns.length, 1);
    });

    test('Process initial check-in saves timestamp', () {
      final hiking = service.pendingCheckIns.first;
      final id = hiking.id;
      
      service.processInitialCheckIn(id);
      
      final updated = service.getHikingById(id);
      expect(updated?.checkInDate, isNotNull);
    });

    test('Process check-in form changes status to checkedIn', () {
      final hiking = service.pendingCheckIns.first;
      final id = hiking.id;
      
      service.processInitialCheckIn(id);
      service.processCheckInForm(
        hikingId: id,
        checkInItems: 'Test items',
        checkInCheckboxes: List.generate(6, (_) => true),
      );
      
      final updated = service.getHikingById(id);
      expect(updated?.status, HikingStatus.checkedIn);
      expect(updated?.checkInItems, 'Test items');
    });

    test('Process initial check-out saves timestamp', () {
      final hiking = service.pendingCheckIns.first;
      final id = hiking.id;
      
      // First do check-in
      service.processInitialCheckIn(id);
      service.processCheckInForm(
        hikingId: id,
        checkInItems: 'Test items',
        checkInCheckboxes: List.generate(6, (_) => true),
      );
      
      // Then do initial check-out
      service.processInitialCheckOut(id);
      
      final updated = service.getHikingById(id);
      expect(updated?.checkOutDate, isNotNull);
    });

    test('Process check-out form changes status to checkedOut', () {
      final hiking = service.pendingCheckIns.first;
      final id = hiking.id;
      
      // Complete check-in
      service.processInitialCheckIn(id);
      service.processCheckInForm(
        hikingId: id,
        checkInItems: 'Test items',
        checkInCheckboxes: List.generate(6, (_) => true),
      );
      
      // Complete check-out
      service.processInitialCheckOut(id);
      service.processCheckOutForm(
        hikingId: id,
        checkOutItems: 'Test return items',
        checkOutCheckboxes: List.generate(3, (_) => true),
      );
      
      final updated = service.getHikingById(id);
      expect(updated?.status, HikingStatus.checkedOut);
      expect(updated?.checkOutItems, 'Test return items');
    });

    test('Complete check-out prepares history data and removes hiking', () {
      final hiking = service.pendingCheckIns.first;
      final id = hiking.id;

      // Complete full flow
      service.processInitialCheckIn(id);
      service.processCheckInForm(
        hikingId: id,
        checkInItems: 'Test items',
        checkInCheckboxes: List.generate(6, (_) => true),
      );
      service.processInitialCheckOut(id);
      service.processCheckOutForm(
        hikingId: id,
        checkOutItems: 'Test return items',
        checkOutCheckboxes: List.generate(3, (_) => true),
      );

      final initialCount = service.allHikings.length;
      final historyData = service.completeCheckOut(id);

      expect(historyData, isNotNull);
      expect(historyData!['mountainName'], 'Puncak Besar Malabar');
      expect(service.allHikings.length, initialCount - 1);
      expect(service.getHikingById(id), isNull);
    });
  });
}
