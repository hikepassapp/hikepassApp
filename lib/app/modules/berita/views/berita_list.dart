import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/berita_controller.dart';
import '../../home/widgets/berita_list_vertical.dart';
import '../../../routes/app_pages.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';
import 'package:hikepass_app/app/shared/theme/app_typography.dart';

class BeritaList extends GetView<BeritaController> {
  const BeritaList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offAllNamed(Routes.bottomNavigation),
        ),
        title: Text(
          'Berita & Event',
          style: AppTypography.h3.copyWith(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.secondary,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: const BeritaListWidget(),
    );
  }
}

