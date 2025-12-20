import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'paket_wisata_card.dart';

class PaketListVertical extends GetView<HomeController> {
  const PaketListVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.paketWisataList.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              'Tidak ada paket wisata',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.paketWisataList.length,
        itemBuilder: (context, index) {
          final item = controller.paketWisataList[index];
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 200,
                child: PaketWisataCard(
                  paketWisata: item,
                  onTap: () => controller.onPaketWisataTapped(item),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
