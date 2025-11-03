import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'berita_card_widget.dart';
import 'package:get/get.dart';

class BeritaListWidget extends GetView<HomeController> {
  const BeritaListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        child: controller.beritaList.isEmpty
            ? const Center(
                child: Text('Tidak ada berita atau event'),
              )
            : ListView.builder(
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
  }
}