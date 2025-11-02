class PaketWisataModel {
  final String id;
  final String title;
  final String agen;
  final String tripType;
  final String date;
  final String imageUrl;
  final String? description;

  PaketWisataModel({
    required this.id,
    required this.title,
    required this.agen,
    required this.tripType,
    required this.date,
    required this.imageUrl,
    this.description,
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
    };
  }
}