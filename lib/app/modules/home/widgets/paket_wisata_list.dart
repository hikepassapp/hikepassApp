import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'paket_wisata_card.dart';
import 'package:get/get.dart';

class PaketWisataList extends GetView<HomeController> {
  const PaketWisataList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading State
      if (controller.isLoadingPaket.value) {
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
      if (controller.paketErrorMessage.value.isNotEmpty) {
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Gagal memuat paket wisata',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: controller.loadPaketWisata,
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
      if (controller.paketWisataList.isEmpty) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.backpack_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  'Tidak ada paket wisata',
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
          itemCount: controller.paketWisataList.length,
          itemBuilder: (context, index) {
            final item = controller.paketWisataList[index];
            return PaketWisataCard(
              paketWisata: item,
              onTap: () => controller.onPaketWisataTapped(item),
            );
          },
        ),
      );
    });
  }
}