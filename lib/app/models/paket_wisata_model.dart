class PaketWisataModel {
  final String id;
  final String title;
  final String agen;
  final String tripType;
  final String date;
  final String imageUrl;
  final String description;
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
    required this.description,
    required this.rating,
    required this.admin,
    required this.tanggal,
    required this.biaya,
    required this.titikKumpul,
    required this.jamKeberangkatan,
    required this.narahubung,
    required this.fasilitas,
    required this.destinasi,
    required this.createdDate,
  });

  // Factory constructor untuk parsing JSON dari Supabase
  factory PaketWisataModel.fromJson(Map<String, dynamic> json) {
    return PaketWisataModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      agen: json['agen'] ?? '',
      tripType: json['trip_type'] ?? '',
      date: json['date'] ?? '',
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      admin: json['admin'] ?? '',
      tanggal: json['tanggal'] ?? '',
      biaya: json['biaya'] ?? '',
      titikKumpul: json['titik_kumpul'] ?? '',
      jamKeberangkatan: json['jam_keberangkatan'] ?? '',
      narahubung: json['narahubung'] ?? '',
      fasilitas: json['fasilitas'] != null 
          ? List<String>.from(json['fasilitas']) 
          : [],
      destinasi: json['destinasi'] != null 
          ? List<String>.from(json['destinasi']) 
          : [],
      createdDate: json['created_date'] ?? '',
    );
  }

  // Method untuk convert ke JSON (untuk insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'agen': agen,
      'trip_type': tripType,
      'date': date,
      'image_url': imageUrl,
      'description': description,
      'rating': rating,
      'admin': admin,
      'tanggal': tanggal,
      'biaya': biaya,
      'titik_kumpul': titikKumpul,
      'jam_keberangkatan': jamKeberangkatan,
      'narahubung': narahubung,
      'fasilitas': fasilitas,
      'destinasi': destinasi,
      'created_date': createdDate,
    };
  }
}