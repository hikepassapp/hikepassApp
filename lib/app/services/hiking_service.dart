import 'package:get/get.dart';
import '../models/hiking_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/riwayat_model.dart';
import 'riwayat_service.dart';

class HikingService extends GetxService {

  final RxList<HikingModel> _hikingList = <HikingModel>[].obs;

  String? get _userId => SupabaseConfig.client.auth.currentUser?.id;

  // Return RxList so changes are properly observed
  RxList<HikingModel> get allHikings => _hikingList;

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

  /// Load hiking records from Supabase for the current user
  Future<void> loadFromSupabase({String? status}) async {
    final userId = _userId;
    if (userId == null) {
      print('⚠️ Cannot load hiking: user not logged in');
      return;
    }

    try {
      print('📥 Loading hiking records from Supabase for user: $userId');
      final rows = await fetchHikingByUser(userId, status: status);
      
      _hikingList.clear();
      
      for (var row in rows) {
        final hiking = HikingModel(
          id: row['id'],
          reservasiId: row['reservasi_id'] ?? '',
          paymentId: row['payment_id'],
          mountainName: row['mountain_name'] ?? '-',
          hikingTrail: row['hiking_trail'] ?? '-',
          startDate: DateTime.tryParse(row['start_date'] ?? '') ?? DateTime.now(),
          checkInDate: DateTime.tryParse(row['check_in_date'] ?? ''),
          checkOutDate: DateTime.tryParse(row['check_out_date'] ?? ''),
          status: _parseStatus(row['status']),
          checkInItems: row['check_in_items'],
          checkInCheckboxes: (row['check_in_checkboxes'] as List?)?.cast<bool>(),
          checkOutItems: row['check_out_items'],
          checkOutCheckboxes: (row['check_out_checkboxes'] as List?)?.cast<bool>(),
        );
        
        _hikingList.add(hiking);
      }

      print('✅ Loaded ${_hikingList.length} hiking records from Supabase');
    } catch (e) {
      print('❌ Error loading hiking from Supabase: $e');
    }
  }

  HikingStatus _parseStatus(String? status) {
    switch (status) {
      case 'checkedIn':
        return HikingStatus.checkedIn;
      case 'checkedOut':
        return HikingStatus.checkedOut;
      default:
        return HikingStatus.pending;
    }
  }

  Future<HikingModel> createFromReservation({
    required String reservasiId,
    String? paymentId,
    required String mountainName,
    required String hikingTrail,
    required DateTime startDate,
    String? userId,
  }) async {
    print('�️ === HikingService.createFromReservation START ===');
    print('   Mountain: $mountainName');
    print('   Trail: $hikingTrail');
    print('   Date: $startDate');
    print('   Passed userId: $userId');
    print('   _userId from auth: $_userId');
    
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
    final uid = userId ?? _userId;
    print('   Final uid to use: $uid');
    
    // ALWAYS upsert to database - even if uid is null, let the database handle it
    // This ensures the hiking record is persisted
    print('   ✅ Upserting hiking with userId: $uid');
    await _upsertHiking(hiking, userId: uid);
    print('🏔️ === HikingService.createFromReservation END ===');
    return hiking;
  }

  Future<List<Map<String, dynamic>>> fetchHikingByUser(String userId, {String? status}) async {
    final base = SupabaseConfig.client
        .from('hiking')
        .select('*')
        .eq('user_id', userId);

    final filtered = (status != null && status.isNotEmpty)
        ? base.eq('status', status)
        : base;

    final rows = await filtered.order('start_date', ascending: false);
    return (rows as List).cast<Map<String, dynamic>>();
  }

