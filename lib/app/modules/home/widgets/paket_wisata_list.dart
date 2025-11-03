import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'paket_wisata_card.dart';
import 'package:get/get.dart';

class PaketWisataList extends GetView<HomeController> {
  const PaketWisataList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 200,
        child: controller.paketWisataList.isEmpty
            ? const Center(
                child: Text('Tidak ada paket wisata'),
              )
            : ListView.builder(
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
      ),
    );
  }
}