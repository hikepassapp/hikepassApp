import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/paket_controller.dart';

class DetailSectionWidget extends GetView<PaketController> {
  const DetailSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailItem('Tanggal', controller.tanggal.value),
            ),
            Expanded(
              child: _buildDetailItem('Biaya', controller.biaya.value),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem('Titik Kumpul', controller.titikKumpul.value),
            ),
            Expanded(
              child: _buildDetailItem('Jam Keberangkatan', controller.jamKeberangkatan.value),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _buildDetailItem('Narahubung', controller.narahubung.value, fullWidth: true),
          ],
        ),
      ],
    ));
  }

  Widget _buildDetailItem(String label, String value, {bool fullWidth = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}