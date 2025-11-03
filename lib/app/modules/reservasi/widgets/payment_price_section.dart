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
        // ====== Kotak Harga ======
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Harga Tiket',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Rp 15.000',
                style: TextStyle(
                  color: Color(0xFF2D9F8C),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ====== Tombol Bayar Sekarang ======
        ElevatedButton(
          onPressed: () {
            // ✅ 1. Validasi tanggal
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

            // ✅ 2. Ambil data & format waktu
            final now = DateTime.now();
            final selected = controller.selectedDate.value!;
            final formattedDate =
                '${selected.day.toString().padLeft(2, '0')}-${selected.month.toString().padLeft(2, '0')}-${selected.year}';
            final formattedTime =
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

            // ✅ 3. Buat data tiket baru
            final data = {
              'id': 'D${now.millisecondsSinceEpoch}',
              'nama': 'Dhea',
              'title': 'Puncak Besar Malabar',
              'jalur': controller.selectedPos.value.isNotEmpty
                  ? controller.selectedPos.value
                  : 'Panorama',
              'metode': 'QRIS',
              'tanggal': formattedDate,
              'waktu': formattedTime,
              'harga': 'Rp 15.000',
              'durasi': '2 Hari',
              'imagePath': 'assets/images/reservasi_panorama.png',
            };

            // ✅ 4. Tambahkan ke riwayat (pasti cuma sekali)
            controller.completePayment(data);

            // ✅ 5. Reset form (biar bisa reservasi lagi)
            controller.selectedDate.value = null;
            controller.selectedPos.value = '';
            controller.ticketCount.value = 1;
            controller.isAgreed.value = false;

            // ✅ 6. Arahkan ke halaman sukses
            Get.offNamed('/payment-success', arguments: data);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D9F8C),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Bayar Sekarang',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
