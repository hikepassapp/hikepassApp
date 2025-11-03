import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/paket_controller.dart';

class DescriptionWidget extends GetView<PaketController> {
  const DescriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deskripsi',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Include & Fasilitas :',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        ...controller.fasilitasList.map((item) => _buildListItem(item)).toList(),
        const SizedBox(height: 8),
        const Text(
          'Destinasi yang dikunjungi :',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...controller.destinasiList.map((item) => _buildListItem(item)).toList(),
        const SizedBox(height: 12),
        const Text(
          'Dibuat pada tanggal',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          controller.createdDate.value,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
      ],
    ));
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 12)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}