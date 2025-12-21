class LaporanModel {
  final String? id;
  final String namaPelapor;
  final DateTime tanggalKejadian;
  final String lokasiKejadian;
  final String deskripsiKejadian;
  final String? fotoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LaporanModel({
    this.id,
    required this.namaPelapor,
    required this.tanggalKejadian,
    required this.lokasiKejadian,
    required this.deskripsiKejadian,
    this.fotoUrl,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama_pelapor': namaPelapor,
      'tanggal_kejadian': tanggalKejadian.toIso8601String().split('T')[0],
      'lokasi_kejadian': lokasiKejadian,
      'deskripsi_kejadian': deskripsiKejadian,
      if (fotoUrl != null) 'foto_url': fotoUrl,
    };
  }

  factory LaporanModel.fromJson(Map<String, dynamic> json) {
    return LaporanModel(
      id: json['id'],
      namaPelapor: json['nama_pelapor'] ?? '',
      tanggalKejadian: DateTime.parse(json['tanggal_kejadian']),
      lokasiKejadian: json['lokasi_kejadian'] ?? '',
      deskripsiKejadian: json['deskripsi_kejadian'] ?? '',
      fotoUrl: json['foto_url'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  LaporanModel copyWith({
    String? id,
    String? namaPelapor,
    DateTime? tanggalKejadian,
    String? lokasiKejadian,
    String? deskripsiKejadian,
    String? fotoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LaporanModel(
      id: id ?? this.id,
      namaPelapor: namaPelapor ?? this.namaPelapor,
      tanggalKejadian: tanggalKejadian ?? this.tanggalKejadian,
      lokasiKejadian: lokasiKejadian ?? this.lokasiKejadian,
      deskripsiKejadian: deskripsiKejadian ?? this.deskripsiKejadian,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'LaporanModel(id: $id, namaPelapor: $namaPelapor, tanggalKejadian: $tanggalKejadian)';
  }
}