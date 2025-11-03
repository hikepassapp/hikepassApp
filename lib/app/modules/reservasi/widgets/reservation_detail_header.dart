import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';

class ReservationDetailHeader extends StatelessWidget {
  final String imagePath;
  final String title;

  const ReservationDetailHeader({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 240,
      backgroundColor: AppColors.secondary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(color: Colors.grey[300]),
        ),
      ),
    );
  }
}
