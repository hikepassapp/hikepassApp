import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/hiking_model.dart';
import '../controllers/hiking_controller.dart';

class HikingCardItem extends StatelessWidget {
  const HikingCardItem({super.key, required this.hiking});
  final HikingModel hiking;

  String _formatDate(DateTime start, DateTime end) {
    String fmt(DateTime d) {
      final day = d.day.toString().padLeft(2, '0');
      final m = d.month.toString().padLeft(2, '0');
      final y = d.year.toString();
      return '$day/$m/$y';
    }
    return '${fmt(start)} - ${fmt(end)}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HikingController>();
    final isCheckIn = hiking.status == HikingStatus.pending;

    return Material(
      elevation: 3,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF179778).withOpacity(0.1),
              ),
              child: const Icon(
                Icons.landscape,
                size: 48,
                color: Color(0xFF179778),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hiking.mountainName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hiking.hikingTrail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(hiking.startDate, hiking.endDate),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isCheckIn) {
                          controller.navigateToCheckIn(hiking);
                        } else {
                          controller.navigateToCheckOut(hiking);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF179778),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        isCheckIn ? 'Check-In' : 'Check-Out',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
