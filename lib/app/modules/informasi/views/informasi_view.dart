import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/informasi_controller.dart';
import '../widgets/informasi_app_bar.dart';
import '../widgets/informasi_header_image.dart';
import '../widgets/informasi_tab_bar.dart';
import '../widgets/informasi_content_list.dart';
import '../widgets/informasi_footer.dart';

class InformasiView extends GetView<InformasiController> {
  const InformasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);

          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              controller.onTabChanged(tabController.index);
            }
          });

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: const InformasiAppBar(),
            body: Obx(() {
              // ===== LOADING =====
              if (controller.isCurrentTabLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // ===== ERROR =====
              if (controller.currentErrorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.currentErrorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              // ===== EMPTY DATA =====
              if (!controller.hasCurrentData) {
                return const Center(
                  child: Text(
                    'Data belum tersedia',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              // ===== SUCCESS =====
              final data = controller.currentData!;

              return Column(
                children: [
                  InformasiHeaderImage(imageUrl: data.imageUrl),
                  InformasiTabBar(tabController: tabController),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: controller.refreshCurrentTab,
                      child: InformasiContentList(),
                    ),
                  ),
                  const InformasiFooter(),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
