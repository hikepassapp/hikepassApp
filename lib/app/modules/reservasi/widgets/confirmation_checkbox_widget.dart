import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';
class ConfirmationCheckbox extends GetView<ReservasiController> {
  const ConfirmationCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB8D4B0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(
        () => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: controller.isAgreed.value,
                onChanged: controller.toggleAgreement,
                activeColor: const Color(0xFF6B9F6E),
                checkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Saya telah membaca, menyetujui, dan bersedia mengikuti semua peraturan SOP yang berlaku.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF2D5234),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}