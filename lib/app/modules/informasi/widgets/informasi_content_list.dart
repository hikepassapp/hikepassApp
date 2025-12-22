import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/informasi_controller.dart';
import 'informasi_content_card.dart';

class InformasiContentList extends GetView<InformasiController> {
  const InformasiContentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentData = controller.currentData;

      if (currentData == null || currentData.contents.isEmpty) {
        return const Center(
          child: Text('Belum ada informasi'),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: currentData.contents.length,
        itemBuilder: (context, index) {
          return InformasiContentCard(
            content: currentData.contents[index],
          );
        },
      );
    });
  }
}
