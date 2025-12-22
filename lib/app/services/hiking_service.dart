import 'package:get/get.dart';
import '../models/hiking_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class HikingService extends GetxService {

  final RxList<HikingModel> _hikingList = <HikingModel>[].obs;

  String? get _userId => SupabaseConfig.client.auth.currentUser?.id;

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
    
    if (uid != null) {
      print('   ✅ Calling _upsertHiking with userId: $uid');
      await _upsertHiking(hiking, userId: uid);
    } else {
      print('   ⚠️ Skipping DB upsert for hiking because user_id is null');
    }
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
      if (userId != null) 'user_id': userId,
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
    return row as Map<String, dynamic>;
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
    return row as Map<String, dynamic>;
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
