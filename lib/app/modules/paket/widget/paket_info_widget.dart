import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/paket_controller.dart';

class PaketInfoWidget extends GetView<PaketController> {
  const PaketInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Open Trip',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Obx(
                () => Text(
                  controller.paketTitle.value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 18),
                const SizedBox(width: 4),
                Obx(
                  () => Text(
                    controller.rating.value.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Obx(
          () => Text(
            controller.admin.value,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
