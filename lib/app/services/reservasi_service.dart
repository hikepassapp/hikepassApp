import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

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
    };
    try {
      await _client.from('reservasi').upsert(payload);
    } catch (_) {}
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
      await _client.from('payment').upsert(payload);
    } catch (_) {}
  }
}
