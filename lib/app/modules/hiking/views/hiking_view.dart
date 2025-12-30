import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hiking_controller.dart';
import '../widgets/hiking_header.dart';
import '../widgets/hiking_tab_bar.dart';
import '../widgets/hiking_card_item.dart';

class HikingView extends GetView<HikingController> {
  const HikingView({super.key});

  @override
  Widget build(BuildContext context) {
    final HikingController controller = Get.isRegistered<HikingController>()
        ? Get.find<HikingController>()
        : Get.put(HikingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Builder(
              builder: (context) {
                controller.applyRouteTabIfPresent();
                return const SizedBox.shrink();
              },
            ),
            const HikingHeader(),
            const SizedBox(height: 12),
            Obx(
              () => HikingTabBar(
                selectedIndex: controller.tabIndex.value,
                onChanged: controller.switchTab,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                final items = controller.filteredItems;
                if (items.isEmpty) {
                  return const Center(child: Text('Belum ada data'));
                }
                return ListView.separated(
                  key: ValueKey(controller.tabIndex.value),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      HikingCardItem(hiking: items[index]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
