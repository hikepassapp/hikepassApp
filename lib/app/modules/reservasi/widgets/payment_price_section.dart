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
            // Validasi tanggal
            if (controller.selectedDate.value == null) {
              Get.snackbar(
                'Peringatan',
                'Silakan pilih tanggal pendakian terlebih dahulu!',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            // Ambil waktu & tanggal asli device
            final now = DateTime.now();
            final selected = controller.selectedDate.value!;
            final formattedDate =
                '${selected.day}-${selected.month}-${selected.year}';

            // 12-jam (AM/PM)
            final hour = now.hour > 12 ? now.hour - 12 : now.hour;
            final ampm = now.hour >= 12 ? 'PM' : 'AM';
            final formattedTime =
                "${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $ampm";

            // Data yang dikirim ke halaman sukses
            final data = {
              'id': 'D${now.millisecondsSinceEpoch}',
              'nama': 'Dhea',
              'title': 'Puncak Besar Malabar',
              'jalur': 'Panorama',
              'metode': 'QRIS',
              'tanggal': formattedDate,
              'waktu': formattedTime,
              'harga': 'Rp 15.000',
              'durasi': '2 Hari',
              'imagePath': 'assets/images/reservasi_panorama.png',
            };

            // Update data di controller
            controller.completePayment(data);

            // Navigasi ke halaman sukses
            Get.toNamed('/payment-success', arguments: data);
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
