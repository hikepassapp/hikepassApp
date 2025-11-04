import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/reservation_detail_view.dart';
import 'package:image_picker/image_picker.dart';

class ReservasiController extends GetxController {
  // ======= DATA UTAMA =======
  final reservations = <Map<String, dynamic>>[].obs; // tiket aktif
  final riwayat = <Map<String, dynamic>>[].obs; // tiket sudah dibayar
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

  // ======= LOAD DATA TIKET (dummy awal) =======
  void loadReservations() {
    isLoading.value = true;

    reservations.value = [
      {
        'id': 'R${DateTime.now().millisecondsSinceEpoch}',
        'imagePath': 'assets/images/reservasi_panorama.png',
        'title': 'Puncak Besar Malabar',
        'jalur': 'Jalur Panorama',
        'subtitle': 'LMDH',
        'harga': 'Rp 15.000',
        'duration': 'Estimasi 2 Jam',
        'location': 'Pangalengan, Kab. Bandung',
        'phoneNumber': '+628123456789',
        'estimasi': '± 2 Jam',
      },
    ];

    // Kosongkan riwayat di awal (sekali saja)
    riwayat.clear();
    isLoading.value = false;
  }

  // ======= AGREEMENT, JUMLAH, DLL =======
  void toggleAgreement(bool? value) => isAgreed.value = value ?? false;

  void incrementTicket() {
    if (ticketCount.value < 8) ticketCount.value++;
  }

  void decrementTicket() {
    if (ticketCount.value > 1) ticketCount.value--;
  }

  void resetTicketCount() => ticketCount.value = 1;

  void setSelectedDate(DateTime date) => selectedDate.value = date;

  // ======= NAVIGASI KE DETAIL =======
  void goToDetail(Map<String, dynamic> reservation) {
    Get.to(
      () => const ReservationDetailView(),
      arguments: reservation,
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 300),
    );
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
  void completePayment(Map<String, dynamic> data) {
    // Ambil waktu & tanggal sekarang
    final now = DateTime.now();
    final formattedDate =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
    final formattedTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // Pastikan semua nilai disimpan dalam bentuk String
    final riwayatItem = {
      'id': (data['id'] ?? 'D${now.millisecondsSinceEpoch}').toString(),
      'nama': data['nama']?.toString() ?? 'Pendaki',
      'jalur':
          (data['selectedPos'] ??
                  data['jalur'] ??
                  data['title'] ??
                  'Jalur Panorama')
              .toString(),
      'tanggal': formattedDate,
      'waktu': formattedTime,
      'image': (data['imagePath'] ?? 'assets/images/reservasi_panorama.png')
          .toString(),
      'harga': (data['harga'] ?? 'Rp 15.000').toString(),
      'status': 'Selesai',
    };

    // Tambahkan ke daftar riwayat hanya sekali
    if (!riwayat.any((r) => r['id'] == riwayatItem['id'])) {
      riwayat.add(riwayatItem);
    }

    // Reset data input
    resetTicketCount();
    selectedDate.value = null;
    selectedPos.value = '';
    isAgreed.value = false;

    // Update UI
    update();

    // Notifikasi sukses (1x saja)
    Get.snackbar(
      'Pembayaran Berhasil',
      'Tiket telah ditambahkan ke Riwayat Pembayaran',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
    );
  }
}
