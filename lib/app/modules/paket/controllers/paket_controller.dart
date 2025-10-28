import 'package:get/get.dart';

class PaketController extends GetxController {
  final paketWisataList = <PaketWisataModel>[
    PaketWisataModel(
      title: 'Puncak Besar Malabar',
      subtitle: 'Trip Dieng Dieng',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      tripType: 'Open Trip',
      isOpenTrip: true,
    ),
    PaketWisataModel(
      title: 'Puncak Bes',
      subtitle: 'Kerta Trip',
      imageUrl: 'https://images.unsplash.com/photo-1454496522488-7a8e488e8606',
      tripType: 'Private Trip',
      isOpenTrip: false,
    ),
  ].obs;
}
class PaketWisataModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tripType;
  final bool isOpenTrip;

  PaketWisataModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tripType,
    required this.isOpenTrip,
  });
}