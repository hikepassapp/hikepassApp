import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import '../../reservasi/controllers/reservasi_controller.dart';

class RiwayatView extends StatelessWidget {
  const RiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      body: Column(
        children: [
          // ===== HEADER =====
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
                  // 🔹 Tombol kembali ke beranda
                  onPressed: () {
                    Get.offAllNamed(
                      '/bottom-navigation',
                      arguments: {'initialIndex': 0}, // tab "Beranda"
                    );
                  },
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
                      "Lihat pesananmu di sini",
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

          // ===== ISI =====
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final riwayat = reservasiC.riwayat;

                if (riwayat.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada riwayat pembayaran',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Riwayat Pembayaran Tiket",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ===== LISTVIEW =====
                    Expanded(
                      child: ListView.builder(
                        itemCount: riwayat.length,
                        itemBuilder: (context, index) {
                          final item = riwayat[index];
                          return _ticketCard(
                            image:
                                item['image'] ??
                                'assets/images/reservasi_panorama.png',
                            title: item['jalur'] ?? '-',
                            subtitle:
                                "${item['tanggal']} • ${item['waktu'] ?? ''}",
                            status: item['status'] ?? 'Selesai',
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ===== KOMPONEN CARD =====
  Widget _ticketCard({
    required String image,
    required String title,
    required String subtitle,
    required String status,
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
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
