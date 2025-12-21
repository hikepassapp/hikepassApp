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
