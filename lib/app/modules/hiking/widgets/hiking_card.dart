import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/modules/hiking/widgets/checkin_form.dart';
import '../controllers/hiking_controller.dart';

class HikingCard extends StatelessWidget {
  const HikingCard({super.key, required this.item});

  final HikingItem item;

  String _formatDate(DateTime d) {
    const months = [
      'Januari','Februari','Maret','April','Mei','Juni',
      'Juli','Agustus','September','Oktober','November','Desember'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isCheckIn = item.type == HikeType.checkIn;

    return Material(
      elevation: 3,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 96,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.imagePath,
                width: 96,
                height: 72,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(item.date),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isCheckIn) {
                          Get.to(() => const CheckInFormPage()); // panggil page dari folder widgets
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF0E564A),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        isCheckIn ? 'Check-In' : 'Check-Out',
                        style: const TextStyle(fontSize: 12, color: Colors.white),
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
