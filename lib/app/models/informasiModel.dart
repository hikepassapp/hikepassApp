class InformasiModel {
  final String id;
  final String imageUrl;
  final List<InformasiContent> contents;

  InformasiModel({
    required this.id,
    required this.imageUrl,
    required this.contents,
  });
}

class InformasiContent {
  final String title;
  final String description;

  InformasiContent({
    required this.title,
    required this.description,
  });
}