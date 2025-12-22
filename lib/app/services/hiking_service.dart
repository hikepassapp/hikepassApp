import 'package:get/get.dart';
import '../models/hiking_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

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
    print('🏔️ HikingService initialized - Instance: $hashCode');
    // No mock data - start empty until reservations are made
  }

  HikingModel createFromReservation({
    required String reservasiId,
    String? paymentId,
    required String mountainName,
    required String hikingTrail,
    required DateTime startDate,
  }) {
    print('🎫 Creating hiking from reservation:');
    print('   - Mountain: $mountainName');
    print('   - Trail: $hikingTrail');
    print('   - Date: $startDate');
    print('   - Service Instance: $hashCode');
    
    final hiking = HikingModel(
      id: 'hiking-${DateTime.now().millisecondsSinceEpoch}',
      reservasiId: reservasiId,
      paymentId: paymentId,
      mountainName: mountainName,
      hikingTrail: hikingTrail,
      startDate: startDate,
      status: HikingStatus.pending,
    );

    _hikingList.add(hiking);
    _upsertHiking(hiking);
    print('✅ Hiking added. Total items: ${_hikingList.length}');
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
      _upsertHiking(_hikingList[index]);
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
      _upsertHiking(_hikingList[index]);
    }
  }

  void processInitialCheckOut(String hikingId) {
    final index = _hikingList.indexWhere((h) => h.id == hikingId);
    if (index != -1) {
      _hikingList[index] = _hikingList[index].copyWith(
        checkOutDate: DateTime.now(),
      );
      _upsertHiking(_hikingList[index]);
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
      _upsertHiking(_hikingList[index]);
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
      'checkInDate': hiking.checkInDate!.toIso8601String(),
      'checkOutDate': hiking.checkOutDate!.toIso8601String(),
      'checkInItems': hiking.checkInItems ?? '',
      'checkOutItems': hiking.checkOutItems ?? '',
    };

    _upsertHiking(hiking);
    _hikingList.removeWhere((h) => h.id == hikingId);

    return historyData;
  }

  void clearAll() {
    _hikingList.clear();
  }

  void _upsertHiking(HikingModel h) {
    final client = SupabaseConfig.client;
    final payload = {
      'id': h.id,
      'reservasi_id': h.reservasiId,
      'payment_id': h.paymentId,
      'mountain_name': h.mountainName,
      'hiking_trail': h.hikingTrail,
      'start_date': h.startDate.toIso8601String(),
      'check_in_date': h.checkInDate?.toIso8601String(),
      'check_out_date': h.checkOutDate?.toIso8601String(),
      'status': h.status.name,
      'check_in_items': h.checkInItems,
      'check_in_checkboxes': h.checkInCheckboxes,
      'check_out_items': h.checkOutItems,
      'check_out_checkboxes': h.checkOutCheckboxes,
    };
    try {
      client.from('hiking').upsert(payload);
    } catch (_) {}
  }
}
