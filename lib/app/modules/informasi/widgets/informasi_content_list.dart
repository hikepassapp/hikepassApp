import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/informasi_controller.dart';
import 'informasi_content_card.dart';

class InformasiContentList extends GetView<InformasiController> {
  const InformasiContentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentData = controller.currentData;
      
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
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