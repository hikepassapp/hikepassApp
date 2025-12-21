import 'package:get/get.dart';
import '../models/hiking_model.dart';

/// Service to manage hiking check-in and check-out operations
/// Handles business logic for hiking data management
class HikingService extends GetxService {
  // Observable list for hiking data
  final RxList<HikingModel> _hikingList = <HikingModel>[].obs;

  // Getters for accessing data
  List<HikingModel> get allHikings => _hikingList;

  List<HikingModel> get pendingCheckIns =>
      _hikingList.where((h) => h.status == HikingStatus.pending).toList();

  List<HikingModel> get checkedIns =>
      _hikingList.where((h) => h.status == HikingStatus.checkedIn).toList();

  List<HikingModel> get checkedOuts =>
      _hikingList.where((h) => h.status == HikingStatus.checkedOut).toList();

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  /// Load mock data for development and testing
  void _loadMockData() {
    _hikingList.add(
      HikingModel(
        id: 'hiking-001',
        reservasiId: 'reservasi-001',
        mountainName: 'Gunung Malabar',
        hikingTrail: 'Jalur Panorama',
        startDate: DateTime(2025, 12, 21),
        endDate: DateTime(2025, 12, 23),
        status: HikingStatus.pending,
      ),
    );
  }

  /// Create hiking data from reservation (placeholder for future integration)
  /// This will be connected to the reservation feature later
  HikingModel createFromReservation({
    required String reservasiId,
    required String mountainName,
    required String hikingTrail,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final hiking = HikingModel(
      id: 'hiking-${DateTime.now().millisecondsSinceEpoch}',
      reservasiId: reservasiId,
      mountainName: mountainName,
      hikingTrail: hikingTrail,
      startDate: startDate,
      endDate: endDate,
      status: HikingStatus.pending,
    );

    _hikingList.add(hiking);
    return hiking;
  }

  /// Get hiking by ID
  HikingModel? getHikingById(String id) {
    try {
      return _hikingList.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Process initial check-in (save timestamp)
  void processInitialCheckIn(String hikingId) {
    final index = _hikingList.indexWhere((h) => h.id == hikingId);
    if (index != -1) {
      _hikingList[index] = _hikingList[index].copyWith(
        checkInDate: DateTime.now(),
      );
    }
  }

  /// Process check-in form submission
  void processCheckInForm({
    required String hikingId,
    required String checkInItems,
    required List<bool> checkInCheckboxes,
  }) {
    final index = _hikingList.indexWhere((h) => h.id == hikingId);
    if (index != -1) {
      _hikingList[index] = _hikingList[index].copyWith(
        checkInItems: checkInItems,
        checkInCheckboxes: checkInCheckboxes,
        status: HikingStatus.checkedIn,
      );
    }
  }

  /// Process initial check-out (save timestamp)
  void processInitialCheckOut(String hikingId) {
    final index = _hikingList.indexWhere((h) => h.id == hikingId);
    if (index != -1) {
      _hikingList[index] = _hikingList[index].copyWith(
        checkOutDate: DateTime.now(),
      );
    }
  }

  /// Process check-out form submission
  void processCheckOutForm({
    required String hikingId,
    required String checkOutItems,
    required List<bool> checkOutCheckboxes,
  }) {
    final index = _hikingList.indexWhere((h) => h.id == hikingId);
    if (index != -1) {
      _hikingList[index] = _hikingList[index].copyWith(
        checkOutItems: checkOutItems,
        checkOutCheckboxes: checkOutCheckboxes,
        status: HikingStatus.checkedOut,
      );
    }
  }

  /// Complete check-out and prepare for history
  /// This will be integrated with the history feature later
  /// Returns a map containing all the necessary data for history
  Map<String, dynamic>? completeCheckOut(String hikingId) {
    final hiking = getHikingById(hikingId);
    if (hiking == null ||
        hiking.checkInDate == null ||
        hiking.checkOutDate == null) {
      return null;
    }

    final historyData = {
      'id': 'riwayat-${DateTime.now().millisecondsSinceEpoch}',
      'hikingId': hiking.id,
      'mountainName': hiking.mountainName,
      'hikingTrail': hiking.hikingTrail,
      'startDate': hiking.startDate.toIso8601String(),
      'endDate': hiking.endDate.toIso8601String(),
      'checkInDate': hiking.checkInDate!.toIso8601String(),
      'checkOutDate': hiking.checkOutDate!.toIso8601String(),
      'checkInItems': hiking.checkInItems ?? '',
      'checkOutItems': hiking.checkOutItems ?? '',
    };

    // Remove from hiking list after completing check-out
    _hikingList.removeWhere((h) => h.id == hikingId);

    return historyData;
  }

  /// Clear all data (for testing purposes)
  void clearAll() {
    _hikingList.clear();
  }
}
