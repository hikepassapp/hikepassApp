import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../models/classNewsEventModel.dart';

class HomeController extends GetxController {
  var userName = 'Nailong'.obs;
  var temperature = 27.obs;
  var weatherCondition = 'Cerah Berawan'.obs;
  var location = 'Pangalengan, Kab. Bandung. Jawa Barat'.obs;
  final RxList<PaketWisataModel> paketWisataList = <PaketWisataModel>[
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

  final newsEventList = <NewsEventModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNewsEvent();
  }

  void loadNewsEvent() {
    newsEventList.value = [
      NewsEventModel(
        id: '1',
        title: '3 Fakta Unik Gunung Malabar',
        category: 'Berita',
        date: '3 Des 2023',
        imageUrl:
            'https://images.unsplash.com/photo-1454496522488-7a8e488e8606', // GANTI DENGAN PATH GAMBAR ANDA
        description:
            'Kisah menarik tentang Gunung Malabar yang jarang diketahui',
      ),
      NewsEventModel(
        id: '2',
        title: 'Reboisasi Hutan Lindung Tahun 2023',
        category: 'Event',
        date: '5 Des 2023',
        imageUrl:
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4', // GANTI DENGAN PATH GAMBAR ANDA
        description: 'Program reboisasi untuk menjaga kelestarian lingkungan',
      ),
    ];
  }

  void onSeeAllTapped() {
    // Navigate ke halaman list lengkap
    Get.toNamed('/berita-event-list');
  }

  void onNewsEventTapped(NewsEventModel item) {
    // Navigate ke detail
    Get.toNamed('/berita-event-detail', arguments: item);
  }

  void navigateToReservation() {
    Get.offAllNamed(Routes.reservasi);
  }

  void navigateToRiwayat() {
    Get.offAllNamed(Routes.riwayat);
  }

  void navigateToInformasi() {
    Get.offAllNamed(Routes.informasi);
  }

  void navigateToLaporan() {
    Get.offAllNamed(Routes.laporan);
  }
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
