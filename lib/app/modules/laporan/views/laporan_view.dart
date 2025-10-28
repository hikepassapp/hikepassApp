import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../widgets/custom_botton.dart';
import '../controllers/laporan_controller.dart';
import '../widgets/custom_text_field.dart';

class LaporanView extends GetView<LaporanController> {
  const LaporanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.navy),
          onPressed: () => Get.offAllNamed(Routes.bottomNavigation),
        ),
        title: Text(
          'Laporan',
          style: AppTypography.h3.copyWith(color: AppColors.navy),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.navy),
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Nama Pelapor',
              hintText: 'Masukan nama Anda',
              controller: controller.namaPelaporController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Tanggal Kejadian',
              hintText: 'dd / mm / yy',
              controller: controller.tanggalController,
              readOnly: true,
              onTap: () => controller.pickDate(context),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Lokasi Kejadian',
              hintText: 'Masukkan lokasi kejadian',
              controller: controller.lokasiController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Deskripsi Kejadian',
              hintText: 'Masukan deskripsi',
              controller: controller.deskripsiController,
              maxLines: 8,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Bukti Foto',
              hintText: 'Tambahkan Foto',
              controller: controller.fotoController,
              readOnly: true,
              prefixIcon: Icons.camera_alt,
              onTap: controller.pickImage,
            ),
            Obx(() {
              if (controller.selectedImage.value != null) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      controller.selectedImage.value!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Kirim',
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
              onPressed: controller.submitLaporan,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
