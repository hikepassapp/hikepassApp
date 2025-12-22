import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';

class TicketSummaryCard extends StatelessWidget {
  final Map<String, dynamic>? data;
  final ReservasiController? controller;
  
  const TicketSummaryCard({super.key, this.data, this.controller});

  @override
  Widget build(BuildContext context) {
    final ctrl = controller ?? Get.find<ReservasiController>();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Obx(
              () => Image.asset(
                ctrl.selectedPos.value == 'Cinyiruan'
                    ? 'assets/images/reservasi_cinyiruan.png'
                    : 'assets/images/reservasi_panorama.png',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ctrl.selectedPos.value.isNotEmpty
                        ? 'Puncak ${data?['namaGunung'] ?? 'Malabar'} via ${ctrl.selectedPos.value}'
                        : 'Puncak ${data?['namaGunung'] ?? 'Malabar'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data?['subtitle'] ?? 'LMDH',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
