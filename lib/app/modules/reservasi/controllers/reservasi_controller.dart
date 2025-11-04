import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/reservation_detail_view.dart';
import 'package:image_picker/image_picker.dart';

class ReservasiController extends GetxController {
  final reservations = <Map<String, dynamic>>[].obs; 
  final riwayat = <Map<String, dynamic>>[].obs; 
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

    riwayat.clear();
    isLoading.value = false;
  }

  void toggleAgreement(bool? value) => isAgreed.value = value ?? false;

  void incrementTicket() {
    if (ticketCount.value < 8) ticketCount.value++;
  }

  void decrementTicket() {
    if (ticketCount.value > 1) ticketCount.value--;
  }

  void resetTicketCount() => ticketCount.value = 1;

  void setSelectedDate(DateTime date) => selectedDate.value = date;

  void goToDetail(Map<String, dynamic> reservation) {
    Get.to(
      () => const ReservationDetailView(),
      arguments: reservation,
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> pickKtpImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ktpImage.value = image;
    }
  }
  void completePayment(Map<String, dynamic> data) {
    final now = DateTime.now();
    final formattedDate =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
    final formattedTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

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

    if (!riwayat.any((r) => r['id'] == riwayatItem['id'])) {
      riwayat.add(riwayatItem);
    }

    resetTicketCount();
    selectedDate.value = null;
    selectedPos.value = '';
    isAgreed.value = false;

    update();

    Get.snackbar(
      'Pembayaran Berhasil',
      'Tiket telah ditambahkan ke Riwayat Pembayaran',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
    );
  }
}
