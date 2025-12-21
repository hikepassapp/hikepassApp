import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';

class PaymentPriceSection extends StatelessWidget {
  final Map<String, dynamic>? data;

  const PaymentPriceSection({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReservasiController>();
    // compute per-ticket price (attempt to parse from data['harga']) and total
    int _parsePrice(String? priceStr) {
      if (priceStr == null) return 0;
      final digits = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.isEmpty) return 0;
      return int.tryParse(digits) ?? 0;
    }

    String _formatRupiah(int value) {
      if (value <= 0) return 'Rp 0';
      final s = value.toString();
      final formatted = s.replaceAllMapped(RegExp(r"\B(?=(\d{3})+(?!\d))"), (m) => '.');
      return 'Rp $formatted';
    }

    final perTicket = _parsePrice(data?['harga']?.toString());
    final total = perTicket * controller.ticketCount.value;
    final totalStr = _formatRupiah(total);

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Harga Tiket (${controller.ticketCount.value} Pendaki)',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              Text(
                totalStr,
                style: const TextStyle(
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
            // Validate all required data
            if ((data == null || data!['tanggal'] == null) &&
                controller.selectedDate.value == null) {
              Get.snackbar(
                'Peringatan',
                'Data tanggal tidak lengkap!',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            if (controller.hikers.isEmpty) {
              Get.snackbar(
                'Peringatan',
                'Silakan isi data pendaki terlebih dahulu!',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            // Create complete ticket data to pass to payment success view
            final now = DateTime.now();
            final ticketData = {
              'id': 'D${now.millisecondsSinceEpoch}',
              'title': data?['title'] ?? '',
              'jalur': controller.selectedPos.value,
              'selectedPos': controller.selectedPos.value,
              'image': data?['imagePath'] ?? '',
              'imagePath': data?['imagePath'] ?? '',
              'harga': _formatRupiah(total),
              'hargaPerTiket': data?['harga'] ?? '',
              'hikersCount': controller.ticketCount.value,
            };

            // Navigate to success page - completePayment will be called there
            Get.offNamed('/payment-success', arguments: ticketData);
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
