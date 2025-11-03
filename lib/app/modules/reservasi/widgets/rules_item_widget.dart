import 'package:flutter/material.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';

class RulesItem extends StatelessWidget {
  final int number;
  final String text;

  const RulesItem({super.key, required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.fontBlack1,
              height: 1.5,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.fontBlack1,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
