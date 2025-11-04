import 'package:flutter/material.dart';

class AboutHeaderWidget extends StatelessWidget {
  const AboutHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tentang Tiket Pendakian',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Berikut adalah tahapan lengkap yang perlu dilalui pendaki sebelum, selama, dan setelah pendakian berlangsung:',
          style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
