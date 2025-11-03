import 'package:flutter/material.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';

class RulesHeader extends StatelessWidget {
  const RulesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Baca Terlebih Dahulu',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.gray,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          'ATURAN PENDAKIAN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A4A4A),
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}