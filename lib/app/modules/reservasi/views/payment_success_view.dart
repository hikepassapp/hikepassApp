import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF004D40),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Status Bayar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.offAllNamed(
              '/bottom-navigation',
              arguments: {'initialIndex': 0}, // tab Beranda
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2D9F8C),
              ),
              padding: const EdgeInsets.all(24),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pembayaran Berhasil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              data?['harga'] ?? 'Rp 15.000',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D9F8C),
              ),
            ),
            const SizedBox(height: 30),
            _ticketInfo(data),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // 🔁 tombol bawah juga kembali ke Beranda
                Get.offAllNamed(
                  '/bottom-navigation',
                  arguments: {'initialIndex': 0},
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
                'Kembali ke Beranda',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ===== DETAIL INFORMASI TIKET =====
  Widget _ticketInfo(Map<String, dynamic>? data) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoRow('ID Pesanan', data?['id'] ?? '-'),
          _infoRow('Nama', data?['nama'] ?? '-'),
          _infoRow('Total Tiket', data?['total'] ?? '1 Tiket'),
          _infoRow('Metode Pembayaran', data?['metode'] ?? '-'),
          _infoRow('Tanggal Pemesanan', data?['tanggal'] ?? '-'),
          _infoRow('Waktu Pemesanan', data?['waktu'] ?? '-'),
          const Divider(),
          _infoRow('Total', data?['harga'] ?? '-', isBold: true),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? const Color(0xFF2D9F8C) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
