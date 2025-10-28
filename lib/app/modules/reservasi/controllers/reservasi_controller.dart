import 'package:get/get.dart';
import '../views/reservation_detail_view.dart';

class ReservasiController extends GetxController {
  final reservations = <Map<String, String>>[].obs;
  final isLoading = false.obs;

  final ticketCount = 1.obs;

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
        'location': 'Kopi Malabar, Pangalengan, Kab. Bandung',
        'phoneNumber': '+628123456789',
        'estimasi': '± 2 Jam',
      },
      {
        'imagePath': 'assets/images/reservasi_cinyiruan.png',
        'title': 'Puncak Besar Malabar Via Cinyiruan',
        'subtitle': 'LMDH',
        'price': 'Rp. 10.000',
        'duration': 'Estimasi 3 Jam',
        'location': 'Cinyiruan, Pangalengan, Kab. Bandung',
        'phoneNumber': '+628987654321',
        'estimasi': '± 3 Jam',
      },
    ];

    isLoading.value = false;
  }

  void incrementTicket() {
    ticketCount.value++;
  }

  void decrementTicket() {
    if (ticketCount.value > 1) ticketCount.value--;
  }

  void resetTicketCount() {
    ticketCount.value = 1;
  }

  // Navigasi ke detail
  void goToDetail(Map<String, String> reservation) {
    Get.to(
      () => const ReservationDetailView(),
      arguments: reservation,
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 300),
    );
  }
}
