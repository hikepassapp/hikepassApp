import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayat_controller.dart';
import '../widgets/riwayat_header.dart';
import '../widgets/riwayat_card_item.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const RiwayatHeader(),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                final items = controller.items;
                if (items.isEmpty) {
                  return const Center(child: Text('Belum ada riwayat pendakian'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) => RiwayatCardItem(
                    riwayat: items[index],
                    onDetail: () => controller.openDetail(items[index]),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
