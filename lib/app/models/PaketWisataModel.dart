class PaketWisataModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tripType; // 'Open Trip' atau 'Private Trip'
  final bool isOpenTrip;

  PaketWisataModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tripType,
    required this.isOpenTrip,
  });
}