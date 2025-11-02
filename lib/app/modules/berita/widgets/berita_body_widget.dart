import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/berita_controller.dart';

class BeritaBodyWidget extends GetView<BeritaController> {
  const BeritaBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Intro paragraph
        Text(
          controller.introText.value,
          style: const TextStyle(
            fontSize: 12,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        
        // Content sections
        ...controller.contentSections.asMap().entries.map((entry) {
          final index = entry.key;
          final section = entry.value;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}. ${section['title']}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                section['content'] ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        }).toList(),
      ],
    );
  }
}