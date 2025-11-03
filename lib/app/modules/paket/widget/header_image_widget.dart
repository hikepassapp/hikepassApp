import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/paket_controller.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';

class HeaderImageWidget extends GetView<PaketController> {
  const HeaderImageWidget({super.key});

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
        controller.paketTitle.value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          controller.paketData.imageUrl.isNotEmpty 
              ? controller.paketData.imageUrl 
              : 'assets/images/banner1.png',
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}