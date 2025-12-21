class ReservasiModel {
  final String id;
  final String code; // Kode Reservasi, e.g. RSV-001
  final String mountainName;
  final String hikingTrail;
  final DateTime startDate;
  final String hikerName;
  final String hikerNik;

  const ReservasiModel({
    required this.id,
    required this.code,
    required this.mountainName,
    required this.hikingTrail,
    required this.startDate,
    required this.hikerName,
    required this.hikerNik,
  });

  factory ReservasiModel.placeholder() => ReservasiModel(
        id: 'reservasi-001',
        code: 'RSV-001',
        mountainName: 'Gunung Malabar',
        hikingTrail: 'Jalur Ciniriyuan',
        startDate: DateTime(2025, 12, 21),
        hikerName: 'John Doe',
        hikerNik: '1111111111111111',
      );
}
