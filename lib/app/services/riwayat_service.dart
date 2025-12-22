import 'package:get/get.dart';
import '../models/riwayat_model.dart';
import '../models/reservasi_model.dart';
import '../models/payment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../modules/reservasi/controllers/reservasi_controller.dart';

class RiwayatService extends GetxService {
  final RxList<RiwayatModel> _items = <RiwayatModel>[].obs;

  List<RiwayatModel> get all => _items;

  @override
  void onInit() {
    super.onInit();
  }

  RiwayatModel? getById(String id) {
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  void addFromHikingHistory(Map<String, dynamic> history) {
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
      _upsertRiwayat(_items[existingIndex]);
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
            name: history['hikerName'] ?? 'John Doe',
            nik: history['hikerNik'] ?? '1111111111111111',
          )]
        : hikersList.map((h) {
            if (h is HikerInfo) return h;
            return HikerInfo(
              name: h['name'] ?? '-',
              nik: h['nik'] ?? '-',
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
        date: DateTime.tryParse(history['paymentDate'] ?? '') ?? DateTime(2025, 12, 20, 17, 0),
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
    _upsertRiwayat(item);
  }

  void _upsertRiwayat(RiwayatModel r) {
    final client = SupabaseConfig.client;
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
      'payment_code': r.payment?.code,
      'payment_total': r.payment?.total,
      'payment_date': r.payment?.date?.toIso8601String(),
      'payment_status': r.payment?.status.name,
    };
    try {
      client.from('riwayat').upsert(payload);
    } catch (_) {}
  }
}
