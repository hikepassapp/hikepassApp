// lib/app/modules/register/widgets/info_box.dart

import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const InfoBox({
    Key? key,
    required this.message,
    this.icon = Icons.check_circle,
    this.backgroundColor = const Color(0xFFD1FAE5),
    this.iconColor = const Color(0xFF059669),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: iconColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: iconColor.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}