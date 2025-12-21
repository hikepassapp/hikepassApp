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

            // Get entry date from arguments or controller
            final entryDate =
                data?['tanggal'] ??
                (controller.selectedDate.value != null
                    ? '${controller.selectedDate.value!.day.toString().padLeft(2, '0')}-${controller.selectedDate.value!.month.toString().padLeft(2, '0')}-${controller.selectedDate.value!.year}'
                    : '');

            // Format payment time
            final now = DateTime.now();
            final formattedTime =
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

            // Get main hiker (first hiker in list)
            final mainHiker = controller.hikers.isNotEmpty
                ? controller.hikers[0]['nama'] ?? 'Pendaki'
                : 'Pendaki';

            // Create complete ticket data from all previous steps
            final ticketData = {
              'id': 'D${now.millisecondsSinceEpoch}',
              'nama': mainHiker,
              'title': data?['title'] ?? 'Puncak Malabar',
              'jalur': data?['jalur'] ?? controller.selectedPos.value,
              'image':
                  data?['imagePath'] ?? 'assets/images/reservasi_panorama.png',
              'metode': 'QRIS',
              'tanggal': entryDate,
              'waktu': formattedTime,
              'harga': data?['harga'] ?? 'Rp 15.000',
              'status': 'Selesai',
            };

            // Add to riwayat (history)
            controller.riwayat.add(ticketData);

            // Reset form for next reservation
            controller.selectedDate.value = null;
            controller.selectedPos.value = '';
            controller.ticketCount.value = 1;
            controller.isAgreed.value = false;
            controller.hikers.clear();

            // Navigate to success page
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
