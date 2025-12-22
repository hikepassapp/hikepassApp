import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import 'riwayat_service.dart';

class ReservasiService extends GetxService {
  SupabaseClient get _client => SupabaseConfig.client;

  Future<void> upsertReservation(Map<String, dynamic> data) async {
    final payload = {
      'id': data['id'],
      'code': data['code'],
      'mountain_name': data['mountainName'],
      'hiking_trail': data['hikingTrail'],
      'start_date': (data['startDate'] is DateTime)
          ? (data['startDate'] as DateTime).toIso8601String()
          : data['startDate'],

      'ticket_price': data['ticketPrice'],
      'ticket_count': data['ticketCount'],

      'hikers': data['hikers'],
      if (data['userId'] != null) 'user_id': data['userId'],
      if (data['status'] != null) 'status': data['status'],
    };

    try {
      print('📤 Upserting reservation: ${data['code']}');
      await _client.from('reservasi').upsert(payload).select();
      print('✅ Reservation upserted successfully: ${data["id"]}');
    } catch (e) {
      print('❌ Error upserting reservation: $e');
      rethrow;
    }
  }

  Future<void> upsertPayment(Map<String, dynamic> data) async {
    final payload = {
      'id': data['paymentId'] ?? data['paymentCode'],
      'reservasi_id': data['reservasiId'],
      'code': data['paymentCode'],
      'total': data['totalPrice'],
      'date': (data['paymentDate'] is DateTime)
          ? (data['paymentDate'] as DateTime).toIso8601String()
          : data['paymentDate'],
      'status': 'paid',
    };

    try {
      print('📤 Upserting payment: ${data["paymentCode"]}');
      await _client.from('payment').upsert(payload).select();
      print('✅ Payment upserted successfully: ${payload["id"]}');

      try {
        print(
          '📝 Fetching reservasi row for history creation: ${data['reservasiId']}',
        );
        final reservasiRow = await _client
            .from('reservasi')
            .select('*')
            .eq('id', data['reservasiId'])
            .single();

        final riwayatService = Get.isRegistered<RiwayatService>()
            ? Get.find<RiwayatService>()
            : Get.put(RiwayatService(), permanent: true);

        final userId =
            data['userId'] ?? SupabaseConfig.client.auth.currentUser?.id;

        await riwayatService.addFromPaymentAndUpsert(
          reservasiRow: reservasiRow,
          paymentRow: payload,
          userId: userId,
        );
      } catch (e) {
        print('❌ ERROR creating history after payment: $e');
        rethrow;
      }
    } catch (e) {
      print('❌ Error upserting payment: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createReservation({
    required String code,
    required String mountainName,
    required String hikingTrail,
    required DateTime startDate,
    required List<dynamic> hikers,
    required int ticketPrice,
    String? userId,
    Map<String, dynamic>? payment,
  }) async {
    final reservationPayload = {
      'code': code,
      'mountain_name': mountainName,
      'hiking_trail': hikingTrail,
      'start_date': startDate.toIso8601String(),

      'ticket_price': ticketPrice,
      'ticket_count': hikers.length,

      'hikers': hikers,
      if (userId != null) 'user_id': userId,
      'status': 'active',
    };

    final inserted = await _client
        .from('reservasi')
        .insert(reservationPayload)
        .select()
        .single();

    if (payment != null) {
      final paymentPayload = {
        'reservasi_id': inserted['id'],
        'code': payment['code'],
        'total': payment['total'],
        'date': (payment['date'] as DateTime).toIso8601String(),
        'status': payment['status'] ?? 'paid',
      };

      await _client.from('payment').insert(paymentPayload).select().single();
    }

    return inserted;
  }

  Future<List<Map<String, dynamic>>> fetchReservationsByUser(
    String userId,
  ) async {
    try {
      final rows = await _client
          .from('reservasi')
          .select('*')
          .eq('user_id', userId)
          .order('start_date', ascending: false);
      return (rows as List).cast<Map<String, dynamic>>();
    } catch (e) {
      final rows = await _client
          .from('reservasi')
          .select('*')
          .order('start_date', ascending: false);
      return (rows as List).cast<Map<String, dynamic>>();
    }
  }

  Future<void> cancelReservation(String reservasiId) async {
    try {
      await _client
          .from('reservasi')
          .update({'status': 'canceled'})
          .eq('id', reservasiId)
          .select();
    } catch (_) {
      await _client.from('reservasi').delete().eq('id', reservasiId);
    }
  }

  /// Fetch a single reservation by ID
  Future<Map<String, dynamic>?> fetchReservationById(String reservasiId) async {
    try {
      final response = await _client
          .from('reservasi')
          .select('*')
          .eq('id', reservasiId)
          .single();
      return response;
    } catch (e) {
      print('❌ Error fetching reservation: $e');
      return null;
    }
  }

  /// Fetch payment for a reservation
  Future<Map<String, dynamic>?> fetchPaymentByReservasiId(
    String reservasiId,
  ) async {
    try {
      final response = await _client
          .from('payment')
          .select('*')
          .eq('reservasi_id', reservasiId)
          .single();
      return response;
    } catch (e) {
      print('⚠️ No payment found for reservation: $e');
      return null;
    }
  }

  /// Update reservation status
  Future<void> updateReservationStatus(
    String reservasiId,
    String status,
  ) async {
    try {
      await _client
          .from('reservasi')
          .update({'status': status})
          .eq('id', reservasiId);
      print('✅ Reservation status updated to: $status');
    } catch (e) {
      print('❌ Error updating reservation status: $e');
      rethrow;
    }
  }

  /// Subscribe to changes for a specific reservation
  RealtimeChannel subscribeReservation(
    String reservasiId,
    void Function() onChange,
  ) {
    final channel = _client
        .channel('reservasi-$reservasiId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'reservasi',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: reservasiId,
          ),
          callback: (_) => onChange(),
        )
        .subscribe();
    return channel;
  }

  /// Get reservations count for a user
  Future<int> getReservationCountByUser(String userId) async {
    try {
      final response = await _client
          .from('reservasi')
          .select('id')
          .eq('user_id', userId)
          .eq('status', 'active');
      return (response as List).length;
    } catch (e) {
      print('❌ Error getting reservation count: $e');
      return 0;
    }
  }
}
