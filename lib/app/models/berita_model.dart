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

  BeritaModel({
    required this.id,
    required this.title,
    required this.kategori,
    required this.tanggal,
    required this.author,
    required this.imageUrl,
    required this.introText,
    required this.contentSections,
    required this.sourceTitle,
    required this.sourceUrl,
  });

  // Factory constructor untuk parsing JSON dari Supabase
  factory BeritaModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> sections = [];
    
    if (json['content_sections'] != null) {
      sections = (json['content_sections'] as List)
          .map((section) => Map<String, String>.from(section))
          .toList();
    }

    return BeritaModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      kategori: json['kategori'] ?? '',
      tanggal: json['tanggal'] ?? '',
      author: json['author'] ?? '',
      imageUrl: json['image_url'] ?? '',
      introText: json['intro_text'] ?? '',
      contentSections: sections,
      sourceTitle: json['source_title'] ?? '',
      sourceUrl: json['source_url'] ?? '',
    );
  }

  // Method untuk convert ke JSON (untuk insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'kategori': kategori,
      'tanggal': tanggal,
      'author': author,
      'image_url': imageUrl,
      'intro_text': introText,
      'content_sections': contentSections,
      'source_title': sourceTitle,
      'source_url': sourceUrl,
    };
  }
}