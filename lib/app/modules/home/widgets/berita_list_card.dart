import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'berita_card_widget.dart';
import 'package:get/get.dart';

class BeritaListWidget extends GetView<HomeController> {
  const BeritaListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap dengan Obx untuk reactive updates
    return Obx(() {
      // Loading State
      if (controller.isLoadingBerita.value) {
        return SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.green[700],
            ),
          ),
        );
      }

      // Error State
      if (controller.beritaErrorMessage.value.isNotEmpty) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 12),
                Text(
                  'Gagal memuat berita',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: controller.loadBerita,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Empty State
      if (controller.beritaList.isEmpty) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  'Tidak ada berita atau event',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Success State - Display List
      return SizedBox(
        height: 200,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: controller.beritaList.length,
          itemBuilder: (context, index) {
            final item = controller.beritaList[index];
            return BeritaCardWidget(
              beritaModel: item,
              onTap: () => controller.onBeritaAcaraTapped(item),
            );
          },
        ),
      );
    });
  }
}