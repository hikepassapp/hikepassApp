import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/reservation_detail_view.dart';
import 'package:image_picker/image_picker.dart';

class ReservasiController extends GetxController {
  // ======= DATA UTAMA =======
  final reservations = <Map<String, String>>[].obs; // tiket aktif
  final riwayat = <Map<String, String>>[].obs; // tiket yang sudah dibayar
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

  // ======= LOAD DATA TIKET =======
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

  // ======= AGREEMENT, JUMLAH, DLL =======
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

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  // ======= NAVIGASI DETAIL =======
  void goToDetail(Map<String, String> reservation) {
    Get.to(
      () => const ReservationDetailView(),
      arguments: reservation,
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 300),
    );
  }

  // ======= SUBMIT / VALIDASI DATA =======
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

  // ======= UPLOAD FOTO KTP =======
  Future<void> pickKtpImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      ktpImage.value = image;
    }
  }

  // ======= PEMBAYARAN & PEMINDAHAN DATA =======
  void completePayment(Map<String, String> data) {
    // hapus dari daftar tiket aktif
    reservations.removeWhere((item) => item['title'] == data['title']);

    // waktu dan tanggal real
    final now = DateTime.now();
    final formattedDate = "${now.day}-${now.month}-${now.year}";
    final formattedTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // tambahkan ke daftar riwayat
    riwayat.add({
      'id': data['id'] ?? 'D${now.millisecondsSinceEpoch}',
      'nama': data['nama'] ?? 'Pendaki',
      'jalur': data['jalur'] ?? 'Panorama',
      'tanggal': formattedDate,
      'waktu': formattedTime,
      'image': data['imagePath'] ?? 'assets/images/reservasi_panorama.png',
      'harga': data['harga'] ?? 'Rp 15.000',
      'status': 'Selesai',
    });

    update(); // refresh UI otomatis
  }
}
