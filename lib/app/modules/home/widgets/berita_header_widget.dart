import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'package:get/get.dart';

class BeritaHeader extends GetView<HomeController> {
  const BeritaHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Berita & Event',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: controller.onSeeAllBeritaAcaraTapped,
          child: const Text(
            'Lihat Semua',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
