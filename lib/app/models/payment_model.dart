enum PaymentStatus { waiting, paid }

class PaymentModel {
  final String id;
  final String code; // Payment code
  final int total; // Total payment in IDR (ticket price × total tickets)
  final DateTime date;
  final PaymentStatus status;

  const PaymentModel({
    required this.id,
    required this.code,
    required this.total,
    required this.date,
    required this.status,
  });

  /// Convert PaymentModel to Supabase JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'total': total,
    'date': date.toIso8601String(),
    'status': status.name,
  };

  /// Create PaymentModel from Supabase JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    id: json['id'] as String? ?? '',
    code: json['code'] as String? ?? '',
    total: json['total'] as int? ?? 0,
    date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    status: (json['status'] as String?) == 'paid' 
        ? PaymentStatus.paid 
        : PaymentStatus.waiting,
  );

  /// Create a copy of PaymentModel with modified fields
  PaymentModel copyWith({
    String? id,
    String? code,
    int? total,
    DateTime? date,
    PaymentStatus? status,
  }) => PaymentModel(
    id: id ?? this.id,
    code: code ?? this.code,
    total: total ?? this.total,
    date: date ?? this.date,
    status: status ?? this.status,
  );

  factory PaymentModel.placeholderPaid() => PaymentModel(
        id: 'payment-001',
        code: 'PAY-001',
        total: 15000,
        date: DateTime(2025, 12, 20, 17, 0),
        status: PaymentStatus.paid,
      );

  factory PaymentModel.placeholderWaiting() => PaymentModel(
        id: 'payment-002',
        code: 'PAY-002',
        total: 30000,
        date: DateTime.now(),
        status: PaymentStatus.waiting,
      );
}
