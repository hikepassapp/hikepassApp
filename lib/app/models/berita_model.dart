class BeritaModel {
  final String id;
  final String title;
  final String kategori;
  final String tanggal;
  final String author;
  final String imageUrl;
  final String introText;
  final List<Map<String, String>> contentSections;
  final String sourceTitle;
  final String sourceUrl;
  final String? description;
  final int? views;
  final List<String>? tags;

  BeritaModel({
    required this.id,
    required this.title,
    this.kategori = 'Berita',
    required this.tanggal,
    required this.author,
    required this.imageUrl,
    this.introText = '',
    this.contentSections = const [],
    this.sourceTitle = '',
    this.sourceUrl = '',
    this.description,
    this.views,
    this.tags,
  });

  factory BeritaModel.fromJson(Map<String, dynamic> json) {
    return BeritaModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      kategori: json['kategori'] ?? 'Berita',
      tanggal: json['tanggal'] ?? '',
      author: json['author'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      introText: json['introText'] ?? '',
      contentSections: json['contentSections'] != null
          ? List<Map<String, String>>.from(
              json['contentSections'].map((x) => Map<String, String>.from(x)))
          : [],
      sourceTitle: json['sourceTitle'] ?? '',
      sourceUrl: json['sourceUrl'] ?? '',
      description: json['description'],
      views: json['views'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'kategori': kategori,
      'tanggal': tanggal,
      'author': author,
      'imageUrl': imageUrl,
      'introText': introText,
      'contentSections': contentSections,
      'sourceTitle': sourceTitle,
      'sourceUrl': sourceUrl,
      'description': description,
      'views': views,
      'tags': tags,
    };
  }

  // Helper method untuk copy dengan perubahan
  BeritaModel copyWith({
    String? id,
    String? title,
    String? kategori,
    String? tanggal,
    String? author,
    String? imageUrl,
    String? introText,
    List<Map<String, String>>? contentSections,
    String? sourceTitle,
    String? sourceUrl,
    String? description,
    int? views,
    List<String>? tags,
  }) {
    return BeritaModel(
      id: id ?? this.id,
      title: title ?? this.title,
      kategori: kategori ?? this.kategori,
      tanggal: tanggal ?? this.tanggal,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      introText: introText ?? this.introText,
      contentSections: contentSections ?? this.contentSections,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      description: description ?? this.description,
      views: views ?? this.views,
      tags: tags ?? this.tags,
    );
  }

  // Helper method untuk mendapatkan preview text
  String getPreviewText({int maxLength = 100}) {
    if (introText.isNotEmpty) {
      return introText.length > maxLength
          ? '${introText.substring(0, maxLength)}...'
          : introText;
    }
    if (description != null && description!.isNotEmpty) {
      return description!.length > maxLength
          ? '${description!.substring(0, maxLength)}...'
          : description!;
    }
    return '';
  }

  // Helper method untuk format tanggal
  String getFormattedDate() {
    // Bisa disesuaikan dengan format yang diinginkan
    return tanggal;
  }

  bool isNew() {
    return false;
  }

  // Helper method untuk increment views
  BeritaModel incrementViews() {
    return copyWith(views: (views ?? 0) + 1);
  }

  @override
  String toString() {
    return 'BeritaModel(id: $id, title: $title, kategori: $kategori, tanggal: $tanggal, author: $author)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BeritaModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}