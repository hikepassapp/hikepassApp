import 'package:flutter/material.dart';

class LandingHeroCard extends StatelessWidget {
  final String title;
  final String description;

  const LandingHeroCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Dibuat `CrossAxisAlignment.start` agar teks rata kiri sesuai gambar
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Agar tidak memakan banyak ruang
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5, // Jarak antar baris agar lebih mudah dibaca
          ),
        ),
      ],
    );
  }
}