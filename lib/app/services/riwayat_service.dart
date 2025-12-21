import 'package:get/get.dart';
import '../models/riwayat_model.dart';
import '../models/reservasi_model.dart';
import '../models/payment_model.dart';

class RiwayatService extends GetxService {
  final RxList<RiwayatModel> _items = <RiwayatModel>[].obs;

  List<RiwayatModel> get all => _items;

  @override
  void onInit() {
    super.onInit();
    // Seed with one placeholder to match reference UI
    _items.add(RiwayatModel.placeholder());
  }

  RiwayatModel? getById(String id) {
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  void addFromHikingHistory(Map<String, dynamic> history) {
    final reservasi = ReservasiModel(
      id: history['reservasiId'] ?? 'reservasi-unknown',
      code: (history['reservasiCode'] ?? '-') as String,
      mountainName: history['mountainName'] ?? '-',
      hikingTrail: history['hikingTrail'] ?? '-',
      startDate: DateTime.tryParse(history['startDate'] ?? '') ?? DateTime.now(),
      hikerName: history['hikerName'] ?? 'John Doe',
      hikerNik: history['hikerNik'] ?? '1111111111111111',
    );

    PaymentModel? payment;
    if ((history['paymentId'] ?? '').toString().isNotEmpty ||
        (history['paymentCode'] ?? '').toString().isNotEmpty) {
      payment = PaymentModel(
        id: history['paymentId'] ?? 'payment-unknown',
        code: (history['paymentCode'] ?? '-') as String,
        total: (history['total'] ?? 15000) as int,
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
