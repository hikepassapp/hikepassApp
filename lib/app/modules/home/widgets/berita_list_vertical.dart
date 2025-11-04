import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'berita_card_widget.dart';

class BeritaListWidget extends GetView<HomeController> {
  const BeritaListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.beritaList.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              'Tidak ada berita atau event',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.beritaList.length,
        itemBuilder: (context, index) {
          final item = controller.beritaList[index];
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 200,
                child: BeritaCardWidget(
                  beritaModel: item,
                  onTap: () => controller.onBeritaAcaraTapped(item),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
