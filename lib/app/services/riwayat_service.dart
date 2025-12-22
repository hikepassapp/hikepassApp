import 'package:get/get.dart';
import '../models/riwayat_model.dart';
import '../models/reservasi_model.dart';
import '../models/payment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../modules/reservasi/controllers/reservasi_controller.dart';

class RiwayatService extends GetxService {
  final RxList<RiwayatModel> _items = <RiwayatModel>[].obs;

  String? get _userId => SupabaseConfig.client.auth.currentUser?.id;

  List<RiwayatModel> get all => _items;

  @override
  void onInit() {
    super.onInit();
    print('📜 RiwayatService initialized');
  }

  /// Load history from Supabase for the current user
  Future<void> loadFromSupabase() async {
    final userId = _userId;
    if (userId == null) {
      print('⚠️ Cannot load history: user not logged in');
      return;
    }

    try {
      print('📥 Loading history from Supabase for user: $userId');
      final rows = await fetchHistoryByUser(userId);
      
      _items.clear();
      
      for (var row in rows) {
        final hikers = (row['hikers'] as List?)
            ?.map((h) => HikerInfo(
                  name: h['name'] ?? '-',
                  nik: h['nik'] ?? '-',
                ))
            .toList() ?? [];

        final reservasi = ReservasiModel(
          id: row['reservasi_id'] ?? 'unknown',
          code: row['reservasi_code'] ?? '-',
          mountainName: row['mountain_name'] ?? '-',
          hikingTrail: row['hiking_trail'] ?? '-',
          startDate: DateTime.tryParse(row['start_date'] ?? '') ?? DateTime.now(),
          hikers: hikers,
          ticketPrice: row['ticket_price'] ?? 15000,
        );

        PaymentModel? payment;
        if (row['payment_code'] != null) {
          payment = PaymentModel(
            id: row['reservasi_id'] ?? 'payment-unknown',
            code: row['payment_code'],
            total: row['payment_total'] ?? 0,
            date: DateTime.tryParse(row['payment_date'] ?? '') ?? DateTime.now(),
            status: row['payment_status'] == 'paid' 
                ? PaymentStatus.paid 
                : PaymentStatus.waiting,
          );
        }

        final item = RiwayatModel(
          id: row['id'],
          reservasi: reservasi,
          payment: payment,
          hikingStatus: row['hiking_status'] == 'finished'
              ? HikingHistoryStatus.finished
              : HikingHistoryStatus.waiting,
          checkInDate: DateTime.tryParse(row['check_in_date'] ?? ''),
          checkOutDate: DateTime.tryParse(row['check_out_date'] ?? ''),
        );

        _items.add(item);
      }

      print('✅ Loaded ${_items.length} history items from Supabase');
    } catch (e) {
      print('❌ Error loading history from Supabase: $e');
    }
  }

  /// Create a history item immediately after payment and upsert to Supabase
  /// This shows a card in History with status `waiting` (not yet hiking).
  Future<void> addFromPaymentAndUpsert({
    required Map<String, dynamic> reservasiRow,
    required Map<String, dynamic> paymentRow,
    String? userId,
  }) async {
    try {
      final hikers = (reservasiRow['hikers'] as List?)
              ?.map((h) => HikerInfo(
                    name: h['name'] ?? '-',
                    nik: h['nik'] ?? '-',
                  ))
              .toList() ??
          [];

      final reservasi = ReservasiModel(
        id: (reservasiRow['id'] ?? '').toString(),
        code: (reservasiRow['code'] ?? '-') as String,
        mountainName: reservasiRow['mountain_name'] ?? '-',
        hikingTrail: reservasiRow['hiking_trail'] ?? '-',
        startDate:
            DateTime.tryParse(reservasiRow['start_date'] ?? '') ?? DateTime.now(),
        hikers: hikers,
        ticketPrice: (reservasiRow['ticket_price'] ?? 15000) as int,
      );

      final payment = PaymentModel(
        id: (paymentRow['id'] ?? 'payment-unknown').toString(),
        code: (paymentRow['code'] ?? '-') as String,
        total: (paymentRow['total'] ?? 0) as int,
        date: DateTime.tryParse(paymentRow['date'] ?? '') ?? DateTime.now(),
        status: PaymentStatus.paid,
      );

      final item = RiwayatModel(
        id: 'riwayat-${DateTime.now().millisecondsSinceEpoch}',
        reservasi: reservasi,
        payment: payment,
        hikingStatus: HikingHistoryStatus.waiting,
        checkInDate: null,
        checkOutDate: null,
      );

      _items.insert(0, item);
      final uid = userId ?? _userId;
      print('📝 History item created: ${item.id}');
      print('   reservasi_id: ${reservasi.id}');
      print('   user_id to save: $uid');
      if (uid != null) {
        print('   Upserting with user_id: $uid');
        await _upsertRiwayat(item, userId: uid);
      } else {
        print('   ⚠️ Upserting WITHOUT user_id (might not load later!)');
        await _upsertRiwayat(item);
      }

      print('✅ Created history from payment for reservasi: ${reservasi.id}');
    } catch (e) {
      print('❌ Error creating history from payment: $e');
    }
  }

