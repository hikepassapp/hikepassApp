import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/theme/app_colors.dart';
import '../controllers/home_controller.dart';
import '../../../shared/theme/app_typography.dart';

class HomeHeaderWidget extends GetView<HomeController> {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      color: AppColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              'Selamat datang, ${controller.userName.value}!',
              style: AppTypography.lBold.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Siap Menjelajahi Pegunungan?',
            style: AppTypography.mRegular.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
