import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/reservation_history_view.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';

class ContinueButton extends StatelessWidget {
  final TextEditingController namaController;
  final TextEditingController nikController;
  final String jkValue;
  final TextEditingController alamatController;
  final TextEditingController telpController;

  const ContinueButton({
    super.key,
    required this.namaController,
    required this.nikController,
    required this.jkValue,
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
          'jenisKelamin': jkValue,
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
        backgroundColor: AppColors.secondary,
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
