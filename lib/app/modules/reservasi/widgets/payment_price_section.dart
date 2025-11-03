import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';

class PaymentPriceSection extends StatelessWidget {
  const PaymentPriceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReservasiController>();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Harga Tiket',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'Rp 15.000',
                style: TextStyle(
                  color: Color(0xFF2D9F8C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ================== TOMBOL BAYAR SEKARANG ==================
        ElevatedButton(
          onPressed: () {
            // Cek apakah user sudah pilih tanggal
            if (controller.selectedDate.value == null) {
              Get.snackbar(
                'Peringatan',
                'Silakan pilih tanggal pendakian terlebih dahulu',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            // Jika sudah, tampilkan notifikasi sukses
            Get.snackbar(
              'Pembayaran Berhasil',
              'Tiket berhasil dibeli!',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );

            // Lalu pindah ke halaman Pesananku (riwayat)
            Get.toNamed(
              '/riwayat',
              arguments: {
                'tanggal': controller.selectedDate.value?.toString() ?? '-',
                'jalur': 'Panorama',
                'nama': 'Dhea',
                'durasi': '2 Hari',
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D9F8C),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Bayar Sekarang',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
