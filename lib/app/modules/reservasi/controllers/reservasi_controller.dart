import 'package:get/get.dart';

class ReservasiController extends GetxController {
  final reservations = <Map<String, String>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadReservations();
  }

  void loadReservations() {
    isLoading.value = true;

    reservations.value = [
      {
        'imagePath': 'assets/images/reservasi_panorama.png',
        'title': 'Puncak Besar Malabar Via Panorama',
        'subtitle': 'LMDH',
        'price': 'Rp. 15.000',
        'duration': 'Estimasi 2 Jam',
      },
      {
        'imagePath': 'assets/images/reservasi_cinyiruan.png',
        'title': 'Puncak Besar Malabar Via Cinyiruan',
        'subtitle': 'LMDH',
        'price': 'Rp. 10.000',
        'duration': 'Estimasi 3 Jam',
      },
    ];

    isLoading.value = false;
  }
}
