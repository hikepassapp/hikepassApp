import 'package:get/get.dart';
import '../models/riwayat_model.dart';
import '../models/reservasi_model.dart';
import '../models/payment_model.dart';

class RiwayatService extends GetxService {
  final RxList<RiwayatModel> _items = <RiwayatModel>[].obs;

  List<RiwayatModel> get all => _items;


  RiwayatModel? getById(String id) {
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  void addFromHikingHistory(Map<String, dynamic> history) {
    // Parse hikers list - can have multiple hikers from the reservation
    final List<dynamic> hikersList = history['hikers'] ?? [];
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
      payment = null; // payment data not available yet
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
  }
}
