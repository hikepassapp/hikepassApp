import 'package:get/get.dart';
import '../models/hiking_model.dart';

class HikingService extends GetxService {

  final RxList<HikingModel> _hikingList = <HikingModel>[].obs;

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

  void _loadMockData() {
    _hikingList.add(
      HikingModel(
        id: 'hiking-001',
        reservasiId: 'reservasi-001',
        paymentId: 'payment-001',
        mountainName: 'Gunung Malabar',
        hikingTrail: 'Jalur Panorama',
        startDate: DateTime(2025, 12, 21),
        endDate: DateTime(2025, 12, 23),
        status: HikingStatus.pending,
      ),
    );
  }

  HikingModel createFromReservation({
    required String reservasiId,
    String? paymentId,
    required String mountainName,
    required String hikingTrail,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final hiking = HikingModel(
      id: 'hiking-${DateTime.now().millisecondsSinceEpoch}',
      reservasiId: reservasiId,
      paymentId: paymentId,
      mountainName: mountainName,
      hikingTrail: hikingTrail,
      startDate: startDate,
      endDate: endDate,
      status: HikingStatus.pending,
    );

    _hikingList.add(hiking);
    return hiking;
  }

  HikingModel? getHikingById(String id) {
    try {
      return _hikingList.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  void processInitialCheckIn(String hikingId) {
    final index = _hikingList.indexWhere((h) => h.id == hikingId);
    if (index != -1) {
      _hikingList[index] = _hikingList[index].copyWith(
        checkInDate: DateTime.now(),
      );
    }
  }

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

  void processInitialCheckOut(String hikingId) {
    final index = _hikingList.indexWhere((h) => h.id == hikingId);
    if (index != -1) {
      _hikingList[index] = _hikingList[index].copyWith(
        checkOutDate: DateTime.now(),
      );
    }
  }

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
      'reservasiId': hiking.reservasiId,
      'paymentId': hiking.paymentId,
      'mountainName': hiking.mountainName,
      'hikingTrail': hiking.hikingTrail,
      'startDate': hiking.startDate.toIso8601String(),
      'endDate': hiking.endDate.toIso8601String(),
      'checkInDate': hiking.checkInDate!.toIso8601String(),
      'checkOutDate': hiking.checkOutDate!.toIso8601String(),
      'checkInItems': hiking.checkInItems ?? '',
      'checkOutItems': hiking.checkOutItems ?? '',
    };

    _hikingList.removeWhere((h) => h.id == hikingId);

    return historyData;
  }

  void clearAll() {
    _hikingList.clear();
  }
}
