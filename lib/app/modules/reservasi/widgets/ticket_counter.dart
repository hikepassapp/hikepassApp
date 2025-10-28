import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';

class TicketCounter extends StatelessWidget {
  const TicketCounter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReservasiController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jumlah Pendaki',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              InkWell(
                onTap: controller.decrementTicket,
                child: _circleButton(Icons.remove),
              ),
              const SizedBox(width: 16),
              Obx(
                () => Text(
                  '${controller.ticketCount.value} tiket',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: controller.incrementTicket,
                child: _circleButton(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 20, color: Colors.black87),
    );
  }
}
