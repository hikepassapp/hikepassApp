import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/berita_controller.dart';

class BeritaBadgeWidget extends GetView<BeritaController> {
  const BeritaBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        controller.kategori.value,
        style: TextStyle(
          color: Colors.orange.shade800,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}