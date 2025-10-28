// lib/app/modules/register/widgets/password_requirements.dart

import 'package:flutter/material.dart';

class PasswordRequirements extends StatelessWidget {
  final List<String> requirements;

  const PasswordRequirements({
    Key? key,
    required this.requirements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD1FAE5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF059669).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF059669), size: 18),
              SizedBox(width: 8),
              Text(
                'Ketentuan Kata Sandi',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF059669),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...requirements.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(left: 26, top: 4),
              child: Text(
                '${entry.key + 1}. ${entry.value}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF059669),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}