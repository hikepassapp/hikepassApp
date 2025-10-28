import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/reservation_history_view.dart';

class ContinueButton extends StatelessWidget {
  final TextEditingController namaController;
  final TextEditingController nikController;
  final TextEditingController jkController;
  final TextEditingController alamatController;
  final TextEditingController telpController;

  const ContinueButton({
    super.key,
    required this.namaController,
    required this.nikController,
    required this.jkController,
    required this.alamatController,
    required this.telpController,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final userData = {
          'nama': namaController.text,
          'nik': nikController.text,
          'jenisKelamin': jkController.text,
          'alamat': alamatController.text,
          'telepon': telpController.text,
          'jalur': 'Jalur Panorama',
          'tanggal': '14–15 Mei 2025',
          'durasi': '2 Hari',
        };

        Get.to(() => const ReservationHistoryView(), arguments: userData);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: const Color(0xFF2D9F8C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Lanjutkan',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
