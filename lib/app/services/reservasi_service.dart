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
        print('✅ Fetched reservasi row: ${reservasiRow['id']}');

        final riwayatService = Get.isRegistered<RiwayatService>()
            ? Get.find<RiwayatService>()
            : Get.put(RiwayatService(), permanent: true);

        final userId =
            data['userId'] ?? SupabaseConfig.client.auth.currentUser?.id;
        print(
          '📝 Creating history entry with userId: $userId for reservasi: ${data['reservasiId']}',
        );
        await riwayatService.addFromPaymentAndUpsert(
          reservasiRow: reservasiRow,
          paymentRow: payload,
          userId: userId,
        );
        print('✅ History entry created successfully');
      } catch (e) {
        print('❌ ERROR creating immediate history after payment: $e');
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
      'hikers': hikers,
      'ticket_price': ticketPrice,
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
}
