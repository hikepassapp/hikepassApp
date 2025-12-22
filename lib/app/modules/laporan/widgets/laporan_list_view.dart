import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikepass_app/app/modules/laporan/widgets/laporan_widget.dart';
import 'package:hikepass_app/app/modules/register/widgets/custom_button_widget.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_typography.dart';
import '../controllers/laporan_controller.dart';

class LaporanListView extends GetView<LaporanController> {
  const LaporanListView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadAllLaporan();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Daftar Laporan',
          style: AppTypography.h3.copyWith(color: AppColors.navy),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 60,
      ),
      body: Obx(() {
        if (controller.isLoadingList.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Memuat laporan...'),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.refreshLaporan,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.laporanList.length,
            itemBuilder: (context, index) {
              final laporan = controller.laporanList[index];
              return LaporanCard(
                laporan: laporan,
                onTap: () => controller.navigateToDetail(laporan),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(
            () => CustomButton(
              text: 'Kembali',
              onPressed: () => Get.offAllNamed(Routes.bottomNavigation),
              isLoading: controller.isLoading.value,
            ),
          ),
        ),
      ),
    );
  }
}