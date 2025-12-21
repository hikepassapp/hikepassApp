class HikerInfo {
  final String name;
  final String nik;

  const HikerInfo({required this.name, required this.nik});
}

class ReservasiModel {
  final String id;
  final String code; // Kode Reservasi, e.g. RSV-001
  final String mountainName;
  final String hikingTrail;
  final DateTime startDate;
  final List<HikerInfo> hikers; // Support multiple hikers
  final int ticketPrice; // Price per ticket in IDR

  const ReservasiModel({
    required this.id,
    required this.code,
    required this.mountainName,
    required this.hikingTrail,
    required this.startDate,
    required this.hikers,
    this.ticketPrice = 15000,
  });

  // Convenience getter for single hiker (legacy)
  String get hikerName => hikers.isNotEmpty ? hikers.first.name : '-';
  String get hikerNik => hikers.isNotEmpty ? hikers.first.nik : '-';

  // Total tickets is the number of hikers
  int get totalTickets => hikers.length;

  factory ReservasiModel.placeholder() => ReservasiModel(
        id: 'reservasi-001',
        code: 'RSV-001',
        mountainName: 'Gunung Malabar',
        hikingTrail: 'Jalur Ciniriyuan',
        startDate: DateTime(2025, 12, 21),
        hikers: [
          HikerInfo(name: 'John Doe', nik: '1111111111111111'),
        ],
        ticketPrice: 15000,
      );
}
