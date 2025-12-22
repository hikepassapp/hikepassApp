class HikerInfo {
  final String name;
  final String nik;

  const HikerInfo({required this.name, required this.nik});
}

class ReservasiModel {
  final String id;
  final String code;
  final String mountainName;
  final String hikingTrail;
  final DateTime startDate;
  final List<HikerInfo> hikers;
  final int ticketPrice;

  const ReservasiModel({
    required this.id,
    required this.code,
    required this.mountainName,
    required this.hikingTrail,
    required this.startDate,
    required this.hikers,
    this.ticketPrice = 15000,
  });

  String get hikerName => hikers.isNotEmpty ? hikers.first.name : '-';
  String get hikerNik => hikers.isNotEmpty ? hikers.first.nik : '-';

  int get totalTickets => hikers.length;
}
