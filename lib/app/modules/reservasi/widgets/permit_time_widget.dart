import 'package:flutter/material.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';

class PermitTimeCard extends StatelessWidget {
  const PermitTimeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jam Buka/Tutup Pos Perizinan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.fontBlack1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: const [
              Icon(
                Icons.circle,
                size: 10,
                color: AppColors.fontBlack1,
              ),
              SizedBox(width: 12),
              Text(
                'Pos Perizinan Buka 24 Jam',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.fontBlack1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}