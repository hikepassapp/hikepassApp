class InformasiModel {
  final String id;
  final String kategori; // 'peraturan', 'tips', 'umum'
  final String imageUrl;
  final int urutan;
  final List<InformasiContent> contents;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InformasiModel({
    required this.id,
    required this.kategori,
    required this.imageUrl,
    this.urutan = 0,
    required this.contents,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor untuk parsing JSON dari Supabase
  factory InformasiModel.fromJson(Map<String, dynamic> json) {
    List<InformasiContent> contentsList = [];
    
    // Parse contents jika ada
    if (json['informasi_content'] != null) {
      contentsList = (json['informasi_content'] as List)
          .map((content) => InformasiContent.fromJson(content))
          .toList();
      
      // Sort berdasarkan urutan
      contentsList.sort((a, b) => a.urutan.compareTo(b.urutan));
    }

    return InformasiModel(
      id: json['id'] ?? '',
      kategori: json['kategori'] ?? '',
      imageUrl: json['image_url'] ?? '',
      urutan: json['urutan'] ?? 0,
      contents: contentsList,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  // Method untuk convert ke JSON (untuk insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategori': kategori,
      'image_url': imageUrl,
      'urutan': urutan,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Copy with method
  InformasiModel copyWith({
    String? id,
    String? kategori,
    String? imageUrl,
    int? urutan,
    List<InformasiContent>? contents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InformasiModel(
      id: id ?? this.id,
      kategori: kategori ?? this.kategori,
      imageUrl: imageUrl ?? this.imageUrl,
      urutan: urutan ?? this.urutan,
      contents: contents ?? this.contents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class InformasiContent {
  final String id;
  final String informasiId;
  final String title;
  final String description;
  final int urutan;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InformasiContent({
    this.id = '',
    this.informasiId = '',
    required this.title,
    required this.description,
    this.urutan = 0,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor untuk parsing JSON dari Supabase
  factory InformasiContent.fromJson(Map<String, dynamic> json) {
    return InformasiContent(
      id: json['id'] ?? '',
      informasiId: json['informasi_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urutan: json['urutan'] ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  // Method untuk convert ke JSON (untuk insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'informasi_id': informasiId,
      'title': title,
      'description': description,
      'urutan': urutan,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Copy with method
  InformasiContent copyWith({
    String? id,
    String? informasiId,
    String? title,
    String? description,
    int? urutan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InformasiContent(
      id: id ?? this.id,
      informasiId: informasiId ?? this.informasiId,
      title: title ?? this.title,
      description: description ?? this.description,
      urutan: urutan ?? this.urutan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}