import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'package:get/get.dart';

class PaketWisataHeader extends GetView<HomeController> {
  const PaketWisataHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Paket Wisata',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: controller.onSeeAllPaketWisataTapped,
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
