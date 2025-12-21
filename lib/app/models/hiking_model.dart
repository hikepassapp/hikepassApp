class HikingModel {
  final String id;
  final String reservasiId;
  final String? paymentId;
  final String mountainName;
  final String hikingTrail;
  final DateTime startDate;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String? checkInItems;
  final List<bool>? checkInCheckboxes;
  final String? checkOutItems;
  final List<bool>? checkOutCheckboxes;
  final HikingStatus status;

  HikingModel({
    required this.id,
    required this.reservasiId,
    this.paymentId,
    required this.mountainName,
    required this.hikingTrail,
    required this.startDate,
    this.checkInDate,
    this.checkOutDate,
    this.checkInItems,
    this.checkInCheckboxes,
    this.checkOutItems,
    this.checkOutCheckboxes,
    this.status = HikingStatus.pending,
  });

  factory HikingModel.fromJson(Map<String, dynamic> json) {
    return HikingModel(
      id: json['id'] as String,
      reservasiId: json['reservasiId'] as String,
      paymentId: json['paymentId'] as String?,
      mountainName: json['mountainName'] as String,
      hikingTrail: json['hikingTrail'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      checkInDate: json['checkInDate'] != null
          ? DateTime.parse(json['checkInDate'] as String)
          : null,
      checkOutDate: json['checkOutDate'] != null
          ? DateTime.parse(json['checkOutDate'] as String)
          : null,
      checkInItems: json['checkInItems'] as String?,
      checkInCheckboxes: json['checkInCheckboxes'] != null
          ? List<bool>.from(json['checkInCheckboxes'] as List)
          : null,
      checkOutItems: json['checkOutItems'] as String?,
      checkOutCheckboxes: json['checkOutCheckboxes'] != null
          ? List<bool>.from(json['checkOutCheckboxes'] as List)
          : null,
      status: HikingStatus.values.firstWhere(
        (e) => e.toString() == 'HikingStatus.${json['status']}',
        orElse: () => HikingStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reservasiId': reservasiId,
      'paymentId': paymentId,
      'mountainName': mountainName,
      'hikingTrail': hikingTrail,
      'startDate': startDate.toIso8601String(),
      'checkInDate': checkInDate?.toIso8601String(),
      'checkOutDate': checkOutDate?.toIso8601String(),
      'checkInItems': checkInItems,
      'checkInCheckboxes': checkInCheckboxes,
      'checkOutItems': checkOutItems,
      'checkOutCheckboxes': checkOutCheckboxes,
      'status': status.toString().split('.').last,
    };
  }

  HikingModel copyWith({
    String? id,
    String? reservasiId,
    String? paymentId,
    String? mountainName,
    String? hikingTrail,
    DateTime? startDate,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    String? checkInItems,
    List<bool>? checkInCheckboxes,
    String? checkOutItems,
    List<bool>? checkOutCheckboxes,
    HikingStatus? status,
  }) {
    return HikingModel(
      id: id ?? this.id,
      reservasiId: reservasiId ?? this.reservasiId,
      paymentId: paymentId ?? this.paymentId,
      mountainName: mountainName ?? this.mountainName,
      hikingTrail: hikingTrail ?? this.hikingTrail,
      startDate: startDate ?? this.startDate,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      checkInItems: checkInItems ?? this.checkInItems,
      checkInCheckboxes: checkInCheckboxes ?? this.checkInCheckboxes,
      checkOutItems: checkOutItems ?? this.checkOutItems,
      checkOutCheckboxes: checkOutCheckboxes ?? this.checkOutCheckboxes,
      status: status ?? this.status,
    );
  }
}

enum HikingStatus {
  pending, // Belum check-in
  checkedIn, // Sudah check-in, belum check-out
  checkedOut, // Sudah check-out
}
