class NewsEventModel {
  final String id;
  final String title;
  final String category;
  final String date;
  final String imageUrl;
  final String? description;

  NewsEventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.imageUrl,
    this.description,
  });

  factory NewsEventModel.fromJson(Map<String, dynamic> json) {
    return NewsEventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'date': date,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}