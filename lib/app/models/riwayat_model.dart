import 'payment_model.dart';
import 'reservasi_model.dart';

enum HikingHistoryStatus { waiting, hiking, finished }

class RiwayatModel {
  final String id;
  final ReservasiModel reservasi;
  final PaymentModel? payment;
  final HikingHistoryStatus hikingStatus;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;

  const RiwayatModel({
    required this.id,
    required this.reservasi,
    required this.hikingStatus,
    this.payment,
    this.checkInDate,
    this.checkOutDate,
  });

  RiwayatModel copyWith({
    ReservasiModel? reservasi,
    PaymentModel? payment,
    HikingHistoryStatus? hikingStatus,
    DateTime? checkInDate,
    DateTime? checkOutDate,
  }) => RiwayatModel(
        id: id,
        reservasi: reservasi ?? this.reservasi,
        payment: payment ?? this.payment,
        hikingStatus: hikingStatus ?? this.hikingStatus,
        checkInDate: checkInDate ?? this.checkInDate,
        checkOutDate: checkOutDate ?? this.checkOutDate,
      );
}
