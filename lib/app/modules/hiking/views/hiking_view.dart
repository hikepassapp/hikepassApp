import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hiking_controller.dart';
import '../widgets/hiking_header.dart';
import '../widgets/hiking_tab_bar.dart';
import '../widgets/hiking_card.dart';

/// Halaman utama Hiking: header, tab (Check-In/Check-Out), dan list kartu.
class HikingView extends GetView<HikingController> {
  const HikingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const HikingHeader(),
            const SizedBox(height: 12),
            Obx(() => HikingTabBar(
                  selectedIndex: controller.tabIndex.value,
                  onChanged: controller.switchTab,
                )),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                final items = controller.filtered;
                if (items.isEmpty) {
                  return const Center(child: Text('Belum ada data'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => HikingCard(item: items[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckInFormView extends GetView<HikingController> {
  const CheckInFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Formulir Check-In',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'List barang bawaanmu sebelum melakukan pendakian!',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            const Text('List Barang', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.listController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'List barang bawaanmu!',
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.submitCheckInAndGoToCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E564A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text('Check-In',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