  HikingModel? getHikingById(String id) {
    try {
      return _hikingList.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> processInitialCheckIn(String hikingId) async {
    final index = _hikingList.indexWhere((h) => h.id == hikingId);
    if (index == -1) {
      print('❌ Hiking not found: $hikingId');
      return;
    }

    _hikingList[index] = _hikingList[index].copyWith(
      checkInDate: DateTime.now(),
    );
    await _upsertHiking(_hikingList[index]);
  }

  Future<void> processCheckInForm({
    required String hikingId,
    required String checkInItems,
    required List<bool> checkInCheckboxes,
  }) async {
    final index = _hikingList.indexWhere((h) => h.id == hikingId);
    if (index == -1) {
      print('❌ Hiking not found: $hikingId');
      return;
    }

    _hikingList[index] = _hikingList[index].copyWith(
      checkInItems: checkInItems,
      checkInCheckboxes: checkInCheckboxes,
      status: HikingStatus.checkedIn,
    );
    await _upsertHiking(_hikingList[index]);
    
    // Also update riwayat table with the new hiking status
    try {
      final riwayatService = Get.isRegistered<RiwayatService>()
          ? Get.find<RiwayatService>()
          : Get.put(RiwayatService(), permanent: true);
      final reservasiId = _hikingList[index].reservasiId;
      // Assuming riwayat.id matches reservasi_id
      await riwayatService.updateHikingStatus(
        reservasiId,
        HikingHistoryStatus.hiking,
      );
    } catch (e) {
      print('⚠️ Could not update riwayat status: $e');
    }
  }

  Future<void> processInitialCheckOut(String hikingId) async {
    final index = _hikingList.indexWhere((h) => h.id == hikingId);
    if (index == -1) {
      print('❌ Hiking not found: $hikingId');
      return;
    }

    _hikingList[index] = _hikingList[index].copyWith(
      checkOutDate: DateTime.now(),
    );
    await _upsertHiking(_hikingList[index]);
  }

  Future<void> processCheckOutForm({
    required String hikingId,
    required String checkOutItems,
    required List<bool> checkOutCheckboxes,
  }) async {
    final index = _hikingList.indexWhere((h) => h.id == hikingId);
    if (index == -1) {
      print('❌ Hiking not found: $hikingId');
      return;
    }

    _hikingList[index] = _hikingList[index].copyWith(
      checkOutItems: checkOutItems,
      checkOutCheckboxes: checkOutCheckboxes,
      status: HikingStatus.checkedOut,
    );
    await _upsertHiking(_hikingList[index]);
    
    // Also update riwayat table with the new hiking status
    try {
      final riwayatService = Get.isRegistered<RiwayatService>()
          ? Get.find<RiwayatService>()
          : Get.put(RiwayatService(), permanent: true);
      final reservasiId = _hikingList[index].reservasiId;
      await riwayatService.updateHikingStatus(
        reservasiId,
        HikingHistoryStatus.finished,
      );
    } catch (e) {
      print('⚠️ Could not update riwayat status for checkout: $e');
    }
  }

  Future<Map<String, dynamic>?> completeCheckOut(String hikingId) async {
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
      if (_userId != null) 'userId': _userId,
    };

    final uid = _userId;
    if (uid != null) {
      await _upsertHiking(hiking, userId: uid);
    } else {
      await _upsertHiking(hiking);
    }
    _hikingList.removeWhere((h) => h.id == hikingId);

    return historyData;
  }

  void clearAll() {
    _hikingList.clear();
  }

  Future<void> _upsertHiking(HikingModel h, {String? userId}) async {
    final client = SupabaseConfig.client;
    final uid = userId ?? _userId;  // Get user_id from parameter or auth
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
      if (uid != null) 'user_id': uid,  // Always include user_id if available
    };
    try {
      print('📤 Upserting hiking to DB with payload keys: ${payload.keys.toList()}');
      print('   user_id in payload: ${payload['user_id']}');
      final response = await client.from('hiking').upsert(payload).select();
      print('✅ Hiking upserted successfully: ${h.id}');
      print('   Response: $response');
    } catch (e) {
      print('❌ Error upserting hiking: $e');
      print('   Payload was: $payload');
    }
  }

  // Clean DB helpers
  Future<Map<String, dynamic>> dbCheckIn({
    required String reservasiId,
    required String userId,
    DateTime? at,
  }) async {
    final client = SupabaseConfig.client;
    final payload = {
      'reservasi_id': reservasiId,
      'user_id': userId,
      'status': 'checkedIn',
      'check_in_date': (at ?? DateTime.now()).toIso8601String(),
    };
    final row = await client.from('hiking').insert(payload).select().single();
    return row;
  }

  Future<Map<String, dynamic>> dbCheckOut({
    required String hikingId,
    required String userId,
    required String checkOutItems,
    required List<bool> checkOutCheckboxes,
    DateTime? at,
  }) async {
    final client = SupabaseConfig.client;
    final payload = {
      'status': 'checkedOut',
      'check_out_date': (at ?? DateTime.now()).toIso8601String(),
      'check_out_items': checkOutItems,
      'check_out_checkboxes': checkOutCheckboxes,
    };
    final row = await client
        .from('hiking')
        .update(payload)
        .eq('id', hikingId)
        .eq('user_id', userId)
        .select()
        .single();
    return row;
  }

  RealtimeChannel subscribeUserHiking(String userId, void Function() onChange) {
    final channel = SupabaseConfig.client
        .channel('hiking-user-$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'hiking',
          callback: (_) => onChange(),
        )
        .subscribe();
    return channel;
  }
}