  RiwayatModel? getById(String id) {
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addFromHikingHistory(Map<String, dynamic> history, {String? userId}) async {
    final reservasiId = history['reservasiId'] ?? '';
    final existingIndex = _items.indexWhere((item) => item.reservasi.id == reservasiId);
    
    if (existingIndex != -1) {
      final existing = _items[existingIndex];
      final checkInDate = DateTime.tryParse(history['checkInDate'] ?? '') ?? existing.checkInDate;
      final checkOutDate = DateTime.tryParse(history['checkOutDate'] ?? '') ?? existing.checkOutDate;

      final updatedReservasi = ReservasiModel(
        id: reservasiId.toString(),
        code: (history['reservasiCode'] ?? existing.reservasi.code),
        mountainName: history['mountainName'] ?? existing.reservasi.mountainName,
        hikingTrail: history['hikingTrail'] ?? existing.reservasi.hikingTrail,
        startDate: DateTime.tryParse(history['startDate'] ?? '') ?? existing.reservasi.startDate,
        hikers: existing.reservasi.hikers,
        ticketPrice: history['ticketPrice'] ?? existing.reservasi.ticketPrice,
      );

      _items[existingIndex] = RiwayatModel(
        id: existing.id,
        reservasi: updatedReservasi,
        payment: existing.payment,
        hikingStatus: HikingHistoryStatus.finished,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
      );
      final uid = userId ?? _userId;
      if (uid != null) {
        await _upsertRiwayat(_items[existingIndex], userId: uid, history: history);
      } else {
        await _upsertRiwayat(_items[existingIndex], history: history);
      }
      return;
    }

    List<dynamic> hikersList = history['hikers'] ?? [];
    if (hikersList.isEmpty && Get.isRegistered<ReservasiController>()) {
      final reservasiC = Get.find<ReservasiController>();
      try {
        final match = reservasiC.riwayat.firstWhere(
          (item) => (item['id'] ?? '') == reservasiId,
          orElse: () => {},
        );
        if (match.isNotEmpty && match['hikers'] != null) {
          hikersList = match['hikers'] as List<dynamic>;
        }
      } catch (_) {
      }
    }
    final hikers = hikersList.isEmpty
        ? [HikerInfo(
            name: history['hikerName'],
            nik: history['hikerNik'],
          )]
        : hikersList.map((h) {
            if (h is HikerInfo) return h;
            return HikerInfo(
              name: h['name'],
              nik: h['nik'],
            );
          }).toList();

    final reservasi = ReservasiModel(
      id: history['reservasiId'] ?? 'reservasi-unknown',
      code: (history['reservasiCode'] ?? '-') as String,
      mountainName: history['mountainName'] ?? '-',
      hikingTrail: history['hikingTrail'] ?? '-',
      startDate: DateTime.tryParse(history['startDate'] ?? '') ?? DateTime.now(),
      hikers: hikers,
      ticketPrice: (history['ticketPrice'] ?? 15000) as int,
    );

    PaymentModel? payment;
    if ((history['paymentId'] ?? '').toString().isNotEmpty ||
        (history['paymentCode'] ?? '').toString().isNotEmpty) {
      final totalTickets = hikers.length;
      final ticketPrice = (history['ticketPrice'] ?? 15000) as int;
      final totalPayment = ticketPrice * totalTickets;

      payment = PaymentModel(
        id: history['paymentId'] ?? 'payment-unknown',
        code: (history['paymentCode'] ?? '-') as String,
        total: totalPayment,
        date: DateTime.tryParse(history['paymentDate'] ?? '') ?? DateTime.now(),
        status: PaymentStatus.paid,
      );
    } else {
      payment = null;
    }

    final item = RiwayatModel(
      id: history['id'] ?? 'riwayat-${DateTime.now().millisecondsSinceEpoch}',
      reservasi: reservasi,
      payment: payment,
      hikingStatus: HikingHistoryStatus.finished,
      checkInDate: DateTime.tryParse(history['checkInDate'] ?? ''),
      checkOutDate: DateTime.tryParse(history['checkOutDate'] ?? ''),
    );

    _items.insert(0, item);
    final uid = userId ?? _userId;
    if (uid != null) {
      await _upsertRiwayat(item, userId: uid, history: history);
    } else {
      await _upsertRiwayat(item, history: history);
    }
  }

  Future<void> _upsertRiwayat(RiwayatModel r, {String? userId, Map<String, dynamic>? history}) async {
    final client = SupabaseConfig.client;
    final ticketCount = (history?['ticketCount'] as int?) ?? r.reservasi.hikers.length;
    
    final payload = {
      'id': r.id,
      'reservasi_id': r.reservasi.id,
      'reservasi_code': r.reservasi.code,
      'mountain_name': r.reservasi.mountainName,
      'hiking_trail': r.reservasi.hikingTrail,
      'start_date': r.reservasi.startDate.toIso8601String(),
      'check_in_date': r.checkInDate?.toIso8601String(),
      'check_out_date': r.checkOutDate?.toIso8601String(),
      'hiking_status': r.hikingStatus.name,
      'hikers': r.reservasi.hikers
          .map((h) => {'name': h.name, 'nik': h.nik})
          .toList(),
      'ticket_price': r.reservasi.ticketPrice,
      'ticket_count': ticketCount,
      // Don't send total_price - it's a generated column
      'payment_code': r.payment?.code,
      'payment_total': r.payment?.total,
      'payment_date': r.payment?.date?.toIso8601String(),
      'payment_status': r.payment?.status.name,
      if (userId != null) 'user_id': userId,
    };
    try {
      print('📤 Upserting riwayat to DB with payload keys: ${payload.keys.toList()}');
      print('   user_id in payload: ${payload['user_id']}');
      print('   ticket_count: ${payload['ticket_count']}');
      final response = await client.from('riwayat').upsert(payload).select();
      print('✅ Riwayat upserted successfully: ${r.id}');
      print('   Response: $response');
    } catch (e) {
      print('❌ Error upserting riwayat: $e');
      print('   Payload was: $payload');
    }
  }

  /// Update hiking status in riwayat after check-in/check-out
  Future<void> updateHikingStatus(String riwayatId, HikingHistoryStatus status) async {
    try {
      print('📤 Updating riwayat $riwayatId with hiking_status: ${status.name}');
      await SupabaseConfig.client
          .from('riwayat')
          .update({'hiking_status': status.name})
          .eq('id', riwayatId);
      print('✅ Riwayat status updated: $riwayatId');
      
      // Update local cache
      final index = _items.indexWhere((item) => item.id == riwayatId);
      if (index != -1) {
        _items[index] = _items[index].copyWith(hikingStatus: status);
      }
    } catch (e) {
      print('❌ Error updating riwayat status: $e');
    }
  }

  // Fetch history rows for a user (fallback to all if RLS not set)
  Future<List<Map<String, dynamic>>> fetchHistoryByUser(String userId) async {
    try {
      final rows = await SupabaseConfig.client
          .from('riwayat')
          .select('*')
          .eq('user_id', userId)
          .order('start_date', ascending: false);
      return (rows as List).cast<Map<String, dynamic>>();
    } catch (e) {
      final rows = await SupabaseConfig.client
          .from('riwayat')
          .select('*')
          .order('start_date', ascending: false);
      return (rows as List).cast<Map<String, dynamic>>();
    }
  }

  // Subscribe to changes for a user's history to refresh UI
  RealtimeChannel subscribeUserHistory(String userId, void Function() onChange) {
    final channel = SupabaseConfig.client
        .channel('riwayat-user-$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'riwayat',
          callback: (_) => onChange(),
        )
        .subscribe();
    return channel;
  }
}

