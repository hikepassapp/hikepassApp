import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../models/classNewsEventModel.dart';
import '../../../models/paketWisataModel.dart';

class HomeController extends GetxController {
  var userName = 'Nailong'.obs;
  var temperature = 27.obs;
  var weatherCondition = 'Cerah Berawan'.obs;
  var location = 'Pangalengan, Kab. Bandung. Jawa Barat'.obs;
  final paketWisataList = <PaketWisataModel>[].obs;
  final newsEventList = <NewsEventModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNewsEvent();
    loadPaketWisata();
  }

  void loadPaketWisata() {
    paketWisataList.value = [
      PaketWisataModel(
        id: '1',
        title: 'Puncak Besar Malabar',
        agen: 'Trip Dieng Dieng',
        tripType: 'Open Trip',
        date: '10 Des 2023',
        imageUrl:
            'assets/images/banner1.png',
        description: 'Nikmati keindahan Puncak Besar Malabar bersama kami!',
      ),
      PaketWisataModel(
        id: '2',
        title: 'Petualangan Gunung Kerta',
        agen: 'Kerta Trip',
        tripType: 'Private Trip',
        date: '15 Des 2023',
        imageUrl:
            'assets/images/banner2.png',
        description: 'Jelajahi Gunung Kerta dengan pengalaman tak terlupakan.',
      ),
    ];
  }

  

  void loadNewsEvent() {
    newsEventList.value = [
      NewsEventModel(
        id: '1',
        title: '3 Fakta Unik Gunung Malabar',
        category: 'Berita',
        date: '3 Des 2023',
        imageUrl:
            'assets/images/banner4.png',
        description:
            'Kisah menarik tentang Gunung Malabar yang jarang diketahui',
      ),
      NewsEventModel(
        id: '2',
        title: 'Reboisasi Hutan Lindung Tahun 2023',
        category: 'Event',
        date: '5 Des 2023',
        imageUrl:
            'assets/images/banner3.png',
        description: 'Program reboisasi untuk menjaga kelestarian lingkungan',
      ),
    ];
  }

  void onSeeAllTapped() {
    Get.toNamed('/berita-event-list');
  }

  void onNewsEventTapped(NewsEventModel item) {
    Get.toNamed('/berita-event-detail', arguments: item);
  }

  void onSeeAllPaketWisataTapped() {
    Get.toNamed('/paket-wisata-list');
  }

  void onPaketWisataTapped(PaketWisataModel item) {
    Get.toNamed('/paket-wisata-detail', arguments: item);
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

