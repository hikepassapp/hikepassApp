import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';

class RiwayatView extends StatelessWidget {
  const RiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                const Positioned(
                  top: 85,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pesananku",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Lihat pesananmu disini",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/pembayaran_pegunungan.png',
                    height: 100,
                  ),
                ),
              ],
            ),

            // ISI
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tiket Anda",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // KARTU AKTIF
                  _ticketCard(
                    image: 'assets/images/reservasi_panorama.png',
                    title: 'Nailong',
                    subtitle: 'Jalur Panorama',
                    status: 'Bayar',
                    buttonColor: const Color(0xFF2D9F8C),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    "Riwayat Pembayaran Tiket",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // RIWAYAT LIST
                  _ticketCard(
                    image: 'assets/images/reservasi_panorama.png',
                    title: 'Jalur Panorama',
                    subtitle: '14–15 Mei 2025',
                    status: 'Selesai',
                    buttonColor: Colors.grey.shade300,
                  ),
                  _ticketCard(
                    image: 'assets/images/reservasi_cinyiruan.png',
                    title: 'Jalur Cinyiruan',
                    subtitle: '10–13 April 2025',
                    status: 'Selesai',
                    buttonColor: Colors.grey.shade300,
                  ),
                  _ticketCard(
                    image: 'assets/images/reservasi_panorama.png',
                    title: 'Jalur Panorama',
                    subtitle: '19 Maret 2025',
                    status: 'Selesai',
                    buttonColor: Colors.grey.shade300,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketCard({
    required String image,
    required String title,
    required String subtitle,
    required String status,
    required Color buttonColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(image, width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: status == 'Bayar' ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
