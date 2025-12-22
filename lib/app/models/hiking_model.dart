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
  final String? userId;

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
    this.userId,
  });

  /// Create HikingModel from Supabase JSON
  factory HikingModel.fromJson(Map<String, dynamic> json) {
    return HikingModel(
      id: json['id'] as String? ?? '',
      reservasiId: json['reservasi_id'] as String? ?? '',
      paymentId: json['payment_id'] as String?,
      mountainName: json['mountain_name'] as String? ?? '-',
      hikingTrail: json['hiking_trail'] as String? ?? '-',
      startDate: DateTime.tryParse(json['start_date'] as String? ?? '') ?? DateTime.now(),
      checkInDate: json['check_in_date'] != null
          ? DateTime.tryParse(json['check_in_date'] as String)
          : null,
      checkOutDate: json['check_out_date'] != null
          ? DateTime.tryParse(json['check_out_date'] as String)
          : null,
      checkInItems: json['check_in_items'] as String?,
      checkInCheckboxes: json['check_in_checkboxes'] != null
          ? List<bool>.from(json['check_in_checkboxes'] as List)
          : null,
      checkOutItems: json['check_out_items'] as String?,
      checkOutCheckboxes: json['check_out_checkboxes'] != null
          ? List<bool>.from(json['check_out_checkboxes'] as List)
          : null,
      status: _parseHikingStatus(json['status'] as String?),
      userId: json['user_id'] as String?,
    );
  }

  /// Convert HikingModel to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reservasi_id': reservasiId,
      'payment_id': paymentId,
      'mountain_name': mountainName,
      'hiking_trail': hikingTrail,
      'start_date': startDate.toIso8601String(),
      'check_in_date': checkInDate?.toIso8601String(),
      'check_out_date': checkOutDate?.toIso8601String(),
      'check_in_items': checkInItems,
      'check_in_checkboxes': checkInCheckboxes,
      'check_out_items': checkOutItems,
      'check_out_checkboxes': checkOutCheckboxes,
      'status': status.name,
      if (userId != null) 'user_id': userId,
    };
  }

  /// Parse HikingStatus from string
  static HikingStatus _parseHikingStatus(String? status) {
    switch (status) {
      case 'checkedIn':
        return HikingStatus.checkedIn;
      case 'checkedOut':
        return HikingStatus.checkedOut;
      default:
        return HikingStatus.pending;
    }
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
