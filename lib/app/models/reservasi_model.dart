class HikerInfo {
  final String name;
  final String nik;

  const HikerInfo({required this.name, required this.nik});

  /// Convert HikerInfo to JSON for Supabase
  Map<String, dynamic> toJson() => {
    'name': name,
    'nik': nik,
  };

  /// Create HikerInfo from JSON
  factory HikerInfo.fromJson(Map<String, dynamic> json) => HikerInfo(
    name: json['name'] as String? ?? '-',
    nik: json['nik'] as String? ?? '-',
  );
}

class ReservasiModel {
  final String id;
  final String code;
  final String mountainName;
  final String hikingTrail;
  final DateTime startDate;
  final List<HikerInfo> hikers;
  final int ticketPrice;
  final String? status;
  final String? userId;

  const ReservasiModel({
    required this.id,
    required this.code,
    required this.mountainName,
    required this.hikingTrail,
    required this.startDate,
    required this.hikers,
    this.ticketPrice = 15000,
    this.status,
    this.userId,
  });

  String get hikerName => hikers.isNotEmpty ? hikers.first.name : '-';
  String get hikerNik => hikers.isNotEmpty ? hikers.first.nik : '-';

  int get totalTickets => hikers.length;

  /// Convert ReservasiModel to JSON for Supabase
  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'mountain_name': mountainName,
    'hiking_trail': hikingTrail,
    'start_date': startDate.toIso8601String(),
    'hikers': hikers.map((h) => h.toJson()).toList(),
    'ticket_price': ticketPrice,
    'ticket_count': hikers.length,
    if (status != null) 'status': status,
    if (userId != null) 'user_id': userId,
  };

  /// Create ReservasiModel from JSON
  factory ReservasiModel.fromJson(Map<String, dynamic> json) {
    final hikersList = (json['hikers'] as List?)
        ?.map((h) => h is HikerInfo ? h : HikerInfo.fromJson(h as Map<String, dynamic>))
        .toList() ?? [];
    
    return ReservasiModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      mountainName: json['mountain_name'] as String? ?? '-',
      hikingTrail: json['hiking_trail'] as String? ?? '-',
      startDate: DateTime.tryParse(json['start_date'] as String? ?? '') ?? DateTime.now(),
      hikers: hikersList,
      ticketPrice: json['ticket_price'] as int? ?? 15000,
      status: json['status'] as String?,
      userId: json['user_id'] as String?,
    );
  }

  /// Create a copy of ReservasiModel with modified fields
  ReservasiModel copyWith({
    String? id,
    String? code,
    String? mountainName,
    String? hikingTrail,
    DateTime? startDate,
    List<HikerInfo>? hikers,
    int? ticketPrice,
    String? status,
    String? userId,
  }) => ReservasiModel(
    id: id ?? this.id,
    code: code ?? this.code,
    mountainName: mountainName ?? this.mountainName,
    hikingTrail: hikingTrail ?? this.hikingTrail,
    startDate: startDate ?? this.startDate,
    hikers: hikers ?? this.hikers,
    ticketPrice: ticketPrice ?? this.ticketPrice,
    status: status ?? this.status,
    userId: userId ?? this.userId,
  );
}
