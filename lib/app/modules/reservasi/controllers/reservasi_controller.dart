import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/reservation_detail_view.dart';
import 'package:image_picker/image_picker.dart';

class ReservasiController extends GetxController {
  final reservations = <Map<String, String>>[].obs;
  final isLoading = false.obs;
  final selectedPos = ''.obs;
  final ticketCount = 1.obs;
  final isAgreed = false.obs;
  var ktpImage = Rxn<XFile>();

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

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
        'title': 'Puncak Besar Malabar',
        'subtitle': 'LMDH',
        'price': 'Rp. 15.000',
        'duration': 'Estimasi 2 Jam',
        'location': 'Pangalengan, Kab. Bandung',
        'phoneNumber': '+628123456789',
        'estimasi': '± 2 Jam',
      },
    ];

    isLoading.value = false;
  }

  void toggleAgreement(bool? value) {
    isAgreed.value = value ?? false;
  }

  void incrementTicket() {
    if (ticketCount.value < 8) ticketCount.value++;
  }

  void decrementTicket() {
    if (ticketCount.value > 1) ticketCount.value--;
  }

  void resetTicketCount() {
    ticketCount.value = 1;
  }

  // Set tanggal yang dipilih
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  // Navigasi ke detail reservasi
  void goToDetail(Map<String, String> reservation) {
    Get.to(
      () => const ReservationDetailView(),
      arguments: reservation,
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 300),
    );
  }

  // Submit data reservasi
  void submitData() {
    if (isAgreed.value) {
      Get.snackbar(
        'Berhasil',
        'Data berhasil disubmit',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Peringatan',
        'Silakan centang persetujuan terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  // Upload foto KTP
  Future<void> pickKtpImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      ktpImage.value = image;
    }
  }
}
