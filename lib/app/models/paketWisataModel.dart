class PaketWisataModel {
  final String id;
  final String title;
  final String agen;
  final String tripType;
  final String date;
  final String imageUrl;
  final String? description;
  
  // Detail paket wisata
  final double rating;
  final String admin;
  final String tanggal;
  final String biaya;
  final String titikKumpul;
  final String jamKeberangkatan;
  final String narahubung;
  final List<String> fasilitas;
  final List<String> destinasi;
  final String createdDate;

  PaketWisataModel({
    required this.id,
    required this.title,
    required this.agen,
    required this.tripType,
    required this.date,
    required this.imageUrl,
    this.description,
    this.rating = 0.0,
    this.admin = '',
    this.tanggal = '',
    this.biaya = '',
    this.titikKumpul = '',
    this.jamKeberangkatan = '',
    this.narahubung = '',
    this.fasilitas = const [],
    this.destinasi = const [],
    this.createdDate = '',
  });

  factory PaketWisataModel.fromJson(Map<String, dynamic> json) {
    return PaketWisataModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      agen: json['agen'] ?? '',
      tripType: json['tripType'] ?? '',
      date: json['date'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'],
      rating: json['rating']?.toDouble() ?? 0.0,
      admin: json['admin'] ?? '',
      tanggal: json['tanggal'] ?? json['date'] ?? '',
      biaya: json['biaya'] ?? '',
      titikKumpul: json['titikKumpul'] ?? '',
      jamKeberangkatan: json['jamKeberangkatan'] ?? '',
      narahubung: json['narahubung'] ?? '',
      fasilitas: json['fasilitas'] != null 
          ? List<String>.from(json['fasilitas']) 
          : [],
      destinasi: json['destinasi'] != null 
          ? List<String>.from(json['destinasi']) 
          : [],
      createdDate: json['createdDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'agen': agen,
      'tripType': tripType,
      'date': date,
      'imageUrl': imageUrl,
      'description': description,
      'rating': rating,
      'admin': admin,
      'tanggal': tanggal,
      'biaya': biaya,
      'titikKumpul': titikKumpul,
      'jamKeberangkatan': jamKeberangkatan,
      'narahubung': narahubung,
      'fasilitas': fasilitas,
      'destinasi': destinasi,
      'createdDate': createdDate,
    };
  }

  // Helper method untuk copy dengan perubahan
  PaketWisataModel copyWith({
    String? id,
    String? title,
    String? agen,
    String? tripType,
    String? date,
    String? imageUrl,
    String? description,
    double? rating,
    String? admin,
    String? tanggal,
    String? biaya,
    String? titikKumpul,
    String? jamKeberangkatan,
    String? narahubung,
    List<String>? fasilitas,
    List<String>? destinasi,
    String? createdDate,
  }) {
    return PaketWisataModel(
      id: id ?? this.id,
      title: title ?? this.title,
      agen: agen ?? this.agen,
      tripType: tripType ?? this.tripType,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      admin: admin ?? this.admin,
      tanggal: tanggal ?? this.tanggal,
      biaya: biaya ?? this.biaya,
      titikKumpul: titikKumpul ?? this.titikKumpul,
      jamKeberangkatan: jamKeberangkatan ?? this.jamKeberangkatan,
      narahubung: narahubung ?? this.narahubung,
      fasilitas: fasilitas ?? this.fasilitas,
      destinasi: destinasi ?? this.destinasi,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}