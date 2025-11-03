import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/berita_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class BeritaSourceWidget extends GetView<BeritaController> {
  const BeritaSourceWidget({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Error',
        'Tidak dapat membuka link',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sumber Artikel berjudul',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '"${controller.sourceTitle.value}"',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'selengkapnya dengan link:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () => _launchURL(controller.sourceUrl.value),
            child: Text(
              controller.sourceUrl.value,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}