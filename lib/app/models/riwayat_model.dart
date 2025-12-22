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
  final String? userId;

  const RiwayatModel({
    required this.id,
    required this.reservasi,
    required this.hikingStatus,
    this.payment,
    this.checkInDate,
    this.checkOutDate,
    this.userId,
  });

  /// Convert RiwayatModel to Supabase JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'reservasi_id': reservasi.id,
    'reservasi_code': reservasi.code,
    'mountain_name': reservasi.mountainName,
    'hiking_trail': reservasi.hikingTrail,
    'start_date': reservasi.startDate.toIso8601String(),
    'check_in_date': checkInDate?.toIso8601String(),
    'check_out_date': checkOutDate?.toIso8601String(),
    'hiking_status': hikingStatus.name,
    'hikers': reservasi.hikers.map((h) => h.toJson()).toList(),
    'ticket_price': reservasi.ticketPrice,
    'ticket_count': reservasi.hikers.length,
    if (payment != null) ...{
      'payment_code': payment!.code,
      'payment_total': payment!.total,
      'payment_date': payment!.date.toIso8601String(),
      'payment_status': payment!.status.name,
    },
    if (userId != null) 'user_id': userId,
  };

  /// Create RiwayatModel from Supabase JSON
  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    final hikers = (json['hikers'] as List?)
        ?.map((h) => h is HikerInfo ? h : HikerInfo.fromJson(h as Map<String, dynamic>))
        .toList() ?? [];

    final reservasi = ReservasiModel(
      id: json['reservasi_id'] as String? ?? '',
      code: json['reservasi_code'] as String? ?? '-',
      mountainName: json['mountain_name'] as String? ?? '-',
      hikingTrail: json['hiking_trail'] as String? ?? '-',
      startDate: DateTime.tryParse(json['start_date'] as String? ?? '') ?? DateTime.now(),
      hikers: hikers,
      ticketPrice: json['ticket_price'] as int? ?? 15000,
    );

    PaymentModel? payment;
    if (json['payment_code'] != null) {
      payment = PaymentModel(
        id: json['id'] as String? ?? '',
        code: json['payment_code'] as String? ?? '',
        total: json['payment_total'] as int? ?? 0,
        date: DateTime.tryParse(json['payment_date'] as String? ?? '') ?? DateTime.now(),
        status: (json['payment_status'] as String?) == 'paid'
            ? PaymentStatus.paid
            : PaymentStatus.waiting,
      );
    }

    return RiwayatModel(
      id: json['id'] as String? ?? '',
      reservasi: reservasi,
      payment: payment,
      hikingStatus: _parseHikingHistoryStatus(json['hiking_status'] as String?),
      checkInDate: json['check_in_date'] != null
          ? DateTime.tryParse(json['check_in_date'] as String)
          : null,
      checkOutDate: json['check_out_date'] != null
          ? DateTime.tryParse(json['check_out_date'] as String)
          : null,
      userId: json['user_id'] as String?,
    );
  }

  /// Parse HikingHistoryStatus from string
  static HikingHistoryStatus _parseHikingHistoryStatus(String? status) {
    switch (status) {
      case 'hiking':
        return HikingHistoryStatus.hiking;
      case 'finished':
        return HikingHistoryStatus.finished;
      default:
        return HikingHistoryStatus.waiting;
    }
  }

  RiwayatModel copyWith({
    String? id,
    ReservasiModel? reservasi,
    PaymentModel? payment,
    HikingHistoryStatus? hikingStatus,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    String? userId,
  }) => RiwayatModel(
        id: id ?? this.id,
        reservasi: reservasi ?? this.reservasi,
        payment: payment ?? this.payment,
        hikingStatus: hikingStatus ?? this.hikingStatus,
        checkInDate: checkInDate ?? this.checkInDate,
        checkOutDate: checkOutDate ?? this.checkOutDate,
        userId: userId ?? this.userId,
      );
}
